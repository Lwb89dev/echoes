import 'dart:convert';

import 'package:dart_nostr/dart_nostr.dart';
import 'package:echoes/services/nip46_client.dart';
import 'package:echoes/utils/crypto.dart';
import 'package:flutter_test/flutter_test.dart';

/// Offline coverage for the NIP-46 pieces that don't need a live bunker: the
/// bunker:// token parser, the response frame parser, and — most importantly
/// — the exact NIP-44 request/response envelope the client and a signer
/// exchange, exercised end-to-end between two real keypairs. Live interop
/// with an actual signer (Amber, nsec.app, …) still has to be tested on a
/// real device; this pins the wire format and the security-relevant parsing.
void main() {
  final keys = Nostr.instance.keys;

  group('Nip46Session.fromBunkerUri', () {
    test('parses signer pubkey, relays and secret', () {
      final signer = keys.generateKeyPair();
      final uri =
          'bunker://${signer.public}?relay=wss://relay.one&relay=wss://relay.two&secret=abc123';
      final session = Nip46Session.fromBunkerUri(
        uri,
        clientPrivateKeyHex: keys.generatePrivateKey(),
      );
      expect(session.remoteSignerPubHex, signer.public);
      expect(session.relays, ['wss://relay.one', 'wss://relay.two']);
      expect(session.secret, 'abc123');
    });

    test('rejects a non-bunker token', () {
      expect(
        () => Nip46Session.fromBunkerUri(
          'nostr://whatever',
          clientPrivateKeyHex: keys.generatePrivateKey(),
        ),
        throwsA(isA<Nip46Exception>()),
      );
    });

    test('rejects an invalid signer pubkey', () {
      expect(
        () => Nip46Session.fromBunkerUri(
          'bunker://not-hex?relay=wss://r',
          clientPrivateKeyHex: keys.generatePrivateKey(),
        ),
        throwsA(isA<Nip46Exception>()),
      );
    });

    test('rejects a token with no relay', () {
      final signer = keys.generateKeyPair();
      expect(
        () => Nip46Session.fromBunkerUri(
          'bunker://${signer.public}',
          clientPrivateKeyHex: keys.generatePrivateKey(),
        ),
        throwsA(isA<Nip46Exception>()),
      );
    });

    test('ignores a non-ws relay value', () {
      final signer = keys.generateKeyPair();
      final uri = 'bunker://${signer.public}?relay=https://evil.example&relay=wss://ok';
      final session = Nip46Session.fromBunkerUri(
        uri,
        clientPrivateKeyHex: keys.generatePrivateKey(),
      );
      expect(session.relays, ['wss://ok']);
    });

    test('accepts a plain ws:// relay (self-hosted bunker on a trusted LAN)', () {
      final signer = keys.generateKeyPair();
      final session = Nip46Session.fromBunkerUri(
        'bunker://${signer.public}?relay=ws://192.168.1.10:4869',
        clientPrivateKeyHex: keys.generatePrivateKey(),
      );
      expect(session.relays, ['ws://192.168.1.10:4869']);
    });

    test('rejects authority smuggling and unexpected paths', () {
      final signer = keys.generateKeyPair();
      for (final suffix in [
        '@${signer.public}?relay=wss://relay.example',
        '${signer.public}:443?relay=wss://relay.example',
        '${signer.public}/unexpected?relay=wss://relay.example',
      ]) {
        expect(
          () => Nip46Session.fromBunkerUri(
            'bunker://$suffix',
            clientPrivateKeyHex: keys.generatePrivateKey(),
          ),
          throwsA(isA<Nip46Exception>()),
        );
      }
    });

    test('rejects malformed persisted sessions', () {
      expect(
        () => Nip46Session.fromJson({
          'clientPrivateKeyHex': 'not-a-key',
          'remoteSignerPubHex': 'also-not-a-key',
          'relays': ['wss://relay.example'],
          'userPubHex': 'invalid',
        }),
        throwsA(isA<Nip46Exception>()),
      );
    });

    test('drops a single-use secret after the handshake', () {
      final signer = keys.generateKeyPair();
      final session = Nip46Session.fromBunkerUri(
        'bunker://${signer.public}?relay=wss://relay.example&secret=once',
        clientPrivateKeyHex: keys.generatePrivateKey(),
      ).copyWith(userPubHex: signer.public).withoutSecret();

      expect(session.secret, isNull);
      expect(session.toJson()['secret'], isNull);
    });
  });

  group('Nip46Client.parseResponse', () {
    test('parses a result frame', () {
      final r = Nip46Client.parseResponse('{"id":"a1","result":"ack"}')!;
      expect(r.id, 'a1');
      expect(r.result, 'ack');
      expect(r.error, isNull);
    });

    test('parses an error frame', () {
      final r = Nip46Client.parseResponse('{"id":"a1","result":"","error":"denied"}')!;
      expect(r.error, 'denied');
    });

    test('parses an auth_url challenge', () {
      final r = Nip46Client.parseResponse('{"id":"a1","result":"","auth_url":"https://x/y"}')!;
      expect(r.authUrl, 'https://x/y');
    });

    test('rejects malformed / idless frames', () {
      expect(Nip46Client.parseResponse('not json'), isNull);
      expect(Nip46Client.parseResponse('{"result":"ack"}'), isNull);
      expect(Nip46Client.parseResponse('[]'), isNull);
    });
  });

  group('NIP-44 request/response envelope (client <-> signer)', () {
    test('a request encrypted by the client decrypts on the signer, and its '
        'response decrypts back on the client', () {
      final client = keys.generateKeyPair();
      final signer = keys.generateKeyPair();

      // Client builds and encrypts a request to the signer.
      const requestPlain = '{"id":"req1","method":"get_public_key","params":[]}';
      final encryptedRequest = CryptoUtils.encryptNip44(
        plaintext: requestPlain,
        privateKeyHex: client.private,
        recipientPublicKeyHex: signer.public,
      );

      // Signer decrypts it with its own key + the client's pubkey.
      final decryptedOnSigner = CryptoUtils.decryptNip44(
        ciphertext: encryptedRequest,
        privateKeyHex: signer.private,
        senderPublicKeyHex: client.public,
      );
      expect(decryptedOnSigner, requestPlain);

      // Signer replies with the account pubkey, encrypted back to the client.
      final responsePlain = jsonEncode({'id': 'req1', 'result': signer.public});
      final encryptedResponse = CryptoUtils.encryptNip44(
        plaintext: responsePlain,
        privateKeyHex: signer.private,
        recipientPublicKeyHex: client.public,
      );

      // Client decrypts and parses it.
      final decryptedOnClient = CryptoUtils.decryptNip44(
        ciphertext: encryptedResponse,
        privateKeyHex: client.private,
        senderPublicKeyHex: signer.public,
      );
      final parsed = Nip46Client.parseResponse(decryptedOnClient)!;
      expect(parsed.id, 'req1');
      expect(parsed.result, signer.public);
    });

    test('a response encrypted to a DIFFERENT client key does not decrypt '
        '(relay cannot read or forge traffic for us)', () {
      final client = keys.generateKeyPair();
      final signer = keys.generateKeyPair();
      final attacker = keys.generateKeyPair();

      final response = jsonEncode({'id': 'x', 'result': 'ack'});
      // Signer (or anyone) encrypts to the attacker's key, not ours.
      final encrypted = CryptoUtils.encryptNip44(
        plaintext: response,
        privateKeyHex: signer.private,
        recipientPublicKeyHex: attacker.public,
      );
      expect(
        () => CryptoUtils.decryptNip44(
          ciphertext: encrypted,
          privateKeyHex: client.private,
          senderPublicKeyHex: signer.public,
        ),
        throwsA(anything),
      );
    });
  });
}
