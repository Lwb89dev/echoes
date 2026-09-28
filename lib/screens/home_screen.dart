import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../l10n/app_localizations.dart';
import '../models/note.dart';
import '../providers/fab_menu_provider.dart';
import '../providers/home_tab_provider.dart';
import '../providers/note_desk_provider.dart';
import '../providers/note_encryption_provider.dart';
import '../providers/note_layout_provider.dart';
import '../providers/note_order_provider.dart';
import '../providers/note_search_provider.dart';
import '../providers/notes_provider.dart';
import '../providers/selection_provider.dart';
import '../utils/constants.dart';
import '../utils/responsive.dart';
import '../theme/echoes_theme.dart';
import '../widgets/brand_mark.dart';
import '../widgets/diary_timeline.dart';
import '../widgets/note_card.dart';
import '../widgets/quick_capture_fab.dart';
import 'note_editor_screen.dart';
import 'settings_screen.dart';
import 'widgets/note_actions.dart';
import 'widgets/reorderable_note.dart';

/// List of all notes (local + synced), with a FAB to create a new one and
/// pull-to-refresh to force a manual sync from the relays.
///
/// Gates on [noteEncryptionProvider] before ever touching [notesProvider]:
/// when note encryption is on but the session is locked, this shows
/// [_UnlockNotesView] instead of attempting to load notes (which would
/// throw — see [LocalStorageService.loadNotes]).
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final encryptionState = ref.watch(noteEncryptionProvider);
    final selection = ref.watch(selectionProvider);
    final fabOpen = ref.watch(fabMenuProvider);
    final tab = ref.watch(homeTabProvider);
    final l = AppLocalizations.of(context);
    // The FAB creates a note that immediately gets saved to the (possibly
    // still-locked) encrypted box, so it must stay hidden in lockstep with
    // the body below instead of always being tappable regardless of state.
    // It's also hidden during multi-select, where the selection app bar's
    // actions are the point of focus. The bottom nav (tab switcher) follows
    // the same gating: both tabs read from the same possibly-locked
    // encrypted box, so there's nothing to switch to until it's unlocked.
    final notesUnlocked = encryptionState.maybeWhen(
      data: (state) => !(state.enabled && !state.unlocked),
      orElse: () => false,
    );

    return Scaffold(
      appBar: selection.isEmpty ? _HomeAppBar(tab: tab) : const _SelectionAppBar(),
      body: Stack(
        children: [
          encryptionState.when(
            data: (state) {
              if (state.enabled && !state.unlocked) {
                return const _UnlockNotesView();
              }
              return tab == HomeTab.notes
                  ? const _RefreshableNotesBody(filter: _notesOnly, builder: _NotesList.new)
                  : const _RefreshableNotesBody(filter: _diaryOnly, builder: _DiaryList.new);
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stackTrace) => _ErrorState(error: error),
          ),
          // Tapping anywhere else while the FAB's speed-dial menu is open
          // should just close it, not also trigger whatever's underneath
          // (e.g. opening a note) — an opaque full-screen barrier, only
          // present while open, gives exactly that "one dead-zone tap to
          // dismiss" behavior instead of requiring another tap on the FAB.
          if (fabOpen)
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => ref.read(fabMenuProvider.notifier).close(),
              ),
            ),
        ],
      ),
      floatingActionButton: (notesUnlocked && selection.isEmpty)
          ? (tab == HomeTab.notes ? const QuickCaptureFab() : const DiaryCaptureFab())
          : null,
      bottomNavigationBar: (notesUnlocked && selection.isEmpty)
          ? GlassPane(
              radius: 0,
              child: NavigationBar(
                selectedIndex: tab.index,
                onDestinationSelected: (index) =>
                    ref.read(homeTabProvider.notifier).select(HomeTab.values[index]),
                destinations: [
                  NavigationDestination(
                    icon: const Icon(Icons.notes_outlined),
                    selectedIcon: const Icon(Icons.notes),
                    label: l.notesTabLabel,
                  ),
                  NavigationDestination(
                    icon: const Icon(Icons.auto_stories_outlined),
                    selectedIcon: const Icon(Icons.auto_stories),
                    label: l.diaryTabLabel,
                  ),
                ],
              ),
            )
          : null,
    );
  }
}

/// The normal (non-selection) header: the active notebook section and its
/// integrated search surface. The query remains in [noteSearchProvider] so
/// notes and diary entries keep sharing the same filtering behavior.
class _HomeAppBar extends ConsumerStatefulWidget implements PreferredSizeWidget {
  const _HomeAppBar({required this.tab});

  final HomeTab tab;

  @override
  ConsumerState<_HomeAppBar> createState() => _HomeAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(132);
}

class _HomeAppBarState extends ConsumerState<_HomeAppBar> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController()
      ..addListener(() => ref.read(noteSearchProvider.notifier).setQuery(_searchController.text));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final layout = ref.watch(noteLayoutProvider);
    final desk = ref.watch(noteDeskProvider);
    final palette = EchoesPalette.of(context);
    final allNotes = ref.watch(notesProvider).value;
    final subtitle = _homeSubtitle(l, widget.tab, desk, allNotes);
    return Material(
      type: MaterialType.transparency,
      child: AppBar(
        toolbarHeight: 72,
        titleSpacing: EchoesTokens.lg,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppConstants.appName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            if (subtitle != null)
              Text(
                subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(color: palette.textMuted),
              ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(desk.viewingArchive ? Icons.inventory_2 : Icons.inventory_2_outlined),
            tooltip: l.archiveTitle,
            onPressed: () => ref.read(noteDeskProvider.notifier).toggleViewingArchive(),
          ),
          if (widget.tab == HomeTab.notes)
            IconButton(
              icon: Icon(
                layout == NoteLayout.list ? Icons.grid_view_outlined : Icons.view_list_outlined,
              ),
              tooltip: l.noteLayoutToggleTitle,
              onPressed: () => ref
                  .read(noteLayoutProvider.notifier)
                  .setLayout(layout == NoteLayout.list ? NoteLayout.grid : NoteLayout.list),
            ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: l.settingsTooltip,
            onPressed: () => Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const SettingsScreen())),
          ),
          const SizedBox(width: EchoesTokens.sm),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              EchoesTokens.lg,
              0,
              EchoesTokens.lg,
              EchoesTokens.md,
            ),
            child: GlassPane(
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: l.searchNotesHint,
                  prefixIcon: Icon(Icons.search_rounded, color: palette.textSecondary),
                  filled: false,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: _searchBorder(palette.accentPrimary, width: 1.5),
                  suffixIcon: ValueListenableBuilder<TextEditingValue>(
                    valueListenable: _searchController,
                    builder: (context, value, child) => value.text.isEmpty
                        ? const SizedBox.shrink()
                        : IconButton(
                            icon: const Icon(Icons.close_rounded),
                            tooltip: l.closeSearchTooltip,
                            onPressed: () {
                              _searchController.clear();
                              ref.read(noteSearchProvider.notifier).clear();
                            },
                          ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

OutlineInputBorder _searchBorder(Color color, {double width = 1}) {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(EchoesTokens.radiusPill),
    borderSide: BorderSide(color: color, width: width),
  );
}

String? _homeSubtitle(AppLocalizations l, HomeTab tab, NoteDesk desk, List<Note>? notes) {
  if (desk.viewingArchive) return l.archiveTitle;
  if (tab == HomeTab.diary) return l.diaryTabLabel;
  if (notes == null) return null;
  final count = notes.where((note) {
    return !note.isDiaryEntry && !desk.archived.contains(note.id);
  }).length;
  return l.notesOnDesk(count);
}

bool _notesOnly(Note note) => !note.isDiaryEntry;
bool _diaryOnly(Note note) => note.isDiaryEntry;

void _toggleArchive(WidgetRef ref, String id) {
  final desk = ref.read(noteDeskProvider);
  final notifier = ref.read(noteDeskProvider.notifier);
  if (desk.archived.contains(id)) {
    notifier.unarchive(id);
  } else {
    notifier.archive(id);
  }
}

/// Shared by both tabs: watches [notesProvider], applies [filter], and
/// wraps the result ([builder]) in the same pull-to-refresh behavior — only
/// the filter and the list widget actually differ between the Notes tab
/// (plain notes) and the Diary tab (diary entries, grouped by day).
class _RefreshableNotesBody extends ConsumerWidget {
  const _RefreshableNotesBody({required this.filter, required this.builder});

  final bool Function(Note note) filter;
  final Widget Function({required List<Note> notes}) builder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notesState = ref.watch(notesProvider);
    final query = ref.watch(noteSearchProvider).trim().toLowerCase();
    final desk = ref.watch(noteDeskProvider);
    final l = AppLocalizations.of(context);
    return RefreshIndicator(
      onRefresh: () async {
        try {
          await ref.read(notesProvider.notifier).refreshFromRelays();
        } catch (e) {
          if (context.mounted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(l.genericErrorPrefix(e.toString()))));
          }
        }
      },
      child: notesState.when(
        data: (notes) {
          final tabFiltered = notes.where(filter);
          final matched = query.isEmpty
              ? tabFiltered
              : tabFiltered.where((n) => _matchesQuery(n, query));
          final visible = matched.where(
            (note) => noteVisibleOnDesk(note, desk, searching: query.isNotEmpty),
          );
          return builder(notes: visible.toList());
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => _ErrorState(error: error),
      ),
    );
  }
}

/// Whether [note] matches a (already-lowercased, trimmed) search [query] —
/// title, body, and every checklist item's text.
///
/// Deliberately searches **all** checklist items, ticked-off ones included,
/// unlike [Note.preview], which shows only what's still to do: "which list
/// did I put olive oil on?" is a perfectly good reason to search, and
/// whether the item has since been checked off doesn't change the answer.
///
/// Matches against [Note.bodyWithoutAttachmentTokens], not the raw body:
/// internal `attachment://<uuid>` markup would otherwise make e.g. a search
/// for "attachment" (or any hex fragment) hit notes it visibly has nothing
/// to do with.
bool _matchesQuery(Note note, String query) {
  if (note.title.toLowerCase().contains(query)) return true;
  if (note.bodyWithoutAttachmentTokens.toLowerCase().contains(query)) {
    return true;
  }
  return note.items.any((item) => item.text.toLowerCase().contains(query));
}

/// App bar shown instead of the normal one while [selectionProvider] is
/// non-empty: a close button to leave selection mode, a "N selected"
/// title, and the three bulk actions (sync/export/delete) the multi-select
/// context menu was asked for.
class _SelectionAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const _SelectionAppBar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final selection = ref.watch(selectionProvider);
    final allNotes = ref.watch(notesProvider).value ?? const <Note>[];
    final selectedNotes = allNotes.where((n) => selection.contains(n.id)).toList();

    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.close),
        onPressed: () => ref.read(selectionProvider.notifier).clear(),
      ),
      title: Text(l.selectionCount(selection.length)),
      actions: [
        IconButton(
          icon: const Icon(Icons.cloud_sync_outlined),
          tooltip: l.syncSelectedTooltip,
          onPressed: () async {
            await syncNotes(context, ref, l, selectedNotes);
            ref.read(selectionProvider.notifier).clear();
          },
        ),
        IconButton(
          icon: const Icon(Icons.upload_outlined),
          tooltip: l.exportSelectedTooltip,
          onPressed: () async {
            await exportNotesToFile(context, ref, l, noteIds: selection);
            ref.read(selectionProvider.notifier).clear();
          },
        ),
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_horiz),
          tooltip: l.moreActionsTooltip,
          onSelected: (value) {
            final ids = selectedNotes.map((note) => note.id);
            final notifier = ref.read(noteDeskProvider.notifier);
            if (value == 'pin') notifier.pinAll(ids);
            if (value == 'archive') {
              final restore = ref.read(noteDeskProvider).viewingArchive;
              notifier.setArchived(ids, !restore);
            }
            ref.read(selectionProvider.notifier).clear();
          },
          itemBuilder: (context) {
            final desk = ref.read(noteDeskProvider);
            final ids = selectedNotes.map((note) => note.id).toList();
            final allPinned = ids.isNotEmpty && ids.every(desk.pinned.contains);
            return [
              PopupMenuItem(value: 'pin', child: Text(allPinned ? l.unpinNote : l.pinNote)),
              PopupMenuItem(
                value: 'archive',
                child: Text(desk.viewingArchive ? l.unarchiveNote : l.archiveNote),
              ),
            ];
          },
        ),
        IconButton(
          icon: const Icon(Icons.delete_outline),
          tooltip: l.deleteSelectedTooltip,
          onPressed: () async {
            final deleted = await deleteNotes(context, ref, l, selectedNotes);
            if (deleted) ref.read(selectionProvider.notifier).clear();
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _NotesList extends ConsumerWidget {
  const _NotesList({required this.notes});

  final List<Note> notes;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final layout = ref.watch(noteLayoutProvider);

    if (notes.isEmpty) {
      // An active search query filtered everything out — "Tap + to create
      // one" would be misleading here, the notes it's talking about exist,
      // they just don't match.
      final searching = ref.watch(noteSearchProvider).trim().isNotEmpty;
      final viewingArchive = ref.watch(noteDeskProvider).viewingArchive;
      final message = searching
          ? l.noSearchResultsMessage
          : (viewingArchive ? l.emptyArchiveMessage : l.emptyNotesMessage);
      return LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: _EmptyNotesState(message: message),
          ),
        ),
      );
    }

    // The user's hand-arranged order, applied here rather than in
    // [_RefreshableNotesBody] so the diary tab keeps its own by-date grouping.
    // Pinned sheets sit above that order, still on this device only.
    final desk = ref.watch(noteDeskProvider);
    final ordered = applyNoteOrder(notes, ref.watch(noteOrderProvider));
    final arranged = desk.viewingArchive ? ordered : pinFirst(ordered, desk.pinned);
    // Reordering a *filtered* list would persist an arrangement covering
    // notes that aren't on screen, so it's off while searching.
    final canReorder = ref.watch(noteSearchProvider).trim().isEmpty && !desk.viewingArchive;

    void move(int from, int to) {
      final next = [...arranged];
      next.insert(to, next.removeAt(from));
      ref.read(noteOrderProvider.notifier).setOrder([for (final note in next) note.id]);
    }

    return switch (layout) {
      NoteLayout.list => _NotesListView(notes: arranged, canReorder: canReorder, onMove: move),
      NoteLayout.grid => _NotesGridView(notes: arranged, canReorder: canReorder, onMove: move),
    };
  }
}

/// A spacious single-column layout for reading note previews as individual
/// notebook pages rather than a wall of identical rows.
class _NotesListView extends ConsumerWidget {
  const _NotesListView({required this.notes, required this.canReorder, required this.onMove});

  final List<Note> notes;
  final bool canReorder;
  final void Function(int from, int to) onMove;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selection = ref.watch(selectionProvider);
    final selectionMode = selection.isNotEmpty;
    final desk = ref.watch(noteDeskProvider);

    return MaxWidthCenter(
      maxWidth: 900,
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 96),
        itemCount: notes.length,
        itemBuilder: (context, index) {
          final note = notes[index];
          return ReorderableNote(
            index: index,
            // Only the selected card can be lifted, but every card must be
            // able to receive it — otherwise the drag has nowhere to land.
            canDrag: canReorder && selection.contains(note.id),
            canReceive: canReorder,
            onMove: onMove,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                EchoesTokens.lg,
                EchoesTokens.sm,
                EchoesTokens.lg,
                EchoesTokens.sm,
              ),
              child: _deskCard(context, ref, note, selection, selectionMode, desk),
            ),
          );
        },
      ),
    );
  }
}

/// Google-Keep-style masonry grid: two columns on a phone, scaling up on
/// wider (tablet/desktop) windows — see [gridColumnsForWidth] — each card
/// only as tall as its own content (via `flutter_staggered_grid_view`'s
/// `MasonryGridView` — a plain `GridView` forces every tile to the same
/// height, which is exactly the "post-it" look this isn't going for).
class _NotesGridView extends ConsumerWidget {
  const _NotesGridView({required this.notes, required this.canReorder, required this.onMove});

  final List<Note> notes;
  final bool canReorder;
  final void Function(int from, int to) onMove;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selection = ref.watch(selectionProvider);
    final selectionMode = selection.isNotEmpty;
    final desk = ref.watch(noteDeskProvider);

    return LayoutBuilder(
      builder: (context, constraints) => MasonryGridView.count(
        padding: const EdgeInsets.fromLTRB(EchoesTokens.lg, EchoesTokens.sm, EchoesTokens.lg, 96),
        crossAxisCount: gridColumnsForWidth(constraints.maxWidth),
        mainAxisSpacing: EchoesTokens.md,
        crossAxisSpacing: EchoesTokens.md,
        itemCount: notes.length,
        itemBuilder: (context, index) {
          final note = notes[index];
          return ReorderableNote(
            index: index,
            canDrag: canReorder && selection.contains(note.id),
            canReceive: canReorder,
            onMove: onMove,
            child: _deskCard(context, ref, note, selection, selectionMode, desk),
          );
        },
      ),
    );
  }
}

NoteCard _deskCard(
  BuildContext context,
  WidgetRef ref,
  Note note,
  Set<String> selection,
  bool selectionMode,
  NoteDesk desk,
) {
  return NoteCard(
    key: ValueKey(note.id),
    note: note,
    selected: selection.contains(note.id),
    selectionMode: selectionMode,
    pinned: desk.pinned.contains(note.id),
    archived: desk.archived.contains(note.id),
    onTap: () => _openNote(context, ref, note, selectionMode),
    onLongPress: () => ref.read(selectionProvider.notifier).toggle(note.id),
    onTogglePin: () => ref.read(noteDeskProvider.notifier).togglePin(note.id),
    onToggleArchive: () => _toggleArchive(ref, note.id),
  );
}

/// Shared by both layouts: toggles selection while already selecting one or
/// more notes, otherwise opens the note for editing.
void _openNote(BuildContext context, WidgetRef ref, Note note, bool selectionMode) {
  if (selectionMode) {
    ref.read(selectionProvider.notifier).toggle(note.id);
    return;
  }
  Navigator.of(context).push(MaterialPageRoute(builder: (_) => NoteEditorScreen(note: note)));
}

/// The diary, as a month-sticky timeline rather than another note grid.
class _DiaryList extends ConsumerWidget {
  const _DiaryList({required this.notes});

  final List<Note> notes;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);

    if (notes.isEmpty) {
      final searching = ref.watch(noteSearchProvider).trim().isNotEmpty;
      final viewingArchive = ref.watch(noteDeskProvider).viewingArchive;
      final message = searching
          ? l.noSearchResultsMessage
          : (viewingArchive ? l.emptyArchiveMessage : l.emptyDiaryMessage);
      return LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: _EmptyNotesState(message: message),
          ),
        ),
      );
    }

    final selection = ref.watch(selectionProvider);
    final desk = ref.watch(noteDeskProvider);
    return MaxWidthCenter(
      maxWidth: 760,
      child: DiaryTimeline(
        notes: notes,
        selectedIds: selection,
        selectionMode: selection.isNotEmpty,
        pinnedIds: desk.pinned,
        archivedIds: desk.archived,
        onOpen: (note) => _openNote(context, ref, note, selection.isNotEmpty),
        onLongPress: (note) => ref.read(selectionProvider.notifier).toggle(note.id),
        onTogglePin: (note) => ref.read(noteDeskProvider.notifier).togglePin(note.id),
        onToggleArchive: (note) => _toggleArchive(ref, note.id),
      ),
    );
  }
}

class _EmptyNotesState extends StatelessWidget {
  const _EmptyNotesState({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const BrandMark(size: 72),
          const SizedBox(height: EchoesTokens.lg),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 260),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Password prompt shown when note encryption is on but the session hasn't
/// unlocked the key yet (e.g. right after app start).
class _UnlockNotesView extends ConsumerStatefulWidget {
  const _UnlockNotesView();

  @override
  ConsumerState<_UnlockNotesView> createState() => _UnlockNotesViewState();
}

class _UnlockNotesViewState extends ConsumerState<_UnlockNotesView> {
  final _passwordController = TextEditingController();
  bool _wrongPassword = false;
  bool _submitting = false;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final password = _passwordController.text;
    if (password.isEmpty) return;
    setState(() {
      _submitting = true;
      _wrongPassword = false;
    });
    final ok = await ref.read(noteEncryptionProvider.notifier).unlock(password);
    if (!mounted) return;
    setState(() {
      _submitting = false;
      _wrongPassword = !ok;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.lock_outline, size: 48, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 16),
            Text(
              l.notesLockedTitle,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              autofocus: true,
              onSubmitted: (_) => _submit(),
              decoration: InputDecoration(
                labelText: l.passwordLabel,
                border: const OutlineInputBorder(),
                errorText: _wrongPassword ? l.wrongPasswordError : null,
              ),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: _submitting ? null : _submit,
              child: _submitting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(l.unlockButton),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.error});

  final Object error;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(AppLocalizations.of(context).errorLoadingNotes(error.toString())),
      ),
    );
  }
}
