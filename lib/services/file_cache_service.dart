import 'dart:developer' as developer;
import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';

/// A flat, app-private disk cache keyed by an opaque string id (the caller
/// picks the id — e.g. a sha256 hash of a URL, or of the encrypted blob it
/// downloaded — so the same cache serves both the profile avatar and
/// decrypted attachment files without knowing anything about either).
///
/// Lives under [getApplicationCacheDirectory], which is explicitly OS-level
/// "safe to delete under storage pressure" and never exposed to other apps
/// or the user's shared photo library — unlike, say, the public downloads
/// or pictures directory.
class FileCacheService {
  Directory? _cacheDir;

  Future<Directory> get _dir async {
    final cached = _cacheDir;
    if (cached != null) return cached;
    final base = await getApplicationCacheDirectory();
    final dir = Directory('${base.path}/echoes_files');
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    _cacheDir = dir;
    return dir;
  }

  /// Returns the cached file for [key], or null if nothing is cached yet.
  Future<File?> get(String key, {String extension = ''}) async {
    final dir = await _dir;
    final file = File('${dir.path}/$key$extension');
    return file.existsSync() ? file : null;
  }

  /// Writes [bytes] to the cache under [key] and returns the resulting file.
  Future<File> put(String key, Uint8List bytes, {String extension = ''}) async {
    developer.log('FileCacheService.put called: $key', name: 'FileCacheService');
    final dir = await _dir;
    final file = File('${dir.path}/$key$extension');
    return file.writeAsBytes(bytes, flush: true);
  }

  /// Deletes the cached file for [key], if any. Best-effort: the cache is
  /// re-derivable by design, so a failed removal is never worth failing
  /// the caller's own operation over — but a *deliberate* removal matters
  /// for privacy (e.g. a deleted note's decrypted attachments must not
  /// keep sitting on disk until the OS happens to purge the cache dir).
  Future<void> remove(String key, {String extension = ''}) async {
    developer.log('FileCacheService.remove called: $key', name: 'FileCacheService');
    final dir = await _dir;
    final file = File('${dir.path}/$key$extension');
    try {
      if (await file.exists()) await file.delete();
    } catch (e) {
      developer.log('Could not remove cached file $key: $e', name: 'FileCacheService');
    }
  }
}
