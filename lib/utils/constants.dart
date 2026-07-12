/// App-wide constants shared across services/providers/UI.
class AppConstants {
  AppConstants._();

  static const String appName = 'Echoes';

  /// Nostr kind used for encrypted notes. 30078 = "Application-specific
  /// Data" (parameterized replaceable event, NIP-78) — lets us update the
  /// same note in place on the relay using the "d" tag. Switch to kind 1 +
  /// tag if an immutable history is preferred instead.
  static const int noteEventKind = 30078;

  /// NIP-09 event deletion request kind, used to retract a note from the
  /// relays (deleting it locally or un-syncing it — see
  /// [NostrService.deleteNoteEvent]).
  static const int deletionEventKind = 5;

  /// SharedPreferences keys.
  static const String prefsRelaysKey = 'echoes.relays';
  static const String prefsPublicKeyKey = 'echoes.pubkey';
  static const String prefsLoginMethodKey = 'echoes.login_method';
  static const String prefsLastSyncKey = 'echoes.last_sync';

  /// Set once the first-launch onboarding carousel has been completed
  /// (either by logging in or by explicitly choosing to stay local-only).
  static const String prefsOnboardingCompleteKey = 'echoes.onboarding_complete';

  /// Last-fetched profile metadata (name/avatar URL) for the logged-in
  /// account, so Settings shows something immediately on launch instead of
  /// a blank state while [ProfileNotifier] re-fetches from the relays.
  static const String prefsProfileCacheKey = 'echoes.profile_cache';

  /// The user's chosen file host for encrypted attachment uploads (see
  /// [UploadProviderOption]) — defaults to [blossomHzrd149Provider].
  static const String prefsUploadProviderKey = 'echoes.upload_provider';

  /// NIP-98 HTTP Auth event kind, used to authorize attachment uploads to
  /// NIP-96 hosts specifically (see `AttachmentUploadService`).
  static const int nip98AuthEventKind = 27235;

  /// Blossom's own authorization event kind (BUD-01/BUD-11) — a distinct
  /// scheme from NIP-98, *not* interchangeable with it: different kind
  /// number, different tags (`t`/`expiration`/`x` instead of
  /// `u`/`method`/`payload`), and a base64url-without-padding encoding
  /// instead of standard base64 for the Authorization header.
  static const int blossomAuthEventKind = 24242;

  /// SharedPreferences keys for optional, password-protected at-rest note
  /// encryption. None of these ever contain the password itself.
  static const String prefsNoteEncryptionEnabledKey = 'echoes.note_encryption.enabled';
  static const String prefsNoteEncryptionSaltKey = 'echoes.note_encryption.salt';
  static const String prefsNoteEncryptionVerifierKey = 'echoes.note_encryption.verifier';
  static const String prefsNoteEncryptionVerifierNonceKey = 'echoes.note_encryption.verifier_nonce';
  static const String prefsNoteEncryptionVerifierMacKey = 'echoes.note_encryption.verifier_mac';

  /// flutter_secure_storage key for the private key (nsec/hex).
  static const String secureStoragePrivateKeyKey = 'echoes.privkey';

  /// Name of the Hive box that holds the notes.
  static const String notesBoxName = 'echoes_notes';

  /// Polling interval for periodically fetching from relays while the app
  /// is in the foreground (fallback on top of the live websocket subscription).
  static const Duration syncPollInterval = Duration(minutes: 3);

  /// Upper bound on how long we wait for Amber to respond to a signing
  /// request (get_public_key, sign_event, nip44_*).
  ///
  /// Needed because `amberflutter`'s native Android side only completes the
  /// method channel result on `RESULT_OK`: if the user cancels/denies inside
  /// Amber, Android returns `RESULT_CANCELED` and the plugin never resolves
  /// or rejects the call, leaving the Dart `Future` (and any UI spinner
  /// waiting on it) hanging forever. This timeout is our only way to
  /// recover from that on the Flutter side.
  static const Duration amberInteractionTimeout = Duration(seconds: 60);
}
