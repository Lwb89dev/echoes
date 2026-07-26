import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../l10n/app_localizations.dart';
import '../models/note.dart';
import '../providers/fab_menu_provider.dart';
import '../providers/home_tab_provider.dart';
import '../providers/note_encryption_provider.dart';
import '../providers/note_layout_provider.dart';
import '../providers/note_search_provider.dart';
import '../providers/notes_provider.dart';
import '../providers/selection_provider.dart';
import '../utils/constants.dart';
import '../utils/formatter.dart';
import '../utils/note_colors.dart';
import '../utils/platform_support.dart';
import '../utils/responsive.dart';
import 'note_editor_screen.dart';
import 'settings_screen.dart';
import 'widgets/note_actions.dart';

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
      appBar: selection.isEmpty
          ? _HomeAppBar(tab: tab)
          : const _SelectionAppBar(),
      body: Stack(
        children: [
          encryptionState.when(
            data: (state) {
              if (state.enabled && !state.unlocked) {
                return const _UnlockNotesView();
              }
              return tab == HomeTab.notes
                  ? const _RefreshableNotesBody(
                      filter: _notesOnly,
                      builder: _NotesList.new,
                    )
                  : const _RefreshableNotesBody(
                      filter: _diaryOnly,
                      builder: _DiaryList.new,
                    );
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
          ? (tab == HomeTab.notes
                ? const _NewNoteFab()
                : const _NewDiaryEntryFab())
          : null,
      bottomNavigationBar: (notesUnlocked && selection.isEmpty)
          ? NavigationBar(
              selectedIndex: tab.index,
              onDestinationSelected: (index) => ref
                  .read(homeTabProvider.notifier)
                  .select(HomeTab.values[index]),
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
            )
          : null,
    );
  }
}

/// The normal (non-selection) app bar: the current tab's title, or — once
/// the search icon is tapped — an inline query field in its place, same
/// idea as Google Keep/Notes' search (no separate search screen/route). A
/// `ConsumerStatefulWidget` (rather than the simpler `ConsumerWidget` most
/// of this file uses) because the query field's controller needs to
/// survive rebuilds without losing focus/cursor position while typing,
/// same rationale as Settings' custom-URL field.
///
/// The query itself lives in [noteSearchProvider] (so both tabs' bodies
/// can filter by it), but whether the search field is currently expanded
/// is local, purely-visual state — it doesn't need to be shared or survive
/// a rebuild of anything else.
class _HomeAppBar extends ConsumerStatefulWidget
    implements PreferredSizeWidget {
  const _HomeAppBar({required this.tab});

  final HomeTab tab;

  @override
  ConsumerState<_HomeAppBar> createState() => _HomeAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _HomeAppBarState extends ConsumerState<_HomeAppBar> {
  bool _searching = false;
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController()
      ..addListener(
        () => ref
            .read(noteSearchProvider.notifier)
            .setQuery(_searchController.text),
      );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _startSearch() => setState(() => _searching = true);

  void _stopSearch() {
    _searchController.clear();
    ref.read(noteSearchProvider.notifier).clear();
    setState(() => _searching = false);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final layout = ref.watch(noteLayoutProvider);
    return AppBar(
      title: _searching
          ? TextField(
              controller: _searchController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: l.searchNotesHint,
                border: InputBorder.none,
              ),
              style: Theme.of(context).textTheme.titleMedium,
            )
          : Text(
              widget.tab == HomeTab.notes
                  ? AppConstants.appName
                  : l.diaryTabLabel,
            ),
      actions: [
        // Layout only applies to the Notes tab's own list — Diary is
        // always a day-grouped timeline, there's no grid variant of it to
        // switch to.
        if (!_searching && widget.tab == HomeTab.notes)
          IconButton(
            icon: Icon(
              layout == NoteLayout.list
                  ? Icons.grid_view_outlined
                  : Icons.view_list_outlined,
            ),
            tooltip: l.noteLayoutToggleTitle,
            onPressed: () => ref
                .read(noteLayoutProvider.notifier)
                .setLayout(
                  layout == NoteLayout.list ? NoteLayout.grid : NoteLayout.list,
                ),
          ),
        IconButton(
          icon: Icon(_searching ? Icons.close : Icons.search),
          tooltip: _searching ? l.closeSearchTooltip : l.searchTooltip,
          onPressed: _searching ? _stopSearch : _startSearch,
        ),
        if (!_searching)
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: l.settingsTooltip,
            onPressed: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const SettingsScreen()));
            },
          ),
      ],
    );
  }
}

bool _notesOnly(Note note) => !note.isDiaryEntry;
bool _diaryOnly(Note note) => note.isDiaryEntry;

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
    final l = AppLocalizations.of(context);
    return RefreshIndicator(
      onRefresh: () async {
        try {
          await ref.read(notesProvider.notifier).refreshFromRelays();
        } catch (e) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l.genericErrorPrefix(e.toString()))),
            );
          }
        }
      },
      child: notesState.when(
        data: (notes) {
          final tabFiltered = notes.where(filter);
          final matched = query.isEmpty
              ? tabFiltered
              : tabFiltered.where((n) => _matchesQuery(n, query));
          return builder(notes: matched.toList());
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => _ErrorState(error: error),
      ),
    );
  }
}

/// Whether [note] matches a (already-lowercased, trimmed) search [query] —
/// title, body, and every checklist item's text, so a search finds a
/// checklist note by an item's wording even though [Note.preview] joins
/// those same items with commas rather than showing the raw body. Matches
/// against [Note.bodyWithoutAttachmentTokens], not the raw body: internal
/// `attachment://<uuid>` markup would otherwise make e.g. a search for
/// "attachment" (or any hex fragment) hit notes it visibly has nothing to
/// do with.
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
    final selectedNotes = allNotes
        .where((n) => selection.contains(n.id))
        .toList();

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
      return LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Center(
              child: Text(
                searching ? l.noSearchResultsMessage : l.emptyNotesMessage,
              ),
            ),
          ),
        ),
      );
    }

    return switch (layout) {
      NoteLayout.list => _NotesListView(notes: notes),
      NoteLayout.grid => _NotesGridView(notes: notes),
    };
  }
}

/// The original single-column layout.
class _NotesListView extends ConsumerWidget {
  const _NotesListView({required this.notes});

  final List<Note> notes;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final selection = ref.watch(selectionProvider);
    final selectionMode = selection.isNotEmpty;

    return MaxWidthCenter(
      maxWidth: 900,
      child: ListView.builder(
        itemCount: notes.length,
        itemBuilder: (context, index) {
          final note = notes[index];
          final selected = selection.contains(note.id);
          // Only overrides text color when the note actually has one of its
          // own — leaves the tile's normal theme-driven colors (including
          // the selected-row tint) alone otherwise.
          final textColor = note.color?.onBackground;
          final mutedColor = note.color != null
              ? mutedTextColorOn(note.color!.background)
              : null;
          return ListTile(
            tileColor: note.color?.background,
            selected: selected,
            leading: selectionMode
                ? Icon(selected ? Icons.check_circle : Icons.circle_outlined)
                : Icon(note.isChecklist ? Icons.checklist : Icons.notes),
            title: Text(
              note.title.isEmpty ? l.untitledNote : note.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: textColor != null ? TextStyle(color: textColor) : null,
            ),
            subtitle: Text(
              note.preview,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: mutedColor != null ? TextStyle(color: mutedColor) : null,
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  Formatter.relativeTimestamp(note.updatedAt, l),
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: mutedColor),
                ),
                const SizedBox(height: 4),
                // Same three-state icon as the cloud button in
                // NoteEditorScreen: never synced, up to date, or edited
                // locally since the last sync (still unsynced, but distinct
                // from "never shared" — see that screen's class doc).
                Icon(
                  note.synced
                      ? Icons.cloud_done_outlined
                      : (note.nostrEventId != null
                            ? Icons.cloud_sync_outlined
                            : Icons.cloud_off_outlined),
                  size: 16,
                  color: note.synced
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.outline,
                ),
              ],
            ),
            onTap: () => _openNote(context, ref, note, selectionMode),
            // Long-press always toggles: with nothing selected yet, that's
            // exactly "start selecting, with this note as the first pick".
            onLongPress: () =>
                ref.read(selectionProvider.notifier).toggle(note.id),
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
  const _NotesGridView({required this.notes});

  final List<Note> notes;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final selection = ref.watch(selectionProvider);
    final selectionMode = selection.isNotEmpty;

    return LayoutBuilder(
      builder: (context, constraints) => MasonryGridView.count(
        padding: const EdgeInsets.all(8),
        crossAxisCount: gridColumnsForWidth(constraints.maxWidth),
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        itemCount: notes.length,
        itemBuilder: (context, index) {
          final note = notes[index];
          final selected = selection.contains(note.id);
          final colorScheme = Theme.of(context).colorScheme;
          // Selection highlight wins over a note's own color when both would
          // otherwise apply — the tint is a transient UI state, not the
          // note's actual color, and needs to stay recognizable regardless
          // of what that color is.
          final cardColor = selected
              ? colorScheme.primaryContainer
              : note.color?.background;
          final textColor = !selected ? note.color?.onBackground : null;
          final mutedColor = !selected && note.color != null
              ? mutedTextColorOn(note.color!.background)
              : null;
          return Card(
            clipBehavior: Clip.antiAlias,
            color: cardColor,
            child: InkWell(
              onTap: () => _openNote(context, ref, note, selectionMode),
              onLongPress: () =>
                  ref.read(selectionProvider.notifier).toggle(note.id),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Icon(
                          selectionMode
                              ? (selected
                                    ? Icons.check_circle
                                    : Icons.circle_outlined)
                              : (note.isChecklist
                                    ? Icons.checklist
                                    : Icons.notes),
                          size: 18,
                          color: mutedColor ?? colorScheme.onSurfaceVariant,
                        ),
                        const Spacer(),
                        Icon(
                          note.synced
                              ? Icons.cloud_done_outlined
                              : (note.nostrEventId != null
                                    ? Icons.cloud_sync_outlined
                                    : Icons.cloud_off_outlined),
                          size: 14,
                          color: note.synced
                              ? colorScheme.primary
                              : colorScheme.outline,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      note.title.isEmpty ? l.untitledNote : note.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(
                        context,
                      ).textTheme.titleSmall?.copyWith(color: textColor),
                    ),
                    if (note.preview.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        note.preview,
                        maxLines: 6,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(
                          context,
                        ).textTheme.bodySmall?.copyWith(color: mutedColor),
                      ),
                    ],
                    const SizedBox(height: 8),
                    Text(
                      Formatter.relativeTimestamp(note.updatedAt, l),
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: mutedColor ?? colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Shared by both layouts: toggles selection while already selecting one or
/// more notes, otherwise opens the note for editing.
void _openNote(
  BuildContext context,
  WidgetRef ref,
  Note note,
  bool selectionMode,
) {
  if (selectionMode) {
    ref.read(selectionProvider.notifier).toggle(note.id);
    return;
  }
  Navigator.of(
    context,
  ).push(MaterialPageRoute(builder: (_) => NoteEditorScreen(note: note)));
}

// ── Diary ────────────────────────────────────────────────────────────────

/// A single flattened row in [_DiaryList]'s [ListView.builder]: either a
/// day header or an entry belonging to the day above it. Flattening into
/// one list (rather than one `ListView` per day) avoids nesting a
/// scrollable inside a scrollable for what's otherwise the same
/// "grouped list" shape as the day dividers below.
class _DiaryRow {
  const _DiaryRow.header(this.date) : note = null;
  const _DiaryRow.entry(this.note) : date = null;

  final DateTime? date;
  final Note? note;

  bool get isHeader => date != null;
}

/// The diary's entries, grouped by the calendar day they're tagged with
/// ([Note.entryDate]) — most recent day first, each day introduced by a
/// small timeline-style marker (a dot + a rule) rather than a plain text
/// label, so scrolling through past days reads as a timeline rather than
/// just another flat note list.
class _DiaryList extends ConsumerWidget {
  const _DiaryList({required this.notes});

  final List<Note> notes;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);

    if (notes.isEmpty) {
      final searching = ref.watch(noteSearchProvider).trim().isNotEmpty;
      return LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Center(
              child: Text(
                searching ? l.noSearchResultsMessage : l.emptyDiaryMessage,
              ),
            ),
          ),
        ),
      );
    }

    final sorted = [...notes]
      ..sort(
        (a, b) =>
            (b.entryDate ?? b.updatedAt).compareTo(a.entryDate ?? a.updatedAt),
      );

    final rows = <_DiaryRow>[];
    DateTime? currentDay;
    for (final note in sorted) {
      final date = note.entryDate ?? note.updatedAt;
      final day = DateTime(date.year, date.month, date.day);
      if (currentDay == null || day != currentDay) {
        rows.add(_DiaryRow.header(day));
        currentDay = day;
      }
      rows.add(_DiaryRow.entry(note));
    }

    final selection = ref.watch(selectionProvider);
    final selectionMode = selection.isNotEmpty;

    return MaxWidthCenter(
      maxWidth: 900,
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 8),
        itemCount: rows.length,
        itemBuilder: (context, index) {
          final row = rows[index];
          if (row.isHeader) return _DiaryDayHeader(date: row.date!);
          final note = row.note!;
          return _DiaryEntryTile(
            note: note,
            selected: selection.contains(note.id),
            selectionMode: selectionMode,
          );
        },
      ),
    );
  }
}

/// The small timeline marker introducing each day's entries in
/// [_DiaryList]: a dot in the app's accent color, the day's label (via
/// [Formatter.diaryDateLabel] — "Today"/"Yesterday" or a full localized
/// date), and a rule trailing off to the edge.
class _DiaryDayHeader extends StatelessWidget {
  const _DiaryDayHeader({required this.date});

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: colorScheme.primary,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            Formatter.diaryDateLabel(date, l, Localizations.localeOf(context)),
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(child: Divider(color: colorScheme.outlineVariant)),
        ],
      ),
    );
  }
}

/// A single diary entry within its day's group — same shape as
/// [_NotesListView]'s row (title/preview/sync state) but indented under
/// the day header's dot, so it visually nests underneath it.
class _DiaryEntryTile extends ConsumerWidget {
  const _DiaryEntryTile({
    required this.note,
    required this.selected,
    required this.selectionMode,
  });

  final Note note;
  final bool selected;
  final bool selectionMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final textColor = note.color?.onBackground;
    final mutedColor = note.color != null
        ? mutedTextColorOn(note.color!.background)
        : null;
    return ListTile(
      contentPadding: const EdgeInsets.only(left: 34, right: 16),
      tileColor: note.color?.background,
      selected: selected,
      leading: selectionMode
          ? Icon(selected ? Icons.check_circle : Icons.circle_outlined)
          : null,
      title: Text(
        note.title.isEmpty ? l.untitledNote : note.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: textColor != null ? TextStyle(color: textColor) : null,
      ),
      subtitle: note.preview.isEmpty
          ? null
          : Text(
              note.preview,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: mutedColor != null ? TextStyle(color: mutedColor) : null,
            ),
      trailing: Icon(
        note.synced
            ? Icons.cloud_done_outlined
            : (note.nostrEventId != null
                  ? Icons.cloud_sync_outlined
                  : Icons.cloud_off_outlined),
        size: 16,
        color: note.synced ? colorScheme.primary : colorScheme.outline,
      ),
      onTap: () => _openNote(context, ref, note, selectionMode),
      onLongPress: () => ref.read(selectionProvider.notifier).toggle(note.id),
    );
  }
}

/// The Diary tab's FAB: a single action (there's only one kind of diary
/// entry, unlike the Notes tab's plain/checklist/voice choice), so this
/// skips [_NewNoteFab]'s speed-dial menu entirely and opens a fresh entry
/// directly.
class _NewDiaryEntryFab extends StatelessWidget {
  const _NewDiaryEntryFab();

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: 'fab_diary',
      onPressed: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => const NoteEditorScreen(isDiaryEntry: true),
        ),
      ),
      child: const Icon(Icons.add),
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
            Icon(
              Icons.lock_outline,
              size: 48,
              color: Theme.of(context).colorScheme.primary,
            ),
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
        child: Text(
          AppLocalizations.of(context).errorLoadingNotes(error.toString()),
        ),
      ),
    );
  }
}

/// The Home FAB, expanded into a small floating menu of icon-only buttons
/// (each with its label to its left, no card/panel behind the group) for
/// the three kinds of note that can be started: plain, checklist, voice.
/// Tapping the main `+` again (now rotated into a `×`) collapses it.
class _NewNoteFab extends ConsumerStatefulWidget {
  const _NewNoteFab();

  @override
  ConsumerState<_NewNoteFab> createState() => _NewNoteFabState();
}

class _NewNoteFabState extends ConsumerState<_NewNoteFab>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 280),
  );

  // One eased sub-interval of the controller per option, staggered so they
  // don't all move in lockstep. Ordered by on-screen distance from the main
  // FAB (closest first) so the nearest option leads the rise on open — and,
  // since a reversed Animation just plays the same curve backwards, leads
  // the collapse back into the FAB on close too.
  late final List<Animation<double>> _optionAnimations = List.generate(
    3,
    (order) => CurvedAnimation(
      parent: _controller,
      curve: Interval(
        order * 0.15,
        order * 0.15 + 0.7,
        curve: Curves.easeOutCubic,
      ),
      reverseCurve: Interval(
        order * 0.15,
        order * 0.15 + 0.7,
        curve: Curves.easeInCubic,
      ),
    ),
  );

  void _choose(BuildContext context, Widget screen) {
    ref.read(fabMenuProvider.notifier).close();
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Wraps [option] so it visually "grows out of" the main FAB and rises
  /// into place as [animation] goes 0→1, and sinks back down into it in
  /// reverse — rather than an instant show/hide. Collapsing the allocated
  /// height too (via `Align.heightFactor`, not just fading/scaling in
  /// place) means a closed option doesn't leave a dead gap above the FAB
  /// or an invisible-but-still-tappable hit area. `widthFactor: 1` keeps
  /// this shrink-wrapped to the option's own width — without it, `Align`
  /// expands to fill the row's available width and, combined with
  /// `crossAxisAlignment.end` on the parent `Column`, throws the whole
  /// button off to the left instead of hugging the right edge.
  Widget _animatedOption(Animation<double> animation, Widget option) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final t = animation.value;
        return IgnorePointer(
          ignoring: t == 0,
          child: Align(
            alignment: Alignment.bottomRight,
            heightFactor: t,
            widthFactor: 1,
            child: Opacity(
              opacity: t,
              child: Transform.scale(
                scale: t,
                alignment: Alignment.bottomRight,
                child: child,
              ),
            ),
          ),
        );
      },
      child: Padding(padding: const EdgeInsets.only(bottom: 12), child: option),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    // The open/closed flag lives in a provider (not local State) so a tap
    // anywhere else on the screen — via HomeScreen's dismiss barrier — can
    // close this menu too, not just tapping the FAB itself again. `ref.listen`
    // (rather than comparing state inline during build) drives the
    // AnimationController exactly once per actual open/close transition.
    ref.listen<bool>(fabMenuProvider, (previous, open) {
      if (open) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
    final open = ref.watch(fabMenuProvider);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Voice notes need `audio_waveforms` for playback, which has no
        // Linux/Windows backend — see [PlatformSupport.supportsVoiceNotes].
        if (PlatformSupport.supportsVoiceNotes)
          _animatedOption(
            _optionAnimations[2],
            _FabOption(
              heroTag: 'fab_voice',
              label: l.newVoiceNoteOption,
              icon: Icons.mic_none_outlined,
              onTap: () => _choose(
                context,
                const NoteEditorScreen(startRecording: true),
              ),
            ),
          ),
        _animatedOption(
          _optionAnimations[1],
          _FabOption(
            heroTag: 'fab_checklist',
            label: l.newChecklistOption,
            icon: Icons.checklist,
            onTap: () => _choose(
              context,
              const NoteEditorScreen(startAsChecklist: true),
            ),
          ),
        ),
        _animatedOption(
          _optionAnimations[0],
          _FabOption(
            heroTag: 'fab_note',
            label: l.newPlainNoteOption,
            icon: Icons.notes,
            onTap: () => _choose(context, const NoteEditorScreen()),
          ),
        ),
        FloatingActionButton(
          heroTag: 'fab_main',
          onPressed: () => ref.read(fabMenuProvider.notifier).toggle(),
          // A full spin that lands on the ×. Geometry note: a "+" glyph only
          // reads as a "×" at 45° (+ any multiple of 90°); a literal 450°
          // (1.25 turns) is 360°+90°, which spins right back to looking like a
          // "+". 405° (1.125 turns) is the nearest value that both does the
          // extra whirl the user wanted and actually lands on the ×.
          child: AnimatedRotation(
            turns: open ? 1.125 : 0,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOutBack,
            child: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }
}

class _FabOption extends StatelessWidget {
  const _FabOption({
    required this.heroTag,
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String heroTag;
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // The label sits directly on the note list behind it — no
        // card/box background, per the request — with just enough shadow
        // to stay legible over whatever content happens to be underneath.
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            shadows: [
              Shadow(
                blurRadius: 6,
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        FloatingActionButton.small(
          heroTag: heroTag,
          onPressed: onTap,
          child: Icon(icon),
        ),
      ],
    );
  }
}
