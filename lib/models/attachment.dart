/// An image or voice-note attachment on a [Note].
///
/// Every field needed to decrypt it travels inside the note's own JSON —
/// which is itself NIP-44 self-encrypted before it ever reaches a relay
/// (see `NostrService.createNoteEvent`) — so an attachment's decryption
/// key/nonce end up exactly as protected as the rest of the note's
/// content: never sent or stored anywhere in the clear.
///
/// Field names deliberately mirror NIP-17's kind-15 "encrypted file
/// message" convention (`decryption-key`/`decryption-nonce`/algorithm/
/// `x`/`ox`) even though Echoes doesn't publish kind-15 events itself —
/// attachments live inside this app's own note JSON, not as separate
/// Nostr events. Reusing that vocabulary keeps the door open for future
/// interop without inventing a new one.
enum AttachmentType { image, audio }

class Attachment {
  final String id;
  final AttachmentType type;

  /// Path to the original, unencrypted file on *this* device, before it's
  /// been uploaded. Meaningless on any other device, and cleared once
  /// [url] is set — kept only so a note saved locally with a
  /// not-yet-synced attachment survives an app restart and can still be
  /// uploaded on the next sync.
  final String? localPath;

  /// Where the *encrypted* blob was uploaded to (never the original
  /// file — see `AttachmentUploadService`). Null until the first
  /// successful upload.
  final String? url;

  final String? decryptionKeyBase64;
  final String? decryptionNonceBase64;
  final String encryptionAlgorithm;
  final String mimeType;
  final int? sizeBytes;

  /// sha256 of the *encrypted* blob (matches Blossom's/NIP-96's own hash),
  /// used to verify a downloaded blob hasn't been swapped by a
  /// compromised or misbehaving host before decrypting it.
  final String? sha256OfEncrypted;

  final int? durationSeconds;
  final int? width;
  final int? height;

  const Attachment({
    required this.id,
    required this.type,
    this.localPath,
    this.url,
    this.decryptionKeyBase64,
    this.decryptionNonceBase64,
    this.encryptionAlgorithm = 'aes-gcm',
    required this.mimeType,
    this.sizeBytes,
    this.sha256OfEncrypted,
    this.durationSeconds,
    this.width,
    this.height,
  });

  bool get isUploaded => url != null;

  /// The uploaded counterpart of this (necessarily still-pending, i.e.
  /// [isUploaded] == false) attachment: same identity/media metadata,
  /// now with a remote [url] and decryption material, and no local path
  /// left to fall back to. There is exactly one transition an
  /// [Attachment] ever goes through in this app, so a single named
  /// constructor for it reads clearer than a general-purpose `copyWith`
  /// with a field for every possible change.
  factory Attachment.uploaded({
    required Attachment pending,
    required String url,
    required String decryptionKeyBase64,
    required String decryptionNonceBase64,
    required int sizeBytes,
    required String sha256OfEncrypted,
  }) {
    return Attachment(
      id: pending.id,
      type: pending.type,
      url: url,
      decryptionKeyBase64: decryptionKeyBase64,
      decryptionNonceBase64: decryptionNonceBase64,
      mimeType: pending.mimeType,
      sizeBytes: sizeBytes,
      sha256OfEncrypted: sha256OfEncrypted,
      durationSeconds: pending.durationSeconds,
      width: pending.width,
      height: pending.height,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type.name,
        'localPath': localPath,
        'url': url,
        'decryptionKeyBase64': decryptionKeyBase64,
        'decryptionNonceBase64': decryptionNonceBase64,
        'encryptionAlgorithm': encryptionAlgorithm,
        'mimeType': mimeType,
        'sizeBytes': sizeBytes,
        'sha256OfEncrypted': sha256OfEncrypted,
        'durationSeconds': durationSeconds,
        'width': width,
        'height': height,
      };

  factory Attachment.fromJson(Map<String, dynamic> json) {
    return Attachment(
      id: json['id'] as String,
      type: AttachmentType.values.byName(json['type'] as String),
      localPath: json['localPath'] as String?,
      url: json['url'] as String?,
      decryptionKeyBase64: json['decryptionKeyBase64'] as String?,
      decryptionNonceBase64: json['decryptionNonceBase64'] as String?,
      encryptionAlgorithm: json['encryptionAlgorithm'] as String? ?? 'aes-gcm',
      mimeType: json['mimeType'] as String,
      sizeBytes: json['sizeBytes'] as int?,
      sha256OfEncrypted: json['sha256OfEncrypted'] as String?,
      durationSeconds: json['durationSeconds'] as int?,
      width: json['width'] as int?,
      height: json['height'] as int?,
    );
  }
}
