import 'dart:convert';

import 'package:echoes/services/credential_store.dart';
import 'package:echoes/services/local_storage_service.dart';
import 'package:echoes/services/nip46_client.dart';
import 'package:echoes/services/note_encryption_service.dart';
import 'package:echoes/utils/constants.dart';
import 'package:flutter_test/flutter_test.dart';

class _MemoryCredentials implements CredentialStore {
  final values = <String, String>{};

  @override
  Future<void> delete({required String key}) async {
    values.remove(key);
  }

  @override
  Future<String?> read({required String key}) async => values[key];

  @override
  Future<void> write({required String key, required String value}) async {
    values[key] = value;
  }
}

class _RefusingCredentials implements CredentialStore {
  @override
  Future<void> delete({required String key}) async {
    throw const SecretStorageException(SecretStorageFailure.unavailable);
  }

  @override
  Future<String?> read({required String key}) async {
    throw const SecretStorageException(SecretStorageFailure.unavailable);
  }

  @override
  Future<void> write({required String key, required String value}) async {
    throw const SecretStorageException(SecretStorageFailure.unavailable);
  }
}

void main() {
  test('a refused keyring does not store the private key anywhere else', () async {
    final service = LocalStorageService(
      noteEncryptionService: NoteEncryptionService(),
      credentials: _RefusingCredentials(),
    );
    const secret = '00112233445566778899aabbccddeeff00112233445566778899aabbccddeeff';
    await expectLater(service.savePrivateKey(secret), throwsA(isA<SecretStorageException>()));
    expect(secret, isNot(contains('nsec')));
  });

  test('bunker session persistence drops the association secret', () async {
    final credentials = _MemoryCredentials();
    final service = LocalStorageService(
      noteEncryptionService: NoteEncryptionService(),
      credentials: credentials,
    );
    const secret = 'association-secret-must-not-be-stored';
    final session = Nip46Session(
      clientPrivateKeyHex: 'ab' * 32,
      remoteSignerPubHex: 'cd' * 32,
      relays: const ['wss://relay.example'],
      userPubHex: 'ef' * 32,
      secret: secret,
    );

    await service.saveBunkerSession(session);
    final raw = credentials.values[AppConstants.secureStorageBunkerSessionKey];
    expect(raw, isNotNull);
    expect(raw, isNot(contains(secret)));
    final stored = Nip46Session.fromJson(jsonDecode(raw!) as Map<String, dynamic>);
    expect(stored.secret, isNull);
    expect(stored.clientPrivateKeyHex, session.clientPrivateKeyHex);

    await service.clearBunkerSession();
    expect(credentials.values.containsKey(AppConstants.secureStorageBunkerSessionKey), isFalse);
  });
}
