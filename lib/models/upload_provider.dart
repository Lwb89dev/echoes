/// Which upload protocol an [UploadProviderOption] speaks — the two ways
/// this app knows how to hand an already-encrypted attachment blob to a
/// public file host (see `AttachmentUploadService`).
enum UploadProtocol { blossom, nip96 }

/// A file host attachments get uploaded to, selectable in Settings. The
/// host only ever receives opaque, already-encrypted bytes (see
/// `AttachmentUploadService.upload`) — [label]/[baseUrl] just say *where*,
/// never anything about *what*.
class UploadProviderOption {
  final String id;
  final String label;
  final UploadProtocol protocol;
  final String baseUrl;

  const UploadProviderOption({
    required this.id,
    required this.label,
    required this.protocol,
    required this.baseUrl,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'label': label,
    'protocol': protocol.name,
    'baseUrl': baseUrl,
  };

  factory UploadProviderOption.fromJson(Map<String, dynamic> json) {
    return UploadProviderOption(
      id: json['id'] as String,
      label: json['label'] as String,
      protocol: UploadProtocol.values.byName(json['protocol'] as String),
      baseUrl: json['baseUrl'] as String,
    );
  }
}

/// Deliberately *not* Primal or nostr.build, despite both being the most
/// popular public Blossom/NIP-96 hosts: verified (see the session that
/// added this comment) that both actively content-validate an upload
/// server-side — decoding it as a real image, not just trusting the
/// declared `Content-Type` — and reject anything that doesn't decode:
/// Primal with a blunt "415 unsupported media type", nostr.build with a
/// bare "500 server error" (its backend tries to derive a blurhash/
/// thumbnail from the bytes and presumably throws on non-image input).
/// Since every attachment this app uploads is AES-GCM ciphertext, not a
/// real image/audio file (see [AttachmentUploadService]'s class doc), an
/// upload to either host fails *every single time*, for any attachment —
/// this was never a "some uploads fail" bug, those two hosts are simply
/// incompatible with client-side encrypted attachments by design.
/// `cdn.hzrd149.com` and `nostr.download` were confirmed to store
/// whatever opaque bytes they're given (proper BUD-01/02 behavior, no
/// server-side re-encoding), which is what a Blossom host needs to do to
/// work here at all.
const blossomHzrd149Provider = UploadProviderOption(
  id: 'blossom_hzrd149',
  label: 'cdn.hzrd149.com',
  protocol: UploadProtocol.blossom,
  baseUrl: 'https://cdn.hzrd149.com',
);

const blossomNostrDownloadProvider = UploadProviderOption(
  id: 'blossom_nostr_download',
  label: 'nostr.download',
  protocol: UploadProtocol.blossom,
  baseUrl: 'https://nostr.download',
);

/// Built-in choices offered in Settings; a user-entered custom URL (kept as
/// a separate "Custom…" option there, since it also needs a protocol pick)
/// is represented the same way once chosen, just with `id: 'custom'` — the
/// way to point at a self-hosted Blossom server for full control over
/// where attachments end up (see [AttachmentUploadService]).
const List<UploadProviderOption> builtInUploadProviders = [
  blossomHzrd149Provider,
  blossomNostrDownloadProvider,
];
