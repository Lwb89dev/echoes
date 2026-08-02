import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/attachment_upload_service.dart';
import '../services/file_cache_service.dart';
import '../services/local_storage_service.dart';
import '../services/note_encryption_service.dart';
import '../services/nostr_service.dart';
import '../services/sync_service.dart';

/// Providers for "infrastructure" services: each is a singleton for the
/// lifetime of the app. They live here (separate from the auth/notes/relay
/// state providers) so state providers can depend on them via
/// `ref.read`/`ref.watch` without manually instantiating them, and tests can
/// override them with `overrideWith`.

final noteEncryptionServiceProvider = Provider<NoteEncryptionService>((ref) {
  return NoteEncryptionService();
});

final localStorageServiceProvider = Provider<LocalStorageService>((ref) {
  return LocalStorageService(noteEncryptionService: ref.watch(noteEncryptionServiceProvider));
});

final nostrServiceProvider = Provider<NostrService>((ref) {
  return NostrService();
});

final fileCacheServiceProvider = Provider<FileCacheService>((ref) {
  return FileCacheService();
});

final attachmentUploadServiceProvider = Provider<AttachmentUploadService>((ref) {
  return AttachmentUploadService(
    nostrService: ref.watch(nostrServiceProvider),
    fileCacheService: ref.watch(fileCacheServiceProvider),
  );
});

final syncServiceProvider = Provider<SyncService>((ref) {
  final service = SyncService(
    localStorageService: ref.watch(localStorageServiceProvider),
    nostrService: ref.watch(nostrServiceProvider),
    attachmentUploadService: ref.watch(attachmentUploadServiceProvider),
  );
  ref.onDispose(service.dispose);
  return service;
});
