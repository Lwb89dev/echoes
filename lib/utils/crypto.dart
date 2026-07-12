import 'nip44.dart';

/// NIP-44 encryption for the `content` field of note events.
///
/// Notes are "self-encrypted": the sender and recipient are the same
/// person (the note's owner), so only whoever holds the private key can
/// ever decrypt them — that's what makes them invisible to everyone else
/// on the relay, including the relay operator.
///
/// `dart_nostr` (the main Nostr SDK used elsewhere in this app) does not
/// implement NIP-44, so this wraps [Nip44] — see that file for the full
/// algorithm and why it's a direct implementation rather than a
/// third-party package. NIP-44 supersedes the older NIP-04 (ECDH + plain
/// AES-256-CBC, no padding, no message authentication — vulnerable to
/// bit-flipping since there's no MAC), which the Nostr protocol itself
/// now marks deprecated; Echoes does not use NIP-04 anywhere.
///
/// This only covers the [LoginMethod.privateKey] path, where the app holds
/// the private key locally. For [LoginMethod.amber], encryption instead
/// goes through `Amberflutter.nip44Encrypt`/`nip44Decrypt` in
/// [NostrService], since the private key never leaves the Amber signer.
class CryptoUtils {
  CryptoUtils._();

  /// Encrypts [plaintext] with NIP-44 using [privateKeyHex] and
  /// [recipientPublicKeyHex]. For self-encrypted notes,
  /// [recipientPublicKeyHex] is the same account's own public key.
  static String encryptNip44({
    required String plaintext,
    required String privateKeyHex,
    required String recipientPublicKeyHex,
  }) {
    return Nip44.encrypt(
      plaintext: plaintext,
      senderPrivateKeyHex: privateKeyHex,
      recipientPublicKeyHex: recipientPublicKeyHex,
    );
  }

  /// Decrypts a NIP-44 payload using [privateKeyHex] and
  /// [senderPublicKeyHex]. For self-encrypted notes, [senderPublicKeyHex]
  /// is the same account's own public key.
  static String decryptNip44({
    required String ciphertext,
    required String privateKeyHex,
    required String senderPublicKeyHex,
  }) {
    return Nip44.decrypt(
      payload: ciphertext,
      recipientPrivateKeyHex: privateKeyHex,
      senderPublicKeyHex: senderPublicKeyHex,
    );
  }
}
