import 'dart:developer' as developer;
import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';

/// A flat, app-private disk store keyed by an opaque string id (the caller
/// picks the id — e.g. a sha256 hash of a URL, or of the encrypted blob it
/// downloaded — so the same store serves both the profile avatar and
/// decrypted attachment files without knowing anything about either).
///
/// Two backing directories, chosen per call via [persistent]:
///
///  * **purgeable** (default) lives under [getApplicationCacheDirectory],
///    which the OS is explicitly allowed to delete under storage pressure.
///    Right for anything re-derivable on a miss: avatars, and decrypted
///    *images* (re-downloadable from their host).
///  * **persistent** lives under [getApplicationSupportDirectory], which the
///    OS does not purge. Right for content whose only other copy is a remote
///    blob on a host that may garbage-collect it — decrypted **voice notes**
///    in particular: once the local original is deleted post-upload, an OS
///    cache purge would otherwise leave the recording dependent on a free
///    Blossom host keeping the blob forever, and losing that race means the
///    recording is gone (see `AttachmentUploadService` and the durability
///    reasoning there). Both dirs are app-private and covered by
///    `android:allowBackup="false"`.
class FileCacheService {
  Directory? _purgeableDir;
  Directory? _persistentDir;

  Future<Directory> _dir({required bool persistent}) async {
    final cached = persistent ? _persistentDir : _purgeableDir;
    if (cached != null) return cached;
    final base = persistent
        ? await getApplicationSupportDirectory()
        : await getApplicationCacheDirectory();
    final dir = Directory('${base.path}/echoes_files');
    if (!await dir.exists()) await dir.create(recursive: true);
    if (persistent) {
      _persistentDir = dir;
    } else {
      _purgeableDir = dir;
    }
    return dir;
  }

  /// Returns the stored file for [key], or null if nothing is stored yet.
  /// Looks only in the [persistent]-selected store: callers that don't know
  /// which store holds a key must check both (see [AttachmentUploadService]).
  Future<File?> get(String key, {bool persistent = false, String extension = ''}) async {
    _validateKeyAndExtension(key, extension);
    final dir = await _dir(persistent: persistent);
    final file = _fileFor(dir, key, extension);
    return file.existsSync() ? file : null;
  }

  /// Writes [bytes] under [key] and returns the resulting file.
  Future<File> put(
    String key,
    Uint8List bytes, {
    bool persistent = false,
    String extension = '',
  }) async {
    _validateKeyAndExtension(key, extension);
    developer.log(
      'FileCacheService.put called: $key (persistent: $persistent)',
      name: 'FileCacheService',
    );
    final dir = await _dir(persistent: persistent);
    final file = _fileFor(dir, key, extension);
    return file.writeAsBytes(bytes, flush: true);
  }

  /// Deletes the stored file for [key] from BOTH stores, if present. Removing
  /// from both (rather than a caller-specified one) keeps deletion honest:
  /// privacy cleanup for a deleted note must not leave a decrypted copy
  /// behind just because the caller guessed the wrong store. Best-effort —
  /// the store is re-derivable, so a failed removal never fails the caller's
  /// own operation.
  Future<void> remove(String key, {String extension = ''}) async {
    developer.log('FileCacheService.remove called: $key', name: 'FileCacheService');
    if (!_validKey(key) || !_validExtension(extension)) {
      developer.log('Refused invalid cache key or extension', name: 'FileCacheService');
      return;
    }
    for (final persistent in const [false, true]) {
      final dir = await _dir(persistent: persistent);
      final file = _fileFor(dir, key, extension);
      try {
        if (await file.exists()) await file.delete();
      } catch (e) {
        developer.log('Could not remove stored file $key: $e', name: 'FileCacheService');
      }
    }
  }

  File _fileFor(Directory directory, String key, String extension) {
    _validateKeyAndExtension(key, extension);
    return File('${directory.path}/$key$extension');
  }

  void _validateKeyAndExtension(String key, String extension) {
    if (!_validKey(key) || !_validExtension(extension)) {
      throw ArgumentError('Invalid cache key or extension.');
    }
  }

  bool _validKey(String key) => RegExp(r'^[0-9a-f]{64}$').hasMatch(key);

  bool _validExtension(String extension) =>
      extension.isEmpty || RegExp(r'^\.[a-zA-Z0-9]{1,10}$').hasMatch(extension);
}
