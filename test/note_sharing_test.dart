// Unit tests for the note-sharing wire/crypto invariants that carry the
// security and privacy weight of the feature:
//  * the per-recipient/edit `d`-tags are deterministic (so updates replace
//    in place) yet distinct across recipients/roles (so a relay can't tell
//    two recipients hold the same note from the coordinates alone);
//  * the shared wire copy leaks neither the recipient list nor the owner's
//    local file paths, and a received attachment can't carry a local path.
import 'package:echoes/models/attachment.dart';
import 'package:echoes/models/note.dart';
import 'package:echoes/utils/note_sharing.dart';
import 'package:flutter_test/flutter_test.dart';

Note _noteFixture() => Note(
      id: 'note-1',
      title: 'Title',
      body: 'Body',
      createdAt: DateTime.utc(2026, 1, 1),
      updatedAt: DateTime.utc(2026, 1, 2),
      ownerPubkey: null,
      sharedWith: const ['recipient-a-pub', 'recipient-b-pub'],
      attachments: [
        const Attachment(
          id: 'att-1',
          type: AttachmentType.image,
          localPath: '/home/secretuser/photos/private.jpg',
          url: 'https://host.example/blob',
          decryptionKeyBase64: 'a2V5',
          decryptionNonceBase64: 'bm9uY2U=',
          mimeType: 'image/jpeg',
          sha256OfEncrypted: 'abc',
        ),
      ],
    );

void main() {
  group('NoteSharing d-tags', () {
    const owner = 'owner-pub';
    const recipientA = 'recipient-a-pub';
    const recipientB = 'recipient-b-pub';

    test('shareDTag is deterministic for the same recipient + note', () {
      expect(
        NoteSharing.shareDTag(recipientPubHex: recipientA, noteId: 'n'),
        NoteSharing.shareDTag(recipientPubHex: recipientA, noteId: 'n'),
      );
    });

    test('shareDTag differs across recipients of the same note', () {
      expect(
        NoteSharing.shareDTag(recipientPubHex: recipientA, noteId: 'n'),
        isNot(NoteSharing.shareDTag(recipientPubHex: recipientB, noteId: 'n')),
      );
    });

    test('shareDTag differs across notes for the same recipient', () {
      expect(
        NoteSharing.shareDTag(recipientPubHex: recipientA, noteId: 'n1'),
        isNot(NoteSharing.shareDTag(recipientPubHex: recipientA, noteId: 'n2')),
      );
    });

    test('editDTag is deterministic and distinct from a shareDTag', () {
      expect(
        NoteSharing.editDTag(ownerPubHex: owner, noteId: 'n'),
        NoteSharing.editDTag(ownerPubHex: owner, noteId: 'n'),
      );
      // A share (owner->recipient) and an edit (recipient->owner) for the
      // same note must never collide on the same coordinate.
      expect(
        NoteSharing.editDTag(ownerPubHex: owner, noteId: 'n'),
        isNot(NoteSharing.shareDTag(recipientPubHex: owner, noteId: 'n')),
      );
    });

    test('d-tags are opaque 64-hex (sha256), not the raw ids', () {
      final tag = NoteSharing.shareDTag(recipientPubHex: recipientA, noteId: 'n');
      expect(tag, matches(RegExp(r'^[0-9a-f]{64}$')));
      expect(tag.contains('n'), isFalse);
      expect(tag.contains(recipientA), isFalse);
    });
  });

  group('Note.toShareJson privacy stripping', () {
    test('drops the recipient list and owner/sync bookkeeping', () {
      final json = _noteFixture().toShareJson();
      expect(json.containsKey('sharedWith'), isFalse);
      expect(json.containsKey('ownerPubkey'), isFalse);
      expect(json.containsKey('synced'), isFalse);
      expect(json.containsKey('nostrEventId'), isFalse);
    });

    test('keeps the actual content a recipient needs', () {
      final json = _noteFixture().toShareJson();
      expect(json['id'], 'note-1');
      expect(json['title'], 'Title');
      expect(json['body'], 'Body');
    });

    test("strips the owner's local file paths from attachments", () {
      final json = _noteFixture().toShareJson();
      final attachments = json['attachments'] as List<dynamic>;
      final att = attachments.single as Map<String, dynamic>;
      expect(att['localPath'], isNull);
      // The remote URL + decryption material must survive — that's how a
      // recipient actually fetches and decrypts it.
      expect(att['url'], 'https://host.example/blob');
      expect(att['decryptionKeyBase64'], 'a2V5');
    });

    test('a round-trip through the wire never carries a local path back', () {
      final wire = _noteFixture().toShareJson();
      final received = Note.fromJson(wire);
      expect(received.attachments.single.localPath, isNull);
    });
  });

  group('Attachment.withoutLocalPath', () {
    test('clears only the local path, preserving everything else', () {
      const att = Attachment(
        id: 'a',
        type: AttachmentType.audio,
        localPath: '/tmp/x.m4a',
        url: 'https://h/x',
        decryptionKeyBase64: 'k',
        decryptionNonceBase64: 'n',
        mimeType: 'audio/mp4',
        durationSeconds: 12,
      );
      final stripped = att.withoutLocalPath();
      expect(stripped.localPath, isNull);
      expect(stripped.url, 'https://h/x');
      expect(stripped.decryptionKeyBase64, 'k');
      expect(stripped.durationSeconds, 12);
    });
  });
}
