import '../utils/note_colors.dart';
import 'attachment.dart';

/// A single checklist entry (used when [Note.isChecklist] is true).
class ChecklistItem {
  final String text;
  final bool done;

  const ChecklistItem({required this.text, this.done = false});

  ChecklistItem copyWith({String? text, bool? done}) {
    return ChecklistItem(text: text ?? this.text, done: done ?? this.done);
  }

  Map<String, dynamic> toJson() => {'text': text, 'done': done};

  factory ChecklistItem.fromJson(Map<String, dynamic> json) {
    return ChecklistItem(text: json['text'] as String, done: json['done'] as bool? ?? false);
  }
}

/// Local note model. Mirrors the fields that end up encrypted inside the
/// `content` of a Nostr event (custom application kind 30078, parameterized
/// replaceable — see [AppConstants.noteEventKind] and [NostrService]).
class Note {
  final String id;
  final String title;
  final String body;
  final List<ChecklistItem> items;
  final bool isChecklist;
  final List<Attachment> attachments;
  final DateTime createdAt;
  final DateTime updatedAt;

  /// true if the current version of this note has already been published
  /// to the relays.
  final bool synced;

  /// Id of the Nostr event tied to the last synced version, if any.
  final String? nostrEventId;

  /// true if this note is a diary entry rather than a regular note — shown
  /// in [DiaryScreen] instead of the main note list, and grouped there by
  /// [entryDate]. Everything else about a [Note] (attachments, checklist,
  /// sync) works identically either way; this only changes where it's
  /// listed and how it's dated.
  final bool isDiaryEntry;

  /// The calendar date this diary entry is *about* — defaults to the day
  /// it was written, but can be set to any arbitrary date (e.g. logging a
  /// day retroactively), independently of [createdAt]/[updatedAt], which
  /// always reflect when the entry was actually written/last edited. Only
  /// meaningful when [isDiaryEntry] is true; null for regular notes.
  final DateTime? entryDate;

  /// User-chosen background color for this specific note (see
  /// [NoteColor]), independent of the app's light/dark theme — Google
  /// Keep-style. Null means no override: rendered with the app's normal
  /// surface color, same as before this existed.
  final NoteColor? color;

  /// Hex pubkey of the note's owner when this note was **shared with me**
  /// by someone else; null when I own it (a normal local note, or one I own
  /// and share with others). This is never trusted from a payload — it's
  /// set from the *signed* event author when a shared note is received (see
  /// `SyncService`), so a sender can't lie about who owns what. See
  /// [NoteSharing] for the whole model.
  final String? ownerPubkey;

  /// Hex pubkeys I (the owner) share this note with. Empty = private.
  /// Only meaningful when [ownerPubkey] is null (I own it). Deliberately
  /// **stripped** from the per-recipient wire copy (see [toShareJson]) so
  /// one recipient never learns who else a note is shared with — it only
  /// travels inside the owner's own self-encrypted copy, for the owner's
  /// other devices.
  final List<String> sharedWith;

  const Note({
    required this.id,
    required this.title,
    required this.body,
    this.items = const [],
    this.isChecklist = false,
    this.attachments = const [],
    required this.createdAt,
    required this.updatedAt,
    this.synced = false,
    this.nostrEventId,
    this.isDiaryEntry = false,
    this.entryDate,
    this.color,
    this.ownerPubkey,
    this.sharedWith = const [],
  });

  /// True when someone else owns this note and shared it with me.
  bool get isSharedWithMe => ownerPubkey != null;

  /// True when I own this note and share it with at least one other person.
  bool get isSharedByMe => ownerPubkey == null && sharedWith.isNotEmpty;

  /// Matches an inline attachment token — image (`![](attachment://...)`)
  /// or voice (`![voice](attachment://...)`) alike, see
  /// `NoteEditorScreen._insertAttachmentToken` — so user-facing text
  /// derivations can drop them rather than exposing raw internal markup.
  static final RegExp _inlineAttachmentToken = RegExp(r'!\[[^\]]*\]\(attachment://[^)]*\)');

  /// [body] with the internal attachment tokens stripped — what search and
  /// [preview] should look at: neither matching nor showing "attachment"
  /// or a UUID that the user never typed and can't see on screen.
  String get bodyWithoutAttachmentTokens => body.replaceAll(_inlineAttachmentToken, '');

  /// Short text preview for the list view (title excluded, no newlines).
  String get preview {
    final source = isChecklist ? items.map((e) => e.text).join(', ') : bodyWithoutAttachmentTokens;
    final singleLine = source.replaceAll('\n', ' ').trim();
    return singleLine.length <= 120 ? singleLine : '${singleLine.substring(0, 120)}…';
  }

  // `nostrEventId` uses a sentinel default instead of the usual `x ?? this.x`
  // pattern: that pattern can never explicitly pass `null` through to clear
  // the field back to "never synced" — a real need for anything that
  // duplicates or resets a note (e.g. a future "duplicate note" action must
  // not carry over the original's event id).
  static const _unset = Object();

  Note copyWith({
    String? id,
    String? title,
    String? body,
    List<ChecklistItem>? items,
    bool? isChecklist,
    List<Attachment>? attachments,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? synced,
    Object? nostrEventId = _unset,
    bool? isDiaryEntry,
    Object? entryDate = _unset,
    Object? color = _unset,
    Object? ownerPubkey = _unset,
    List<String>? sharedWith,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      items: items ?? this.items,
      isChecklist: isChecklist ?? this.isChecklist,
      attachments: attachments ?? this.attachments,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      synced: synced ?? this.synced,
      nostrEventId: identical(nostrEventId, _unset) ? this.nostrEventId : nostrEventId as String?,
      isDiaryEntry: isDiaryEntry ?? this.isDiaryEntry,
      entryDate: identical(entryDate, _unset) ? this.entryDate : entryDate as DateTime?,
      color: identical(color, _unset) ? this.color : color as NoteColor?,
      ownerPubkey: identical(ownerPubkey, _unset) ? this.ownerPubkey : ownerPubkey as String?,
      sharedWith: sharedWith ?? this.sharedWith,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'body': body,
    'items': items.map((e) => e.toJson()).toList(),
    'isChecklist': isChecklist,
    'attachments': attachments.map((a) => a.toJson()).toList(),
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'synced': synced,
    'nostrEventId': nostrEventId,
    'isDiaryEntry': isDiaryEntry,
    'entryDate': entryDate?.toIso8601String(),
    'color': color?.name,
    'ownerPubkey': ownerPubkey,
    'sharedWith': sharedWith,
  };

  /// Wire format for the per-recipient shared copy: the note's actual
  /// content, minus everything that is either local-only state or that a
  /// recipient must not see. In particular [sharedWith] is dropped (a
  /// recipient must never learn the rest of the recipient list) along with
  /// [ownerPubkey] and the local sync bookkeeping ([synced]/[nostrEventId]
  /// — the latter would also leak the owner's own event id). The receiver
  /// re-derives the owner from the *signed* event author, not from here.
  Map<String, dynamic> toShareJson() {
    final json = toJson();
    json.remove('sharedWith');
    json.remove('ownerPubkey');
    json.remove('synced');
    json.remove('nostrEventId');
    // Never ship this device's local file paths to a recipient — they can
    // embed a username and are meaningless (and unsafe to trust) elsewhere.
    json['attachments'] = attachments.map((a) => a.withoutLocalPath().toJson()).toList();
    return json;
  }

  /// Portable backup representation. Device-local attachment paths are
  /// deliberately excluded: they leak usernames and are unsafe to trust when
  /// an export is imported on another device.
  Map<String, dynamic> toExportJson() {
    final json = toJson();
    json['attachments'] = attachments.map((a) => a.withoutLocalPath().toJson()).toList();
    return json;
  }

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      items: (json['items'] as List<dynamic>? ?? [])
          .map((e) => ChecklistItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      isChecklist: json['isChecklist'] as bool? ?? false,
      attachments: (json['attachments'] as List<dynamic>? ?? [])
          .map((e) => Attachment.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      synced: json['synced'] as bool? ?? false,
      nostrEventId: json['nostrEventId'] as String?,
      isDiaryEntry: json['isDiaryEntry'] as bool? ?? false,
      entryDate: json['entryDate'] != null ? DateTime.parse(json['entryDate'] as String) : null,
      color: json['color'] != null ? NoteColor.values.byName(json['color'] as String) : null,
      ownerPubkey: json['ownerPubkey'] as String?,
      sharedWith: (json['sharedWith'] as List<dynamic>? ?? const [])
          .map((e) => e.toString())
          .toList(),
    );
  }
}
