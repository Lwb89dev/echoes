import 'dart:io';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../l10n/app_localizations.dart';
import '../models/attachment.dart';
import '../models/note.dart';
import '../providers/auth_provider.dart';
import '../providers/notes_provider.dart';
import '../providers/service_providers.dart';
import '../utils/formatter.dart';
import 'widgets/note_actions.dart';
import 'widgets/voice_recorder.dart';

/// Editor for creating or editing a note. If [note] is null this is a new
/// note; otherwise the edit is in place and saving bumps [Note.updatedAt].
///
/// Editing a note that was already synced does not retract or corrupt
/// what's on the relay: it only ever flips the *local* copy to
/// `synced: false` (see [_markDirty]/[_buildNote]) while keeping its
/// [Note.nostrEventId]. The cloud button in the app bar reflects that
/// distinction — a "needs sync" icon rather than the plain "never synced"
/// one — and pressing it (or waiting for the next automatic sync cycle,
/// see [NostrService.syncLocalNotes]) republishes the edited content under
/// the *same* parameterized-replaceable coordinate (kind + pubkey + the
/// note's own `d` tag), so relays honoring NIP-33/78 simply replace the
/// old version rather than keeping both around.
class NoteEditorScreen extends ConsumerStatefulWidget {
  const NoteEditorScreen({
    super.key,
    this.note,
    this.startAsChecklist = false,
    this.startRecording = false,
    this.isDiaryEntry = false,
  });

  final Note? note;

  /// Set by the Home FAB's "checklist" option when creating a brand-new
  /// note — has no effect when [note] is non-null (an existing note's own
  /// [Note.isChecklist] always wins).
  final bool startAsChecklist;

  /// Set by the Home FAB's "voice note" option: shows the recorder (see
  /// [VoiceRecorder]) inline as soon as this screen opens, instead of
  /// requiring an extra tap to start recording.
  final bool startRecording;

  /// Set by [DiaryScreen]'s FAB when creating a brand-new diary entry — has
  /// no effect when [note] is non-null (an existing note's own
  /// [Note.isDiaryEntry] always wins). A diary entry is otherwise a
  /// perfectly ordinary [Note]: same title/body/attachments/sync, just
  /// listed in [DiaryScreen] instead of the main note list and tagged with
  /// an editable [Note.entryDate] (see [_entryDate]/[_pickEntryDate])
  /// instead of always defaulting to "today".
  final bool isDiaryEntry;

  @override
  ConsumerState<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends ConsumerState<NoteEditorScreen> {
  late final TextEditingController _titleController;
  late final TextEditingController _bodyController;
  late bool _isChecklist;

  // Stable for the lifetime of this screen, generated once instead of at
  // save time: the cloud button can trigger a save independently of (and
  // possibly more than once relative to) the final "save and close" tap,
  // so regenerating a random id per save would silently create duplicate
  // notes instead of updating the same one.
  late final String _noteId;
  late final DateTime _createdAt;

  bool _synced = false;
  bool _syncing = false;

  // Tracked separately from `widget.note` (immutable for this screen's
  // lifetime) because [_syncNow]/[_unsyncNow] can change it mid-session —
  // e.g. sync a brand-new note, then keep editing without leaving the
  // screen. `_buildNote` must see the *current* event id, not whatever
  // `widget.note` was constructed with.
  String? _nostrEventId;

  // Fixed for the lifetime of this screen, same rationale as `_noteId`: an
  // existing note's own [Note.isDiaryEntry] always wins over the
  // Diary-FAB's request, and there's no in-editor way to convert between
  // the two (same as `_isChecklist`).
  late final bool _isDiaryEntry;

  // Only meaningful when `_isDiaryEntry` is true; null otherwise. Distinct
  // from `_createdAt`/`updatedAt`: this is the calendar date the entry is
  // *about*, editable via [_pickEntryDate] so a day can be logged
  // retroactively — the two only coincide by default, for a brand-new entry.
  DateTime? _entryDate;

  // Checklist items are edited with one persistent TextEditingController +
  // FocusNode per row (kept in sync by index with `_checklistDone`), instead
  // of rebuilding a TextFormField's `initialValue` on every keystroke. This
  // is what lets us move focus to a freshly inserted row programmatically
  // (see [_addChecklistItemAfter]) and keep the cursor stable while typing.
  final List<bool> _checklistDone = [];
  final List<TextEditingController> _checklistControllers = [];
  final List<FocusNode> _checklistFocusNodes = [];

  // Image/voice attachments. `AttachmentUploadService.upload` fills in
  // `url`/decryption fields in place (see [_syncNow]) once a pending one
  // is actually uploaded — nothing here removes an entry except the user
  // explicitly tapping its remove button.
  final List<Attachment> _attachments = [];

  List<Attachment> get _imageAttachments =>
      _attachments.where((a) => a.type == AttachmentType.image).toList();
  List<Attachment> get _audioAttachments =>
      _attachments.where((a) => a.type == AttachmentType.audio).toList();

  /// Image attachments not referenced by any `attachment://<id>` token in
  /// the body — checklist notes (which have no markdown body to embed an
  /// image in) and notes created before inline images existed both fall
  /// back to showing these in the plain attachment strip, so nothing a
  /// user already attached silently becomes inaccessible.
  List<Attachment> get _unreferencedImageAttachments {
    final body = _bodyController.text;
    return _imageAttachments.where((a) => !body.contains('attachment://${a.id}')).toList();
  }

  bool _showRecorder = false;

  // Whether this screen is showing the editable form (text fields,
  // formatting toolbar, attachment controls) or the read-only rendered
  // view. A brand-new note has nothing to "view" yet, so it opens straight
  // into editing; an existing note opens read-only and only switches to
  // editing once the user taps its content (see [_enterEditMode]) — no
  // separate edit-mode button, the whole point of this over the old
  // preview/edit toggle icon.
  late bool _editing;

  bool get _isNewNote => widget.note == null;

  @override
  void initState() {
    super.initState();
    final note = widget.note;
    _noteId = note?.id ?? const Uuid().v4();
    _createdAt = note?.createdAt ?? DateTime.now();
    _synced = note?.synced ?? false;
    _nostrEventId = note?.nostrEventId;
    _isDiaryEntry = note?.isDiaryEntry ?? widget.isDiaryEntry;
    _entryDate = note?.entryDate ?? (_isDiaryEntry ? DateTime.now() : null);
    _titleController = TextEditingController(text: note?.title ?? '')..addListener(_markDirty);
    _bodyController = TextEditingController(text: note?.body ?? '')..addListener(_markDirty);
    _isChecklist = note?.isChecklist ?? (_isNewNote && widget.startAsChecklist);
    _attachments.addAll(note?.attachments ?? const <Attachment>[]);
    _showRecorder = _isNewNote && widget.startRecording;
    _editing = _isNewNote;

    for (final item in note?.items ?? const <ChecklistItem>[]) {
      _checklistDone.add(item.done);
      _checklistControllers.add(TextEditingController(text: item.text)..addListener(_markDirty));
      _checklistFocusNodes.add(FocusNode());
    }
  }

  /// Flags on-screen content as different from what's on the relay the
  /// instant the user changes anything — before they even save — so the
  /// cloud icon never shows a stale "synced" state while there are
  /// unpushed edits. Without this, tapping the cloud mid-edit would run
  /// [_unsyncNow] (the action bound to "already synced") and retract the
  /// *previous* version from the relay instead of publishing the new one.
  void _markDirty() {
    if (_synced) setState(() => _synced = false);
  }

  /// Switches from the read-only view into the editable form — the sole
  /// way in, triggered by tapping anywhere on the read view's content (see
  /// [_buildViewBody]) rather than a dedicated edit button.
  void _enterEditMode() {
    if (!_editing) setState(() => _editing = true);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    for (final controller in _checklistControllers) {
      controller.dispose();
    }
    for (final node in _checklistFocusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  /// Inserts a new empty checklist row right after [index] and moves keyboard
  /// focus to it. Passing -1 inserts (and focuses) the first row.
  void _addChecklistItemAfter(int index) {
    final insertAt = index + 1;
    final focusNode = FocusNode();
    setState(() {
      _checklistDone.insert(insertAt, false);
      _checklistControllers.insert(insertAt, TextEditingController()..addListener(_markDirty));
      _checklistFocusNodes.insert(insertAt, focusNode);
      _synced = false;
    });
    // The new row's TextField doesn't exist yet in the widget tree until
    // this frame finishes building, so the focus request has to wait for it.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) focusNode.requestFocus();
    });
  }

  void _removeChecklistItem(int index) {
    setState(() {
      _checklistDone.removeAt(index);
      _checklistControllers.removeAt(index).dispose();
      _checklistFocusNodes.removeAt(index).dispose();
      _synced = false;
    });
  }

  void _setChecklistItemDone(int index, bool done) {
    setState(() {
      _checklistDone[index] = done;
      _synced = false;
    });
  }

  /// Lets the user pick a local image (via `file_picker`, already a
  /// dependency for notes export/import — no need for a separate
  /// `image_picker` package), appends it as a pending attachment (stays
  /// local-only, no `url`, until the next sync uploads it — see
  /// [_syncNow]) and inserts a reference to it into the body's markdown
  /// text (`![](attachment://<id> "size")`) so it renders inline once back
  /// in the read-only view instead of sitting in a separate attachment
  /// strip — while still editing, it's just raw `![]()` text like any
  /// other markdown syntax (there's no live WYSIWYG mode).
  Future<void> _addImage() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    final path = result?.files.single.path;
    if (path == null) return;

    final extension = path.split('.').last.toLowerCase();
    final mimeType = switch (extension) {
      'png' => 'image/png',
      'gif' => 'image/gif',
      'webp' => 'image/webp',
      _ => 'image/jpeg',
    };
    final attachment = Attachment(
      id: const Uuid().v4(),
      type: AttachmentType.image,
      localPath: path,
      mimeType: mimeType,
    );

    final size = await _pickImageSize(currentSize: 'medium');
    if (size == null || !mounted) return;

    setState(() {
      _attachments.add(attachment);
      _insertImageToken(attachment.id, size);
      _synced = false;
    });
  }

  /// Matches the specific inline image token referencing [attachmentId],
  /// regardless of its current size keyword — used to update or remove it
  /// without disturbing any other text around it.
  RegExp _imageTokenPattern(String attachmentId) {
    return RegExp('!\\[[^\\]]*\\]\\(attachment://${RegExp.escape(attachmentId)}(?:\\s+"[^"]*")?\\)');
  }

  /// Inserts a fresh inline image token at the current cursor position (or
  /// the end, if there isn't a valid selection), adding surrounding
  /// newlines only where the text doesn't already have one — markdown
  /// treats an image sharing a line with other text as part of the same
  /// paragraph, which isn't what "add image" should produce.
  void _insertImageToken(String attachmentId, String widthKeyword) {
    final token = '![](attachment://$attachmentId "$widthKeyword")';
    final text = _bodyController.text;
    final selection = _bodyController.selection;
    final insertAt = selection.isValid ? selection.start : text.length;
    final needsLeadingNewline = insertAt > 0 && text[insertAt - 1] != '\n';
    final needsTrailingNewline = insertAt < text.length && text[insertAt] != '\n';
    final insertion = '${needsLeadingNewline ? '\n' : ''}$token${needsTrailingNewline ? '\n' : ''}';
    _bodyController.text = text.replaceRange(insertAt, insertAt, insertion);
  }

  /// Changes an already-inserted image's size keyword in place — the tap
  /// target in the read-only view (see [_InlineAttachmentImage]) for
  /// "resize" without a drag handle.
  void _setImageSize(String attachmentId, String widthKeyword) {
    setState(() {
      _bodyController.text = _bodyController.text.replaceFirst(
        _imageTokenPattern(attachmentId),
        '![](attachment://$attachmentId "$widthKeyword")',
      );
      _synced = false;
    });
  }

  /// Removes an inline image: both its token from the body text and the
  /// underlying [Attachment] (via [_removeAttachment], which also cleans
  /// up the not-yet-uploaded local file, if any).
  void _removeInlineImage(Attachment attachment) {
    setState(() {
      _bodyController.text = _bodyController.text.replaceFirst(_imageTokenPattern(attachment.id), '');
    });
    _removeAttachment(attachment);
  }

  // ── Formatting toolbar ──────────────────────────────────────────────
  //
  // No live WYSIWYG here either — these just insert/wrap plain markdown
  // syntax around the current selection (or the cursor, if nothing's
  // selected), the same as typing it by hand. The result only renders
  // formatted once back in the read-only view (see [_buildViewBody]).

  /// Wraps the current selection in [prefix]/[suffix] (bold "**"/"**",
  /// italic "*"/"*") — inserted around the cursor with nothing selected.
  /// Leaves the wrapped text selected afterward so the result of the tap
  /// is immediately visible instead of just moving the cursor.
  void _wrapBodySelection(String prefix, [String? suffix]) {
    final effectiveSuffix = suffix ?? prefix;
    final text = _bodyController.text;
    final selection = _bodyController.selection;
    final start = selection.isValid ? selection.start : text.length;
    final end = selection.isValid ? selection.end : text.length;
    final selected = text.substring(start, end);

    setState(() {
      _bodyController.value = TextEditingValue(
        text: text.replaceRange(start, end, '$prefix$selected$effectiveSuffix'),
        selection: TextSelection(
          baseOffset: start + prefix.length,
          extentOffset: start + prefix.length + selected.length,
        ),
      );
    });
  }

  /// Prepends [prefix] to the start of every line touched by the current
  /// selection (or just the cursor's line, if nothing is selected) — used
  /// for the heading ("# ") and bulleted-list ("- ") toolbar buttons, so
  /// selecting several lines and tapping "list" turns all of them into
  /// list items at once rather than just the first.
  void _prefixBodyLines(String prefix) {
    final text = _bodyController.text;
    final selection = _bodyController.selection;
    final start = selection.isValid ? selection.start : text.length;
    final end = selection.isValid ? selection.end : text.length;

    final lineStart = text.lastIndexOf('\n', start > 0 ? start - 1 : 0) + 1;
    final nextNewline = text.indexOf('\n', end);
    final lineEnd = nextNewline == -1 ? text.length : nextNewline;

    final block = text.substring(lineStart, lineEnd);
    final prefixedBlock =
        block.isEmpty ? prefix : block.split('\n').map((line) => '$prefix$line').join('\n');
    final addedLength = prefixedBlock.length - block.length;

    setState(() {
      _bodyController.value = TextEditingValue(
        text: text.replaceRange(lineStart, lineEnd, prefixedBlock),
        selection: TextSelection(
          baseOffset: start + prefix.length,
          extentOffset: end + addedLength,
        ),
      );
    });
  }

  /// Inserts a markdown link around the current selection (used as the
  /// link text/label) with a `url` placeholder immediately selected
  /// afterward, so typing right away replaces it — no separate dialog
  /// needed just to fill in an address.
  void _insertLink() {
    final text = _bodyController.text;
    final selection = _bodyController.selection;
    final start = selection.isValid ? selection.start : text.length;
    final end = selection.isValid ? selection.end : text.length;
    final label = text.substring(start, end);
    final insertion = '[$label](url)';
    final urlOffset = start + label.length + 3; // right after "[label]("

    setState(() {
      _bodyController.value = TextEditingValue(
        text: text.replaceRange(start, end, insertion),
        selection: TextSelection(baseOffset: urlOffset, extentOffset: urlOffset + 3),
      );
    });
  }

  /// Bottom sheet offering the predefined widths an inline image can be
  /// shown at (no drag-to-resize — see the FAB/deletion-progress work this
  /// session for the same "keep it simple" call on other features) plus a
  /// way to remove it. Tapping a size only highlights it — an explicit
  /// Confirm button is what actually closes the sheet and returns the
  /// choice, so picking the wrong option isn't a one-tap commit with no
  /// way to reconsider. Returns the chosen size keyword, or null if the
  /// sheet was dismissed/cancelled without confirming.
  Future<String?> _pickImageSize({required String? currentSize, VoidCallback? onRemove}) async {
    final l = AppLocalizations.of(context);
    var selected = currentSize ?? 'medium';
    return showModalBottomSheet<String>(
      context: context,
      builder: (sheetContext) => StatefulBuilder(
        builder: (sheetContext, setSheetState) => SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioGroup<String>(
                groupValue: selected,
                onChanged: (value) {
                  if (value != null) setSheetState(() => selected = value);
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (final option in const ['small', 'medium', 'full'])
                      RadioListTile<String>(
                        value: option,
                        title: Text(switch (option) {
                          'small' => l.imageSizeSmall,
                          'full' => l.imageSizeFull,
                          _ => l.imageSizeMedium,
                        }),
                      ),
                  ],
                ),
              ),
              if (onRemove != null) ...[
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.delete_outline),
                  title: Text(l.removeImageButton),
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    onRemove();
                  },
                ),
              ],
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(sheetContext).pop(),
                      child: Text(l.cancelButton),
                    ),
                    const SizedBox(width: 8),
                    FilledButton(
                      onPressed: () => Navigator.of(sheetContext).pop(selected),
                      child: Text(l.confirmButton),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Handles a tap on an already-inserted inline image (see
  /// [_MarkdownPreview]/[_InlineAttachmentImage]): offers the same
  /// small/medium/full size choices as adding one, plus removal.
  Future<void> _editInlineImage(Attachment attachment, String? currentSize) async {
    final size = await _pickImageSize(
      currentSize: currentSize,
      onRemove: () => _removeInlineImage(attachment),
    );
    if (size != null) _setImageSize(attachment.id, size);
  }

  /// Called by [VoiceRecorder] once recording stops: appends the recording
  /// as a pending `audio` attachment (same upload-on-sync path as images)
  /// and hides the recorder — one voice note per FAB tap, matching how the
  /// FAB's other two options each produce a single piece of content.
  void _onVoiceRecorded(String path, Duration duration) {
    setState(() {
      _attachments.add(Attachment(
        id: const Uuid().v4(),
        type: AttachmentType.audio,
        localPath: path,
        mimeType: 'audio/mp4',
        durationSeconds: duration.inSeconds,
      ));
      _showRecorder = false;
      _synced = false;
    });
  }

  void _removeAttachment(Attachment attachment) {
    // Best-effort: if this was still pending (never uploaded), its local
    // copy has no other purpose once removed from the note — don't leave
    // a private photo or recording sitting in the cache directory just
    // because the model reference to it was dropped.
    final localPath = attachment.localPath;
    if (!attachment.isUploaded && localPath != null) {
      _deleteLocalFileQuietly(localPath);
    }
    setState(() {
      _attachments.removeWhere((a) => a.id == attachment.id);
      _synced = false;
    });
  }

  /// Lets the user change this diary entry's [_entryDate] to any arbitrary
  /// day — logging "today" is just the default, not the only option (see
  /// [DiaryScreen]). Bounded to the past 100 years (backdating an old
  /// entry) through tomorrow (writing one slightly ahead, e.g. for a
  /// midnight-adjacent entry) rather than an unbounded range.
  Future<void> _pickEntryDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _entryDate ?? now,
      firstDate: DateTime(now.year - 100),
      lastDate: now.add(const Duration(days: 1)),
    );
    if (picked == null) return;
    setState(() {
      _entryDate = picked;
      _synced = false;
    });
  }

  Future<void> _deleteLocalFileQuietly(String path) async {
    try {
      await File(path).delete();
    } catch (_) {
      // Nothing useful to do with a cleanup failure here.
    }
  }

  /// Builds a [Note] from the current field values. Editing always resets
  /// `synced` to false: the local copy no longer matches whatever was last
  /// published (if anything), until the cloud button re-syncs it.
  Note _buildNote() {
    final items = <ChecklistItem>[
      for (var i = 0; i < _checklistControllers.length; i++)
        ChecklistItem(text: _checklistControllers[i].text, done: _checklistDone[i]),
    ];

    return Note(
      id: _noteId,
      title: _titleController.text.trim(),
      body: _bodyController.text,
      items: items,
      isChecklist: _isChecklist,
      attachments: _attachments,
      createdAt: _createdAt,
      updatedAt: DateTime.now(),
      synced: false,
      nostrEventId: _nostrEventId,
      isDiaryEntry: _isDiaryEntry,
      entryDate: _entryDate,
    );
  }

  Future<void> _save() async {
    await ref.read(notesProvider.notifier).saveNote(_buildNote());
    if (mounted) Navigator.of(context).pop();
  }

  /// Publishes the note. Uploading any not-yet-uploaded attachment first is
  /// [SyncService]'s job (shared with the multi-select sync action and the
  /// unattended auto-sync cycle — see [SyncService.syncNote]), not this
  /// screen's: its JSON must always point at a real URL for other devices
  /// to fetch, never a path that only exists on this one.
  ///
  /// Must survive the user navigating away from this screen before it
  /// finishes — the whole point of the cloud button is "publish this
  /// now", not "publish this only if I keep the editor open the whole
  /// time". Two things stop working the instant this screen is popped:
  /// `ref` (Riverpod throws if a disposed widget's `ref` is read again)
  /// and every `TextEditingController` (`_buildNote` would throw reading
  /// a disposed one). So everything both depend on is captured *before*
  /// any `await` below — every provider lookup and the note's text
  /// content — and nothing after that first line touches `ref` or a
  /// controller again, however long the upload/publish takes.
  Future<void> _syncNow() async {
    final l = AppLocalizations.of(context);
    setState(() => _syncing = true);

    final author = ref.read(authProvider).value;
    final notesNotifier = ref.read(notesProvider.notifier);
    final draft = _buildNote();

    try {
      if (author == null) {
        throw StateError('Cannot sync without a Nostr account.');
      }

      // Saved with whatever local-only attachments it still has *before*
      // the upload/publish below: a failure partway through must not lose
      // the edit, only leave it (still, correctly) marked unsynced.
      await notesNotifier.saveNote(draft);
      final syncedNote = await notesNotifier.syncNote(draft);
      if (!mounted) return;
      setState(() {
        // Reflects whatever SyncService just uploaded (urls/decryption
        // material filled in) back into the editor's own attachment list,
        // so e.g. a thumbnail switches from the local file to the
        // now-uploaded one without needing to reopen the note.
        _attachments
          ..clear()
          ..addAll(syncedNote.attachments);
        _synced = syncedNote.synced;
        _nostrEventId = syncedNote.nostrEventId;
        _syncing = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _synced = false;
        _syncing = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.syncNoteError(e.toString()))),
      );
    }
  }

  /// Retracts the note from the relays (NIP-09 deletion event) while
  /// keeping it locally — the counterpart to [_syncNow], triggered by
  /// tapping the cloud button once it's already showing "synced". Same
  /// survives-navigating-away rationale as [_syncNow]: `notesNotifier`
  /// and `note` are both captured before the only `await` here.
  Future<void> _unsyncNow() async {
    final l = AppLocalizations.of(context);
    setState(() => _syncing = true);
    final notesNotifier = ref.read(notesProvider.notifier);
    final note = _buildNote();
    try {
      final unsyncedNote = await notesNotifier.unsyncNote(note);
      if (!mounted) return;
      setState(() {
        _synced = unsyncedNote.synced;
        _nostrEventId = unsyncedNote.nostrEventId;
        _syncing = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _syncing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.unsyncNoteError(e.toString()))),
      );
    }
  }

  /// Confirms, then deletes, the note currently open in this screen (see
  /// [deleteNotes] — shared with the note list's multi-select delete
  /// action). Pops the editor on confirmation, since the note it was
  /// showing no longer exists to keep editing regardless of whether the
  /// relay retraction itself succeeded.
  Future<void> _delete() async {
    final l = AppLocalizations.of(context);
    final note = widget.note;
    if (note == null) return;
    final deleted = await deleteNotes(context, ref, l, [note]);
    if (deleted && mounted) Navigator.of(context).pop();
  }

  String _appBarTitle(AppLocalizations l) {
    if (_isDiaryEntry) {
      return _isNewNote ? l.newDiaryEntryTitle : l.editDiaryEntryTitle;
    }
    return _isNewNote ? l.newNoteTitle : l.editNoteTitle;
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final hasNostrAccount = ref.watch(authProvider).value != null;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(_appBarTitle(l)),
        actions: [
          if (hasNostrAccount)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: _syncing
                  ? const SizedBox(
                      width: 40,
                      height: 40,
                      child: Center(
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                    )
                  : IconButton.outlined(
                      // Three visually distinct states: never synced (plain
                      // "off" cloud), synced and up to date (filled cloud,
                      // primary color), and previously synced but edited
                      // since (a "needs sync" cloud, same outline color as
                      // "never synced" since the tap action is identical —
                      // publish now — but a different icon shape so editing
                      // an already-shared note doesn't look identical to a
                      // note that was never shared at all).
                      icon: Icon(
                        _synced
                            ? Icons.cloud_done_outlined
                            : (_nostrEventId != null ? Icons.cloud_sync_outlined : Icons.cloud_off_outlined),
                      ),
                      tooltip: _synced ? l.unsyncNoteTooltip : l.syncNoteTooltip,
                      style: IconButton.styleFrom(
                        side: BorderSide(
                          color: _synced ? colorScheme.primary : colorScheme.outline,
                        ),
                        foregroundColor: _synced ? colorScheme.primary : colorScheme.outline,
                      ),
                      onPressed: _synced ? _unsyncNow : _syncNow,
                    ),
            ),
          // Replaces the old preview/edit toggle icon: only meaningful
          // while actively editing a non-checklist note (a checklist has
          // no image-bearing body to add one into).
          if (_editing && !_isChecklist)
            IconButton(
              icon: const Icon(Icons.add_photo_alternate_outlined),
              tooltip: l.addImageButton,
              onPressed: _addImage,
            ),
          if (!_isNewNote)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              tooltip: l.deleteNoteButton,
              onPressed: _delete,
            ),
          if (_editing)
            IconButton(
              icon: const Icon(Icons.check),
              tooltip: l.saveTooltip,
              onPressed: _save,
            ),
        ],
      ),
      body: _editing ? _buildEditBody(l) : _buildViewBody(l),
    );
  }

  /// The editable form: title/body text fields (or the checklist editor),
  /// the formatting toolbar, and every attachment control — everything
  /// that was always on this screen before the read/edit split.
  Widget _buildEditBody(AppLocalizations l) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_isDiaryEntry) _DiaryDateSelector(date: _entryDate!, onTap: _pickEntryDate),
          TextField(
            controller: _titleController,
            decoration: InputDecoration(
              labelText: l.titleFieldLabel,
              border: InputBorder.none,
            ),
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const Divider(),
          if (_isChecklist)
            _ChecklistEditor(
              doneFlags: _checklistDone,
              controllers: _checklistControllers,
              focusNodes: _checklistFocusNodes,
              onToggleDone: _setChecklistItemDone,
              onSubmitted: _addChecklistItemAfter,
              onRemove: _removeChecklistItem,
              onAddItem: () => _addChecklistItemAfter(_checklistControllers.length - 1),
            )
          else ...[
            _FormattingToolbar(
              onBold: () => _wrapBodySelection('**'),
              onItalic: () => _wrapBodySelection('*'),
              onHeading: () => _prefixBodyLines('# '),
              onList: () => _prefixBodyLines('- '),
              onLink: _insertLink,
            ),
            TextField(
              controller: _bodyController,
              decoration: InputDecoration(
                labelText: l.bodyFieldHint,
                border: InputBorder.none,
              ),
              maxLines: null,
              minLines: 10,
            ),
          ],
          const SizedBox(height: 12),
          if (!_showRecorder)
            IconButton(
              icon: const Icon(Icons.mic_none_outlined),
              tooltip: l.recordVoiceNoteTooltip,
              onPressed: () => setState(() => _showRecorder = true),
            ),
          if (_showRecorder)
            VoiceRecorder(
              onRecorded: _onVoiceRecorded,
              onCancel: () => setState(() => _showRecorder = false),
            ),
          if (_unreferencedImageAttachments.isNotEmpty)
            _AttachmentsStrip(attachments: _unreferencedImageAttachments, onRemove: _removeAttachment),
          // Voice notes get their own full-width "message" bubble (with a
          // waveform, like Telegram) rather than being squeezed into the
          // same small square thumbnail strip as images.
          for (final attachment in _audioAttachments)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: _VoiceMessageBubble(
                attachment: attachment,
                onRemove: () => _removeAttachment(attachment),
              ),
            ),
        ],
      ),
    );
  }

  /// The read-only rendered view an existing note opens into: title,
  /// rendered markdown body (or a read-only checklist), and attachments,
  /// none of it directly editable. Tapping *anywhere* in it — the sole
  /// entry point into editing, see [_enterEditMode] — switches to
  /// [_buildEditBody]; a few genuinely read-only interactions (playing a
  /// voice note) are left to still work without triggering that, since
  /// they're not an editing intent.
  Widget _buildViewBody(AppLocalizations l) {
    return LayoutBuilder(
      builder: (context, constraints) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: _enterEditMode,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_isDiaryEntry) _DiaryDateSelector(date: _entryDate!, onTap: _enterEditMode),
                Text(
                  _titleController.text.isEmpty ? l.untitledNote : _titleController.text,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const Divider(),
                if (_isChecklist)
                  _ReadOnlyChecklist(
                    doneFlags: _checklistDone,
                    texts: [for (final controller in _checklistControllers) controller.text],
                  )
                else
                  _MarkdownPreview(
                    text: _bodyController.text,
                    attachments: _attachments,
                    // Same resize/remove bottom sheet as while editing
                    // (see [_editInlineImage]) rather than routing through
                    // [_enterEditMode]: like voice playback and the diary
                    // date chip above, this is a self-contained action
                    // that doesn't need the full raw-text editor open.
                    onTapImage: _editInlineImage,
                  ),
                if (_unreferencedImageAttachments.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  _AttachmentsStrip(attachments: _unreferencedImageAttachments, onRemove: null),
                ],
                for (final attachment in _audioAttachments)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: _VoiceMessageBubble(attachment: attachment, onRemove: null),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// The date chip shown at the top of a diary entry (see
/// [NoteEditorScreen.isDiaryEntry]) — tapping it opens a date picker (see
/// [_NoteEditorScreenState._pickEntryDate]) to log the entry under a day
/// other than today, a rounded tonal pill (rather than a plain text row)
/// so it visually reads as tappable/editable at a glance, matching the
/// tonal-surface language already used elsewhere (e.g. Settings' relay
/// `ExpansionTile`).
class _DiaryDateSelector extends StatelessWidget {
  const _DiaryDateSelector({required this.date, required this.onTap});

  final DateTime date;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.edit_calendar_outlined, size: 16, color: colorScheme.onPrimaryContainer),
              const SizedBox(width: 6),
              Text(
                Formatter.diaryDateLabel(date, l, Localizations.localeOf(context)),
                style: Theme.of(context)
                    .textTheme
                    .labelLarge
                    ?.copyWith(color: colorScheme.onPrimaryContainer),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Horizontal strip of the note's current attachments (images and voice
/// notes together, in the order they were added) — each shown as a small
/// square thumbnail/player chip with a remove (✕) overlay.
class _AttachmentsStrip extends ConsumerWidget {
  const _AttachmentsStrip({required this.attachments, required this.onRemove});

  final List<Attachment> attachments;

  /// Null in the read-only view (see
  /// [_NoteEditorScreenState._buildViewBody]): hides every chip's remove
  /// (✕) overlay instead of wiring it to an action that shouldn't be
  /// reachable outside editing.
  final void Function(Attachment attachment)? onRemove;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 88,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: attachments.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final attachment = attachments[index];
          final remove = onRemove;
          return _AttachmentChip(
            attachment: attachment,
            onRemove: remove == null ? null : () => remove(attachment),
          );
        },
      ),
    );
  }
}

class _AttachmentChip extends ConsumerWidget {
  const _AttachmentChip({required this.attachment, this.onRemove});

  final Attachment attachment;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: SizedBox(
            width: 80,
            height: 80,
            child: _ImageAttachmentPreview(attachment: attachment),
          ),
        ),
        if (onRemove != null)
          Positioned(
            top: -8,
            right: -8,
            child: Material(
              color: Theme.of(context).colorScheme.surface,
              shape: const CircleBorder(),
              child: IconButton(
                icon: const Icon(Icons.close, size: 16),
                constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                padding: EdgeInsets.zero,
                onPressed: onRemove,
              ),
            ),
          ),
      ],
    );
  }
}

/// An image attachment's thumbnail: the local file directly while it's
/// still pending upload, or the decrypted-and-cached file once uploaded
/// (see `AttachmentUploadService.getDecrypted`) — never the raw remote
/// URL, since that's only ever encrypted bytes.
///
/// A `ConsumerStatefulWidget` on purpose, not the simpler `ConsumerWidget`
/// it used to be: that version called `getDecrypted` directly inline in
/// `build()`, which built a *brand new* `Future` every single rebuild —
/// and `FutureBuilder` resets to "waiting" whenever the `future` it's
/// passed isn't identical to the previous one. Since this widget sits
/// inside `NoteEditorScreen`'s body, *any* `setState` there (typing a
/// character, toggling a checklist item, anything) rebuilt it and
/// silently restarted the download-and-decrypt from scratch, so a slow or
/// briefly-unreachable host could keep it stuck "loading" (or flipping
/// back to broken) indefinitely, no matter how many times it retried.
/// Caching the `Future` once per attachment identity (here, in State)
/// lets it actually run to completion and settle.
class _ImageAttachmentPreview extends ConsumerStatefulWidget {
  const _ImageAttachmentPreview({required this.attachment, this.fit = BoxFit.cover});

  final Attachment attachment;
  final BoxFit fit;

  @override
  ConsumerState<_ImageAttachmentPreview> createState() => _ImageAttachmentPreviewState();
}

class _ImageAttachmentPreviewState extends ConsumerState<_ImageAttachmentPreview> {
  Future<File>? _decryptFuture;

  @override
  void initState() {
    super.initState();
    _startDecrypt();
  }

  @override
  void didUpdateWidget(covariant _ImageAttachmentPreview oldWidget) {
    super.didUpdateWidget(oldWidget);
    // A note editor reuses this Element across rebuilds, but the
    // attachment it's showing can genuinely change (e.g. right after an
    // upload fills in `url` for the first time) — only then does the
    // cached Future need to be replaced.
    if (oldWidget.attachment.url != widget.attachment.url ||
        oldWidget.attachment.localPath != widget.attachment.localPath) {
      _startDecrypt();
    }
  }

  void _startDecrypt() {
    if (!widget.attachment.isUploaded) {
      _decryptFuture = null; // Not-yet-uploaded case is handled synchronously below.
      return;
    }
    _decryptFuture = ref.read(attachmentUploadServiceProvider).getDecrypted(widget.attachment);
  }

  @override
  Widget build(BuildContext context) {
    final localPath = widget.attachment.localPath;
    if (!widget.attachment.isUploaded && localPath != null) {
      return Image.file(File(localPath), fit: widget.fit);
    }
    return FutureBuilder<File>(
      future: _decryptFuture,
      builder: (context, snapshot) {
        final file = snapshot.data;
        if (file == null) {
          return Container(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: snapshot.hasError
                ? IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: () => setState(_startDecrypt),
                  )
                : const Center(child: CircularProgressIndicator(strokeWidth: 2)),
          );
        }
        return Image.file(file, fit: widget.fit);
      },
    );
  }
}

/// Renders a note's body as markdown — used by the read-only view (see
/// [_NoteEditorScreenState._buildViewBody]) — with inline
/// `attachment://<id>` image tokens (see [_insertImageToken]) resolved to
/// the actual attachment and shown at their chosen width.
class _MarkdownPreview extends StatelessWidget {
  const _MarkdownPreview({required this.text, required this.attachments, required this.onTapImage});

  final String text;
  final List<Attachment> attachments;

  /// Called with the tapped image's attachment and its current size
  /// keyword (null if the token had none/an unrecognized one).
  final void Function(Attachment attachment, String? currentSize) onTapImage;

  Attachment? _findAttachment(String id) {
    for (final attachment in attachments) {
      if (attachment.id == id) return attachment;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    if (text.trim().isEmpty) return const SizedBox.shrink();
    return MarkdownBody(
      data: text,
      styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)),
      imageBuilder: (uri, title, alt) {
        final attachment = _findAttachment(uri.host);
        if (attachment == null) {
          // A token whose attachment was removed some other way (e.g. an
          // older export/import round trip) — nothing sane to render.
          return const SizedBox.shrink();
        }
        return _InlineAttachmentImage(
          attachment: attachment,
          widthKeyword: title,
          onTap: () => onTapImage(attachment, title),
        );
      },
    );
  }
}

/// A single inline image within [_MarkdownPreview]: constrained to a
/// fraction of the available width per its size keyword (small/medium/
/// full — see [_NoteEditorScreenState._pickImageSize]), tappable to change
/// that size or remove it.
class _InlineAttachmentImage extends StatelessWidget {
  const _InlineAttachmentImage({required this.attachment, required this.widthKeyword, required this.onTap});

  final Attachment attachment;
  final String? widthKeyword;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final widthFactor = switch (widthKeyword) {
      'small' => 0.35,
      'full' => 1.0,
      _ => 0.65,
    };
    return GestureDetector(
      onTap: onTap,
      child: FractionallySizedBox(
        widthFactor: widthFactor,
        alignment: Alignment.centerLeft,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: _ImageAttachmentPreview(attachment: attachment, fit: BoxFit.contain),
        ),
      ),
    );
  }
}

/// A voice attachment shown as a Telegram-style "voice message" bubble: a
/// play/pause button, a waveform that traces the actual recorded audio
/// (extracted on-device by `audio_waveforms`, not a generic placeholder)
/// and fills in to show playback progress, and the recording's duration.
class _VoiceMessageBubble extends ConsumerStatefulWidget {
  const _VoiceMessageBubble({required this.attachment, this.onRemove});

  final Attachment attachment;

  /// Null in the read-only view: hides the remove (✕) button but leaves
  /// playback fully working — listening to a voice note isn't an editing
  /// intent, unlike everything else on that screen (see
  /// [_NoteEditorScreenState._buildViewBody]).
  final VoidCallback? onRemove;

  @override
  ConsumerState<_VoiceMessageBubble> createState() => _VoiceMessageBubbleState();
}

class _VoiceMessageBubbleState extends ConsumerState<_VoiceMessageBubble> {
  final _playerController = PlayerController();
  bool _ready = false;
  Object? _error;

  @override
  void initState() {
    super.initState();
    // Fire-and-forget: the file needs a local path (waiting on a decrypt
    // download if not yet cached) before the player can prepare, both of
    // which are async — the widget renders a loading spinner in the
    // meantime (see [build]) rather than blocking the first frame on it.
    _prepare();
  }

  @override
  void dispose() {
    _playerController.dispose();
    super.dispose();
  }

  Future<void> _prepare() async {
    try {
      final localPath = widget.attachment.localPath;
      final path = localPath != null && !widget.attachment.isUploaded
          ? localPath
          : (await ref.read(attachmentUploadServiceProvider).getDecrypted(widget.attachment)).path;
      await _playerController.preparePlayer(path: path, noOfSamples: 60);
      if (!mounted) return;
      setState(() => _ready = true);
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e);
    }
  }

  Future<void> _toggle() async {
    if (!_ready) return;
    if (_playerController.playerState == PlayerState.playing) {
      await _playerController.pausePlayer();
    } else {
      await _playerController.startPlayer();
    }
    if (mounted) setState(() {});
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onBubble = theme.colorScheme.onSecondaryContainer;
    final playing = _playerController.playerState == PlayerState.playing;
    final duration = widget.attachment.durationSeconds;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          IconButton(
            icon: _error != null
                ? Icon(Icons.error_outline, color: onBubble)
                : Icon(playing ? Icons.pause : Icons.play_arrow, color: onBubble),
            onPressed: _ready ? _toggle : null,
          ),
          Expanded(
            child: _ready
                ? LayoutBuilder(
                    builder: (context, constraints) => AudioFileWaveforms(
                      size: Size(constraints.maxWidth, 36),
                      playerController: _playerController,
                      waveformType: WaveformType.fitWidth,
                      enableSeekGesture: true,
                      playerWaveStyle: PlayerWaveStyle(
                        fixedWaveColor: onBubble.withValues(alpha: 0.35),
                        liveWaveColor: onBubble,
                        spacing: 4,
                        waveThickness: 2,
                      ),
                    ),
                  )
                : SizedBox(
                    height: 36,
                    child: Center(
                      child: _error != null
                          ? null
                          : const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                    ),
                  ),
          ),
          const SizedBox(width: 8),
          if (duration != null)
            Text(_formatDuration(duration), style: theme.textTheme.bodySmall?.copyWith(color: onBubble)),
          if (widget.onRemove != null)
            IconButton(
              icon: Icon(Icons.close, size: 18, color: onBubble),
              onPressed: widget.onRemove,
            ),
        ],
      ),
    );
  }
}

/// Row of markdown formatting shortcuts shown above the body field while
/// editing a non-checklist note (see [_NoteEditorScreenState._buildEditBody]):
/// bold/italic/heading/bulleted-list/link, each just inserting or wrapping
/// plain markdown syntax (see `_wrapBodySelection`/`_prefixBodyLines`/
/// `_insertLink`) — there's no rich-text model underneath, only the same
/// text a user could've typed by hand.
class _FormattingToolbar extends StatelessWidget {
  const _FormattingToolbar({
    required this.onBold,
    required this.onItalic,
    required this.onHeading,
    required this.onList,
    required this.onLink,
  });

  final VoidCallback onBold;
  final VoidCallback onItalic;
  final VoidCallback onHeading;
  final VoidCallback onList;
  final VoidCallback onLink;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          IconButton(icon: const Icon(Icons.format_bold), tooltip: l.formatBoldTooltip, onPressed: onBold),
          IconButton(icon: const Icon(Icons.format_italic), tooltip: l.formatItalicTooltip, onPressed: onItalic),
          IconButton(icon: const Icon(Icons.title), tooltip: l.formatHeadingTooltip, onPressed: onHeading),
          IconButton(
            icon: const Icon(Icons.format_list_bulleted),
            tooltip: l.formatListTooltip,
            onPressed: onList,
          ),
          IconButton(icon: const Icon(Icons.link), tooltip: l.formatLinkTooltip, onPressed: onLink),
        ],
      ),
    );
  }
}

class _ChecklistEditor extends StatelessWidget {
  const _ChecklistEditor({
    required this.doneFlags,
    required this.controllers,
    required this.focusNodes,
    required this.onToggleDone,
    required this.onSubmitted,
    required this.onRemove,
    required this.onAddItem,
  });

  final List<bool> doneFlags;
  final List<TextEditingController> controllers;
  final List<FocusNode> focusNodes;

  /// Called with the row index when its checkbox is toggled.
  final void Function(int index, bool done) onToggleDone;

  /// Called with the row index when the keyboard's return/next key is
  /// pressed in that row's field — inserts and focuses the next row.
  final void Function(int index) onSubmitted;

  /// Called with the row index when its delete button is tapped.
  final void Function(int index) onRemove;

  final VoidCallback onAddItem;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final doneTextColor = Theme.of(context).disabledColor;

    return Column(
      children: [
        for (var i = 0; i < controllers.length; i++)
          Row(
            children: [
              Checkbox(
                value: doneFlags[i],
                onChanged: (value) => onToggleDone(i, value ?? false),
              ),
              Expanded(
                child: TextField(
                  controller: controllers[i],
                  focusNode: focusNodes[i],
                  textInputAction: TextInputAction.next,
                  // Without this, TextField runs its default
                  // onEditingComplete behavior (which shifts/drops focus)
                  // before onSubmitted below gets to move focus to the new
                  // row itself — the keyboard would briefly close and
                  // reopen as focus bounces between the two. An empty
                  // override leaves focus management entirely to
                  // onSubmitted/_addChecklistItemAfter.
                  onEditingComplete: () {},
                  onSubmitted: (_) => onSubmitted(i),
                  style: TextStyle(
                    decoration: doneFlags[i] ? TextDecoration.lineThrough : TextDecoration.none,
                    color: doneFlags[i] ? doneTextColor : null,
                  ),
                  decoration: InputDecoration(
                    hintText: l.checklistItemHint,
                    border: InputBorder.none,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, size: 18),
                onPressed: () => onRemove(i),
              ),
            ],
          ),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            onPressed: onAddItem,
            icon: const Icon(Icons.add),
            label: Text(l.addItemButton),
          ),
        ),
      ],
    );
  }
}

/// [_ChecklistEditor]'s read-only counterpart, shown in
/// [_NoteEditorScreenState._buildViewBody]: same checked/unchecked +
/// strikethrough look, but plain [Icon]s and [Text] instead of interactive
/// [Checkbox]/[TextField] rows — any tap on it falls through to the
/// enclosing view's "tap anywhere to edit" gesture (see
/// [_NoteEditorScreenState._enterEditMode]) rather than toggling an item
/// in place, keeping the read view's "nothing here mutates state" model
/// simple instead of having to auto-save a single toggled checkbox.
class _ReadOnlyChecklist extends StatelessWidget {
  const _ReadOnlyChecklist({required this.doneFlags, required this.texts});

  final List<bool> doneFlags;
  final List<String> texts;

  @override
  Widget build(BuildContext context) {
    final doneTextColor = Theme.of(context).disabledColor;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < texts.length; i++)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  doneFlags[i] ? Icons.check_box_outlined : Icons.check_box_outline_blank,
                  size: 20,
                  color: doneTextColor,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    texts[i],
                    style: TextStyle(
                      decoration: doneFlags[i] ? TextDecoration.lineThrough : TextDecoration.none,
                      color: doneFlags[i] ? doneTextColor : null,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
