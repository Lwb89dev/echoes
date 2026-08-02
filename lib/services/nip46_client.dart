import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:math';

import 'package:dart_nostr/dart_nostr.dart';

import '../utils/crypto.dart';
import '../utils/network_url.dart';

/// A NIP-46 ("Nostr Connect" / remote signing) client — the desktop- and
/// mobile-friendly alternative to holding an nsec or to Amber's Android-only
/// NIP-55 intents. The user's private key stays inside a **remote signer**
/// (a bunker: Amber acting as one, nsec.app, nsecbunker, …); Echoes never
/// sees it. Every signing / NIP-44 encrypt / NIP-44 decrypt request is sent
/// to the signer as a kind-24133 event, itself NIP-44 encrypted between an
/// **ephemeral, connection-only client key** and the signer's key, and
/// carried over the relay(s) named in the connection token.
///
/// Security model (the whole point of this class):
///  * The signer's pubkey is pinned from the `bunker://` token the user
///    pasted. Every inbound response MUST be (a) authored by exactly that
///    pubkey, (b) a valid signature over its own id, (c) addressed to our
///    ephemeral client key, and (d) NIP-44-decryptable with our client key.
///    A relay (or anyone else) can drop events onto the transport, but can
///    forge none of these — so it can neither impersonate the signer nor
///    read the traffic.
///  * Responses are matched to requests by a random id; an unmatched or
///    duplicate id is ignored, so a stale/replayed response can't resolve a
///    later request.
///  * The client private key authorises nothing on its own — it's only the
///    transport identity to the bunker, which still gates every operation.
///    It is nonetheless treated as a secret (stored only in secure storage
///    by the caller, never logged).
///  * Nothing sensitive is ever logged: not the client key, not the connect
///    secret, not any decrypted payload.
class Nip46Client {
  Nip46Client({required this.session, this.onAuthChallenge})
    : _clientKeyPairs = Nostr.instance.keys.generateKeyPairFromExistingPrivateKey(
        session.clientPrivateKeyHex,
      );

  final Nip46Session session;

  /// Invoked when the signer asks the user to approve the connection out of
  /// band (it returns an `auth_url` instead of an immediate result). The UI
  /// should open the URL; the real result then arrives on the same request
  /// id, so the pending call keeps waiting rather than failing.
  final void Function(String authUrl)? onAuthChallenge;

  final NostrKeyPairs _clientKeyPairs;

  /// A DEDICATED Nostr instance, not the app-wide `Nostr.instance`, so the
  /// bunker relay lives in its own pool. Sharing the singleton would add the
  /// bunker relay to the pool that `NostrService.publishNote` broadcasts
  /// notes to — silently sending the user's (encrypted, but still) note
  /// events to a relay they only added to reach their signer. Isolating the
  /// transport keeps signer traffic and note traffic on separate sockets.
  ///
  /// This must also be per-client, not static: during account replacement the
  /// old client is disposed after the new one connects. A shared transport
  /// would let the old client's `freeAllResources()` tear down the new
  /// session's sockets.
  final Nostr _nostr = Nostr();
  final _pending = <String, Completer<String>>{};
  final _authNotified = <String>{};
  NostrEventsStream? _subscription;
  StreamSubscription<NostrEvent>? _streamSub;

  static final Random _secureRandom = Random.secure();

  /// How long to wait for the signer to answer. Generous because the signer
  /// may prompt the user (approve on the phone, unlock a bunker, …).
  static const _requestTimeout = Duration(seconds: 60);

  String get clientPublicKeyHex => _clientKeyPairs.public;

  /// Opens the transport: connects the bunker relay(s) and starts listening
  /// for responses addressed to our ephemeral client key. Idempotent.
  Future<void> start() async {
    if (_subscription != null) return;
    developer.log('Nip46Client.start', name: 'Nip46Client');
    await _nostr.relays.init(relaysUrl: session.relays, retryOnError: true, retryOnClose: true);
    final sub = _nostr.relays.startEventsSubscription(
      request: NostrRequest(
        filters: [
          NostrFilter(
            kinds: const [24133],
            authors: [session.remoteSignerPubHex],
            p: [clientPublicKeyHex],
          ),
        ],
      ),
    );
    _subscription = sub;
    _streamSub = sub.stream.listen(_onEvent);
  }

  /// Sends the `connect` handshake and resolves the account's real pubkey via
  /// `get_public_key`, returning it. Throws on timeout or signer error.
  Future<String> connectAndGetPubkey() async {
    await start();
    final params = <String>[
      session.remoteSignerPubHex,
      if (session.secret != null) session.secret!,
    ];
    await _request('connect', params);
    return getPublicKey();
  }

  Future<String> getPublicKey() => _request('get_public_key', const []);

  /// Asks the signer to sign [unsignedEvent] (a NIP-01 event map without
  /// `id`/`sig`) and returns the signed event JSON. The returned event is
  /// verified to be validly signed by [expectedPubkey] before it's trusted —
  /// so a compromised relay can't slip back a differently-keyed event.
  Future<String> signEvent(
    Map<String, dynamic> unsignedEvent, {
    required String expectedPubkey,
  }) async {
    final signedJson = await _request('sign_event', [jsonEncode(unsignedEvent)]);
    final map = jsonDecode(signedJson) as Map<String, dynamic>;
    final event = _eventFromMap(map);
    if (event.pubkey != expectedPubkey || !_isVerified(event)) {
      throw const Nip46Exception(
        'Signer returned an event with an invalid or unexpected signature.',
      );
    }
    return signedJson;
  }

  Future<String> nip44Encrypt({required String peerPubkey, required String plaintext}) =>
      _request('nip44_encrypt', [peerPubkey, plaintext]);

  Future<String> nip44Decrypt({required String peerPubkey, required String ciphertext}) =>
      _request('nip44_decrypt', [peerPubkey, ciphertext]);

  Future<void> dispose() async {
    await _streamSub?.cancel();
    _subscription?.close();
    _streamSub = null;
    _subscription = null;
    for (final completer in _pending.values) {
      if (!completer.isCompleted) {
        completer.completeError(const Nip46Exception('Client disposed.'));
      }
    }
    _pending.clear();
    // Close the dedicated transport's sockets so logout doesn't leave a live
    // connection to the signer relay hanging around. A later login re-inits.
    try {
      await _nostr.relays.freeAllResources();
    } catch (_) {
      // Best-effort teardown.
    }
  }

  // -------------------------------------------------------------------

  /// Encrypts a `{id, method, params}` request to the signer, publishes it as
  /// a kind-24133 event signed by the ephemeral client key, and awaits the
  /// matching response. The request id ties the response back to this call.
  Future<String> _request(String method, List<String> params) async {
    await start();
    final id = _randomId();
    final payload = jsonEncode({'id': id, 'method': method, 'params': params});
    final content = CryptoUtils.encryptNip44(
      plaintext: payload,
      privateKeyHex: session.clientPrivateKeyHex,
      recipientPublicKeyHex: session.remoteSignerPubHex,
    );
    final event = NostrEvent.fromPartialData(
      kind: 24133,
      content: content,
      keyPairs: _clientKeyPairs,
      tags: [
        ['p', session.remoteSignerPubHex],
      ],
    );

    final completer = Completer<String>();
    _pending[id] = completer;
    try {
      await _nostr.relays.sendEventToRelaysAsync(event, timeout: const Duration(seconds: 10));
    } catch (e) {
      _pending.remove(id);
      throw Nip46Exception('Could not reach the signer relay: $e');
    }
    try {
      return await completer.future.timeout(
        _requestTimeout,
        onTimeout: () => throw const Nip46Exception('The signer did not respond in time.'),
      );
    } finally {
      _pending.remove(id);
      _authNotified.remove(id);
    }
  }

  /// Validates and dispatches one inbound event. Every check here is a
  /// security boundary — see the class doc. A failed check drops the event
  /// silently: it is not a response we can trust, so it is not a response.
  void _onEvent(NostrEvent event) {
    if (event.pubkey != session.remoteSignerPubHex) return;
    if (!_pTaggedToClient(event)) return;
    if (!_isVerified(event)) return;
    final content = event.content;
    if (content == null || content.isEmpty) return;

    final String plaintext;
    try {
      plaintext = CryptoUtils.decryptNip44(
        ciphertext: content,
        privateKeyHex: session.clientPrivateKeyHex,
        senderPublicKeyHex: session.remoteSignerPubHex,
      );
    } catch (_) {
      return; // Not actually encrypted to us — ignore.
    }

    final response = parseResponse(plaintext);
    if (response == null) return;
    final completer = _pending[response.id];
    if (completer == null) return; // Unknown or already-served id.

    // An auth challenge is not the final answer: surface the URL once and
    // keep the request pending for the real result on the same id.
    if (response.authUrl != null &&
        (response.result == null || response.result!.isEmpty) &&
        response.error == null) {
      if (_authNotified.add(response.id)) {
        onAuthChallenge?.call(response.authUrl!);
      }
      return;
    }

    _pending.remove(response.id);
    if (response.error != null && response.error!.isNotEmpty) {
      completer.completeError(Nip46Exception(response.error!));
    } else {
      completer.complete(response.result ?? '');
    }
  }

  bool _pTaggedToClient(NostrEvent event) {
    for (final tag in event.tags ?? const <List<String>>[]) {
      if (tag.length >= 2 && tag[0] == 'p' && tag[1] == clientPublicKeyHex) {
        return true;
      }
    }
    return false;
  }

  /// True when [event]'s id is the canonical hash of its fields and its sig
  /// verifies against its pubkey — same envelope check the note fetch path
  /// uses. Never throws.
  bool _isVerified(NostrEvent event) {
    try {
      final id = event.id;
      final kind = event.kind;
      final createdAt = event.createdAt;
      if (id == null || kind == null || createdAt == null) return false;
      final recomputed = NostrEvent.getEventId(
        kind: kind,
        content: event.content ?? '',
        createdAt: createdAt,
        tags: event.tags ?? const [],
        pubkey: event.pubkey,
      );
      if (recomputed != id) return false;
      return event.isVerified();
    } catch (_) {
      return false;
    }
  }

  NostrEvent _eventFromMap(Map<String, dynamic> map) {
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

  String _randomId() {
    final bytes = List<int>.generate(16, (_) => _secureRandom.nextInt(256));
    return bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  }

  /// Parses a decrypted NIP-46 response payload. Pure and null-safe so it can
  /// be unit-tested without any transport. Returns null for anything that
  /// isn't a well-formed response object.
  static Nip46Response? parseResponse(String plaintext) {
    try {
      final json = jsonDecode(plaintext);
      if (json is! Map<String, dynamic>) return null;
      final id = json['id'];
      if (id is! String || id.isEmpty) return null;
      return Nip46Response(
        id: id,
        result: json['result'] as String?,
        error: json['error'] as String?,
        authUrl: json['auth_url'] as String?,
      );
    } catch (_) {
      return null;
    }
  }
}

/// One parsed NIP-46 response frame.
class Nip46Response {
  const Nip46Response({required this.id, this.result, this.error, this.authUrl});
  final String id;
  final String? result;
  final String? error;
  final String? authUrl;
}

/// The persisted connection to a remote signer. Contains one secret — the
/// ephemeral client private key — so the whole object lives only in secure
/// storage (Keystore on Android, Secret Service on Linux), never in
/// SharedPreferences, a note, or a log.
class Nip46Session {
  const Nip46Session({
    required this.clientPrivateKeyHex,
    required this.remoteSignerPubHex,
    required this.relays,
    required this.userPubHex,
    this.secret,
  });

  final String clientPrivateKeyHex;
  final String remoteSignerPubHex;
  final List<String> relays;

  /// The account's real pubkey, learned via `get_public_key` at connect time.
  /// May differ from [remoteSignerPubHex] (a bunker can sign for an account
  /// under a separate connection key).
  final String userPubHex;

  /// Optional single-use connect secret from the `bunker://` token.
  final String? secret;

  Nip46Session copyWith({String? userPubHex}) => Nip46Session(
    clientPrivateKeyHex: clientPrivateKeyHex,
    remoteSignerPubHex: remoteSignerPubHex,
    relays: relays,
    userPubHex: userPubHex ?? this.userPubHex,
    secret: secret,
  );

  /// The connect secret is single-use bootstrap material. It has no purpose
  /// after the handshake and must not remain in the persisted session.
  Nip46Session withoutSecret() => Nip46Session(
    clientPrivateKeyHex: clientPrivateKeyHex,
    remoteSignerPubHex: remoteSignerPubHex,
    relays: relays,
    userPubHex: userPubHex,
  );

  Map<String, dynamic> toJson() => {
    'clientPrivateKeyHex': clientPrivateKeyHex,
    'remoteSignerPubHex': remoteSignerPubHex,
    'relays': relays,
    'userPubHex': userPubHex,
    'secret': secret,
  };

  factory Nip46Session.fromJson(Map<String, dynamic> json) => Nip46Session(
    clientPrivateKeyHex: json['clientPrivateKeyHex'] as String,
    remoteSignerPubHex: json['remoteSignerPubHex'] as String,
    relays: (json['relays'] as List<dynamic>).map((e) => e as String).toList(),
    userPubHex: json['userPubHex'] as String,
    secret: json['secret'] as String?,
  ).._validate();

  /// Parses a `bunker://<signer-pubkey-hex>?relay=<url>&relay=<url>&secret=<s>`
  /// token into a session with a freshly generated ephemeral client key.
  /// Throws [Nip46Exception] on anything malformed — a bad token must fail
  /// loudly at login, not connect to some half-parsed endpoint.
  factory Nip46Session.fromBunkerUri(String uri, {required String clientPrivateKeyHex}) {
    final trimmed = uri.trim();
    if (!trimmed.startsWith('bunker://')) {
      throw const Nip46Exception('Not a bunker:// connection token.');
    }
    final tokenBody = trimmed.substring('bunker://'.length);
    final queryStart = tokenBody.indexOf('?');
    final rawSigner = queryStart == -1 ? tokenBody : tokenBody.substring(0, queryStart);
    if (!RegExp(r'^[0-9a-fA-F]{64}$').hasMatch(rawSigner)) {
      throw const Nip46Exception('The bunker token has an invalid signer public key.');
    }
    // Reparse under a scheme Uri understands, so the host (signer pubkey) and
    // query are decoded by the standard parser rather than by hand.
    final parsed = Uri.parse('https://$tokenBody');
    final signer = parsed.host.toLowerCase();
    if (parsed.authority.toLowerCase() != signer ||
        parsed.userInfo.isNotEmpty ||
        parsed.hasPort ||
        (parsed.path.isNotEmpty && parsed.path != '/') ||
        parsed.fragment.isNotEmpty) {
      throw const Nip46Exception('The bunker token has an invalid authority or path.');
    }
    final relays = parsed.queryParametersAll['relay'] ?? const [];
    final relayUrls = <String>[];
    for (final relay in relays) {
      try {
        relayUrls.add(requireWebSocketUri(relay).toString());
      } on FormatException {
        // Ignore unrelated/malformed relay parameters as long as one valid
        // relay remains.
      }
    }
    if (relayUrls.isEmpty) {
      throw const Nip46Exception('The bunker token names no valid relay to reach the signer on.');
    }
    final session = Nip46Session(
      clientPrivateKeyHex: clientPrivateKeyHex,
      remoteSignerPubHex: signer,
      relays: relayUrls,
      userPubHex: '', // filled after connect
      secret: parsed.queryParameters['secret'],
    );
    session._validate(allowEmptyUserPubkey: true);
    return session;
  }

  void _validate({bool allowEmptyUserPubkey = false}) {
    final hex64 = RegExp(r'^[0-9a-fA-F]{64}$');
    if (!hex64.hasMatch(clientPrivateKeyHex) ||
        !hex64.hasMatch(remoteSignerPubHex) ||
        (!allowEmptyUserPubkey && !hex64.hasMatch(userPubHex))) {
      throw const Nip46Exception('The bunker session contains invalid key material.');
    }
    if (relays.isEmpty) {
      throw const Nip46Exception('The bunker session contains no relay.');
    }
    for (final relay in relays) {
      try {
        requireWebSocketUri(relay);
      } on FormatException {
        throw const Nip46Exception('The bunker session contains an invalid relay.');
      }
    }
  }
}

/// A NIP-46 transport/protocol failure (timeout, malformed token, signer
/// error, bad signature). Carries a human-readable message safe to surface —
/// it never contains key material.
class Nip46Exception implements Exception {
  const Nip46Exception(this.message);
  final String message;
  @override
  String toString() => 'Nip46Exception: $message';
}
