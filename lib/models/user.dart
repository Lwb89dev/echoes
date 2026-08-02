/// How this Nostr account logged in, i.e. who holds the private key and
/// therefore who signs/decrypts events.
enum LoginMethod {
  /// Private key (nsec/hex) imported and kept in [LocalStorageService]
  /// (flutter_secure_storage). The app signs and encrypts locally.
  privateKey,

  /// External signer (Amber, NIP-55, Android only). The app never sees the
  /// private key: every signing/encryption op goes through an intent to Amber.
  amber,

  /// Remote signer over NIP-46 ("bunker"): the private key stays in a bunker
  /// (Amber acting as one, nsec.app, nsecbunker, …) reachable over relays.
  /// Works on every platform, unlike Amber's Android-only intents. The app
  /// never sees the private key; signing/encryption/decryption go to the
  /// signer as encrypted kind-24133 requests (see `Nip46Client`). The live
  /// connection lives in `NostrService`; the persisted session (which holds
  /// the ephemeral client key) lives in secure storage only.
  bunker,
}

/// Identity of the logged-in Nostr account: public key in hex form + its
/// bech32 (npub) variant for the UI.
class User {
  final String publicKeyHex;
  final String npub;
  final LoginMethod loginMethod;

  /// Only present for [LoginMethod.privateKey]. Must never be kept in
  /// memory longer than necessary, or logged: it's read from
  /// [LocalStorageService] (flutter_secure_storage) only when signing or
  /// decrypting an event is needed. Always null with [LoginMethod.amber].
  final String? privateKeyHex;

  const User({
    required this.publicKeyHex,
    required this.npub,
    required this.loginMethod,
    this.privateKeyHex,
  });
}
