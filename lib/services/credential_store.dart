import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Why a credential write was refused. The UI maps this to a translated
/// sentence. The message never contains the secret that was being stored.
enum SecretStorageFailure { unavailable, rejected }

/// Thrown when the platform keyring cannot store a secret. Callers must not
/// catch this and write the same value to SharedPreferences, a file, or a log.
class SecretStorageException implements Exception {
  const SecretStorageException(this.failure);

  final SecretStorageFailure failure;

  @override
  String toString() => 'SecretStorageException(${failure.name})';
}

/// Keyring-backed storage for nsec material and NIP-46 transport keys.
///
/// There is no plaintext fallback. On Linux a missing Secret Service name
/// on the session bus fails the write before libsecret is asked.
abstract class CredentialStore {
  Future<void> write({required String key, required String value});

  Future<String?> read({required String key});

  Future<void> delete({required String key});
}

class SecureCredentialStore implements CredentialStore {
  SecureCredentialStore({FlutterSecureStorage? storage, Future<void> Function()? ensureAvailable})
    : _storage = storage ?? const FlutterSecureStorage(),
      _ensureAvailable = ensureAvailable ?? ensureLinuxSecretService;

  final FlutterSecureStorage _storage;
  final Future<void> Function() _ensureAvailable;

  @override
  Future<void> write({required String key, required String value}) async {
    await _ensureAvailable();
    try {
      await _storage.write(key: key, value: value);
    } on PlatformException {
      throw const SecretStorageException(SecretStorageFailure.rejected);
    }
  }

  @override
  Future<String?> read({required String key}) async {
    try {
      return await _storage.read(key: key);
    } on PlatformException {
      throw const SecretStorageException(SecretStorageFailure.rejected);
    }
  }

  @override
  Future<void> delete({required String key}) async {
    try {
      await _storage.delete(key: key);
    } on PlatformException {
      throw const SecretStorageException(SecretStorageFailure.rejected);
    }
  }
}

/// Linux only: `org.freedesktop.secrets` must already own a name on the
/// session bus. Other platforms use their own keystore and skip this check.
/// A missing `gdbus` binary does not invent a fallback; the write is still
/// attempted and libsecret's own error surfaces as [SecretStorageException].
Future<void> ensureLinuxSecretService() async {
  if (!Platform.isLinux) return;
  final probe = await Process.run('gdbus', const [
    'call',
    '--session',
    '--dest',
    'org.freedesktop.DBus',
    '--object-path',
    '/org/freedesktop/DBus',
    '--method',
    'org.freedesktop.DBus.NameHasOwner',
    'org.freedesktop.secrets',
  ]);
  if (probe.exitCode != 0) return;
  if (probe.stdout.toString().contains('true')) return;
  throw const SecretStorageException(SecretStorageFailure.unavailable);
}
