import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;

import 'package:amberflutter/amberflutter.dart';
import 'package:dart_nostr/dart_nostr.dart';
import 'package:flutter/services.dart' show MissingPluginException;

import '../models/note.dart';
import '../models/profile.dart';
import '../models/relay.dart';
import '../models/user.dart';
import '../utils/constants.dart';
import '../utils/crypto.dart';

/// Wraps all interaction with the Nostr protocol: login (importing a
/// private key, or delegating to Amber), connecting to the selected
/// relays, and publishing/fetching the encrypted events that represent
/// notes.
///
/// Echoes never creates brand-new Nostr accounts: it's a client for people
/// who already have one (direct private-key import, or via the Amber
/// external signer). For people without an account yet, onboarding should
/// point them to a full client like Amethyst (not implemented here).
///
/// Uses `dart_nostr` (`Nostr.instance`) as the low-level SDK for event
/// signing and relay transport, `amberflutter` for NIP-55 delegation to
/// Amber, and [CryptoUtils] for NIP-44 encryption of the note `content`
/// when the private key is held locally.
class NostrService {
  final Nostr _nostr = Nostr.instance;

  final Amberflutter _amber = Amberflutter();

  // -------------------------------------------------------------------
  // Identity / login
  // -------------------------------------------------------------------

  /// Converts a hex public key to its bech32 npub form, for the UI and for
  /// rebuilding a [User] from just the pubkey saved locally (Amber session
  /// restored in [AuthNotifier.build]).
  String publicKeyToNpub(String publicKeyHex) {
    return _nostr.bech32.encodePublicKeyToNpub(publicKeyHex);
  }

  /// Imports an existing Nostr account from a private key the user typed in
  /// (nsec bech32 or raw hex).
  Future<User> importAccount(String privateKey) async {
    developer.log('NostrService.importAccount called', name: 'NostrService');
    final privateKeyHex = privateKey.startsWith('nsec1')
        ? _nostr.bech32.decodeNsecKeyToPrivateKey(privateKey)
        : privateKey.trim().toLowerCase();
    return login(privateKeyHex);
  }

  /// Restores a session from an already-known private key (hex), e.g. read
  /// from secure storage at app startup. Does not require any user input:
  /// this is the "silent" path used during automatic app startup.
  Future<User> login(String privateKeyHex) async {
    developer.log('NostrService.login called', name: 'NostrService');
    final keyPairs = _nostr.keys.generateKeyPairFromExistingPrivateKey(privateKeyHex);
    return User(
      publicKeyHex: keyPairs.public,
      npub: publicKeyToNpub(keyPairs.public),
      loginMethod: LoginMethod.privateKey,
      privateKeyHex: privateKeyHex,
    );
  }

  /// true if the Amber app (NIP-55 signer) is installed on this device.
  /// Android only: other platforms don't implement the plugin method, so we
  /// treat that as "not available" rather than crashing.
  Future<bool> isAmberInstalled() async {
    developer.log('NostrService.isAmberInstalled called', name: 'NostrService');
    try {
      return await _amber.isAppInstalled();
    } on MissingPluginException {
      return false;
    }
  }

  /// Asks Amber for the public key of the account currently active in the
  /// signer (via a NIP-55 intent) and opens a [LoginMethod.amber] session:
  /// the private key never crosses into the app, it stays inside Amber.
  ///
  /// Requests every permission Echoes will ever need up front — `sign_event`
  /// (publishing) plus `nip44_encrypt`/`nip44_decrypt` (the self-encryption
  /// used for every note's `content`, both when publishing and when
  /// fetching) — so Amber can grant them once here instead of prompting for
  /// interactive approval on every single publish/fetch afterwards. Without
  /// the nip44 permissions in particular, fetching notes (which decrypts
  /// every event returned by the relay, in a loop, often with nothing in
  /// the foreground to interact with) would silently stall waiting for
  /// approvals that never arrive.
  ///
  /// Amber may return the key either as hex (standard NIP-55 behaviour) or
  /// already as a bech32 npub depending on the installed version: both
  /// formats are handled and normalised to hex internally.
  Future<User> loginWithAmber() async {
    developer.log('NostrService.loginWithAmber called', name: 'NostrService');

    if (!await isAmberInstalled()) {
      throw StateError(
        'Amber does not appear to be installed on this device. '
        'Install Amber (NIP-55 signer) and try again.',
      );
    }

    final result = await _awaitAmber(_amber.getPublicKey(
      permissions: const [
        Permission(type: 'sign_event'),
        Permission(type: 'nip44_encrypt'),
        Permission(type: 'nip44_decrypt'),
      ],
    ));
    final raw = (result['signature'] as String?)?.trim() ?? '';
    if (raw.isEmpty) {
      throw StateError('Amber did not return a public key.');
    }

    final String publicKeyHex;
    final String npub;
    if (raw.startsWith('npub1')) {
      npub = raw;
      publicKeyHex = _nostr.bech32.decodeNpubKeyToPublicKey(raw);
    } else {
      publicKeyHex = raw.toLowerCase();
      npub = publicKeyToNpub(publicKeyHex);
    }

    return User(
      publicKeyHex: publicKeyHex,
      npub: npub,
      loginMethod: LoginMethod.amber,
    );
  }

  // -------------------------------------------------------------------
  // Relay connection
  // -------------------------------------------------------------------

  /// Opens websocket connections to the given [relays] and starts listening
  /// to them right away. Safe to call more than once (e.g. before every
  /// publish/fetch): `dart_nostr` keeps a registry of already-open sockets
  /// keyed by URL.
  ///
  /// `lazyListeningToRelays` must stay `false` (the default): when `true`,
  /// `dart_nostr` opens the socket but never dispatches incoming messages
  /// unless `startListeningToRelay` is also called manually — which nothing
  /// here does. With it left `true`, published events would connect fine
  /// but the relay's "OK" confirmation would never be read off the socket,
  /// so every publish would time out even on a successful publish; reads
  /// would silently come back empty the same way.
  Future<void> connectToRelays(List<Relay> relays) async {
    developer.log('NostrService.connectToRelays called (${relays.length} relays)', name: 'NostrService');
    final urls = relays.map((r) => r.url).toList();
    if (urls.isEmpty) return;
    await _nostr.relays.init(
      relaysUrl: urls,
      retryOnError: true,
      retryOnClose: true,
    );
  }

  Future<void> disconnectFromRelays() async {
    developer.log('NostrService.disconnectFromRelays called', name: 'NostrService');
    await _nostr.relays.freeAllResources();
  }

  // -------------------------------------------------------------------
  // Profile metadata (NIP-01 kind 0)
  // -------------------------------------------------------------------

  /// Fetches [publicKeyHex]'s public profile card (kind 0), if any relay
  /// has one. Unlike notes, this is plain public data by design — no
  /// NIP-44 involved — so a missing or malformed profile is not an error,
  /// just `null`/best-effort field parsing (see [NostrProfile.fromMetadataJson]).
  Future<NostrProfile?> fetchProfileMetadata({
    required String publicKeyHex,
    required List<Relay> relays,
  }) async {
    developer.log('NostrService.fetchProfileMetadata called for $publicKeyHex', name: 'NostrService');
    // The user's configured relays are chosen for *note storage* — there's
    // no reason to expect they also carry this account's profile, which
    // was very likely published by a different Nostr client to that
    // client's own default relays. Always querying a few well-known
    // metadata-oriented relays alongside them (deduplicated) is what lets
    // Settings actually find a name/avatar in practice — see
    // [profileMetadataFallbackRelayUrls].
    final urls = {
      ...relays.map((r) => r.url),
      ...profileMetadataFallbackRelayUrls,
    };
    final queryRelays = urls.map((url) => Relay(url: url)).toList();
    await connectToRelays(queryRelays);

    final events = await _nostr.relays.startEventsSubscriptionAsync(
      request: NostrRequest(
        filters: [
          NostrFilter(authors: [publicKeyHex], kinds: const [0], limit: 1),
        ],
      ),
      timeout: const Duration(seconds: 10),
      shouldThrowErrorOnTimeoutWithoutEose: false,
    );
    if (events.isEmpty) return null;

    // Relays are not required to enforce "one kind-0 per author" or return
    // results in order — pick the most recent event actually received.
    // `createdAt` is nullable on `NostrEvent`; treat a missing timestamp as
    // "oldest possible" rather than letting it crash the comparison.
    final epoch = DateTime.fromMillisecondsSinceEpoch(0);
    final latest = events.reduce(
      (a, b) => (a.createdAt ?? epoch).isAfter(b.createdAt ?? epoch) ? a : b,
    );
    final content = latest.content;
    if (content == null || content.isEmpty) return null;

    try {
      final json = jsonDecode(content) as Map<String, dynamic>;
      return NostrProfile.fromMetadataJson(publicKeyHex, json);
    } catch (e) {
      developer.log('Could not parse profile metadata for $publicKeyHex: $e', name: 'NostrService');
      return null;
    }
  }

  // -------------------------------------------------------------------
  // Notes as Nostr events
  // -------------------------------------------------------------------

  /// Serializes [note], encrypts it (NIP-44, to the author's own pubkey —
  /// "self-encrypted", so only the author can ever read it back) and signs
  /// it as a Nostr event. Does not publish to any relay yet: that's
  /// [publishNote]'s/[syncLocalNotes]'s job, keeping "build the event"
  /// cleanly separate from "try to send it" (offline-first).
  ///
  /// With [LoginMethod.privateKey] both encryption and signing happen
  /// locally. With [LoginMethod.amber] both go through an intent to Amber
  /// instead — the app never touches the private key.
  Future<NostrEvent> createNoteEvent(Note note, User author) async {
    developer.log('NostrService.createNoteEvent called: ${note.id}', name: 'NostrService');
    final plaintext = jsonEncode(note.toJson());
    // "d" tag: identifies the parameterized-replaceable slot (NIP-33/78) so
    // republishing the same note.id updates it in place instead of piling
    // up duplicate events on the relay.
    final tags = [
      ['d', note.id],
    ];
    final createdAt = note.updatedAt;

    final String content;
    switch (author.loginMethod) {
      case LoginMethod.privateKey:
        final privateKeyHex = author.privateKeyHex;
        if (privateKeyHex == null) {
          throw StateError('Missing private key for a LoginMethod.privateKey session.');
        }
        content = CryptoUtils.encryptNip44(
          plaintext: plaintext,
          privateKeyHex: privateKeyHex,
          recipientPublicKeyHex: author.publicKeyHex,
        );

      case LoginMethod.amber:
        final encryptResult = await _awaitAmber(_amber.nip44Encrypt(
          plaintext: plaintext,
          currentUser: author.npub,
          pubKey: author.publicKeyHex,
        ));
        final encrypted = (encryptResult['signature'] as String?) ?? '';
        if (encrypted.isEmpty) {
          throw StateError('Amber returned no encrypted content.');
        }
        content = encrypted;
    }

    return signGenericEvent(
      kind: AppConstants.noteEventKind,
      tags: tags,
      content: content,
      createdAt: createdAt,
      author: author,
    );
  }

  /// Signs an arbitrary Nostr event — local key or Amber intent, depending
  /// on [author.loginMethod] — without touching encryption at all. Shared
  /// by [createNoteEvent] (content already NIP-44 encrypted by the time it
  /// gets here), [deleteNoteEvent] (NIP-09, empty content), and
  /// `AttachmentUploadService`'s NIP-98 upload-authorization events: all
  /// three used to carry their own copy of this exact switch before it was
  /// pulled out here.
  Future<NostrEvent> signGenericEvent({
    required int kind,
    required List<List<String>> tags,
    required String content,
    required User author,
    DateTime? createdAt,
  }) async {
    final effectiveCreatedAt = createdAt ?? DateTime.now();

    switch (author.loginMethod) {
      case LoginMethod.privateKey:
        final privateKeyHex = author.privateKeyHex;
        if (privateKeyHex == null) {
          throw StateError('Missing private key for a LoginMethod.privateKey session.');
        }
        final keyPairs = _nostr.keys.generateKeyPairFromExistingPrivateKey(privateKeyHex);
        return NostrEvent.fromPartialData(
          kind: kind,
          content: content,
          keyPairs: keyPairs,
          tags: tags,
          createdAt: effectiveCreatedAt,
        );

      case LoginMethod.amber:
        final unsignedEvent = {
          'pubkey': author.publicKeyHex,
          'created_at': effectiveCreatedAt.millisecondsSinceEpoch ~/ 1000,
          'kind': kind,
          'tags': tags,
          'content': content,
        };
        final signResult = await _awaitAmber(_amber.signEvent(
          currentUser: author.npub,
          eventJson: jsonEncode(unsignedEvent),
        ));
        final signedJson = signResult['event'] as String?;
        if (signedJson == null) {
          throw StateError('Amber returned no signed event.');
        }
        return _nostrEventFromMap(jsonDecode(signedJson) as Map<String, dynamic>);
    }
  }

  /// Publishes an already-built event to every relay in [relays] (every
  /// configured relay is used for both reading and writing — see [Relay]).
  /// Returns the relay-confirmed event id on success.
  Future<String> publishNote(NostrEvent event, List<Relay> relays) async {
    developer.log('NostrService.publishNote called: ${event.id}', name: 'NostrService');
    if (relays.isEmpty) {
      throw StateError('No relay configured.');
    }
    await connectToRelays(relays);

    final ok = await _nostr.relays.sendEventToRelaysAsync(
      event,
      timeout: const Duration(seconds: 10),
    );
    if (ok.isEventAccepted != true) {
      throw StateError('Relay rejected the event: ${ok.message ?? 'unknown reason'}');
    }
    return ok.eventId;
  }

  /// Fetches every note event (Echoes' application kind) authored by
  /// [author] from every relay in [relays], decrypts them and converts them
  /// to [Note]s. Events that fail to decrypt or parse (e.g. corrupted, or
  /// encrypted for a different key) are skipped rather than failing the
  /// whole fetch.
  ///
  /// The result's `complete` flag is false when [timeout] was hit before
  /// *every* relay sent its own EOSE ("end of stored events"). This matters
  /// because `dart_nostr`'s own `startEventsSubscriptionAsync` doesn't make
  /// that distinction: it resolves as soon as the *first* relay of however
  /// many are configured says it's done, silently discarding whatever the
  /// others were still mid-delivery on. That could truncate a large first
  /// sync to a brand-new device — a lot of history to backfill in one
  /// shot, over however many relays (a self-hosted one in particular could
  /// be the slow one to finish) — and [runSyncCycle] used to move its
  /// `since` bookmark forward regardless, so whatever got cut off then fell
  /// permanently behind that cutoff, never refetched again. This instead
  /// waits for every configured relay's own EOSE (or [timeout], whichever
  /// comes first) and reports whether it actually finished, so the caller
  /// knows whether it's safe to advance that bookmark.
  Future<({List<Note> notes, bool complete})> fetchNotesFromRelay({
    required User author,
    required List<Relay> relays,
    DateTime? since,
    Duration timeout = const Duration(seconds: 20),
  }) async {
    developer.log('NostrService.fetchNotesFromRelay called for ${author.publicKeyHex}', name: 'NostrService');
    if (relays.isEmpty) return (notes: const <Note>[], complete: true);
    await connectToRelays(relays);

    final pendingRelays = relays.map((r) => r.url).toSet();
    final rawEvents = <NostrEvent>[];
    final allEoseCompleter = Completer<void>();

    final subscription = _nostr.relays.startEventsSubscription(
      request: NostrRequest(
        filters: [
          NostrFilter(
            authors: [author.publicKeyHex],
            kinds: const [AppConstants.noteEventKind],
            since: since,
          ),
        ],
      ),
      onEose: (relay, eose) {
        pendingRelays.remove(relay);
        if (pendingRelays.isEmpty && !allEoseCompleter.isCompleted) {
          allEoseCompleter.complete();
        }
      },
    );
    final eventsSubscription = subscription.stream.listen(rawEvents.add);
    await Future.any([allEoseCompleter.future, Future.delayed(timeout)]);
    await eventsSubscription.cancel();
    subscription.close();
    if (pendingRelays.isNotEmpty) {
      developer.log(
        'fetchNotesFromRelay: timed out waiting for EOSE from: $pendingRelays '
        '(often means those relays are unreachable from this network) — '
        'returning ${rawEvents.length} event(s) from the relays that did respond',
        name: 'NostrService',
      );
    }

    final notes = <Note>[];
    for (final event in rawEvents) {
      final note = await _decryptNoteEvent(event, author);
      if (note != null) notes.add(note);
    }
    return (notes: notes, complete: pendingRelays.isEmpty);
  }

  /// Pushes every local note that isn't synced yet ([Note.synced] ==
  /// false) *and* has already been synced at least once before
  /// ([Note.nostrEventId] != null) to the relays. Returns the notes that
  /// were successfully synced (with `synced: true` and `nostrEventId` set);
  /// notes that fail to publish are left out so the next sync cycle retries
  /// them.
  ///
  /// Notes with no [Note.nostrEventId] have never been explicitly synced by
  /// the user (see the cloud button in `NoteEditorScreen`) and must stay
  /// local-only until they choose to: including them here would silently
  /// publish notes the user deliberately kept off the relays on every
  /// pull-to-refresh / auto-sync cycle, defeating that whole feature.
  ///
  /// This is also what re-publishes an *edited* note that was already
  /// synced before: `NoteEditorScreen` always resets `synced` to false the
  /// moment its content changes (while keeping `nostrEventId`), so an
  /// edited-then-saved note falls right into this method's target set on
  /// the next cycle — no separate "was this note edited" tracking needed.
  /// [createNoteEvent] republishes it under the same "d" tag coordinate it
  /// already used, so a NIP-33/78-compliant relay replaces the old version
  /// in place instead of keeping both.
  Future<List<Note>> syncLocalNotes({
    required List<Note> localNotes,
    required User author,
    required List<Relay> relays,
  }) async {
    developer.log(
      'NostrService.syncLocalNotes called (${localNotes.length} local notes)',
      name: 'NostrService',
    );
    final unsyncedNotes = localNotes.where((n) => !n.synced && n.nostrEventId != null).toList();
    final syncedNotes = <Note>[];
    for (final note in unsyncedNotes) {
      try {
        final event = await createNoteEvent(note, author);
        final eventId = await publishNote(event, relays);
        syncedNotes.add(note.copyWith(synced: true, nostrEventId: eventId));
      } catch (e) {
        developer.log('Failed to sync note ${note.id}: $e', name: 'NostrService');
        // Leave it unsynced; the next sync cycle will retry it.
      }
    }
    return syncedNotes;
  }

  /// Publishes a NIP-09 deletion request (kind 5) retracting [note]'s last
  /// synced event, so relays honoring NIP-09 stop serving it. Tags both the
  /// specific event id ("e") and the parameterized-replaceable coordinate
  /// ("a", `kind:pubkey:d-tag`) — the latter is what NIP-09 recommends for
  /// addressable/replaceable kinds like Echoes' notes (30078), since a
  /// relay indexing deletions by coordinate can also catch any older
  /// republished version of the same note that "e" alone would miss.
  ///
  /// No-op if [note] was never synced ([Note.nostrEventId] is null) — there
  /// is nothing on the relays to retract.
  Future<void> deleteNoteEvent({
    required Note note,
    required User author,
    required List<Relay> relays,
  }) async {
    final eventId = note.nostrEventId;
    if (eventId == null) return;
    developer.log('NostrService.deleteNoteEvent called: $eventId', name: 'NostrService');

    final tags = [
      ['e', eventId],
      ['a', '${AppConstants.noteEventKind}:${author.publicKeyHex}:${note.id}'],
    ];

    final deletionEvent = await signGenericEvent(
      kind: AppConstants.deletionEventKind,
      tags: tags,
      content: '',
      author: author,
    );

    await publishNote(deletionEvent, relays);
  }

  // -------------------------------------------------------------------
  // Helpers
  // -------------------------------------------------------------------

  /// Bounds how long we wait for an Amber intent to come back (see
  /// [AppConstants.amberInteractionTimeout]): `amberflutter`'s Android side
  /// only resolves the method channel result on `RESULT_OK`, so if the user
  /// cancels/denies in Amber the underlying [future] would otherwise never
  /// complete, leaving callers (and their loading spinners) stuck forever.
  Future<T> _awaitAmber<T>(Future<T> future) {
    return future.timeout(
      AppConstants.amberInteractionTimeout,
      onTimeout: () => throw StateError(
        'Amber did not respond in time. If you cancelled the request in Amber, please try again.',
      ),
    );
  }

  Future<Note?> _decryptNoteEvent(NostrEvent event, User author) async {
    final content = event.content;
    final eventId = event.id;
    if (content == null || content.isEmpty || eventId == null) return null;
    // Cheapest check first: an oversized `content` is either a broken or a
    // hostile relay wasting CPU/memory on hashing and decryption attempts
    // that were never going to succeed — see [AppConstants.maxNoteEventContentChars].
    if (content.length > AppConstants.maxNoteEventContentChars) {
      developer.log('Note event $eventId content exceeds the size cap — dropped', name: 'NostrService');
      return null;
    }
    // Relays are untrusted: recompute the id from the event's own fields
    // and check the signature against it before trusting anything about
    // this event, in particular `eventId` itself — which becomes
    // `Note.nostrEventId`, later used to target a NIP-09 deletion. Without
    // this, a malicious relay could hand back a real (validly-encrypted,
    // genuinely decryptable) ciphertext under a *different* id of its own
    // choosing; the note would decrypt and look legitimate, but deleting it
    // later would retract the wrong event — the real one would silently
    // survive on every honest relay. The content itself doesn't strictly
    // need this (NIP-44 self-encryption already means a relay can't forge
    // decryptable content without the private key), but the outer envelope
    // (id, tags, created_at as delivered) isn't otherwise checked at all.
    if (!_isVerifiedEvent(event)) {
      developer.log('Note event $eventId failed id/signature verification — dropped', name: 'NostrService');
      return null;
    }

    try {
      final String plaintext;
      switch (author.loginMethod) {
        case LoginMethod.privateKey:
          final privateKeyHex = author.privateKeyHex;
          if (privateKeyHex == null) return null;
          plaintext = CryptoUtils.decryptNip44(
            ciphertext: content,
            privateKeyHex: privateKeyHex,
            senderPublicKeyHex: author.publicKeyHex,
          );
        case LoginMethod.amber:
          final result = await _awaitAmber(_amber.nip44Decrypt(
            ciphertext: content,
            currentUser: author.npub,
            pubKey: author.publicKeyHex,
          ));
          final decrypted = result['signature'] as String?;
          if (decrypted == null) return null;
          plaintext = decrypted;
      }

      final json = jsonDecode(plaintext) as Map<String, dynamic>;
      return Note.fromJson(json).copyWith(synced: true, nostrEventId: eventId);
    } catch (e) {
      developer.log('Could not decrypt/parse note event $eventId: $e', name: 'NostrService');
      return null;
    }
  }

  /// True when [event]'s `id` matches the canonical NIP-01 hash of its own
  /// fields AND its `sig` is a valid signature over that id by `pubkey` —
  /// i.e. the event is exactly what its signer actually signed, not a
  /// relay-tampered mix of a genuine id/sig with substituted content/tags.
  /// Never throws: any malformed event (missing field, bad hex, ...) is
  /// simply not verified.
  bool _isVerifiedEvent(NostrEvent event) {
    try {
      final id = event.id;
      final kind = event.kind;
      final createdAt = event.createdAt;
      if (id == null || kind == null || createdAt == null) return false;
      final recomputedId = NostrEvent.getEventId(
        kind: kind,
        content: event.content ?? '',
        createdAt: createdAt,
        tags: event.tags ?? const [],
        pubkey: event.pubkey,
      );
      if (recomputedId != id) return false;
      return event.isVerified();
    } catch (_) {
      return false;
    }
  }

  NostrEvent _nostrEventFromMap(Map<String, dynamic> map) {
    return NostrEvent(
      id: map['id'] as String,
      kind: map['kind'] as int,
      content: map['content'] as String? ?? '',
      sig: map['sig'] as String,
      pubkey: map['pubkey'] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch((map['created_at'] as int) * 1000),
      tags: (map['tags'] as List<dynamic>)
          .map((tag) => (tag as List<dynamic>).map((e) => e.toString()).toList())
          .toList(),
    );
  }
}
