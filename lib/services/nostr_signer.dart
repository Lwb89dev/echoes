import 'dart:convert';

import 'package:amberflutter/amberflutter.dart';
import 'package:dart_nostr/dart_nostr.dart';

import '../models/user.dart';
import '../utils/constants.dart';
import '../utils/crypto.dart';
import 'nip46_client.dart';

/// Signs and encrypts for the logged-in Nostr identity without the caller
/// knowing which backend holds the private key.
///
/// Local notes do not go through this type. It is only for operations that
/// need the identity key: publishing, deleting, and NIP-44 on relay
/// payloads. A remote signer that is offline fails the operation. Echoes
/// does not keep a copy of that identity key to ride through the outage.
abstract class NostrSigner {
  String get publicKeyHex;
  LoginMethod get loginMethod;

  Future<String> nip44Encrypt({required String peerPubkey, required String plaintext});

  Future<String> nip44Decrypt({required String peerPubkey, required String ciphertext});

  Future<NostrEvent> sign({
    required int kind,
    required List<List<String>> tags,
    required String content,
    DateTime? createdAt,
  });

  /// Picks the backend that matches [user]. [bunker] is required for
  /// [LoginMethod.bunker] and ignored otherwise. Amber is never constructed
  /// for a Linux session because the login method cannot be amber there.
  factory NostrSigner.forUser(User user, {required Nip46Client? bunker, Amberflutter? amber}) {
    switch (user.loginMethod) {
      case LoginMethod.privateKey:
        final privateKeyHex = user.privateKeyHex;
        if (privateKeyHex == null) {
          throw StateError('Missing private key for a local-key session.');
        }
        return LocalKeySigner(privateKeyHex: privateKeyHex, publicKeyHex: user.publicKeyHex);
      case LoginMethod.amber:
        return AmberSigner(amber: amber ?? Amberflutter(), user: user);
      case LoginMethod.bunker:
        final client = bunker;
        if (client == null) {
          throw const Nip46Exception('No active bunker connection — please sign in again.');
        }
        return Nip46Signer(client: client, publicKeyHex: user.publicKeyHex);
    }
  }
}

/// The nsec stays inside this object only as long as the [User] that was
/// passed in already held it. Nothing here writes the key to disk.
class LocalKeySigner implements NostrSigner {
  LocalKeySigner({required this.privateKeyHex, required this.publicKeyHex});

  final String privateKeyHex;

  @override
  final String publicKeyHex;

  @override
  LoginMethod get loginMethod => LoginMethod.privateKey;

  NostrKeyPairs get _keys =>
      Nostr.instance.keys.generateKeyPairFromExistingPrivateKey(privateKeyHex);

  @override
  Future<String> nip44Encrypt({required String peerPubkey, required String plaintext}) async {
    return CryptoUtils.encryptNip44(
      plaintext: plaintext,
      privateKeyHex: privateKeyHex,
      recipientPublicKeyHex: peerPubkey,
    );
  }

  @override
  Future<String> nip44Decrypt({required String peerPubkey, required String ciphertext}) async {
    return CryptoUtils.decryptNip44(
      ciphertext: ciphertext,
      privateKeyHex: privateKeyHex,
      senderPublicKeyHex: peerPubkey,
    );
  }

  @override
  Future<NostrEvent> sign({
    required int kind,
    required List<List<String>> tags,
    required String content,
    DateTime? createdAt,
  }) async {
    return NostrEvent.fromPartialData(
      kind: kind,
      content: content,
      keyPairs: _keys,
      tags: tags,
      createdAt: createdAt ?? DateTime.now(),
    );
  }
}

/// Android NIP-55. The identity key never enters the process; Amber signs
/// and encrypts in its own app. Constructing this on Linux is harmless only
/// because nothing calls it: the login screen does not offer Amber there.
class AmberSigner implements NostrSigner {
  AmberSigner({required Amberflutter amber, required User user}) : _amber = amber, _user = user;

  final Amberflutter _amber;
  final User _user;

  @override
  String get publicKeyHex => _user.publicKeyHex;

  @override
  LoginMethod get loginMethod => LoginMethod.amber;

  Future<T> _await<T>(Future<T> future) {
    return future.timeout(
      AppConstants.amberInteractionTimeout,
      onTimeout: () => throw StateError(
        'Amber did not respond in time. If you cancelled the request in Amber, please try again.',
      ),
    );
  }

  @override
  Future<String> nip44Encrypt({required String peerPubkey, required String plaintext}) async {
    final result = await _await(
      _amber.nip44Encrypt(plaintext: plaintext, currentUser: _user.npub, pubKey: peerPubkey),
    );
    final encrypted = (result['signature'] as String?) ?? '';
    if (encrypted.isEmpty) {
      throw StateError('Amber returned no encrypted content.');
    }
    return encrypted;
  }

  @override
  Future<String> nip44Decrypt({required String peerPubkey, required String ciphertext}) async {
    final result = await _await(
      _amber.nip44Decrypt(ciphertext: ciphertext, currentUser: _user.npub, pubKey: peerPubkey),
    );
    final decrypted = result['signature'] as String?;
    if (decrypted == null) {
      throw StateError('Amber returned no decrypted content.');
    }
    return decrypted;
  }

  @override
  Future<NostrEvent> sign({
    required int kind,
    required List<List<String>> tags,
    required String content,
    DateTime? createdAt,
  }) async {
    final unsignedEvent = {
      'pubkey': publicKeyHex,
      'created_at': (createdAt ?? DateTime.now()).millisecondsSinceEpoch ~/ 1000,
      'kind': kind,
      'tags': tags,
      'content': content,
    };
    final signResult = await _await(
      _amber.signEvent(currentUser: _user.npub, eventJson: jsonEncode(unsignedEvent)),
    );
    final signedJson = signResult['event'] as String?;
    if (signedJson == null) {
      throw StateError('Amber returned no signed event.');
    }
    return nostrEventFromMap(jsonDecode(signedJson) as Map<String, dynamic>);
  }
}

/// NIP-46 remote signer. Works on Android and on Linux. The user identity
/// key stays in the bunker; this process holds only the ephemeral transport
/// key inside [Nip46Client].
class Nip46Signer implements NostrSigner {
  Nip46Signer({required Nip46Client client, required this.publicKeyHex}) : _client = client;

  final Nip46Client _client;

  @override
  final String publicKeyHex;

  @override
  LoginMethod get loginMethod => LoginMethod.bunker;

  @override
  Future<String> nip44Encrypt({required String peerPubkey, required String plaintext}) {
    return _client.nip44Encrypt(peerPubkey: peerPubkey, plaintext: plaintext);
  }

  @override
  Future<String> nip44Decrypt({required String peerPubkey, required String ciphertext}) {
    return _client.nip44Decrypt(peerPubkey: peerPubkey, ciphertext: ciphertext);
  }

  @override
  Future<NostrEvent> sign({
    required int kind,
    required List<List<String>> tags,
    required String content,
    DateTime? createdAt,
  }) async {
    final unsignedEvent = {
      'pubkey': publicKeyHex,
      'created_at': (createdAt ?? DateTime.now()).millisecondsSinceEpoch ~/ 1000,
      'kind': kind,
      'tags': tags,
      'content': content,
    };
    final signedJson = await _client.signEvent(unsignedEvent, expectedPubkey: publicKeyHex);
    return nostrEventFromMap(jsonDecode(signedJson) as Map<String, dynamic>);
  }
}

NostrEvent nostrEventFromMap(Map<String, dynamic> map) {
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
