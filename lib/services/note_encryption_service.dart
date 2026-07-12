import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:math';

import 'package:cryptography/cryptography.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/constants.dart';

/// Optional at-rest encryption for locally saved notes, turned on by the
/// user with a password.
///
/// The password itself is never saved: only a random salt and a
/// "verifier" (a known plaintext encrypted with the derived key) are
/// written to SharedPreferences, so the next unlock attempt can say
/// "correct/wrong password" without keeping the password anywhere.
///
/// Algorithms: PBKDF2-HMAC-SHA256 with 210,000 iterations (OWASP 2023
/// recommendation for this combination) derives an AES-256 key from the
/// password, then AES-256-GCM (authenticated: a wrong password or corrupted
/// data is detected instead of silently producing garbage) encrypts and
/// decrypts.
///
/// The derived key only lives in RAM for the current session: [lock]
/// discards it and notes become unreadable again until [unlock] is called.
class NoteEncryptionService {
  static const _pbkdf2Iterations = 210000;
  static const _keyBits = 256;
  static const _saltLength = 16;
  static const _verifierPlaintext = 'echoes-note-encryption-verifier';

  final Pbkdf2 _pbkdf2 = Pbkdf2.hmacSha256(
    iterations: _pbkdf2Iterations,
    bits: _keyBits,
  );
  final AesGcm _aesGcm = AesGcm.with256bits();

  SecretKey? _cachedKey;

  Future<SharedPreferences> get _prefs => SharedPreferences.getInstance();

  /// true if the user has turned on password protection for notes.
  Future<bool> isEnabled() async {
    final prefs = await _prefs;
    return prefs.getBool(AppConstants.prefsNoteEncryptionEnabledKey) ?? false;
  }

  /// true if notes are readable right now: either encryption is off, or it
  /// is on and already unlocked in this session.
  Future<bool> isUnlocked() async {
    if (!await isEnabled()) return true;
    return _cachedKey != null;
  }

  /// Discards the derived key from memory. Call this when the user wants to
  /// explicitly lock notes (auto-locking on app background is not
  /// implemented yet).
  void lock() {
    developer.log('NoteEncryptionService.lock called', name: 'NoteEncryptionService');
    _cachedKey = null;
  }

  /// Derives a key from [password] and checks it against the saved
  /// verifier. On success, caches the key (unlocking notes for this
  /// session) and returns true; on a wrong password, returns false without
  /// touching any saved state.
  Future<bool> unlock(String password) async {
    developer.log('NoteEncryptionService.unlock called', name: 'NoteEncryptionService');
    final key = await _deriveAndVerify(password);
    if (key == null) return false;
    _cachedKey = key;
    return true;
  }

  /// Checks [password] against the saved verifier *without* unlocking the
  /// session (the derived key is discarded, nothing is cached) — used when
  /// a caller only needs to confirm the password is correct, such as
  /// before using it to encrypt a note export (see [encryptExportWithNewPassword]).
  Future<bool> verifyPassword(String password) async {
    return (await _deriveAndVerify(password)) != null;
  }

  /// Shared by [unlock] and [verifyPassword]: derives a key from [password]
  /// against the saved salt and returns it only if it also matches the
  /// saved verifier — null on a wrong password. Neither caches nor mutates
  /// any state; callers decide what to do with a successful result.
  Future<SecretKey?> _deriveAndVerify(String password) async {
    final prefs = await _prefs;
    final saltB64 = prefs.getString(AppConstants.prefsNoteEncryptionSaltKey);
    final verifierB64 = prefs.getString(AppConstants.prefsNoteEncryptionVerifierKey);
    final verifierNonceB64 = prefs.getString(AppConstants.prefsNoteEncryptionVerifierNonceKey);
    final verifierMacB64 = prefs.getString(AppConstants.prefsNoteEncryptionVerifierMacKey);
    if (saltB64 == null || verifierB64 == null || verifierNonceB64 == null || verifierMacB64 == null) {
      throw StateError(
        'No encryption configuration found: password protection is not enabled.',
      );
    }

    final key = await _deriveKey(password, base64Decode(saltB64));

    try {
      final plaintext = await _aesGcm.decrypt(
        SecretBox(
          base64Decode(verifierB64),
          nonce: base64Decode(verifierNonceB64),
          mac: Mac(base64Decode(verifierMacB64)),
        ),
        secretKey: key,
      );
      return utf8.decode(plaintext) == _verifierPlaintext ? key : null;
    } on SecretBoxAuthenticationError {
      return null; // Wrong password: the MAC does not match.
    }
  }

  /// Turns encryption on for the first time with [password] and unlocks the
  /// session right away with the freshly derived key.
  ///
  /// Does not touch any already-saved notes: the caller
  /// ([LocalStorageService]) is responsible for reading them back in
  /// plaintext and rewriting them encrypted right after, while the key is
  /// still cached.
  Future<void> enable(String password) async {
    developer.log('NoteEncryptionService.enable called', name: 'NoteEncryptionService');
    final salt = _randomBytes(_saltLength);
    final key = await _deriveKey(password, salt);

    final verifierBox = await _aesGcm.encrypt(
      utf8.encode(_verifierPlaintext),
      secretKey: key,
    );

    final prefs = await _prefs;
    await prefs.setString(AppConstants.prefsNoteEncryptionSaltKey, base64Encode(salt));
    await prefs.setString(
      AppConstants.prefsNoteEncryptionVerifierKey,
      base64Encode(verifierBox.cipherText),
    );
    await prefs.setString(
      AppConstants.prefsNoteEncryptionVerifierNonceKey,
      base64Encode(verifierBox.nonce),
    );
    await prefs.setString(
      AppConstants.prefsNoteEncryptionVerifierMacKey,
      base64Encode(verifierBox.mac.bytes),
    );
    await prefs.setBool(AppConstants.prefsNoteEncryptionEnabledKey, true);

    _cachedKey = key;
  }

  /// Turns encryption off and discards salt, verifier and cached key.
  ///
  /// The caller is responsible for having already rewritten notes in
  /// plaintext (using the old key, still cached at call time) before
  /// invoking this method.
  Future<void> disable() async {
    developer.log('NoteEncryptionService.disable called', name: 'NoteEncryptionService');
    final prefs = await _prefs;
    await prefs.remove(AppConstants.prefsNoteEncryptionSaltKey);
    await prefs.remove(AppConstants.prefsNoteEncryptionVerifierKey);
    await prefs.remove(AppConstants.prefsNoteEncryptionVerifierNonceKey);
    await prefs.remove(AppConstants.prefsNoteEncryptionVerifierMacKey);
    await prefs.setBool(AppConstants.prefsNoteEncryptionEnabledKey, false);
    _cachedKey = null;
  }

  /// Encrypts a string (typically a [Note]'s JSON) with the cached key.
  /// Requires [isUnlocked] to be true, otherwise throws.
  Future<Map<String, dynamic>> encryptString(String plainText) async {
    final key = _requireCachedKey();
    final box = await _aesGcm.encrypt(utf8.encode(plainText), secretKey: key);
    return {
      'ciphertext': base64Encode(box.cipherText),
      'nonce': base64Encode(box.nonce),
      'mac': base64Encode(box.mac.bytes),
    };
  }

  /// Decrypts a map produced by [encryptString], returning the original text.
  Future<String> decryptString(Map<dynamic, dynamic> stored) async {
    final key = _requireCachedKey();
    final plaintext = await _aesGcm.decrypt(
      SecretBox(
        base64Decode(stored['ciphertext'] as String),
        nonce: base64Decode(stored['nonce'] as String),
        mac: Mac(base64Decode(stored['mac'] as String)),
      ),
      secretKey: key,
    );
    return utf8.decode(plaintext);
  }

  // ---------------------------------------------------------------------
  // Note export encryption — a separate concern from at-rest encryption
  // above: this always derives its own fresh salt/key from whatever
  // password the export dialog collects, so the resulting file is fully
  // self-contained (decryptable on any device, by anyone who knows that
  // password, independent of this device's stored at-rest salt/verifier
  // or cached key — an import elsewhere has neither). Used regardless of
  // whether at-rest encryption happens to be on; see `note_actions.dart`.
  // ---------------------------------------------------------------------

  /// Encrypts [plaintext] (an export's notes JSON) with a key derived fresh
  /// from [password], returning a self-contained map — including its own
  /// salt — that [decryptExportWithPassword] can later reverse with just
  /// the same password, no other saved state required.
  Future<Map<String, dynamic>> encryptExportWithNewPassword(String plaintext, String password) async {
    final salt = _randomBytes(_saltLength);
    final key = await _deriveKey(password, salt);
    final box = await _aesGcm.encrypt(utf8.encode(plaintext), secretKey: key);
    return {
      'salt': base64Encode(salt),
      'ciphertext': base64Encode(box.cipherText),
      'nonce': base64Encode(box.nonce),
      'mac': base64Encode(box.mac.bytes),
    };
  }

  /// Decrypts a map produced by [encryptExportWithNewPassword]. Throws
  /// [SecretBoxAuthenticationError] on a wrong password — callers should
  /// catch that specifically to show an inline "wrong password" message.
  Future<String> decryptExportWithPassword(Map<String, dynamic> stored, String password) async {
    final salt = base64Decode(stored['salt'] as String);
    final key = await _deriveKey(password, salt);
    final plaintext = await _aesGcm.decrypt(
      SecretBox(
        base64Decode(stored['ciphertext'] as String),
        nonce: base64Decode(stored['nonce'] as String),
        mac: Mac(base64Decode(stored['mac'] as String)),
      ),
      secretKey: key,
    );
    return utf8.decode(plaintext);
  }

  SecretKey _requireCachedKey() {
    final key = _cachedKey;
    if (key == null) {
      throw StateError(
        'Notes are encrypted and locked: call unlock() with the password before reading or writing them.',
      );
    }
    return key;
  }

  Future<SecretKey> _deriveKey(String password, List<int> salt) {
    return _pbkdf2.deriveKeyFromPassword(password: password, nonce: salt);
  }

  List<int> _randomBytes(int length) {
    final random = Random.secure();
    return List<int>.generate(length, (_) => random.nextInt(256));
  }
}
