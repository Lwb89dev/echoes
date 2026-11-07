import 'dart:convert';
import 'dart:io';

import 'package:dart_nostr/dart_nostr.dart';
import 'package:echoes/services/nip46_client.dart';
import 'package:echoes/utils/constants.dart';
import 'package:echoes/utils/crypto.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/loopback_relay.dart';

/// A NIP-46 signer on the other side of a real websocket. It is not a mock
/// of [Nip46Client]: it speaks kind 24133 and NIP-44 with its own keys.
class _RemoteSigner {
  _RemoteSigner({required this.relayUrl, required this.transport, required this.user});

  final String relayUrl;
  final NostrKeyPairs transport;
  final NostrKeyPairs user;
  WebSocket? _socket;
  var revoked = false;

  Future<void> start() async {
    _socket = await WebSocket.connect(relayUrl);
    _socket!.add(
      jsonEncode([
        'REQ',
        'signer',
        {
          'kinds': [24133],
          '#p': [transport.public],
        },
      ]),
    );
    _socket!.listen(_onFrame);
  }

  Future<void> announce({required String secret, required String clientPub}) async {
    final payload = jsonEncode({'id': 'connect-${user.public.substring(0, 8)}', 'result': secret});
    await _publish(plaintext: payload, recipient: clientPub, signer: transport);
  }

  Future<void> close() async {
    await _socket?.close();
  }

  void _onFrame(Object? data) {
    final text = data is String ? data : null;
    if (text == null) return;
    final decoded = jsonDecode(text);
    if (decoded is! List || decoded.isEmpty || decoded.first != 'EVENT') return;
    final event = decoded[2];
    if (event is! Map) return;
    final author = event['pubkey'];
    final content = event['content'];
    if (author is! String || content is! String || author == transport.public) return;
    final String plaintext;
    try {
      plaintext = CryptoUtils.decryptNip44(
        ciphertext: content,
        privateKeyHex: transport.private,
        senderPublicKeyHex: author,
      );
    } catch (_) {
      return;
    }
    final request = jsonDecode(plaintext);
    if (request is! Map) return;
    final id = request['id'];
    final method = request['method'];
    if (id is! String || method is! String) return;
    final params = request['params'];
    final args = params is List ? params.map((item) => item.toString()).toList() : <String>[];
    _answer(id: id, method: method, params: args, clientPub: author);
  }

  Future<void> _answer({
    required String id,
    required String method,
    required List<String> params,
    required String clientPub,
  }) async {
    if (revoked && method != 'connect') {
      await _reply(id: id, clientPub: clientPub, error: 'rejected');
      return;
    }
    if (method == 'connect') {
      await _reply(id: id, clientPub: clientPub, result: 'ack');
      return;
    }
    if (method == 'get_public_key') {
      await _reply(id: id, clientPub: clientPub, result: user.public);
      return;
    }
    if (method == 'ping') {
      await _reply(id: id, clientPub: clientPub, result: 'pong');
      return;
    }
    if (method == 'logout') {
      revoked = true;
      await _reply(id: id, clientPub: clientPub, result: 'ack');
      return;
    }
    if (method == 'switch_relays') {
      await _reply(id: id, clientPub: clientPub, result: 'null');
      return;
    }
    if (method == 'sign_event') {
      await _reply(id: id, clientPub: clientPub, result: _sign(params.single));
      return;
    }
    if (method == 'nip44_encrypt') {
      await _reply(
        id: id,
        clientPub: clientPub,
        result: CryptoUtils.encryptNip44(
          plaintext: params[1],
          privateKeyHex: user.private,
          recipientPublicKeyHex: params[0],
        ),
      );
      return;
    }
    if (method == 'nip44_decrypt') {
      await _reply(
        id: id,
        clientPub: clientPub,
        result: CryptoUtils.decryptNip44(
          ciphertext: params[1],
          privateKeyHex: user.private,
          senderPublicKeyHex: params[0],
        ),
      );
      return;
    }
    await _reply(id: id, clientPub: clientPub, error: 'unknown method');
  }

  String _sign(String unsignedJson) {
    final unsigned = jsonDecode(unsignedJson) as Map<String, dynamic>;
    final tags = (unsigned['tags'] as List<dynamic>)
        .map((tag) => (tag as List<dynamic>).map((part) => part.toString()).toList())
        .toList();
    final event = NostrEvent.fromPartialData(
      kind: unsigned['kind'] as int,
      content: unsigned['content'] as String? ?? '',
      tags: tags,
      keyPairs: user,
      createdAt: DateTime.fromMillisecondsSinceEpoch((unsigned['created_at'] as int) * 1000),
    );
    return jsonEncode(event.toMap());
  }

  Future<void> _reply({
    required String id,
    required String clientPub,
    String? result,
    String? error,
  }) async {
    final payload = jsonEncode({'id': id, 'result': result ?? '', 'error': ?error});
    await _publish(plaintext: payload, recipient: clientPub, signer: transport);
  }

  Future<void> _publish({
    required String plaintext,
    required String recipient,
    required NostrKeyPairs signer,
  }) async {
    final content = CryptoUtils.encryptNip44(
      plaintext: plaintext,
      privateKeyHex: signer.private,
      recipientPublicKeyHex: recipient,
    );
    final event = NostrEvent.fromPartialData(
      kind: 24133,
      content: content,
      keyPairs: signer,
      tags: [
        ['p', recipient],
      ],
    );
    _socket?.add(event.serialized());
  }
}

void main() {
  final keys = Nostr.instance.keys;

  test('nostrconnect URI carries the secret, relays and minimal permissions', () {
    final offer = Nip46ConnectOffer.generate(relays: const ['wss://relay.example']);
    final uri = Uri.parse(offer.uri);
    expect(uri.scheme, 'nostrconnect');
    expect(uri.host, offer.clientPublicKeyHex);
    expect(uri.queryParameters['secret'], offer.secret);
    expect(uri.queryParametersAll['relay'], ['wss://relay.example']);
    expect(uri.queryParameters['perms'], contains('sign_event:${AppConstants.noteEventKind}'));
    expect(uri.queryParameters['perms'], contains('nip44_encrypt'));
    expect(uri.queryParameters['perms'], contains('nip44_decrypt'));
    expect(offer.toString(), isNot(contains(offer.secret)));
    expect(offer.toString(), isNot(contains(offer.clientPrivateKeyHex)));
    expect(nip46SecretsMatch(offer.secret, offer.secret), isTrue);
    expect(nip46SecretsMatch('nope', offer.secret), isFalse);
  });

  test('a wrong nostrconnect secret never pins the signer', () async {
    final relay = await LoopbackRelay.start();
    final transport = keys.generateKeyPair();
    final user = keys.generateKeyPair();
    final signer = _RemoteSigner(relayUrl: relay.url, transport: transport, user: user);
    final offer = Nip46ConnectOffer.generate(relays: [relay.url]);
    final client = Nip46Client.discover(
      clientPrivateKeyHex: offer.clientPrivateKeyHex,
      relays: offer.relays,
      secret: offer.secret,
    );
    try {
      await signer.start();
      final waiting = client.waitForSigner(timeout: const Duration(seconds: 1));
      await signer.announce(secret: 'wrong-secret', clientPub: offer.clientPublicKeyHex);
      await expectLater(waiting, throwsA(isA<Nip46Exception>()));
    } finally {
      await client.dispose();
      await signer.close();
      await relay.close();
    }
  });

  test('nostrconnect login, kind 30078 NIP-44, reconnect and revoke', () async {
    final relay = await LoopbackRelay.start();
    final transport = keys.generateKeyPair();
    final user = keys.generateKeyPair();
    expect(transport.public, isNot(user.public));
    final signer = _RemoteSigner(relayUrl: relay.url, transport: transport, user: user);
    final offer = Nip46ConnectOffer.generate(relays: [relay.url]);
    final client = Nip46Client.discover(
      clientPrivateKeyHex: offer.clientPrivateKeyHex,
      relays: offer.relays,
      secret: offer.secret,
    );
    try {
      await signer.start();
      final waiting = client.waitForSigner(timeout: const Duration(seconds: 8));
      await signer.announce(secret: offer.secret, clientPub: offer.clientPublicKeyHex);
      await waiting;
      expect(client.session.remoteSignerPubHex, transport.public);

      final userPub = (await client.getPublicKey()).toLowerCase();
      expect(userPub, user.public);
      await client.trySwitchRelays();

      final note = jsonEncode({
        'id': 'note-1',
        'kind': AppConstants.noteEventKind,
        'body': 'offline-first',
      });
      final cipher = await client.nip44Encrypt(peerPubkey: userPub, plaintext: note);
      expect(cipher, isNot(contains('offline-first')));
      expect(await client.nip44Decrypt(peerPubkey: userPub, ciphertext: cipher), note);

      final signedJson = await client.signEvent({
        'pubkey': userPub,
        'created_at': 1_700_000_000,
        'kind': AppConstants.noteEventKind,
        'tags': [
          ['d', 'note-1'],
        ],
        'content': cipher,
      }, expectedPubkey: userPub);
      final signed = jsonDecode(signedJson) as Map<String, dynamic>;
      expect(signed['kind'], AppConstants.noteEventKind);
      expect(signed['pubkey'], userPub);
      expect(signed['content'], cipher);

      final stored = client.session.copyWith(userPubHex: userPub).withoutSecret();
      expect(jsonEncode(stored.toJson()), isNot(contains(offer.secret)));
      expect(stored.secret, isNull);
      expect(stored.clientPrivateKeyHex, isNot(user.private));

      await client.dispose();
      final restored = Nip46Client(session: stored);
      await restored.start();
      expect((await restored.getPublicKey()).toLowerCase(), userPub);
      await restored.logout();

      final afterRevoke = Nip46Client(session: stored);
      await afterRevoke.start();
      await expectLater(afterRevoke.getPublicKey(), throwsA(isA<Nip46Exception>()));
      await afterRevoke.dispose();
    } finally {
      await signer.close();
      await relay.close();
    }
  });
}
