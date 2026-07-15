import 'dart:developer' as developer;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth_provider.dart';
import 'notes_provider.dart';
import 'relay_provider.dart';
import 'service_providers.dart';
import 'upload_settings_provider.dart';

/// Keeps [SyncService]'s background auto-sync (periodic polling +
/// reconnect-on-connectivity) started exactly when there is a logged-in
/// Nostr account, restarting it whenever the account or relay list changes
/// so added/removed relays take effect on the next cycle, and stopping it
/// entirely on logout.
///
/// Pure reactive wiring with no UI of its own — force-read once in
/// `main()` so it takes effect even before any widget happens to watch it.
/// Kept out of `service_providers.dart` to avoid a circular import (that
/// file would need to import `auth_provider.dart`, which already imports
/// it).
final syncLifecycleProvider = Provider<void>((ref) {
  final syncService = ref.watch(syncServiceProvider);

  void restart() {
    final author = ref.read(authProvider).value;
    if (author == null) {
      syncService.stopAutoSync();
      return;
    }
    final relays = ref.read(relayProvider).value ?? const [];
    final uploadProvider = ref.read(uploadProviderProvider);
    developer.log(
      'syncLifecycleProvider: (re)starting auto-sync for ${author.publicKeyHex}',
      name: 'syncLifecycleProvider',
    );
    syncService.startAutoSync(
      author: author,
      relays: relays,
      uploadProvider: uploadProvider,
      // Background cycles write uploaded-attachment state and fetched
      // notes straight to storage; the in-memory list must be told or the
      // home screen (and editors opened from it) keep serving pre-sync
      // snapshots. Guarded on `exists`: forcing notesProvider into
      // existence here would run its build() — which throws while the
      // encrypted box is still locked — and cache that error state for
      // the UI to trip over after unlocking. If nothing has created the
      // provider yet, there is no stale in-memory copy to refresh anyway.
      onCycleCompleted: () {
        if (ref.exists(notesProvider)) {
          ref.read(notesProvider.notifier).reloadFromLocal();
        }
      },
    );
  }

  ref.listen(authProvider, (previous, next) => restart(), fireImmediately: true);
  ref.listen(relayProvider, (previous, next) => restart());
  ref.listen(uploadProviderProvider, (previous, next) => restart());

  ref.onDispose(syncService.stopAutoSync);
});
