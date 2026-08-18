import 'package:dart_nostr/dart_nostr.dart';
import 'package:echoes/models/note.dart';
import 'package:echoes/models/relay.dart';
import 'package:echoes/models/upload_provider.dart';
import 'package:echoes/models/user.dart';
import 'package:echoes/services/attachment_upload_service.dart';
import 'package:echoes/services/file_cache_service.dart';
import 'package:echoes/services/local_storage_service.dart';
import 'package:echoes/services/nostr_service.dart';
import 'package:echoes/services/note_encryption_service.dart';
import 'package:echoes/services/sync_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final authorKeys = Nostr.instance.keys.generateKeyPair();
  final author = User(
    publicKeyHex: authorKeys.public,
    npub: Nostr.instance.bech32.encodePublicKeyToNpub(authorKeys.public),
    loginMethod: LoginMethod.privateKey,
    privateKeyHex: authorKeys.private,
  );
  const relays = [Relay(url: 'wss://relay.example')];
  const fourRelays = [
    Relay(url: 'wss://relay.one'),
    Relay(url: 'wss://relay.two'),
    Relay(url: 'wss://relay.three'),
    Relay(url: 'wss://relay.four'),
  ];

  Note note({String? owner, List<String> sharedWith = const []}) => Note(
    id: 'note-1',
    title: 'title',
    body: 'body',
    createdAt: DateTime.utc(2026),
    updatedAt: DateTime.utc(2026, 1, 2),
    ownerPubkey: owner,
    sharedWith: sharedWith,
  );

  test('explicit sync republishes an owned note to every recipient', () async {
    final harness = _Harness();
    final result = await harness.service.syncNote(
      note: note(sharedWith: const ['recipient-a', 'recipient-b']),
      author: author,
      relays: relays,
      uploadProvider: blossomHzrd149Provider,
    );

    expect(harness.nostr.published, ['self', 'share:recipient-a', 'share:recipient-b']);
    expect(result.note.synced, isTrue);
    expect(harness.storage.saved.any((saved) => !saved.synced), isTrue);
  });

  test('explicit sync of a received note sends only an edit proposal', () async {
    final harness = _Harness();
    final result = await harness.service.syncNote(
      note: note(owner: 'owner-pubkey'),
      author: author,
      relays: relays,
      uploadProvider: blossomHzrd149Provider,
    );

    expect(harness.nostr.published, ['edit:owner-pubkey']);
    expect(result.note.synced, isTrue);
    expect(result.note.ownerPubkey, 'owner-pubkey');
  });

  test('tapping sync reports how many relays actually took the note', () async {
    // The bug this pins down: a note accepted by one relay out of four used
    // to be reported as plainly "synced", which is how it could look
    // published here and be missing on another device.
    final harness = _Harness(acceptedRelays: 1);
    final result = await harness.service.syncNote(
      note: note(),
      author: author,
      relays: fourRelays,
      uploadProvider: blossomHzrd149Provider,
    );

    expect(harness.nostr.published, ['self']);
    expect(result.accepted, 1);
    expect(result.total, 4);
  });

  test('a note taken by every relay reports full coverage', () async {
    final harness = _Harness();
    final result = await harness.service.syncNote(
      note: note(),
      author: author,
      relays: fourRelays,
      uploadProvider: blossomHzrd149Provider,
    );

    expect(result.accepted, result.total);
    expect(result.note.synced, isTrue);
    expect(result.note.nostrEventId, isNotNull);
  });

  test('partial recipient failure leaves a resumable unsynced state', () async {
    final harness = _Harness(failOn: 'share:recipient-b');
    final future = harness.service.syncNote(
      note: note(sharedWith: const ['recipient-a', 'recipient-b']),
      author: author,
      relays: relays,
      uploadProvider: blossomHzrd149Provider,
    );

    await expectLater(future, throwsStateError);
    expect(harness.storage.saved.last.synced, isFalse);
    expect(harness.storage.saved.last.nostrEventId, isNotNull);
  });
}

class _Harness {
  _Harness({String? failOn, int? acceptedRelays}) {
    nostr = _FakeNostrService(failOn: failOn, acceptedRelays: acceptedRelays);
    storage = _FakeStorage();
    service = _OnlineSyncService(
      localStorageService: storage,
      nostrService: nostr,
      attachmentUploadService: AttachmentUploadService(
        nostrService: nostr,
        fileCacheService: FileCacheService(),
      ),
    );
  }

  late final _FakeNostrService nostr;
  late final _FakeStorage storage;
  late final SyncService service;
}

class _OnlineSyncService extends SyncService {
  _OnlineSyncService({
    required super.localStorageService,
    required super.nostrService,
    required super.attachmentUploadService,
  });

  @override
  Future<bool> isOnline() async => true;
}

class _FakeStorage extends LocalStorageService {
  _FakeStorage() : super(noteEncryptionService: NoteEncryptionService());

  final saved = <Note>[];

  @override
  Future<Note> saveNote(Note note) async {
    saved.add(note);
    return note;
  }
}

class _FakeNostrService extends NostrService {
  _FakeNostrService({this.failOn, this.acceptedRelays});

  final String? failOn;

  /// How many relays accept a publish; null means "all of them". Lets a test
  /// stand in for the real-world case of some relays rejecting or timing out.
  final int? acceptedRelays;
  final published = <String>[];
  final _keys = Nostr.instance.keys.generateKeyPair();

  NostrEvent _event(String label) =>
      NostrEvent.fromPartialData(kind: 30078, content: label, keyPairs: _keys, tags: const []);

  @override
  Future<NostrEvent> createNoteEvent(Note note, User author) async {
    return _event('self');
  }

  @override
  Future<NostrEvent> createSharedNoteEvent({
    required Note note,
    required User author,
    required String recipientPubHex,
  }) async {
    return _event('share:$recipientPubHex');
  }

  @override
  Future<NostrEvent> createEditProposalEvent({
    required Note note,
    required User author,
    required String ownerPubHex,
  }) async {
    return _event('edit:$ownerPubHex');
  }

  // The single publish seam: the real `publishNote` just delegates here, so
  // overriding this one covers every publish path (self copy, recipient
  // copies, edit proposals) without the fake having to know which is which.
  @override
  Future<({String eventId, int accepted, int total, List<String> failures})> publishNoteToRelays(
    NostrEvent event,
    List<Relay> relays,
  ) async {
    final label = event.content!;
    published.add(label);
    if (label == failOn) {
      throw StateError('simulated publish failure');
    }
    final accepted = acceptedRelays ?? relays.length;
    return (
      eventId: event.id!,
      accepted: accepted,
      total: relays.length,
      failures: [for (var i = accepted; i < relays.length; i++) 'relay$i: rejected'],
    );
  }
}
