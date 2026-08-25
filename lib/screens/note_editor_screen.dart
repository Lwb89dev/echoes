import 'dart:async';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemUiOverlayStyle;
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../l10n/app_localizations.dart';
import '../models/attachment.dart';
import '../models/note.dart';
import '../providers/auth_provider.dart';
import '../providers/auto_sync_provider.dart';
import '../providers/note_background_provider.dart';
import '../providers/notes_provider.dart';
import '../providers/service_providers.dart';
import '../utils/app_messenger.dart';
import '../utils/formatter.dart';
import '../utils/note_colors.dart';
import '../utils/platform_support.dart';
import '../utils/responsive.dart';
import 'widgets/note_actions.dart';
import 'widgets/share_note_sheet.dart';
import 'widgets/voice_recorder.dart';

part 'note_editor_attachments.dart';

part 'note_editor_colors.dart';

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

  /// Same idea as [_unreferencedImageAttachments], for voice notes: a new
  /// recording is inserted as an inline token (see [_onVoiceRecorded]) so
  /// it can sit wherever the user placed the cursor — right between two
  /// paragraphs, say — instead of always trailing at the very bottom of
  /// the note. Checklists (no body to embed a token in) and any voice note
  /// recorded before this existed still fall back to showing it here.
  List<Attachment> get _unreferencedAudioAttachments {
    final body = _bodyController.text;
    return _audioAttachments.where((a) => !body.contains('attachment://${a.id}')).toList();
  }

  bool _showRecorder = false;

  /// Whether the body's formatting toolbar is showing — driven by
  /// [_bodyController]'s selection (see the listener added in [initState]),
  /// not a manually-toggled flag: it appears the moment there's an actual
  /// text selection (e.g. from a long-press) and disappears the moment
  /// there isn't, freeing that same slot for [_VoiceRecorderTrigger]/
  /// [VoiceRecorder] the rest of the time (see [_buildEditBody]).
  bool _showFormattingToolbar = false;

  /// Checklist-only, transient: the row being typed in, plus every
  /// *completed* item whose text starts with what's been typed so far.
  /// Drives the as-you-type suggestions in [_ChecklistEditor] — the point
  /// being that on a long shopping list you re-type "oli" rather than
  /// hunting through dozens of ticked-off rows for "olive oil", and would
  /// otherwise end up with a second copy of it.
  ({int row, List<int> matches})? _completedSuggestions;

  /// This note's own background color (see [NoteColor]), null for "no
  /// override, use the app's normal surface color" — editable via the
  /// palette icon in the app bar (see [_pickColor]), same in both view and
  /// edit mode.
  NoteColor? _color;

  /// Sharing state, carried through every [_buildNote] so an autosave never
  /// silently wipes it. [_ownerPubkey] non-null means this note was shared
  /// *with* me (I'm a recipient, not the owner); [_sharedWith] is the set of
  /// recipients I (the owner) share it with. Both are only ever changed via
  /// the explicit share actions (see [_openShareSheet]), which publish
  /// immediately through the provider — never edited through a text field.
  String? _ownerPubkey;
  List<String> _sharedWith = const [];

  // Whether this screen is showing the editable form (text fields,
  // formatting toolbar, attachment controls) or the read-only rendered
  // view. A brand-new note has nothing to "view" yet, so it opens straight
  // into editing; an existing note opens read-only and only switches to
  // editing once the user taps its content (see [_enterEditMode]) — no
  // separate edit-mode button, the whole point of this over the old
  // preview/edit toggle icon.
  late bool _editing;

  /// Debounces [_autosave] so a burst of keystrokes coalesces into one
  /// write instead of one per character — see [_scheduleAutosave].
  Timer? _autosaveTimer;

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
    _color = note?.color;
    _ownerPubkey = note?.ownerPubkey;
    _sharedWith = note?.sharedWith ?? const [];
    _titleController = TextEditingController(text: note?.title ?? '')..addListener(_markDirty);
    _bodyController = TextEditingController(text: note?.body ?? '')
      ..addListener(_markDirty)
      ..addListener(_onBodySelectionChanged);
    _isChecklist = note?.isChecklist ?? (_isNewNote && widget.startAsChecklist);
    _attachments.addAll(note?.attachments ?? const <Attachment>[]);
    _showRecorder = _isNewNote && widget.startRecording && PlatformSupport.supportsVoiceNotes;
    // A checklist has nothing sensible to *read* — it's a working list,
    // not prose — so it skips the read-only view entirely and always
    // opens straight into editing, same as a brand-new note.
    _editing = _isNewNote || _isChecklist;

    for (final item in note?.items ?? const <ChecklistItem>[]) {
      _checklistDone.add(item.done);
      _checklistControllers.add(_newChecklistController(item.text));
      _checklistFocusNodes.add(_newChecklistFocusNode());
    }

    // A brand-new checklist starts with one empty row, already focused. With
    // no row at all there is no text field on screen — nothing to type into
    // and no caret to signal the list is ready for input, which reads as a
    // broken screen rather than an empty one.
    if (_isChecklist && _checklistControllers.isEmpty) {
      _checklistDone.add(false);
      _checklistControllers.add(_newChecklistController());
      _checklistFocusNodes.add(_newChecklistFocusNode());
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _checklistFocusNodes.first.requestFocus();
      });
    }

    // Keeps this screen's private `_attachments` copy in step with upload
    // state landing in the provider from *outside* this screen — chiefly a
    // background auto-sync cycle uploading a pending attachment (and
    // deleting its local plaintext file) mid-edit. Without this, the
    // editor keeps rendering (and worse, autosaving) attachments that
    // claim a `localPath` that no longer exists and no `url`.
    // `fireImmediately` also covers having been opened from a home-list
    // snapshot that was already stale when tapped. Auto-cancelled when
    // this State is disposed.
    ref.listenManual(notesProvider, fireImmediately: true, (previous, next) {
      _mergeUploadedAttachmentState(next.value);
    });
  }

  /// Adopts uploaded-attachment state (url/decryption material) from the
  /// provider's copy of this note into [_attachments], id-matched and
  /// upgrade-only: never downgrades an uploaded attachment, never
  /// resurrects one the user removed on screen, never touches text. The
  /// in-editor counterpart of `LocalStorageService`'s own save-time merge
  /// — that one protects what's written, this one fixes what's shown.
  void _mergeUploadedAttachmentState(List<Note>? notes) {
    Note? latest;
    for (final n in notes ?? const <Note>[]) {
      if (n.id == _noteId) {
        latest = n;
        break;
      }
    }
    if (latest == null) return;

    final uploadedById = {
      for (final attachment in latest.attachments)
        if (attachment.isUploaded) attachment.id: attachment,
    };

    var changed = false;
    for (var i = 0; i < _attachments.length; i++) {
      final uploaded = uploadedById[_attachments[i].id];
      if (!_attachments[i].isUploaded && uploaded != null) {
        _attachments[i] = uploaded;
        changed = true;
      }
    }
    // A background cycle can also have published this note for the first
    // time on this device's screen-session; without adopting the event id
    // the editor would treat it as never-synced.
    if (_nostrEventId == null && latest.nostrEventId != null) {
      _nostrEventId = latest.nostrEventId;
      changed = true;
    }
    if (changed && mounted) setState(() {});
  }

  /// Flags on-screen content as different from what's on the relay the
  /// instant the user changes anything — before they even save — so the
  /// cloud icon never shows a stale "synced" state while there are
  /// unpushed edits. Without this, tapping the cloud mid-edit would run
  /// [_unsyncNow] (the action bound to "already synced") and retract the
  /// *previous* version from the relay instead of publishing the new one.
  void _markDirty() {
    if (_synced) setState(() => _synced = false);
    _scheduleAutosave();
  }

  /// Switches from the read-only view into the editable form — the sole
  /// way in, triggered by tapping anywhere on the read view's content (see
  /// [_buildViewBody]) rather than a dedicated edit button.
  void _enterEditMode() {
    if (!_editing) setState(() => _editing = true);
  }

  /// Shows/hides the formatting toolbar based on whether the body field
  /// currently has an actual (non-collapsed) text selection — called on
  /// every change to [_bodyController], not just text edits, since
  /// changing the *selection* alone (e.g. a long-press, or dragging a
  /// handle) still notifies a `TextEditingController`'s listeners.
  void _onBodySelectionChanged() {
    final hasSelection =
        _bodyController.selection.isValid && !_bodyController.selection.isCollapsed;
    if (hasSelection != _showFormattingToolbar) {
      setState(() => _showFormattingToolbar = hasSelection);
    }
  }

  /// Debounced local save, a safety net against losing an edit to e.g. the
  /// system back button or the app being killed — not a replacement for
  /// the cloud button's own explicit, immediate save (see [_syncNow]).
  /// Coalesces a burst of keystrokes/edits into one write instead of one
  /// per change by restarting the delay on every call.
  void _scheduleAutosave() {
    _autosaveTimer?.cancel();
    _autosaveTimer = Timer(const Duration(milliseconds: 600), _autosave);
  }

  Future<void> _autosave() async {
    if (!mounted) return;
    // A sync (see [_syncNow]) already does its own local save before and
    // after uploading attachments/publishing — `_attachments` may not yet
    // reflect a just-completed upload's real url while that's in flight
    // (it's only updated at the very end, in `_syncNow`'s own `setState`).
    // Saving here concurrently, with a stale pre-upload snapshot, would
    // otherwise be able to clobber the sync's own, more up-to-date write.
    // Deferring until the sync finishes (rather than just dropping this
    // save) means an edit made mid-sync still ends up persisted, just
    // slightly later.
    if (_syncing) {
      _scheduleAutosave();
      return;
    }
    await ref.read(notesProvider.notifier).saveNote(_buildNote());
  }

  @override
  void dispose() {
    if (_autosaveTimer?.isActive ?? false) {
      // A save was about to happen but hadn't fired yet — flush it now
      // rather than silently dropping the last few hundred milliseconds
      // of edits just because the debounce window didn't close in time.
      // `ref.read` for a one-off action is still valid this late in
      // dispose (only `watch`/`listen` aren't); `_buildNote()` is called
      // before the controllers below are disposed, while it can still
      // read their text.
      _autosaveTimer!.cancel();
      ref.read(notesProvider.notifier).saveNote(_buildNote());
    }
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

  /// Every checklist row's controller is built here so each one carries the
  /// same two listeners: the shared dirty/autosave marker, and the live
  /// prefix match that powers [_completedSuggestions].
  TextEditingController _newChecklistController([String text = '']) {
    return TextEditingController(text: text)
      ..addListener(_markDirty)
      ..addListener(_refreshCompletedSuggestions);
  }

  /// Rows suggest against the *focused* row, so the focus node has to drive a
  /// recompute too — otherwise moving between rows would leave the previous
  /// row's suggestions on screen.
  FocusNode _newChecklistFocusNode() => FocusNode()..addListener(_refreshCompletedSuggestions);

  /// Recomputes [_completedSuggestions] as the user types or moves between
  /// rows. Cheap (a scan of this list's own rows, no I/O) and only repaints
  /// when the answer actually changes, so it can run on every keystroke.
  void _refreshCompletedSuggestions() {
    final next = _findCompletedSuggestions();
    if (!_sameSuggestions(next, _completedSuggestions)) {
      setState(() => _completedSuggestions = next);
    }
  }

  /// Records compare by identity for their list field, so the match lists
  /// need comparing element-wise — otherwise every keystroke would repaint
  /// even when the suggestions are unchanged.
  bool _sameSuggestions(({int row, List<int> matches})? a, ({int row, List<int> matches})? b) {
    if (a == null || b == null) return a == null && b == null;
    if (a.row != b.row || a.matches.length != b.matches.length) return false;
    for (var i = 0; i < a.matches.length; i++) {
      if (a.matches[i] != b.matches[i]) return false;
    }
    return true;
  }

  /// Completed items whose text *starts with* what's currently typed in the
  /// focused row, matched case-insensitively and ignoring surrounding
  /// spaces. Prefix rather than whole-word on purpose: typing "o" should
  /// already narrow to everything starting with "o", "ol" narrows further,
  /// and so on — nobody should have to retype a whole entry to be told it
  /// already exists. Null when there's nothing to suggest.
  ({int row, List<int> matches})? _findCompletedSuggestions() {
    final row = _focusedChecklistRow();
    if (row == null) return null;
    final typed = _checklistControllers[row].text.trim().toLowerCase();
    if (typed.isEmpty) return null;

    final matches = <int>[];
    for (var i = 0; i < _checklistControllers.length; i++) {
      if (i == row || !_checklistDone[i]) continue;
      if (_checklistControllers[i].text.trim().toLowerCase().startsWith(typed)) {
        matches.add(i);
        // A handful is enough to pick from; more would bury the list itself.
        if (matches.length == _maxCompletedSuggestions) break;
      }
    }
    return matches.isEmpty ? null : (row: row, matches: matches);
  }

  static const _maxCompletedSuggestions = 5;

  int? _focusedChecklistRow() {
    for (var i = 0; i < _checklistFocusNodes.length; i++) {
      if (_checklistFocusNodes[i].hasFocus) return i;
    }
    return null;
  }

  /// Picks suggestion [existing]: un-ticks that completed item (putting it
  /// back among the things still to do) and drops the row being typed, since
  /// the two are the same item and keeping the pair is exactly what these
  /// suggestions exist to prevent.
  void _restoreCompletedItem(int existing) {
    final suggestions = _completedSuggestions;
    if (suggestions == null) return;
    final typedRow = suggestions.row;
    // The typed row's focus node is disposed below; let go of focus first so
    // the framework isn't left holding a node that's about to disappear.
    FocusScope.of(context).unfocus();
    setState(() {
      _checklistDone[existing] = false;
      _checklistDone.removeAt(typedRow);
      _checklistControllers.removeAt(typedRow).dispose();
      _checklistFocusNodes.removeAt(typedRow).dispose();
      _completedSuggestions = null;
      _synced = false;
    });
    _scheduleAutosave();
  }

  /// Inserts a new empty checklist row right after [index] and moves keyboard
  /// focus to it. Passing -1 inserts (and focuses) the first row.
  void _addChecklistItemAfter(int index) {
    final insertAt = index + 1;
    final focusNode = _newChecklistFocusNode();
    setState(() {
      _checklistDone.insert(insertAt, false);
      _checklistControllers.insert(insertAt, _newChecklistController());
      _checklistFocusNodes.insert(insertAt, focusNode);
      _synced = false;
    });
    _scheduleAutosave();
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
      // Row indices shifted; a hint computed against the old ones would
      // point at the wrong rows (same below, wherever rows move).
      _completedSuggestions = _findCompletedSuggestions();
      _synced = false;
    });
    _scheduleAutosave();
  }

  void _setChecklistItemDone(int index, bool done) {
    setState(() {
      _checklistDone[index] = done;
      _completedSuggestions = _findCompletedSuggestions();
      _synced = false;
    });
    _scheduleAutosave();
  }

  /// Removes every checklist item currently marked done, in one shot —
  /// the "clear completed" action (see [_ChecklistToolbar]). Indices are
  /// removed back-to-front so each removal doesn't shift the ones still
  /// to come out from under it.
  Future<void> _deleteCompletedChecklistItems() async {
    final l = AppLocalizations.of(context);
    final completedIndices = [
      for (var i = 0; i < _checklistDone.length; i++)
        if (_checklistDone[i]) i,
    ];
    if (completedIndices.isEmpty) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l.deleteCompletedItemsConfirmTitle),
        content: Text(l.deleteCompletedItemsConfirmBody(completedIndices.length)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l.cancelButton),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l.deleteCompletedItemsButton),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    setState(() {
      for (final index in completedIndices.reversed) {
        _checklistDone.removeAt(index);
        _checklistControllers.removeAt(index).dispose();
        _checklistFocusNodes.removeAt(index).dispose();
      }
      _completedSuggestions = _findCompletedSuggestions();
      _synced = false;
    });
    _scheduleAutosave();
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
    _scheduleAutosave();
  }

  /// Matches the specific inline attachment token referencing
  /// [attachmentId] — image (with its optional size keyword) or voice
  /// (none) alike, both are `![alt](attachment://id "optional title")`
  /// — used to update or remove it without disturbing any other text
  /// around it.
  RegExp _attachmentTokenPattern(String attachmentId) {
    return RegExp(
      '!\\[[^\\]]*\\]\\(attachment://${RegExp.escape(attachmentId)}(?:\\s+"[^"]*")?\\)',
    );
  }

  /// Inserts [token] at the current cursor position (or the end, if there
  /// isn't a valid selection), adding surrounding newlines only where the
  /// text doesn't already have one — markdown treats an image/token
  /// sharing a line with other text as part of the same paragraph, which
  /// isn't what "insert this as its own block" should produce. Shared by
  /// [_insertImageToken] and [_insertVoiceToken].
  void _insertAttachmentToken(String token) {
    final text = _bodyController.text;
    final selection = _bodyController.selection;
    final insertAt = selection.isValid ? selection.start : text.length;
    final needsLeadingNewline = insertAt > 0 && text[insertAt - 1] != '\n';
    final needsTrailingNewline = insertAt < text.length && text[insertAt] != '\n';
    final insertion = '${needsLeadingNewline ? '\n' : ''}$token${needsTrailingNewline ? '\n' : ''}';
    _bodyController.text = text.replaceRange(insertAt, insertAt, insertion);
  }

  void _insertImageToken(String attachmentId, String widthKeyword) {
    _insertAttachmentToken('![](attachment://$attachmentId "$widthKeyword")');
  }

  /// Embeds a just-recorded voice note at the current cursor position —
  /// same mechanism as an inline image (see [_insertAttachmentToken]), so
  /// it can sit wherever the user placed it (between two paragraphs, say)
  /// instead of always trailing at the bottom of the note. No size
  /// keyword: unlike images, a voice message bubble is always full-width.
  void _insertVoiceToken(String attachmentId) {
    _insertAttachmentToken('![voice](attachment://$attachmentId)');
  }

  /// Changes an already-inserted image's size keyword in place — the tap
  /// target in the read-only view (see [_InlineAttachmentImage]) for
  /// "resize" without a drag handle.
  void _setImageSize(String attachmentId, String widthKeyword) {
    setState(() {
      _bodyController.text = _bodyController.text.replaceFirst(
        _attachmentTokenPattern(attachmentId),
        '![](attachment://$attachmentId "$widthKeyword")',
      );
      _synced = false;
    });
  }

  /// Removes an inline image or voice note: both its token from the body
  /// text and the underlying [Attachment] (via [_removeAttachment], which
  /// also cleans up the not-yet-uploaded local file, if any).
  void _removeInlineAttachment(Attachment attachment) {
    setState(() {
      _bodyController.text = _bodyController.text.replaceFirst(
        _attachmentTokenPattern(attachment.id),
        '',
      );
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
    final prefixedBlock = block.isEmpty
        ? prefix
        : block.split('\n').map((line) => '$prefix$line').join('\n');
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
      onRemove: () => _removeInlineAttachment(attachment),
    );
    if (size != null) _setImageSize(attachment.id, size);
  }

  /// Called by [VoiceRecorder] once recording stops: appends the recording
  /// as a pending `audio` attachment (same upload-on-sync path as images)
  /// and hides the recorder. For a note with a body to embed it in, it's
  /// inserted as an inline token at the cursor position — same as an image
  /// — so it can be positioned wherever, e.g. between two paragraphs of
  /// notes, rather than always trailing at the bottom (checklists have no
  /// body to embed a token into, so their recordings just fall back to
  /// [_unreferencedAudioAttachments]'s plain list, same as always).
  void _onVoiceRecorded(String path, Duration duration) {
    final attachment = Attachment(
      id: const Uuid().v4(),
      type: AttachmentType.audio,
      localPath: path,
      mimeType: 'audio/mp4',
      durationSeconds: duration.inSeconds,
      recordedAt: DateTime.now(),
    );
    setState(() {
      _attachments.add(attachment);
      // Inserted at the caret, so a recording lands *inside* the text where
      // it was taken rather than at the bottom — a lecture snippet sitting
      // right under the paragraph it belongs to.
      if (!_isChecklist) _insertVoiceToken(attachment.id);
      _showRecorder = false;
      // Surfaces the timestamp opt-out for this recording only; cleared as
      // soon as the user answers it or records another (see [_justRecordedId]).
      _justRecordedId = attachment.id;
      _synced = false;
    });
    _scheduleAutosave();
  }

  /// The voice note recorded a moment ago, while its "keep the timestamp?"
  /// prompt is still on screen. Transient and never persisted — the note
  /// itself only stores whether [Attachment.recordedAt] is set.
  String? _justRecordedId;

  /// The prompt shown right under the recorder after a take: a single
  /// checkbox, ticked by default, deciding whether this recording is stamped
  /// with the moment it was captured. Shown at capture time because that is
  /// when the answer is obvious — afterwards it's a long-press on the bubble,
  /// which nobody discovers.
  Widget _justRecordedPrompt(AppLocalizations l) {
    final id = _justRecordedId;
    if (id == null) return const SizedBox.shrink();
    final index = _attachments.indexWhere((a) => a.id == id);
    if (index == -1) return const SizedBox.shrink();

    final recordedAt = _attachments[index].recordedAt;
    final locale = Localizations.localeOf(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Checkbox(
            value: recordedAt != null,
            visualDensity: VisualDensity.compact,
            onChanged: (checked) =>
                _setAttachmentTimestamp(id, (checked ?? false) ? DateTime.now() : null),
          ),
          Expanded(
            child: Text(
              recordedAt == null
                  ? l.addVoiceTimestampButton
                  : Formatter.voiceTimestampLabel(recordedAt, locale),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 18),
            tooltip: l.cancelButton,
            visualDensity: VisualDensity.compact,
            onPressed: () => setState(() => _justRecordedId = null),
          ),
        ],
      ),
    );
  }

  /// Sets or edits a voice note's [Attachment.recordedAt] — the long-press
  /// menu on [_VoiceMessageBubble], defaulting to the moment recording
  /// stopped but freely editable to log it under a different time.
  void _setAttachmentTimestamp(String attachmentId, DateTime? timestamp) {
    setState(() {
      final index = _attachments.indexWhere((a) => a.id == attachmentId);
      if (index == -1) return;
      _attachments[index] = _attachments[index].withRecordedAt(timestamp);
      _synced = false;
    });
    _scheduleAutosave();
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
    _scheduleAutosave();
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
    _scheduleAutosave();
  }

  /// Lets the user pick this note's own background color (see
  /// [NoteColor]), or clear it back to the app's normal surface color. A
  /// modal bottom sheet of swatches, applying and closing immediately on
  /// tap — unlike e.g. an image's resize/remove sheet, a color choice has
  /// no wrong-tap consequence worth a separate confirm step.
  /// This note's custom background photo, if one was chosen (see
  /// [noteBackgroundProvider]). Null means "no photo" — the note then falls
  /// back to its [NoteColor], or to the app's normal surface.
  String? get _backgroundPhotoPath => ref.watch(noteBackgroundProvider)[_noteId];

  bool get _hasCustomBackground => ref.read(noteBackgroundProvider).containsKey(_noteId);

  /// Picks a photo from the user's library and makes it this note's
  /// background. The file is copied into app storage by the provider, so the
  /// note doesn't depend on the original staying where it was.
  Future<void> _pickBackgroundPhoto() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    final path = result?.files.single.path;
    if (path == null) return;
    await ref.read(noteBackgroundProvider.notifier).setBackground(_noteId, path);
  }

  Future<void> _pickColor() async {
    final l = AppLocalizations.of(context);
    const noColorSentinel = Object();
    const photoSentinel = Object();
    const removePhotoSentinel = Object();

    final result = await showModalBottomSheet<Object>(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Wrap(
            spacing: 20,
            runSpacing: 16,
            alignment: WrapAlignment.center,
            children: [
              _ColorSwatchOption(
                color: null,
                label: l.noteColorDefault,
                selected: _color == null,
                onTap: () => Navigator.of(sheetContext).pop(noColorSentinel),
              ),
              for (final option in NoteColor.values)
                _ColorSwatchOption(
                  color: option,
                  label: _noteColorLabel(option, l),
                  selected: _color == option,
                  onTap: () => Navigator.of(sheetContext).pop(option),
                ),
              // A photo from the user's own library, as an alternative to the
              // built-in swatches — same sheet, since "what does this note
              // look like" is one decision, not two.
              _PhotoBackgroundOption(
                label: l.noteBackgroundPhoto,
                selected: _hasCustomBackground,
                onTap: () => Navigator.of(sheetContext).pop(photoSentinel),
              ),
              if (_hasCustomBackground)
                _PhotoBackgroundOption(
                  label: l.noteBackgroundRemove,
                  selected: false,
                  icon: Icons.hide_image_outlined,
                  onTap: () => Navigator.of(sheetContext).pop(removePhotoSentinel),
                ),
            ],
          ),
        ),
      ),
    );
    if (result == null) return; // Dismissed without picking anything.

    if (identical(result, photoSentinel)) {
      await _pickBackgroundPhoto();
      return;
    }
    if (identical(result, removePhotoSentinel)) {
      await ref.read(noteBackgroundProvider.notifier).clearBackground(_noteId);
      return;
    }

    final newColor = identical(result, noColorSentinel) ? null : result as NoteColor;
    if (newColor == _color) return;
    setState(() {
      _color = newColor;
      _synced = false;
    });
    _scheduleAutosave();
  }

  Future<void> _deleteLocalFileQuietly(String path) async {
    try {
      await File(path).delete();
    } catch (_) {
      // Nothing useful to do with a cleanup failure here.
    }
  }

  /// Opens the share sheet. Persists the current edits first so what gets
  /// shared is exactly what's on screen, then reflects any recipient change
  /// back into local state (so [_buildNote] keeps carrying it). If the note
  /// was a shared-in one and the user left it, pops the editor — the note no
  /// longer exists locally.
  Future<void> _openShareSheet() async {
    final note = _buildNote();
    await ref.read(notesProvider.notifier).saveNote(note);
    if (!mounted) return;
    var abandoned = false;
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => ShareNoteSheet(
        note: note,
        onChanged: (updated) {
          if (updated == null) {
            abandoned = true;
            return;
          }
          setState(() {
            _sharedWith = updated.sharedWith;
            _ownerPubkey = updated.ownerPubkey;
            _nostrEventId = updated.nostrEventId;
            _synced = updated.synced;
          });
        },
      ),
    );
    if (abandoned && mounted) Navigator.of(context).pop();
  }

  /// Builds a [Note] from the current field values. Uses [_synced] as-is
  /// rather than hardcoding `false`: every mutation method already flips
  /// `_synced` to false itself the instant it touches anything (see
  /// [_markDirty]), so by the time this runs after a real edit it's
  /// already correctly false — but this way, a call that happens to land
  /// with *no* edit since the last successful sync (e.g. [_autosave]
  /// deferred past a sync that just completed — see [_scheduleAutosave])
  /// doesn't spuriously mark an unchanged, still-synced note as dirty.
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
      // A snapshot, not the live `_attachments` reference: `_syncNow` hands
      // its own `_buildNote()` result off to `SyncService`, which uploads
      // pending attachments one at a time over the network — genuinely
      // slow, and every `await` in that loop is a point where the user can
      // still add/remove an attachment on screen. Sharing the same mutable
      // List there meant a recording/image added or removed mid-upload
      // could shift what a concurrently-running `for (attachment in
      // note.attachments)` loop sees mid-iteration, pairing the wrong
      // encryption key/nonce with the wrong uploaded file — decrypting the
      // mismatched result produces garbage bytes, which is exactly what a
      // broken-image icon (or the voice player's error glyph) is.
      attachments: List<Attachment>.of(_attachments),
      createdAt: _createdAt,
      updatedAt: DateTime.now(),
      synced: _synced,
      nostrEventId: _nostrEventId,
      isDiaryEntry: _isDiaryEntry,
      entryDate: _entryDate,
      color: _color,
      ownerPubkey: _ownerPubkey,
      sharedWith: _sharedWith,
    );
  }

  /// Saves and switches back to the read-only view of what was just saved
  /// — not a pop back to the note list. The list is one Navigator level
  /// further out (the back arrow already goes there); "done editing"
  /// should land on the note itself, the same way tapping its content is
  /// what got here in the first place.
  ///
  /// A checklist has no read-only view to land on (see [initState]'s
  /// `_editing` default) — saving it pops back to the list instead, the
  /// same way this button always behaved before the read/edit split
  /// existed.
  Future<void> _save() async {
    await ref.read(notesProvider.notifier).saveNote(_buildNote());
    if (!mounted) return;

    // Republish immediately when this note is already on the relays and the
    // preference is on (see [autoSyncOnSaveProvider]). Never for a note that
    // has never been synced: saving must not be able to publish something the
    // user deliberately kept local. Fire-and-forget — [_syncNow] reports
    // through the app-wide messenger, so leaving this screen (a checklist
    // pops straight away, below) doesn't swallow the result.
    if (_shouldAutoSyncOnSave) unawaited(_syncNow());

    if (_isChecklist) {
      Navigator.of(context).pop();
    } else {
      setState(() => _editing = false);
    }
  }

  /// True when saving should also publish: the preference is on, this note has
  /// been published before, there's an account to publish with, and the local
  /// copy actually differs from what's on the relays.
  bool get _shouldAutoSyncOnSave {
    if (!ref.read(autoSyncOnSaveProvider)) return false;
    if (_nostrEventId == null || _synced) return false;
    return ref.read(authProvider).value != null;
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
  /// Publishes this note now. Deliberately reports through
  /// [showAppSnackBar] rather than this screen's own messenger: uploading
  /// attachments and publishing to every relay can take a while, the work
  /// belongs to [NotesNotifier] (so it keeps running once started), and the
  /// user is free to leave the editor meanwhile. Tying the outcome to this
  /// widget being alive meant a sync that finished after they left said
  /// nothing at all — success *and* failure went silent.
  Future<void> _syncNow() async {
    final l = AppLocalizations.of(context);
    setState(() => _syncing = true);

    final author = ref.read(authProvider).value;
    final notesNotifier = ref.read(notesProvider.notifier);
    final draft = _buildNote();
    // Captured before the await: afterwards `_nostrEventId` may have been
    // filled in, and "first time" is the more reassuring of the two messages.
    final firstPublish = _nostrEventId == null;

    try {
      if (author == null) {
        throw StateError('Cannot sync without a Nostr account.');
      }

      // Saved with whatever local-only attachments it still has *before*
      // the upload/publish below: a failure partway through must not lose
      // the edit, only leave it (still, correctly) marked unsynced.
      await notesNotifier.saveNote(draft);
      final result = await notesNotifier.syncNote(draft);
      final syncedNote = result.note;
      // Say plainly when only some relays took it: "synced" while sitting on
      // one relay out of four is exactly how a note ends up missing on
      // another device, so that case must not read the same as a full write.
      showAppSnackBar(
        result.accepted < result.total
            ? l.notePartiallySyncedMessage(result.accepted, result.total)
            : (firstPublish ? l.noteSyncedFirstTimeMessage : l.noteSyncedMessage),
      );
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
      // Reported globally too: a failure the user never sees is worse than
      // one they see on a different screen.
      showAppSnackBar(l.syncNoteError(e.toString()));
      if (!mounted) return;
      setState(() {
        _synced = false;
        _syncing = false;
      });
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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l.unsyncNoteError(e.toString()))));
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

  /// The note's own title lives here now, not a generic "New note"/"Edit
  /// note" label — editable in place while [_editing], read-only (but
  /// still tappable, same as everywhere else in the read view) otherwise.
  /// The body no longer has its own separate title field/text — this is
  /// the only place it's shown, matching how [_appBarTitle] used to be
  /// the only thing in the app bar with nothing useful to say.
  Widget _buildAppBarTitle(AppLocalizations l) {
    // The app bar sits outside [_applyNoteColorTheme]'s wrapped body (an
    // app bar colored to match — see [build] — needs its *own* readable
    // text, before that widget even exists), and this title's style is
    // always fully specified rather than inherited, so the color has to
    // be explicit here regardless.
    final color = _color;
    final titleColor = color?.onBackground;
    // One style for both modes, clearly larger and heavier than the body: at
    // the default app-bar size the title read as just another line of note
    // text, so it wasn't obvious which one you were looking at. Using the
    // same style in read and edit mode also stops the title resizing under
    // the user's finger the moment they tap into it.
    final titleStyle = Theme.of(
      context,
    ).textTheme.headlineSmall?.copyWith(color: titleColor, fontWeight: FontWeight.w600);
    if (_editing) {
      return TextField(
        controller: _titleController,
        decoration: InputDecoration(
          hintText: l.titleFieldLabel,
          hintStyle: color != null ? TextStyle(color: mutedTextColorOn(color.background)) : null,
          border: InputBorder.none,
          // The title sits in the app bar, on top of the note's own colour
          // (or the app surface). The app-wide filled input style would paint
          // an opaque slab across it — right in a form, wrong for a title
          // that should read as part of the note it belongs to.
          filled: false,
          isDense: true,
        ),
        style: titleStyle,
        cursorColor: titleColor,
      );
    }
    return GestureDetector(
      onTap: _enterEditMode,
      child: Text(
        _titleController.text.isEmpty ? l.untitledNote : _titleController.text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: titleStyle,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final hasNostrAccount = ref.watch(authProvider).value != null;
    final colorScheme = Theme.of(context).colorScheme;
    final color = _color;
    // The app bar — and the system status bar right above it — follow this
    // note's own color when it has one, for the same "consistent, not two
    // different chrome colors stacked on top of each other" reason the
    // body itself does (see [_applyNoteColorTheme]). `surfaceTintColor:
    // transparent` stops Material 3's own scroll-elevation tint from
    // mixing the app theme's accent color back into it.
    final appBarOnColor = color?.onBackground;
    final isLightNoteColor = appBarOnColor == Colors.black;

    // Built as a local so the body below can offset itself by this bar's
    // *real* height: it is two rows tall (actions, then the title — see
    // `bottom`), not the standard one, and hard-coding kToolbarHeight while
    // `extendBodyBehindAppBar` is on would slide the content up underneath it.
    final appBar = AppBar(
      backgroundColor: Colors.transparent,
      foregroundColor: appBarOnColor,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      systemOverlayStyle: color == null
          ? null
          : SystemUiOverlayStyle(
              statusBarColor: color.background,
              statusBarIconBrightness: isLightNoteColor ? Brightness.dark : Brightness.light,
              statusBarBrightness: isLightNoteColor ? Brightness.light : Brightness.dark,
            ),
      // No title on this row: it belongs to the action icons alone. With up
      // to six of them, a title sharing the row was squeezed down to a few
      // characters — or ran straight into them. It moves to `bottom` below.
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
                          : (_nostrEventId != null
                                ? Icons.cloud_sync_outlined
                                : Icons.cloud_off_outlined),
                    ),
                    tooltip: _synced ? l.unsyncNoteTooltip : l.syncNoteTooltip,
                    style: IconButton.styleFrom(
                      side: BorderSide(color: _synced ? colorScheme.primary : colorScheme.outline),
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
        // Available in both view and edit mode — a self-contained,
        // lightweight action, same reasoning as the diary date chip and
        // voice-note timestamp (see [_buildViewBody]'s doc comment).
        IconButton(
          icon: const Icon(Icons.palette_outlined),
          tooltip: l.noteColorButton,
          onPressed: _pickColor,
        ),
        if (hasNostrAccount)
          IconButton(
            icon: Icon(
              _ownerPubkey != null
                  ? Icons.people_outline
                  : (_sharedWith.isEmpty ? Icons.person_add_outlined : Icons.people),
            ),
            tooltip: l.shareNoteTooltip,
            onPressed: _openShareSheet,
          ),
        if (!_isNewNote)
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: l.deleteNoteButton,
            onPressed: _delete,
          ),
        if (_editing)
          IconButton(icon: const Icon(Icons.check), tooltip: l.saveTooltip, onPressed: _save),
      ],
      // The title gets a full-width row of its own, directly under the
      // actions — room for a real title (and a comfortable tap target when
      // it doubles as the title field while editing).
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: Align(alignment: Alignment.centerLeft, child: _buildAppBarTitle(l)),
        ),
      ),
    );

    return Scaffold(
      // Paired with the app bar's own background being fully transparent:
      // this is what lets [_NoteColorReveal] paint one single, continuous
      // circle across the *entire* screen — app bar and status-bar strip
      // included — instead of the reveal stopping at the body's own top edge
      // with the app bar snapping separately.
      extendBodyBehindAppBar: true,
      appBar: appBar,
      body: _NoteColorReveal(
        // A concrete color either way (never null/transparent): the reveal
        // animates between two solid fills, including the "back to no
        // custom color" direction, which needs just as real a target as
        // any actual [NoteColor] — the theme's own surface color, here.
        color: color?.background ?? Theme.of(context).colorScheme.surface,
        // A chosen photo sits on top of that fill, behind all the content.
        // Scrimmed rather than shown raw: note text has to stay readable over
        // whatever picture the user picked, and a photo at full strength
        // behind body copy is unreadable more often than not.
        backgroundPhotoPath: _backgroundPhotoPath,
        child: Padding(
          // The reveal's own background fills the *entire* screen,
          // status bar and app bar included (see `extendBodyBehindAppBar`
          // above) — only the actual content needs pushing back down
          // below the now-transparent app bar's real height, or it'd
          // render right underneath it.
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + appBar.preferredSize.height,
          ),
          child: _applyNoteColorTheme(_editing ? _buildEditBody(l) : _buildViewBody(l)),
        ),
      ),
    );
  }

  /// Wraps [child] so every default-styled text/icon within it — a plain
  /// [Text], a [TextField]'s input, a [Checkbox], hint text — resolves to
  /// a color readable against this note's own background (see
  /// [NoteColor]), when it has one, in *both* light and dark app theme.
  ///
  /// Overriding [ColorScheme.onSurface]/[onSurfaceVariant] alone is not
  /// enough: `ThemeData.textTheme` bakes a concrete `color` into each of
  /// its styles (`titleLarge`, `bodyMedium`, ...) at the point the app's
  /// theme was built, from *that* theme's original colorScheme — a later
  /// `theme.copyWith(colorScheme: ...)` does not retroactively recompute
  /// them. Anything that renders via `Theme.of(context).textTheme.X`
  /// (the title/body fields' own style, `MarkdownStyleSheet.fromTheme`'s
  /// paragraph/heading styles, ...) would keep showing the *app* theme's
  /// text color — in dark mode, a light grey meant for a dark background,
  /// which is exactly what read as low-contrast against a light pastel
  /// note color. [TextTheme.apply] is what actually retints every style at
  /// once; `iconTheme`/`hintColor` are separate top-level `ThemeData`
  /// fields that don't derive from `colorScheme` either, so they need
  /// their own explicit override too.
  Widget _applyNoteColorTheme(Widget child) {
    final color = _color;
    if (color == null) return child;
    final theme = Theme.of(context);
    final onColor = color.onBackground;
    final mutedColor = mutedTextColorOn(color.background);
    return Theme(
      data: theme.copyWith(
        colorScheme: theme.colorScheme.copyWith(onSurface: onColor, onSurfaceVariant: mutedColor),
        textTheme: theme.textTheme.apply(bodyColor: onColor, displayColor: onColor),
        primaryTextTheme: theme.primaryTextTheme.apply(bodyColor: onColor, displayColor: onColor),
        iconTheme: theme.iconTheme.copyWith(color: onColor),
        hintColor: mutedColor,
        // The app-wide input theme fills every text field with an opaque
        // surface colour. That is right on a normal screen and wrong here:
        // on a coloured note it paints a pale slab behind the title and body
        // while editing, so the note's own colour only shows around the
        // edges. Editing a note should look like writing on the note.
        inputDecorationTheme: theme.inputDecorationTheme.copyWith(
          filled: false,
          fillColor: Colors.transparent,
        ),
      ),
      child: child,
    );
  }

  /// The editable form: the body text field (or the checklist editor), the
  /// formatting toolbar, and every attachment control — everything that
  /// was always on this screen before the read/edit split. The title
  /// itself lives in the app bar now (see [_buildAppBarTitle]), not here.
  Widget _buildEditBody(AppLocalizations l) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: MaxWidthCenter(
        maxWidth: 760,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_isDiaryEntry) _DiaryDateSelector(date: _entryDate!, onTap: _pickEntryDate),
            if (_isChecklist) ...[
              _ChecklistToolbar(
                doneCount: _checklistDone.where((done) => done).length,
                totalCount: _checklistDone.length,
                onDeleteCompleted: _deleteCompletedChecklistItems,
              ),
              _ChecklistEditor(
                doneFlags: _checklistDone,
                controllers: _checklistControllers,
                focusNodes: _checklistFocusNodes,
                onToggleDone: _setChecklistItemDone,
                onSubmitted: _addChecklistItemAfter,
                onRemove: _removeChecklistItem,
                onAddItem: () => _addChecklistItemAfter(_checklistControllers.length - 1),
                completedSuggestions: _completedSuggestions,
                onRestoreCompleted: _restoreCompletedItem,
              ),
              const SizedBox(height: 8),
              _voiceRecorderSlot(),
            ] else ...[
              _voiceRecorderSlot(),
              _justRecordedPrompt(l),
              // Breathing room between the recorder/formatting slot and the
              // body: without it the record button sits right on top of the
              // first line of text, close enough to look like part of it.
              const SizedBox(height: 12),
              TextField(
                controller: _bodyController,
                decoration: InputDecoration(labelText: l.bodyFieldHint, border: InputBorder.none),
                maxLines: null,
                minLines: 10,
              ),
            ],
            const SizedBox(height: 12),
            if (_unreferencedImageAttachments.isNotEmpty)
              _AttachmentsStrip(
                attachments: _unreferencedImageAttachments,
                onRemove: _removeAttachment,
              ),
            // Voice notes get their own full-width "message" bubble (with a
            // waveform, like Telegram) rather than being squeezed into the
            // same small square thumbnail strip as images. Only ones not
            // already embedded inline in the body (see [_insertVoiceToken])
            // show up here — new recordings go straight into the text.
            for (final attachment in _unreferencedAudioAttachments)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: _VoiceMessageBubble(
                  key: ValueKey(attachment.id),
                  attachment: attachment,
                  onRemove: () => _removeAttachment(attachment),
                  onSetTimestamp: (timestamp) => _setAttachmentTimestamp(attachment.id, timestamp),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Whichever of these three is relevant is shown here, in the exact same
  /// layout slot right under the title: the active [VoiceRecorder] panel;
  /// otherwise, for a non-checklist note, the formatting toolbar while
  /// there's a text selection (see [_showFormattingToolbar]); otherwise, a
  /// compact "start recording" trigger. Freeing this slot up when there's
  /// no selection — rather than a toolbar permanently pinned under the
  /// title like a Word ribbon — is what makes room for the recording
  /// trigger without needing a whole separate row of its own.
  Widget _voiceRecorderSlot() {
    if (_showRecorder && PlatformSupport.supportsVoiceNotes) {
      return VoiceRecorder(
        onRecorded: _onVoiceRecorded,
        onCancel: () => setState(() => _showRecorder = false),
      );
    }
    if (!_isChecklist && _showFormattingToolbar) {
      return _FormattingToolbar(
        onBold: () => _wrapBodySelection('**'),
        onItalic: () => _wrapBodySelection('*'),
        // GitHub-flavoured markdown's strikethrough, which the preview
        // renderer already understands (`del` -> lineThrough).
        onStrikethrough: () => _wrapBodySelection('~~'),
        onHeading: () => _prefixBodyLines('# '),
        onList: () => _prefixBodyLines('- '),
        onLink: _insertLink,
      );
    }
    // No recording trigger to fall back to on platforms where voice notes
    // aren't supported (see [PlatformSupport.supportsVoiceNotes]) — the
    // slot simply stays empty until there's a selection to format.
    if (!PlatformSupport.supportsVoiceNotes) return const SizedBox.shrink();
    return _VoiceRecorderTrigger(onTap: () => setState(() => _showRecorder = true));
  }

  /// The read-only rendered view an existing note opens into: rendered
  /// markdown body and attachments, none of it directly editable — the
  /// title itself is in the app bar (see [_buildAppBarTitle]), not here.
  /// Never reached for a checklist (see [initState]'s `_editing` default —
  /// a checklist has nothing sensible to *read*, so it always opens
  /// straight into [_buildEditBody] instead). Tapping *anywhere* in it —
  /// the sole entry point into editing, see [_enterEditMode] — switches to
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
            // Top-align: the box is full-height so a tap anywhere enters edit
            // mode, but the note's text must start at the top, not float in
            // the vertical middle for a short note (default is center).
            child: MaxWidthCenter(
              maxWidth: 760,
              alignment: Alignment.topCenter,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_isDiaryEntry) _DiaryDateSelector(date: _entryDate!, onTap: _enterEditMode),
                  _MarkdownPreview(
                    text: _bodyController.text,
                    attachments: _attachments,
                    // Same resize/remove bottom sheet as while editing
                    // (see [_editInlineImage]) rather than routing through
                    // [_enterEditMode]: like voice playback and the diary
                    // date chip above, this is a self-contained action
                    // that doesn't need the full raw-text editor open.
                    onTapImage: _editInlineImage,
                    onRemoveVoice: _removeInlineAttachment,
                    onSetVoiceTimestamp: (attachment, timestamp) =>
                        _setAttachmentTimestamp(attachment.id, timestamp),
                  ),
                  if (_unreferencedImageAttachments.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    _AttachmentsStrip(attachments: _unreferencedImageAttachments, onRemove: null),
                  ],
                  for (final attachment in _unreferencedAudioAttachments)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: _VoiceMessageBubble(
                        key: ValueKey(attachment.id),
                        attachment: attachment,
                        onRemove: null,
                        onSetTimestamp: (timestamp) =>
                            _setAttachmentTimestamp(attachment.id, timestamp),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

String _noteColorLabel(NoteColor color, AppLocalizations l) => switch (color) {
  NoteColor.yellow => l.noteColorYellow,
  NoteColor.red => l.noteColorRed,
  NoteColor.purple => l.noteColorPurple,
  NoteColor.blue => l.noteColorBlue,
  NoteColor.green => l.noteColorGreen,
  NoteColor.orange => l.noteColorOrange,
  NoteColor.white => l.noteColorWhite,
};

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
                style: Theme.of(
                  context,
                ).textTheme.labelLarge?.copyWith(color: colorScheme.onPrimaryContainer),
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
            key: ValueKey(attachment.id),
            attachment: attachment,
            onRemove: remove == null ? null : () => remove(attachment),
          );
        },
      ),
    );
  }
}

class _AttachmentChip extends ConsumerWidget {
  const _AttachmentChip({super.key, required this.attachment, this.onRemove});

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

/// Row of markdown formatting shortcuts shown above the body field while
/// editing a non-checklist note (see [_NoteEditorScreenState._buildEditBody]):
/// bold/italic/heading/bulleted-list/link, each just inserting or wrapping
/// plain markdown syntax (see `_wrapBodySelection`/`_prefixBodyLines`/
/// `_insertLink`) — there's no rich-text model underneath, only the same
/// text a user could've typed by hand.
/// Compact entry point for recording a voice note, shown in the same slot
/// as [_FormattingToolbar]/[VoiceRecorder] (see
/// [_NoteEditorScreenState._voiceRecorderSlot]) whenever neither of those
/// is currently relevant — i.e. most of the time, since a text selection
/// is momentary. Deliberately understated (a single icon + short label,
/// not a full row of controls) so it doesn't read as more important than
/// the body text it sits above.
class _VoiceRecorderTrigger extends StatelessWidget {
  const _VoiceRecorderTrigger({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Icon(Icons.mic_none_outlined, size: 18, color: colorScheme.onSurfaceVariant),
            const SizedBox(width: 8),
            Text(
              l.recordVoiceNoteTooltip,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}

class _FormattingToolbar extends StatelessWidget {
  const _FormattingToolbar({
    required this.onBold,
    required this.onItalic,
    required this.onStrikethrough,
    required this.onHeading,
    required this.onList,
    required this.onLink,
  });

  final VoidCallback onBold;
  final VoidCallback onItalic;
  final VoidCallback onStrikethrough;
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
          IconButton(
            icon: const Icon(Icons.format_bold),
            tooltip: l.formatBoldTooltip,
            onPressed: onBold,
          ),
          IconButton(
            icon: const Icon(Icons.format_italic),
            tooltip: l.formatItalicTooltip,
            onPressed: onItalic,
          ),
          IconButton(
            icon: const Icon(Icons.format_strikethrough),
            tooltip: l.formatStrikethroughTooltip,
            onPressed: onStrikethrough,
          ),
          IconButton(
            icon: const Icon(Icons.title),
            tooltip: l.formatHeadingTooltip,
            onPressed: onHeading,
          ),
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

/// Sits above [_ChecklistEditor] — a checklist has no read-only view to
/// also appear in (see [_NoteEditorScreenState.initState]'s `_editing`
/// default), so this is always in an editing context: a "N of M done"
/// progress line, a hide/show-completed toggle, and a "delete completed"
/// action.
class _ChecklistToolbar extends StatelessWidget {
  const _ChecklistToolbar({
    required this.doneCount,
    required this.totalCount,
    required this.onDeleteCompleted,
  });

  final int doneCount;
  final int totalCount;
  final VoidCallback onDeleteCompleted;

  @override
  Widget build(BuildContext context) {
    if (totalCount == 0) return const SizedBox.shrink();
    final l = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              l.checklistProgress(doneCount, totalCount),
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
            ),
          ),
          // No hide/show toggle any more: completed items now live in their
          // own collapsed section (see [_ChecklistEditor]), which already is
          // "hidden until asked for" — a second control for the same thing
          // would only be one more thing to reason about.
          if (doneCount > 0)
            IconButton(
              icon: const Icon(Icons.delete_sweep_outlined, size: 20),
              tooltip: l.deleteCompletedItemsButton,
              visualDensity: VisualDensity.compact,
              onPressed: onDeleteCompleted,
            ),
        ],
      ),
    );
  }
}

/// The checklist's editable rows, in three parts: the items still to do, the
/// "add item" action, and — collapsed by default, below both — everything
/// already ticked off. Keeping completed items out of the working area (but
/// one tap away) is what stops a long-running list, a weekly shopping list
/// above all, from burying today's handful of rows under weeks of history.
///
/// Row order in [doneFlags]/[controllers]/[focusNodes] never changes here;
/// only which section a given index is rendered in does.
class _ChecklistEditor extends StatelessWidget {
  const _ChecklistEditor({
    required this.doneFlags,
    required this.controllers,
    required this.focusNodes,
    required this.onToggleDone,
    required this.onSubmitted,
    required this.onRemove,
    required this.onAddItem,
    required this.completedSuggestions,
    required this.onRestoreCompleted,
  });

  final List<bool> doneFlags;
  final List<TextEditingController> controllers;
  final List<FocusNode> focusNodes;

  /// Called with the row index when its checkbox is toggled.
  final void Function(int index, bool done) onToggleDone;

  /// Called with the row index when the keyboard's return/next key is
  /// pressed in that row's field — inserts and focuses the new row.
  final void Function(int index) onSubmitted;

  /// Called with the row index when its delete button is tapped.
  final void Function(int index) onRemove;

  final VoidCallback onAddItem;

  /// The row being typed plus the completed items it prefix-matches, if any
  /// — see [_NoteEditorScreenState._completedSuggestions].
  final ({int row, List<int> matches})? completedSuggestions;

  /// Called with the index of the completed item the user picked.
  final void Function(int existing) onRestoreCompleted;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final doneTextColor = Theme.of(context).disabledColor;
    // "Add item" reads as a de-emphasized action, not note content: use the
    // muted-text color rather than the default (primary/accent) button color.
    // Inside a colored note this resolves — via [_applyNoteColorTheme] — to a
    // dark gray derived from the note's own background (distinct from the
    // black note text); on an uncolored note it's the theme's own muted gray,
    // which stays readable in both light and dark mode.
    final addItemColor = colorScheme.onSurfaceVariant;
    final activeIndices = [
      for (var i = 0; i < controllers.length; i++)
        if (!doneFlags[i]) i,
    ];
    final completedIndices = [
      for (var i = 0; i < controllers.length; i++)
        if (doneFlags[i]) i,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final i in activeIndices) ...[
          _row(context, i, doneTextColor: doneTextColor),
          if (completedSuggestions?.row == i)
            _suggestions(context, l, colorScheme, completedSuggestions!.matches),
        ],
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            onPressed: onAddItem,
            style: TextButton.styleFrom(foregroundColor: addItemColor),
            icon: const Icon(Icons.add),
            label: Text(l.addItemButton),
          ),
        ),
        if (completedIndices.isNotEmpty)
          // `dividerColor: transparent` removes ExpansionTile's own hairlines,
          // which otherwise cut across the note's colored background.
          Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              tilePadding: EdgeInsets.zero,
              childrenPadding: EdgeInsets.zero,
              expandedCrossAxisAlignment: CrossAxisAlignment.start,
              iconColor: addItemColor,
              collapsedIconColor: addItemColor,
              title: Text(
                l.completedItemsSection(completedIndices.length),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: addItemColor),
              ),
              children: [
                for (final i in completedIndices) _row(context, i, doneTextColor: doneTextColor),
              ],
            ),
          ),
      ],
    );
  }

  /// One checklist row: tick box, editable text, remove button.
  Widget _row(BuildContext context, int i, {required Color doneTextColor}) {
    final l = AppLocalizations.of(context);
    final done = doneFlags[i];
    return Row(
      children: [
        Checkbox(value: done, onChanged: (value) => onToggleDone(i, value ?? false)),
        Expanded(
          child: TextField(
            controller: controllers[i],
            focusNode: focusNodes[i],
            textInputAction: TextInputAction.next,
            // An explicit, slightly thicker caret in the note's own text
            // color: the default takes the theme's primary color, which on a
            // pastel note background can be faint enough that the row gives
            // no visible sign it's focused and ready for typing.
            cursorColor: Theme.of(context).colorScheme.onSurface,
            cursorWidth: 2.5,
            // Without this, TextField runs its default onEditingComplete
            // behavior (which shifts/drops focus) before onSubmitted below
            // gets to move focus to the new row itself — the keyboard would
            // briefly close and reopen as focus bounces between the two. An
            // empty override leaves focus management entirely to
            // onSubmitted/_addChecklistItemAfter.
            onEditingComplete: () {},
            onSubmitted: (_) => onSubmitted(i),
            style: TextStyle(
              decoration: done ? TextDecoration.lineThrough : TextDecoration.none,
              color: done ? doneTextColor : null,
            ),
            decoration: InputDecoration(hintText: l.checklistItemHint, border: InputBorder.none),
          ),
        ),
        IconButton(icon: const Icon(Icons.close, size: 18), onPressed: () => onRemove(i)),
      ],
    );
  }

  /// The as-you-type suggestion list, shown directly under the row being
  /// typed: every already-completed item starting with what's been entered so
  /// far. Tapping one puts that item back among the things to do and drops
  /// the half-typed row, instead of leaving the list with two copies.
  Widget _suggestions(
    BuildContext context,
    AppLocalizations l,
    ColorScheme colorScheme,
    List<int> matches,
  ) {
    return Card(
      margin: const EdgeInsets.only(left: 48, right: 8, bottom: 8),
      color: colorScheme.secondaryContainer,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
            child: Text(
              l.duplicateChecklistItemMessage,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: colorScheme.onSecondaryContainer),
            ),
          ),
          for (final i in matches)
            InkWell(
              onTap: () => onRestoreCompleted(i),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        controllers[i].text.trim(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: colorScheme.onSecondaryContainer),
                      ),
                    ),
                    Icon(
                      Icons.undo,
                      size: 18,
                      semanticLabel: l.restoreChecklistItemButton,
                      color: colorScheme.onSecondaryContainer,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
