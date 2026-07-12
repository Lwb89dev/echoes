import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart' show sha256;
import 'package:cryptography/cryptography.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart' show MediaType;

import '../models/attachment.dart';
import '../models/upload_provider.dart';
import '../models/user.dart';
import '../utils/constants.dart';
import 'file_cache_service.dart';
import 'nostr_service.dart';

/// Encrypts an attachment's local file, uploads the ciphertext to a
/// Blossom or NIP-96 file host, and — the other direction — downloads,
/// verifies, and decrypts an already-uploaded one, caching the *decrypted*
/// bytes on disk.
///
/// The host on either protocol only ever receives/serves the *encrypted*
/// bytes — the underlying content, exact byte layout, and filename are
/// never sent. It does learn the attachment's general media category
/// (declared via `Content-Type`/`content_type` as e.g. `image/jpeg` or
/// `audio/m4a`, not `application/octet-stream`): several real-world
/// Blossom/NIP-96 hosts reject an upload whose type they can't identify
/// with HTTP 415/400, so this is the minimum disclosure needed to get the
/// upload accepted at all.
///
/// A category declaration is not the same as *validation*, though: some
/// widely-used public hosts (Primal's Blossom, nostr.build's NIP-96 — both
/// deliberately *not* [builtInUploadProviders], see the comment there) go
/// further and actually decode the uploaded bytes server-side to confirm
/// they're a real image/audio file, which ciphertext by definition never
/// is — those hosts reject every single upload from this app, not just
/// some. The two hosts chosen as defaults were verified to store whatever
/// opaque bytes they're given, matching what a Blossom server is actually
/// specified (BUD-01/02) to do. The AES-256-GCM
/// key and nonce needed to decrypt travel only inside the attachment's
/// [Attachment] record, which lives inside the note's own JSON — itself
/// NIP-44 self-encrypted before it ever reaches a relay (see
/// [NostrService.createNoteEvent]). So a network eavesdropper, the file
/// host operator, or a relay operator only ever get to see: an encrypted
/// blob tagged "this is roughly an image/audio file", and a public key
/// making HTTP requests — never the note's or attachment's actual content.
class AttachmentUploadService {
  AttachmentUploadService({
    required NostrService nostrService,
    required FileCacheService fileCacheService,
  })  : _nostrService = nostrService, // ignore: prefer_initializing_formals
        _fileCacheService = fileCacheService; // ignore: prefer_initializing_formals

  final NostrService _nostrService;
  final FileCacheService _fileCacheService;

  static final AesGcm _aesGcm = AesGcm.with256bits();
  static final Random _secureRandom = Random.secure();

  /// GCM's authentication tag is always 16 bytes; concatenated onto the
  /// ciphertext when uploading (see [upload]) since Blossom/NIP-96 only
  /// deal in one opaque blob, then split back off on [getDecrypted].
  static const _macLength = 16;

  /// Encrypts [pending]'s local file and uploads the ciphertext to
  /// [provider] under [author]'s authorization (NIP-98 for a NIP-96 host,
  /// Blossom's own BUD-01/BUD-11 scheme for a Blossom host — see
  /// [_nip98AuthHeader]/[_blossomAuthHeader]), returning the now-uploaded
  /// counterpart of [pending] (see [Attachment.uploaded]).
  Future<Attachment> upload({
    required Attachment pending,
    required UploadProviderOption provider,
    required User author,
  }) async {
    final localPath = pending.localPath;
    if (localPath == null) {
      throw StateError('Attachment ${pending.id} has no local file to upload.');
    }
    developer.log('AttachmentUploadService.upload called: ${pending.id}', name: 'AttachmentUploadService');

    final plainBytes = await File(localPath).readAsBytes();
    final key = _randomBytes(32);
    final nonce = _randomBytes(12);
    final secretBox = await _aesGcm.encrypt(plainBytes, secretKey: SecretKey(key), nonce: nonce);
    final encryptedBytes = Uint8List.fromList([...secretBox.cipherText, ...secretBox.mac.bytes]);
    final encryptedHash = sha256.convert(encryptedBytes).toString();

    final url = await _uploadWithFallback(
      provider: provider,
      bytes: encryptedBytes,
      mimeType: pending.mimeType,
      author: author,
    );

    // Seed the decrypted-file cache with what's already in memory, under
    // the same key [getDecrypted] will look for later — so viewing this
    // attachment right after uploading it doesn't need a redundant
    // download-then-decrypt round trip — and clean up the original local
    // copy: its only two jobs (get encrypted, get cached) are both done,
    // and there's no reason for a private photo or voice note to keep
    // sitting in the cache directory under its own, separate, unencrypted
    // path once that's true.
    await _fileCacheService.put(encryptedHash, plainBytes);
    try {
      await File(localPath).delete();
    } catch (e) {
      developer.log('Could not delete local attachment file after upload: $e', name: 'AttachmentUploadService');
    }

    return Attachment.uploaded(
      pending: pending,
      url: url,
      decryptionKeyBase64: base64Encode(key),
      decryptionNonceBase64: base64Encode(nonce),
      sizeBytes: encryptedBytes.length,
      sha256OfEncrypted: encryptedHash,
    );
  }

  /// Uploads to [provider], automatically retrying against the *other*
  /// built-in host (see [builtInUploadProviders]) if the first attempt
  /// fails — but only when [provider] itself is one of those two. A
  /// custom host the user explicitly configured (e.g. a private/
  /// self-hosted instance) is never silently swapped out for a public one
  /// they didn't choose; if that one fails, the failure is just reported,
  /// same as before this fallback existed.
  ///
  /// This is upload-time-only: a single successful attempt uploads to
  /// exactly one host (never both "just in case"), so this doesn't change
  /// how many different servers end up holding a copy of any given
  /// attachment — only which *one* of the two built-ins gets picked when
  /// the preferred one happens to be down.
  Future<String> _uploadWithFallback({
    required UploadProviderOption provider,
    required Uint8List bytes,
    required String mimeType,
    required User author,
  }) async {
    try {
      return await _uploadToProvider(provider: provider, bytes: bytes, mimeType: mimeType, author: author);
    } catch (primaryError) {
      final fallback = _fallbackFor(provider);
      if (fallback == null) rethrow;
      developer.log(
        'Upload to ${provider.baseUrl} failed, retrying with fallback ${fallback.baseUrl}: $primaryError',
        name: 'AttachmentUploadService',
      );
      try {
        return await _uploadToProvider(provider: fallback, bytes: bytes, mimeType: mimeType, author: author);
      } catch (fallbackError) {
        throw StateError(
          'Upload failed on ${provider.baseUrl} ($primaryError) and on the fallback ${fallback.baseUrl} ($fallbackError).',
        );
      }
    }
  }

  Future<String> _uploadToProvider({
    required UploadProviderOption provider,
    required Uint8List bytes,
    required String mimeType,
    required User author,
  }) {
    return switch (provider.protocol) {
      UploadProtocol.blossom =>
        _uploadToBlossom(baseUrl: provider.baseUrl, bytes: bytes, mimeType: mimeType, author: author),
      UploadProtocol.nip96 =>
        _uploadToNip96(baseUrl: provider.baseUrl, bytes: bytes, mimeType: mimeType, author: author),
    };
  }

  UploadProviderOption? _fallbackFor(UploadProviderOption provider) {
    if (provider.id == blossomHzrd149Provider.id) return blossomNostrDownloadProvider;
    if (provider.id == blossomNostrDownloadProvider.id) return blossomHzrd149Provider;
    return null;
  }

  /// Downloads, hash-verifies, and decrypts [attachment]'s blob, caching
  /// the *decrypted* bytes on disk so this only ever happens once per
  /// attachment (see [FileCacheService]) — never the ciphertext, since the
  /// decrypted form is what every caller actually needs.
  ///
  /// Verifying the downloaded bytes against [Attachment.sha256OfEncrypted]
  /// before decrypting means a compromised or misbehaving host can't
  /// quietly swap the blob for something else and have it decrypt
  /// (GCM would then just fail the authentication check anyway, but the
  /// hash check rejects it earlier, with a clearer error).
  Future<File> getDecrypted(Attachment attachment) async {
    final url = attachment.url;
    final keyB64 = attachment.decryptionKeyBase64;
    final nonceB64 = attachment.decryptionNonceBase64;
    final expectedHash = attachment.sha256OfEncrypted;
    if (url == null || keyB64 == null || nonceB64 == null) {
      throw StateError('Attachment ${attachment.id} has not been uploaded yet.');
    }
    _requireHttps(url);

    final cacheKey = expectedHash ?? sha256.convert(utf8.encode(url)).toString();
    final cached = await _fileCacheService.get(cacheKey);
    if (cached != null) return cached;

    developer.log('AttachmentUploadService.getDecrypted downloading: ${attachment.id}', name: 'AttachmentUploadService');
    // Without a timeout, an unreachable-but-not-actively-refusing host
    // (e.g. one that's down at the network level rather than returning a
    // clean error) leaves this hanging indefinitely instead of surfacing
    // an error the retry button (see `_ImageAttachmentPreview`) can act on.
    final response = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 15));
    if (response.statusCode != 200) {
      throw StateError('Could not download attachment (HTTP ${response.statusCode}).');
    }
    final encryptedBytes = response.bodyBytes;

    if (expectedHash != null) {
      final actualHash = sha256.convert(encryptedBytes).toString();
      if (actualHash != expectedHash) {
        throw StateError(
          'Downloaded attachment does not match its expected hash — refusing to decrypt a possibly tampered file.',
        );
      }
    }

    if (encryptedBytes.length <= _macLength) {
      throw StateError('Downloaded attachment is too short to contain a valid GCM tag.');
    }
    final cipherText = encryptedBytes.sublist(0, encryptedBytes.length - _macLength);
    final mac = encryptedBytes.sublist(encryptedBytes.length - _macLength);
    final secretBox = SecretBox(cipherText, nonce: base64Decode(nonceB64), mac: Mac(mac));

    final plainBytes = await _aesGcm.decrypt(secretBox, secretKey: SecretKey(base64Decode(keyB64)));
    return _fileCacheService.put(cacheKey, Uint8List.fromList(plainBytes));
  }

  // ---------------------------------------------------------------------
  // Blossom (BUD-01/BUD-02)
  // ---------------------------------------------------------------------

  Future<String> _uploadToBlossom({
    required String baseUrl,
    required Uint8List bytes,
    required String mimeType,
    required User author,
  }) async {
    _requireHttps(baseUrl);
    final uploadUrl = '$baseUrl/upload';
    final authHeader = await _blossomAuthHeader(verb: 'upload', body: bytes, author: author);

    final response = await http.put(
      Uri.parse(uploadUrl),
      headers: {
        // The bytes themselves are already ciphertext — this only tells
        // the host "this was an image/audio file", not what's in it. Some
        // real-world Blossom servers reject a generic application/
        // octet-stream declaration outright with HTTP 415, so the real
        // category has to go here for the upload to be accepted at all;
        // BUD-02 explicitly allows servers to do this. (A *stricter* host
        // that goes further and actually decodes the bytes to verify they
        // really are an image — e.g. Primal's, deliberately not a default
        // here, see [builtInUploadProviders] — will reject this app's
        // ciphertext regardless of what Content-Type is declared.)
        'Content-Type': mimeType,
        'Authorization': authHeader,
      },
      body: bytes,
    ).timeout(const Duration(seconds: 30));
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw StateError('Blossom upload failed (HTTP ${response.statusCode}): ${response.body}');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final url = json['url'] as String?;
    if (url == null) throw StateError('Blossom server did not return a url.');
    // The server's own response is untrusted input like any other — don't
    // hand back a downgraded-to-http URL just because it upheld https for
    // the upload itself.
    _requireHttps(url);
    return url;
  }

  // ---------------------------------------------------------------------
  // NIP-96
  // ---------------------------------------------------------------------

  Future<String> _uploadToNip96({
    required String baseUrl,
    required Uint8List bytes,
    required String mimeType,
    required User author,
  }) async {
    _requireHttps(baseUrl);
    final apiUrl = await _discoverNip96ApiUrl(baseUrl);
    final authHeader = await _nip98AuthHeader(url: apiUrl, method: 'POST', body: bytes, author: author);

    // The bytes are already ciphertext — declaring the real category on
    // the file part's own `Content-Type` only tells the host "this was an
    // image/audio file", not what's in it. Real-world NIP-96 hosts (e.g.
    // nostr.build) reject uploads whose type they can't identify with
    // HTTP 400, so a generic/absent content type isn't accepted in
    // practice even though the spec makes it optional. (Deliberately not
    // *also* sending NIP-96's separate `content_type` form field: on
    // nostr.build it was observed to make multi-image syncs fail with
    // "no file or more than one file posted" from their multipart parser
    // — the file part's own header is the spec's primary, standard way to
    // declare this and is sufficient on its own. Separately, nostr.build
    // was also confirmed to go further and actually decode the file
    // server-side — generating a blurhash/thumbnail from it — and to
    // 500 on anything, like this app's ciphertext, that fails to decode
    // as a real image; not fixable by any request-shape change, which is
    // why it's deliberately not a default, see [builtInUploadProviders].)
    //
    // The `filename` is required, not cosmetic: a multipart part *without*
    // a `filename` attribute is treated by standard parsers (nostr.build's
    // included) as an ordinary form field rather than an uploaded file, so
    // the server counts zero files and rejects with "no file ... posted /
    // only one file is expected" (this is what broke voice-note uploads).
    // It's a fixed generic name — never the user's original filename,
    // which could itself be identifying — carrying only an extension that
    // matches the already-disclosed category.
    final request = http.MultipartRequest('POST', Uri.parse(apiUrl))
      ..headers['Authorization'] = authHeader
      ..files.add(http.MultipartFile.fromBytes(
        'file',
        bytes,
        filename: 'attachment.${_extensionForMime(mimeType)}',
        contentType: MediaType.parse(mimeType),
      ));

    final streamedResponse = await request.send().timeout(const Duration(seconds: 30));
    final response = await http.Response.fromStream(streamedResponse);
    // 202 Accepted shows up in the wild for NIP-96 hosts that queue
    // post-processing (e.g. transcoding) rather than finishing it inline;
    // treating only 200/201 as success rejects an upload that actually
    // succeeded.
    if (response.statusCode != 200 && response.statusCode != 201 && response.statusCode != 202) {
      throw StateError('NIP-96 upload failed (HTTP ${response.statusCode}): ${response.body}');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final nip94Tags = (json['nip94_event'] as Map<String, dynamic>?)?['tags'] as List<dynamic>?;
    for (final tag in nip94Tags ?? const []) {
      final entry = tag as List<dynamic>;
      if (entry.isNotEmpty && entry[0] == 'url') {
        final url = entry[1] as String;
        // Same reasoning as the Blossom path above: the response is
        // untrusted input, re-validate before trusting it as a future
        // download target.
        _requireHttps(url);
        return url;
      }
    }
    throw StateError('NIP-96 response did not include a url tag.');
  }

  /// Resolves a NIP-96 server's actual upload endpoint via its
  /// `/.well-known/nostr/nip96.json` descriptor, per spec — this also
  /// makes "custom NIP-96 server" configurations in Settings work without
  /// this app needing to know each server's endpoint layout in advance.
  Future<String> _discoverNip96ApiUrl(String baseUrl) async {
    final wellKnownUrl = Uri.parse('$baseUrl/.well-known/nostr/nip96.json');
    final response = await http.get(wellKnownUrl).timeout(const Duration(seconds: 10));
    if (response.statusCode != 200) {
      throw StateError('Could not discover the NIP-96 upload endpoint for $baseUrl (HTTP ${response.statusCode}).');
    }
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final apiUrl = json['api_url'] as String?;
    if (apiUrl == null) {
      throw StateError('$baseUrl/.well-known/nostr/nip96.json is missing "api_url".');
    }
    // Per spec api_url may be relative to the server root — but may also be
    // a full, independent URL, which a malicious or misconfigured server
    // could point at a plain-http endpoint even though `baseUrl` itself
    // checked out as https. Re-validate the *resolved* URL rather than
    // trusting a value this app didn't construct itself.
    final resolved = apiUrl.startsWith('http') ? apiUrl : '$baseUrl$apiUrl';
    _requireHttps(resolved);
    return resolved;
  }

  // ---------------------------------------------------------------------
  // NIP-98 HTTP Auth — NIP-96 only. Blossom uses its own scheme (BUD-01/
  // BUD-11, see [_blossomAuthHeader] below): same general shape (a signed
  // Nostr event, base64-encoded, in the Authorization header), but a
  // different kind and tag set — the two are not interchangeable, and
  // using one where a server expects the other fails authorization
  // (this is exactly what a prior version of this code got wrong: it used
  // NIP-98 for Blossom uploads too, which Blossom servers correctly
  // reject as "wrong kind of auth event").
  // ---------------------------------------------------------------------

  Future<String> _nip98AuthHeader({
    required String url,
    required String method,
    required Uint8List body,
    required User author,
  }) async {
    final tags = [
      ['u', url],
      ['method', method],
      ['payload', sha256.convert(body).toString()],
    ];
    final event = await _nostrService.signGenericEvent(
      kind: AppConstants.nip98AuthEventKind,
      tags: tags,
      content: '',
      author: author,
    );
    return 'Nostr ${base64Encode(utf8.encode(jsonEncode(event.toMap())))}';
  }

  // ---------------------------------------------------------------------
  // Blossom authorization (BUD-01/BUD-11)
  // ---------------------------------------------------------------------

  /// Builds a Blossom authorization event (kind 24242 — *not* NIP-98's
  /// 27235) for [verb] ("upload", "get", "list", or "delete" per BUD-11).
  /// Required tags per spec: `t` (the verb), `expiration` (a NIP-40 Unix
  /// timestamp — short-lived, since this token is only ever used for the
  /// single HTTP request made right after signing it), and `x` (the
  /// sha256 of the blob this authorization covers — the *encrypted*
  /// bytes, since that's literally the only form of the blob a Blossom
  /// server ever sees). Unlike NIP-98, the signed event is base64url
  /// (URL-safe alphabet) *without* padding, per BUD-11.
  Future<String> _blossomAuthHeader({
    required String verb,
    required Uint8List body,
    required User author,
  }) async {
    final expiresAt = DateTime.now().add(const Duration(minutes: 5));
    final tags = [
      ['t', verb],
      ['expiration', (expiresAt.millisecondsSinceEpoch ~/ 1000).toString()],
      ['x', sha256.convert(body).toString()],
    ];
    final event = await _nostrService.signGenericEvent(
      kind: AppConstants.blossomAuthEventKind,
      tags: tags,
      content: 'Echoes: $verb attachment',
      author: author,
    );
    final encoded = base64Url.encode(utf8.encode(jsonEncode(event.toMap())));
    return 'Nostr ${encoded.replaceAll('=', '')}';
  }

  // ---------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------

  void _requireHttps(String url) {
    if (!url.startsWith('https://')) {
      throw ArgumentError('Refusing a non-HTTPS attachment URL/provider: $url');
    }
  }

  /// A plausible file extension for [mimeType], used only for the generic
  /// upload filename (see [_uploadToNip96]) — never derived from, and never
  /// revealing, the user's original filename. Falls back to `bin` for
  /// anything unrecognized rather than guessing.
  String _extensionForMime(String mimeType) {
    return switch (mimeType) {
      'image/jpeg' => 'jpg',
      'image/png' => 'png',
      'image/gif' => 'gif',
      'image/webp' => 'webp',
      'audio/mp4' || 'audio/aac' => 'm4a',
      'audio/mpeg' => 'mp3',
      'audio/ogg' => 'ogg',
      'audio/wav' => 'wav',
      _ => 'bin',
    };
  }

  Uint8List _randomBytes(int length) {
    return Uint8List.fromList(List<int>.generate(length, (_) => _secureRandom.nextInt(256)));
  }
}
