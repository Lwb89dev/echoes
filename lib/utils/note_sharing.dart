import 'dart:convert';

import 'package:crypto/crypto.dart';

/// Helpers for the note-sharing protocol (see `SyncService`'s sharing
/// methods and `NostrService`'s share-event methods).
///
/// ## Model in one paragraph
///
/// A shared note always has exactly one **owner** — the identity that first
/// created it — who is the only one who can publish its canonical
/// self-encrypted event (a parameterized-replaceable event's `d`-tag
/// coordinate can only be written by its own author's key, so there is no
/// such thing as a truly co-owned event on Nostr). Sharing works by the
/// owner publishing, *per recipient*, a separate NIP-44 copy encrypted to
/// that recipient's pubkey. A recipient who edits can't touch the owner's
/// event, so they publish their own "edit proposal" encrypted back to the
/// owner; the owner's client merges it (last-write-wins by `updatedAt`,
/// same rule as multi-device sync) and re-publishes to everyone. Acceptance
/// of an edit is therefore implicit — no manual approval — it's just the
/// owner's device doing the merge it would do for any of its own devices.
///
/// ## Why per-recipient encryption (not one shared symmetric key)
///
/// It makes "stop sharing with X" actually enforceable going forward: the
/// owner simply stops encrypting future updates for X (and deletes X's
/// existing copy). With one shared key, revoking anyone would mean
/// re-keying everyone. The unavoidable limit either way: whatever a
/// recipient already decrypted and stored locally can't be un-shared —
/// revocation only cuts off *future* updates.
///
/// ## What is protected (and what isn't)
///
/// Every note payload is NIP-44 encrypted end to end, so relays and file
/// hosts only ever see ciphertext — never a title, body, or attachment.
/// The trust boundary for *incoming* events is strict: an event's signature
/// is verified before its author is believed, and the author (not anything
/// in the payload) decides what that event is allowed to do — a stranger
/// can't push edits to a note you own, and only a note's real owner can
/// update a note shared with you (see `SyncService._applyIncomingNote`).
/// Received attachments are fetched only from their own https URL, hash-
/// checked before decryption, and stripped of any sender-chosen local path.
///
/// ### Known residual risks (documented, not yet mitigated)
///
///  * **Social-graph metadata.** Share and edit events carry a cleartext
///    `p`-tag naming the counterparty, so a relay learns *who shares with
///    whom* and roughly when/how often — though never *what*. Closing this
///    needs NIP-59 gift-wrapping (ephemeral keys, hidden sender), a larger
///    change deferred to a later version.
///  * **Unsolicited shares (spam).** Anyone can publish an event addressed
///    to you, exactly like a Nostr DM, so anyone can "share" a note with
///    you. Per-cycle intake is capped (see `maxIncomingSharesPerCycle`), but
///    real spam filtering wants a contacts allowlist, not yet built.
///  * **Read-receipt / IP exposure via attachments.** Opening a note shared
///    with you fetches its attachments from a host the *sharer* chose, which
///    reveals your IP and timing to that host (a tracking-pixel-style
///    signal). Enforced-https limits it to TLS; fully hiding it would need
///    proxied/onion fetches.
class NoteSharing {
  NoteSharing._();

  /// Domain-separated, deterministic `d`-tag for the owner's per-recipient
  /// copy of a note. Deterministic so the owner can *update* (replace) that
  /// recipient's copy in place across edits; per-recipient (the recipient
  /// pubkey is mixed in) so two recipients' copies of the same note get
  /// different coordinates — a relay can't tell from the `d`-tags alone
  /// that they're the same underlying note.
  static String shareDTag({required String recipientPubHex, required String noteId}) {
    return _tag('echoes-share:v1:$recipientPubHex:$noteId');
  }

  /// Deterministic `d`-tag for a recipient's edit-proposal copy addressed
  /// back to the note's owner. Deterministic so a recipient editing twice
  /// replaces their own previous proposal instead of piling up events.
  static String editDTag({required String ownerPubHex, required String noteId}) {
    return _tag('echoes-share-edit:v1:$ownerPubHex:$noteId');
  }

  static String _tag(String input) {
    return sha256.convert(utf8.encode(input)).toString();
  }

  /// Marker key in a shared payload's JSON identifying a control message
  /// rather than a note. Absent on normal note payloads.
  static const String controlTypeKey = '_echoesControl';

  /// Control payload a recipient sends the owner when abandoning a shared
  /// note, so the owner can drop them from the recipient list (and stop
  /// encrypting future updates for them). Best-effort — the recipient's
  /// local tombstone is the actual "can't re-hook" enforcement; this is the
  /// owner-side cleanup on top of it.
  static const String controlLeave = 'leave';
}
