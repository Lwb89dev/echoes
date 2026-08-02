import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:isolate';

import 'package:amberflutter/amberflutter.dart';
import 'package:dart_nostr/dart_nostr.dart';
import 'package:flutter/services.dart' show MissingPluginException;
import 'package:http/http.dart' as http;

import '../models/note.dart';
import '../models/profile.dart';
import '../models/relay.dart';
import '../models/user.dart';
import '../utils/constants.dart';
import '../utils/crypto.dart';
import '../utils/note_sharing.dart';
import 'nip46_client.dart';

/// One decrypted event addressed to the local user: either a note update
/// (a share from an owner, or an edit proposal from a recipient — the
/// caller decides which by looking at [sender]) or a control message (e.g.
/// a recipient leaving). [sender] is always the *signed* event author, so
/// it is safe to make trust decisions on.
class IncomingShare {
  final String sender;
  final DateTime createdAt;
  final Note? note;
  final String? controlType;
  final String? controlNoteId;

  const IncomingShare._({
    required this.sender,
    required this.createdAt,
    this.note,
    this.controlType,
    this.controlNoteId,
  });

  factory IncomingShare.note({
    required String sender,
    required DateTime createdAt,
    required Note note,
  }) =>
      IncomingShare._(sender: sender, createdAt: createdAt, note: note);

  factory IncomingShare.control({
    required String sender,
    required DateTime createdAt,
    required String type,
    required String noteId,
  }) =>
      IncomingShare._(sender: sender, createdAt: createdAt, controlType: type, controlNoteId: noteId);

  bool get isControl => controlType != null;
}

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

  /// The live NIP-46 connection for a [LoginMethod.bunker] session, or null
  /// for any other login method. Held here (not on [User]) so it survives as
  /// a single long-lived transport for the whole session; set by
  /// [loginWithBunker]/[restoreBunkerSession] and torn down by [logoutBunker].
  Nip46Client? _bunkerClient;

  // -------------------------------------------------------------------
  // Identity / login
  // -------------------------------------------------------------------

  /// Converts a hex public key to its bech32 npub form, for the UI and for
  /// rebuilding a [User] from just the pubkey saved locally (Amber session
  /// restored in [AuthNotifier.build]).
  String publicKeyToNpub(String publicKeyHex) {
    return _nostr.bech32.encodePublicKeyToNpub(publicKeyHex);
  }

  /// Normalizes a recipient identifier the user typed — a bech32 `npub` or a
  /// raw 64-char hex pubkey — to lowercase hex, or throws [FormatException]
  /// if it's neither. Used when adding a share recipient; keeping the
  /// parsing here (not in the UI) means the bech32/hex validation lives in
  /// one place next to the rest of the key handling.
  String recipientToPublicKeyHex(String input) {
    final trimmed = input.trim();
    if (trimmed.startsWith('npub1')) {
      return _nostr.bech32.decodeNpubKeyToPublicKey(trimmed).toLowerCase();
    }
    final hex = trimmed.toLowerCase();
    if (hex.length == 64 && RegExp(r'^[0-9a-f]{64}$').hasMatch(hex)) {
      return hex;
    }
    throw const FormatException('Not a valid npub or hex public key.');
  }

  /// Resolves a NIP-05 identifier (`name@domain`) to its owner's pubkey hex
  /// by fetching `https://<domain>/.well-known/nostr.json?name=<name>` and
  /// reading `names[<name>]`. Returns lowercase hex, or throws
  /// [FormatException] if the identifier is malformed, the domain doesn't
  /// answer with a 200, or it lists no valid pubkey for that name.
  ///
  /// This only tells us the pubkey the *domain operator* maps that name to —
  /// it is not proof of who the person is (anyone can host a nostr.json). The
  /// share sheet therefore treats the result as a suggestion to be confirmed
  /// visually (avatar + npub), never an authenticated identity.
  ///
  /// The identifier's shape is validated *before* any network call: the local
  /// part is restricted to NIP-05's charset and the domain to a bare host, so
  /// a typed value can never smuggle a scheme, path, port or query of its own
  /// into the request — [Uri.https] then percent-encodes both into a fixed
  /// well-known path. HTTPS is mandatory (like avatar/attachment fetches).
  Future<String> resolveNip05(String identifier) async {
    developer.log('NostrService.resolveNip05 called', name: 'NostrService');
    final trimmed = identifier.trim();
    final at = trimmed.indexOf('@');
    // Exactly one '@', with a non-empty local part before it.
    if (at <= 0 || at != trimmed.lastIndexOf('@')) {
      throw const FormatException('Not a NIP-05 identifier.');
    }
    final localPart = trimmed.substring(0, at);
    final domain = trimmed.substring(at + 1).toLowerCase();
    if (!RegExp(r'^[a-zA-Z0-9._-]+$').hasMatch(localPart) ||
        !RegExp(r'^[a-z0-9-]+(\.[a-z0-9-]+)+$').hasMatch(domain)) {
      throw const FormatException('Malformed NIP-05 identifier.');
    }

    final url = Uri.https(domain, '/.well-known/nostr.json', {'name': localPart});
    final body = await _httpsGetBounded(url, maxBytes: 100 * 1024);

    final decoded = jsonDecode(body);
    final names = (decoded is Map) ? decoded['names'] : null;
    if (names is! Map) {
      throw const FormatException('NIP-05 response has no names map.');
    }
    // Prefer the exact name the server was asked for; fall back to a
    // case-insensitive match since some servers normalise the key's case.
    var hex = names[localPart];
    if (hex is! String) {
      final lower = localPart.toLowerCase();
      for (final entry in names.entries) {
        if (entry.key is String && (entry.key as String).toLowerCase() == lower) {
          hex = entry.value;
          break;
        }
      }
    }
    if (hex is! String) {
      throw const FormatException('NIP-05 name not found.');
    }
    final normalized = hex.toLowerCase();
    if (!RegExp(r'^[0-9a-f]{64}$').hasMatch(normalized)) {
      throw const FormatException('NIP-05 name maps to an invalid pubkey.');
    }
    return normalized;
  }

  /// GET [url] with the same paranoia the rest of the app applies to
  /// arbitrary third-party hosts, returning the response body as a string.
  ///
  ///  * **https end-to-end**: redirects are followed manually (at most
  ///    [maxRedirects] hops) and only to https targets. `package:http`'s
  ///    default client would happily follow a redirect that downgrades to
  ///    plain http, silently moving the query — which for NIP-05 includes
  ///    the name being looked up — onto the wire in cleartext.
  ///  * **bounded body**: the byte stream is abandoned the moment it passes
  ///    [maxBytes], *before* any JSON parsing, so a hostile host can't feed
  ///    an arbitrarily large response into memory. `http.get` offers no such
  ///    cut-off: it buffers whatever the server sends, however big.
  ///
  /// Throws [FormatException] on any non-200 terminal status, a non-https
  /// or missing redirect target, too many hops, or an oversized body.
  Future<String> _httpsGetBounded(Uri url, {required int maxBytes, int maxRedirects = 3}) async {
    var current = url;
    final client = http.Client();
    try {
      for (var hop = 0; hop <= maxRedirects; hop++) {
        final request = http.Request('GET', current)..followRedirects = false;
        final response = await client.send(request).timeout(const Duration(seconds: 10));

        if (const {301, 302, 303, 307, 308}.contains(response.statusCode)) {
          final location = response.headers['location'];
          if (location == null) throw const FormatException('Redirect without a location.');
          final target = current.resolve(location);
          if (target.scheme != 'https') {
            throw const FormatException('Refusing a redirect off https.');
          }
          current = target;
          continue;
        }
        if (response.statusCode != 200) {
          throw FormatException('Lookup failed (HTTP ${response.statusCode}).');
        }

        final bytes = <int>[];
        await for (final chunk in response.stream.timeout(const Duration(seconds: 10))) {
          bytes.addAll(chunk);
          if (bytes.length > maxBytes) {
            throw const FormatException('Response too large.');
          }
        }
        return utf8.decode(bytes);
      }
      throw const FormatException('Too many redirects.');
    } finally {
      client.close();
    }
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

  /// Logs in with a NIP-46 remote signer from a `bunker://` token: opens the
  /// transport, performs the `connect` handshake and reads the account's
  /// pubkey. Returns the [User] plus the fully-populated [Nip46Session] the
  /// caller must persist (it holds the ephemeral client key — secure storage
  /// only). [onAuthChallenge] is invoked if the signer wants the user to
  /// approve the connection out of band (open the returned URL); the connect
  /// call keeps waiting for the real result afterwards.
  ///
  /// Works identically on Android and Linux — nothing here is platform
  /// specific, which is the whole reason it's offered alongside (Android-only)
  /// Amber.
  Future<({User user, Nip46Session session})> loginWithBunker(
    String bunkerUri, {
    void Function(String authUrl)? onAuthChallenge,
  }) async {
    developer.log('NostrService.loginWithBunker called', name: 'NostrService');
    final clientPrivateKeyHex = _nostr.keys.generatePrivateKey();
    final session = Nip46Session.fromBunkerUri(bunkerUri, clientPrivateKeyHex: clientPrivateKeyHex);

    final client = Nip46Client(session: session, onAuthChallenge: onAuthChallenge);
    try {
      final userPubHex = await client.connectAndGetPubkey();
      if (!RegExp(r'^[0-9a-f]{64}$').hasMatch(userPubHex)) {
        throw const Nip46Exception('The signer returned an invalid public key.');
      }
      final populated = session.copyWith(userPubHex: userPubHex);
      await _bunkerClient?.dispose();
      _bunkerClient = client;
      return (
        user: User(
          publicKeyHex: userPubHex,
          npub: publicKeyToNpub(userPubHex),
          loginMethod: LoginMethod.bunker,
        ),
        session: populated,
      );
    } catch (e) {
      await client.dispose();
      rethrow;
    }
  }

  /// Rebuilds a bunker connection from a persisted [session] at app startup —
  /// no handshake or user interaction, just reopen the transport. The pubkey
  /// is already known from the stored session.
  Future<User> restoreBunkerSession(Nip46Session session) async {
    developer.log('NostrService.restoreBunkerSession called', name: 'NostrService');
    final client = Nip46Client(session: session);
    await client.start();
    await _bunkerClient?.dispose();
    _bunkerClient = client;
    return User(
      publicKeyHex: session.userPubHex,
      npub: publicKeyToNpub(session.userPubHex),
      loginMethod: LoginMethod.bunker,
    );
  }

  /// Tears down the live bunker connection, if any. Called on logout.
  Future<void> logoutBunker() async {
    await _bunkerClient?.dispose();
    _bunkerClient = null;
  }

  Nip46Client _requireBunkerClient() {
    final client = _bunkerClient;
    if (client == null) {
      throw const Nip46Exception('No active bunker connection — please sign in again.');
    }
    return client;
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

  /// Filters raw relay events down to the ones that can safely be
  /// *attributed*: signature-verified AND actually authored by one of
  /// [expectedAuthors]. The two checks matter independently — a relay is
  /// free to ignore the request's `authors` filter and return events
  /// carrying any pubkey it likes (only a valid signature makes the pubkey
  /// real), and a validly-signed event by some *unrelated* key would still
  /// pass verification alone (letting a relay inject strangers into, say,
  /// the contact autocomplete). Everything feeding identity UI — the
  /// name/avatar a person is recognised by before a note is shared with
  /// them — must pass through here first. Oversized content is dropped
  /// *before* the signature check: verification hashes the whole content,
  /// so a hostile relay shipping huge events would otherwise get free CPU
  /// out of the verifier itself (same cheapest-check-first ordering as
  /// [_decryptNoteEvent]).
  ///
  /// Runs the actual verification on a **background isolate**: schnorr
  /// verification in pure Dart costs tens of milliseconds per event, and
  /// this path can face a whole contact list's worth of kind-0s at once
  /// (~hundreds). Done inline that arithmetic adds up to seconds of blocked
  /// UI thread — frozen typing, and on Android long enough for an ANR kill.
  /// Only primitive maps cross the isolate boundary (rebuilt into events on
  /// the far side via [_nostrEventFromMap]) and only kept *indexes* come
  /// back, so nothing non-sendable is ever transferred.
  Future<List<NostrEvent>> _attributedEvents(
      List<NostrEvent> events, Set<String> expectedAuthors) async {
    if (events.isEmpty) return const [];
    // Events missing any field required for verification can be dropped
    // right here — they could never pass — which also guarantees the wire
    // maps below are fully non-null for the isolate-side rebuild.
    final candidates = events
        .where((e) =>
            e.id != null &&
            e.sig != null &&
            e.kind != null &&
            e.createdAt != null &&
            (e.content?.length ?? 0) <= AppConstants.maxNoteEventContentChars &&
            expectedAuthors.contains(e.pubkey))
        .toList();
    if (candidates.isEmpty) return const [];

    final wireMaps = [
      for (final e in candidates)
        {
          'id': e.id!,
          'kind': e.kind!,
          'content': e.content ?? '',
          'sig': e.sig!,
          'pubkey': e.pubkey,
          'created_at': e.createdAt!.millisecondsSinceEpoch ~/ 1000,
          'tags': [
            for (final tag in e.tags ?? const <List<String>>[]) List<String>.of(tag),
          ],
        },
    ];
    final keptIndexes = await Isolate.run(() => _verifiedIndexes(wireMaps));
    return [for (final i in keptIndexes) candidates[i]];
  }

  /// Isolate entry point for [_attributedEvents]: rebuilds each wire map
  /// into a [NostrEvent] and returns the indexes of the ones whose id and
  /// signature verify. Static and touching no instance state — it must be
  /// callable from a background isolate.
  static List<int> _verifiedIndexes(List<Map<String, dynamic>> wireMaps) {
    final kept = <int>[];
    for (var i = 0; i < wireMaps.length; i++) {
      try {
        if (_isVerifiedEvent(_nostrEventFromMap(wireMaps[i]))) kept.add(i);
      } catch (_) {
        // Malformed map — simply not verified.
      }
    }
    return kept;
  }

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

    // Uses the same all-relays-EOSE [_gatherEvents] helper as note fetching,
    // not `startEventsSubscriptionAsync` directly: that call resolves as
    // soon as the *first* relay of however many are queried sends its own
    // EOSE, discarding whatever slower relays were still mid-delivery on
    // (see [_gatherEvents]'s doc comment). With several fallback relays in
    // play here, a fast-but-empty relay racing ahead of the one relay that
    // actually has this profile was silently starving real profile lookups
    // — this fetch is now hit far more (once per recipient shown, not just
    // once for the logged-in account at Settings) so that race lost far
    // more often in practice than it used to.
    final gathered = await _gatherEvents(
      request: NostrRequest(
        filters: [
          NostrFilter(authors: [publicKeyHex], kinds: const [0], limit: 1),
        ],
      ),
      relays: queryRelays,
      timeout: const Duration(seconds: 10),
    );
    // Attribution check before anything else: this name/avatar is what the
    // user will *recognise a person by* in the share flow, so a relay must
    // not be able to attach an arbitrary profile to this pubkey.
    final events = await _attributedEvents(gathered.events, {publicKeyHex});
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
    if (content.length > AppConstants.maxNoteEventContentChars) return null;

    try {
      final json = jsonDecode(content) as Map<String, dynamic>;
      return NostrProfile.fromMetadataJson(publicKeyHex, json);
    } catch (e) {
      developer.log('Could not parse profile metadata for $publicKeyHex: $e', name: 'NostrService');
      return null;
    }
  }

  /// Fetches [publicKeyHex]'s NIP-02 contact list — the pubkeys of every
  /// account they follow — from the most recent kind-3 event they've
  /// published. Used only to power the share sheet's local, client-side
  /// recipient autocomplete: matching against people already followed,
  /// never a network-wide name search (see [AppConstants.contactListEventKind]
  /// for why that distinction matters here). Empty on no event, malformed
  /// tags, or no relay response — this is a UX nicety, not load-bearing.
  Future<List<String>> fetchContactPubkeys({
    required String publicKeyHex,
    required List<Relay> relays,
  }) async {
    developer.log('NostrService.fetchContactPubkeys called for $publicKeyHex', name: 'NostrService');
    if (relays.isEmpty) return const [];

    final gathered = await _gatherEvents(
      request: NostrRequest(
        filters: [
          NostrFilter(authors: [publicKeyHex], kinds: const [AppConstants.contactListEventKind], limit: 1),
        ],
      ),
      relays: relays,
      timeout: const Duration(seconds: 10),
    );
    // A forged (unverified) kind-3 here would let a relay seed the share
    // autocomplete with pubkeys the user never followed — the exact
    // "trusted suggestions" surface this feature leans on. Only an event
    // provably signed by the user's own key counts as their follow list.
    final events = await _attributedEvents(gathered.events, {publicKeyHex});
    if (events.isEmpty) return const [];

    final epoch = DateTime.fromMillisecondsSinceEpoch(0);
    final latest = events.reduce(
      (a, b) => (a.createdAt ?? epoch).isAfter(b.createdAt ?? epoch) ? a : b,
    );

    final pubkeys = <String>{};
    for (final tag in latest.tags ?? const <List<String>>[]) {
      if (tag.length < 2 || tag[0] != 'p') continue;
      final hex = tag[1].toLowerCase();
      if (RegExp(r'^[0-9a-f]{64}$').hasMatch(hex)) pubkeys.add(hex);
    }
    return pubkeys.toList();
  }

  /// Batch-fetches public profiles (kind 0) for every pubkey in
  /// [publicKeyHexes] in as few subscriptions as possible — one relay
  /// round-trip for the whole contact list instead of one per contact.
  /// [AppConstants.contactProfileBatchSize]-sized chunks are OR'd together
  /// as separate filters on the same subscription (some relays cap how many
  /// values one filter's `authors` array may hold). Pubkeys with no
  /// reachable profile are simply absent from the result.
  Future<List<NostrProfile>> fetchProfilesBatch({
    required List<String> publicKeyHexes,
    required List<Relay> relays,
  }) async {
    developer.log('NostrService.fetchProfilesBatch called (${publicKeyHexes.length} pubkeys)', name: 'NostrService');
    if (publicKeyHexes.isEmpty || relays.isEmpty) return const [];

    final urls = {
      ...relays.map((r) => r.url),
      ...profileMetadataFallbackRelayUrls,
    };
    final queryRelays = urls.map((url) => Relay(url: url)).toList();

    final filters = <NostrFilter>[];
    for (var i = 0; i < publicKeyHexes.length; i += AppConstants.contactProfileBatchSize) {
      final chunk = publicKeyHexes.sublist(
        i,
        (i + AppConstants.contactProfileBatchSize).clamp(0, publicKeyHexes.length),
      );
      filters.add(NostrFilter(authors: chunk, kinds: const [0]));
    }

    final gathered = await _gatherEvents(
      request: NostrRequest(filters: filters),
      relays: queryRelays,
      timeout: const Duration(seconds: 15),
    );

    // Only verified events actually authored by a *requested* pubkey may
    // proceed: without the membership check, a relay could volunteer
    // validly-signed profiles of complete strangers and have them surface
    // as "contacts" in the share autocomplete.
    final trusted = await _attributedEvents(gathered.events, publicKeyHexes.toSet());

    // Relays may return more than one kind-0 per author (an older event
    // alongside its replacement) — keep only the most recent.
    final epoch = DateTime.fromMillisecondsSinceEpoch(0);
    final latestByAuthor = <String, NostrEvent>{};
    for (final event in trusted) {
      final existing = latestByAuthor[event.pubkey];
      if (existing == null || (event.createdAt ?? epoch).isAfter(existing.createdAt ?? epoch)) {
        latestByAuthor[event.pubkey] = event;
      }
    }

    final profiles = <NostrProfile>[];
    for (final entry in latestByAuthor.entries) {
      final content = entry.value.content;
      if (content == null || content.isEmpty) continue;
      if (content.length > AppConstants.maxNoteEventContentChars) continue;
      try {
        final json = jsonDecode(content) as Map<String, dynamic>;
        profiles.add(NostrProfile.fromMetadataJson(entry.key, json));
      } catch (e) {
        developer.log('Could not parse batch profile for ${entry.key}: $e', name: 'NostrService');
      }
    }
    return profiles;
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
    // Self-encrypted: recipient == author, so only the author can read it.
    final content = await _encryptFor(
      author: author,
      peerPubHex: author.publicKeyHex,
      plaintext: plaintext,
    );

    return signGenericEvent(
      kind: AppConstants.noteEventKind,
      tags: tags,
      content: content,
      createdAt: note.updatedAt,
      author: author,
    );
  }

  // -------------------------------------------------------------------
  // Note sharing with other users (see [NoteSharing])
  // -------------------------------------------------------------------

  /// Builds the owner's per-recipient copy of [note] for [recipientPubHex]:
  /// a parameterized-replaceable event under a deterministic per-recipient
  /// `d`-tag (so editing the note replaces that recipient's copy in place),
  /// with the note NIP-44-encrypted to the recipient. Uses [Note.toShareJson]
  /// so the recipient list never travels inside it.
  Future<NostrEvent> createSharedNoteEvent({
    required Note note,
    required User author,
    required String recipientPubHex,
  }) async {
    final content = await _encryptFor(
      author: author,
      peerPubHex: recipientPubHex,
      plaintext: jsonEncode(note.toShareJson()),
    );
    return signGenericEvent(
      kind: AppConstants.noteEventKind,
      tags: [
        ['d', NoteSharing.shareDTag(recipientPubHex: recipientPubHex, noteId: note.id)],
        ['p', recipientPubHex],
      ],
      content: content,
      createdAt: note.updatedAt,
      author: author,
    );
  }

  /// Builds a recipient's edit-proposal copy of [note] addressed back to its
  /// owner ([ownerPubHex]): same shape as a share event, but under the
  /// recipient's own edit `d`-tag and encrypted to the owner. The owner's
  /// client merges it on the next cycle (see `SyncService`).
  Future<NostrEvent> createEditProposalEvent({
    required Note note,
    required User author,
    required String ownerPubHex,
  }) async {
    final content = await _encryptFor(
      author: author,
      peerPubHex: ownerPubHex,
      plaintext: jsonEncode(note.toShareJson()),
    );
    return signGenericEvent(
      kind: AppConstants.noteEventKind,
      tags: [
        ['d', NoteSharing.editDTag(ownerPubHex: ownerPubHex, noteId: note.id)],
        ['p', ownerPubHex],
      ],
      content: content,
      createdAt: note.updatedAt,
      author: author,
    );
  }

  /// Builds the "I'm leaving this shared note" control event a recipient
  /// sends its owner on abandon, so the owner can drop them. Reuses the
  /// recipient's edit `d`-tag so it replaces any pending edit proposal for
  /// the same note rather than adding a separate event.
  Future<NostrEvent> createLeaveControlEvent({
    required String noteId,
    required User author,
    required String ownerPubHex,
  }) async {
    final content = await _encryptFor(
      author: author,
      peerPubHex: ownerPubHex,
      plaintext: jsonEncode({
        NoteSharing.controlTypeKey: NoteSharing.controlLeave,
        'id': noteId,
      }),
    );
    return signGenericEvent(
      kind: AppConstants.noteEventKind,
      tags: [
        ['d', NoteSharing.editDTag(ownerPubHex: ownerPubHex, noteId: noteId)],
        ['p', ownerPubHex],
      ],
      content: content,
      createdAt: DateTime.now(),
      author: author,
    );
  }

  /// Fetches every share/edit/control event addressed to [me] (events
  /// `p`-tagging my pubkey), verifies and decrypts each one, and returns
  /// them as [IncomingShare]s tagged with the *signed* sender pubkey. Events
  /// that fail verification, size limits, decryption or parsing are dropped
  /// (never throw the whole fetch). `complete` mirrors
  /// [fetchNotesFromRelay]'s all-relays-EOSE semantics.
  Future<({List<IncomingShare> items, bool complete})> fetchSharesAddressedTo({
    required User me,
    required List<Relay> relays,
    DateTime? since,
    Duration timeout = const Duration(seconds: 20),
  }) async {
    developer.log('NostrService.fetchSharesAddressedTo called', name: 'NostrService');
    if (relays.isEmpty) return (items: const <IncomingShare>[], complete: true);

    final gathered = await _gatherEvents(
      request: NostrRequest(
        filters: [
          NostrFilter(
            kinds: const [AppConstants.noteEventKind],
            since: since,
            p: [me.publicKeyHex],
          ),
        ],
      ),
      relays: relays,
      timeout: timeout,
    );

    final items = <IncomingShare>[];
    for (final event in gathered.events) {
      final item = await _decryptSharedEvent(event, me);
      if (item != null) items.add(item);
    }
    return (items: items, complete: gathered.complete);
  }

  /// Publishes a NIP-09 deletion for the copy shared with [recipientPubHex]
  /// of note [noteId] — targeted by parameterized-replaceable coordinate
  /// (`a` tag), which is all we need since the `d`-tag is deterministic.
  /// Used when the owner stops sharing with that recipient.
  Future<void> deleteSharedNoteEvent({
    required String noteId,
    required String recipientPubHex,
    required User author,
    required List<Relay> relays,
  }) async {
    developer.log('NostrService.deleteSharedNoteEvent called', name: 'NostrService');
    final dTag = NoteSharing.shareDTag(recipientPubHex: recipientPubHex, noteId: noteId);
    final deletionEvent = await signGenericEvent(
      kind: AppConstants.deletionEventKind,
      tags: [
        ['a', '${AppConstants.noteEventKind}:${author.publicKeyHex}:$dTag'],
      ],
      content: '',
      author: author,
    );
    await publishNote(deletionEvent, relays);
  }

  /// Verifies, decrypts and parses one event addressed to [me] into an
  /// [IncomingShare], or null if it isn't a usable share (bad signature,
  /// oversized, undecryptable — i.e. not actually encrypted to me — or
  /// malformed). The sender is taken from the *signed* event author, never
  /// from the payload, so it can't be spoofed.
  Future<IncomingShare?> _decryptSharedEvent(NostrEvent event, User me) async {
    final content = event.content;
    final senderPubHex = event.pubkey;
    if (content == null || content.isEmpty) return null;
    if (content.length > AppConstants.maxNoteEventContentChars) return null;
    // A relay could put anyone's pubkey on an event; only a verified
    // signature makes `senderPubHex` trustworthy, and trust in the sender
    // is exactly what the authorization rules downstream hinge on.
    if (!_isVerifiedEvent(event)) return null;
    // Never treat our own echoed-back events as an inbound share.
    if (senderPubHex == me.publicKeyHex) return null;

    try {
      final plaintext = await _decryptFrom(author: me, peerPubHex: senderPubHex, ciphertext: content);
      final json = jsonDecode(plaintext) as Map<String, dynamic>;

      final createdAt = event.createdAt ?? DateTime.now();
      final control = json[NoteSharing.controlTypeKey];
      if (control is String) {
        final noteId = json['id'];
        if (noteId is! String || noteId.isEmpty) return null;
        return IncomingShare.control(
          sender: senderPubHex,
          createdAt: createdAt,
          type: control,
          noteId: noteId,
        );
      }

      final parsed = Note.fromJson(json);
      // Sanitize the sender's attachments: a received attachment must only
      // ever be fetched from its remote (https, hash-checked) url — never
      // from a `localPath` the sender chose, which could point at a file on
      // *this* device (a local-file-read vector). See [Attachment.withoutLocalPath].
      final note = parsed.copyWith(
        attachments: parsed.attachments.map((a) => a.withoutLocalPath()).toList(),
      );
      return IncomingShare.note(sender: senderPubHex, createdAt: createdAt, note: note);
    } catch (e) {
      developer.log('Could not decrypt/parse shared event ${event.id}: $e', name: 'NostrService');
      return null;
    }
  }

  /// NIP-44 encrypt [plaintext] from [author] to [peerPubHex] — local key or
  /// Amber intent depending on the login method. Shared by the self-note and
  /// all sharing paths.
  Future<String> _encryptFor({
    required User author,
    required String peerPubHex,
    required String plaintext,
  }) async {
    switch (author.loginMethod) {
      case LoginMethod.privateKey:
        final privateKeyHex = author.privateKeyHex;
        if (privateKeyHex == null) {
          throw StateError('Missing private key for a LoginMethod.privateKey session.');
        }
        return CryptoUtils.encryptNip44(
          plaintext: plaintext,
          privateKeyHex: privateKeyHex,
          recipientPublicKeyHex: peerPubHex,
        );
      case LoginMethod.amber:
        final result = await _awaitAmber(_amber.nip44Encrypt(
          plaintext: plaintext,
          currentUser: author.npub,
          pubKey: peerPubHex,
        ));
        final encrypted = (result['signature'] as String?) ?? '';
        if (encrypted.isEmpty) {
          throw StateError('Amber returned no encrypted content.');
        }
        return encrypted;
      case LoginMethod.bunker:
        return _requireBunkerClient().nip44Encrypt(peerPubkey: peerPubHex, plaintext: plaintext);
    }
  }

  /// NIP-44 decrypt [ciphertext] sent by [peerPubHex] for [author] — local
  /// key or Amber intent depending on the login method.
  Future<String> _decryptFrom({
    required User author,
    required String peerPubHex,
    required String ciphertext,
  }) async {
    switch (author.loginMethod) {
      case LoginMethod.privateKey:
        final privateKeyHex = author.privateKeyHex;
        if (privateKeyHex == null) {
          throw StateError('Missing private key for a LoginMethod.privateKey session.');
        }
        return CryptoUtils.decryptNip44(
          ciphertext: ciphertext,
          privateKeyHex: privateKeyHex,
          senderPublicKeyHex: peerPubHex,
        );
      case LoginMethod.amber:
        final result = await _awaitAmber(_amber.nip44Decrypt(
          ciphertext: ciphertext,
          currentUser: author.npub,
          pubKey: peerPubHex,
        ));
        final decrypted = result['signature'] as String?;
        if (decrypted == null) {
          throw StateError('Amber returned no decrypted content.');
        }
        return decrypted;
      case LoginMethod.bunker:
        return _requireBunkerClient().nip44Decrypt(peerPubkey: peerPubHex, ciphertext: ciphertext);
    }
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

      case LoginMethod.bunker:
        final unsignedEvent = {
          'pubkey': author.publicKeyHex,
          'created_at': effectiveCreatedAt.millisecondsSinceEpoch ~/ 1000,
          'kind': kind,
          'tags': tags,
          'content': content,
        };
        // The client verifies the returned event is validly signed by the
        // account's own key before handing it back, so a relay can't slip in
        // a differently-keyed event here.
        final signedJson = await _requireBunkerClient()
            .signEvent(unsignedEvent, expectedPubkey: author.publicKeyHex);
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

    final gathered = await _gatherEvents(
      request: NostrRequest(
        filters: [
          NostrFilter(
            authors: [author.publicKeyHex],
            kinds: const [AppConstants.noteEventKind],
            since: since,
          ),
        ],
      ),
      relays: relays,
      timeout: timeout,
    );

    final notes = <Note>[];
    for (final event in gathered.events) {
      final note = await _decryptNoteEvent(event, author);
      if (note != null) notes.add(note);
    }
    return (notes: notes, complete: gathered.complete);
  }

  /// Subscribes with [request] across every relay in [relays], gathering
  /// events until *every* relay has sent its EOSE ("end of stored events")
  /// or [timeout] elapses — whichever comes first. `complete` is false when
  /// the timeout won the race, i.e. at least one relay never finished (see
  /// [fetchNotesFromRelay] for why that distinction matters for the sync
  /// bookmark). Shared by every fetch path so none of them re-implements
  /// the all-relays-EOSE handling.
  Future<({List<NostrEvent> events, bool complete})> _gatherEvents({
    required NostrRequest request,
    required List<Relay> relays,
    required Duration timeout,
  }) async {
    if (relays.isEmpty) return (events: const <NostrEvent>[], complete: true);
    await connectToRelays(relays);

    final pendingRelays = relays.map((r) => r.url).toSet();
    final rawEvents = <NostrEvent>[];
    final allEoseCompleter = Completer<void>();

    final subscription = _nostr.relays.startEventsSubscription(
      request: request,
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
        '_gatherEvents: timed out waiting for EOSE from: $pendingRelays '
        '(often means those relays are unreachable from this network) — '
        'returning ${rawEvents.length} event(s) from the relays that did respond',
        name: 'NostrService',
      );
    }
    return (events: rawEvents, complete: pendingRelays.isEmpty);
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
    // Notes owned by me publish to my own coordinate — but only once the
    // user has explicitly synced them at least once (`nostrEventId != null`),
    // so a purely-local note never leaks onto relays on a background cycle.
    // Notes *shared with me* (someone else owns them) never get a self copy;
    // my only outbound event for them is an edit proposal to their owner, so
    // they publish regardless of `nostrEventId`.
    final unsyncedNotes = localNotes
        .where((n) => !n.synced && (n.ownerPubkey == null ? n.nostrEventId != null : true))
        .toList();
    final syncedNotes = <Note>[];
    for (final note in unsyncedNotes) {
      try {
        if (note.ownerPubkey == null) {
          // I own it: publish the self-encrypted canonical copy (for my own
          // devices), plus one NIP-44 copy per recipient I share it with.
          final event = await createNoteEvent(note, author);
          final eventId = await publishNote(event, relays);
          for (final recipient in note.sharedWith) {
            final shareEvent =
                await createSharedNoteEvent(note: note, author: author, recipientPubHex: recipient);
            await publishNote(shareEvent, relays);
          }
          syncedNotes.add(note.copyWith(synced: true, nostrEventId: eventId));
        } else {
          // Shared with me: publish an edit proposal back to the owner, who
          // merges it and re-publishes to everyone (implicit acceptance).
          final editEvent =
              await createEditProposalEvent(note: note, author: author, ownerPubHex: note.ownerPubkey!);
          await publishNote(editEvent, relays);
          syncedNotes.add(note.copyWith(synced: true));
        }
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
      final plaintext = await _decryptFrom(
        author: author,
        peerPubHex: author.publicKeyHex,
        ciphertext: content,
      );
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
  /// simply not verified. Static (no instance state) so it can also run on
  /// the background isolate spawned by [_attributedEvents].
  static bool _isVerifiedEvent(NostrEvent event) {
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

  /// Static (no instance state) so it can also run on the background
  /// isolate spawned by [_attributedEvents].
  static NostrEvent _nostrEventFromMap(Map<String, dynamic> map) {
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
