import 'dart:async';
import 'dart:developer' as developer;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/relay.dart';
import 'notes_provider.dart';
import 'service_providers.dart';

/// List of relays configured by the user (managed from Settings' relay
/// section). Loaded from SharedPreferences on first `watch`; if
/// empty/absent, the UI can offer [defaultRelayUrls] as a starting point.
class RelayNotifier extends AsyncNotifier<List<Relay>> {
  @override
  Future<List<Relay>> build() async {
    developer.log('RelayNotifier.build called', name: 'RelayNotifier');
    final localStorageService = ref.read(localStorageServiceProvider);
    return localStorageService.loadRelays();
  }

  Future<void> addRelay(String url) async {
    developer.log('RelayNotifier.addRelay called: $url', name: 'RelayNotifier');
    final current = state.value ?? const <Relay>[];
    // Adding a relay that's already configured is a no-op, not a duplicate
    // row — and must not kick off a pointless republish to a relay that
    // already has everything.
    if (current.any((r) => r.url == url)) return;

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final localStorageService = ref.read(localStorageServiceProvider);
      final updated = [...current, Relay(url: url)];
      await localStorageService.saveRelays(updated);
      return updated;
    });
    // A freshly added relay starts empty: the normal per-note sync only ever
    // reaches it on each note's *next* edit, so without this a new relay
    // (e.g. one added because relay.damus.io was flaky) would silently carry
    // none of the user's already-synced history. Backfill it in the
    // background — best-effort, never surfaced as an add-relay failure, and
    // only when the relay was actually added (guarded above).
    if (state.hasValue) unawaited(_backfillNewRelay());
  }

  /// Republishes every already-synced note to all configured relays (the new
  /// one included), so it stops here rather than throwing into the unawaited
  /// gap: no account, no network, or nothing synced yet are all normal
  /// states in which there's simply nothing to backfill.
  Future<void> _backfillNewRelay() async {
    try {
      final count = await ref.read(notesProvider.notifier).republishAllToRelays();
      developer.log('Backfilled newly added relay with $count note(s)', name: 'RelayNotifier');
    } catch (e) {
      developer.log('Could not backfill newly added relay: $e', name: 'RelayNotifier');
    }
  }

  Future<void> removeRelay(String url) async {
    developer.log('RelayNotifier.removeRelay called: $url', name: 'RelayNotifier');
    final current = state.value ?? const <Relay>[];
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final localStorageService = ref.read(localStorageServiceProvider);
      final updated = current.where((r) => r.url != url).toList();
      await localStorageService.saveRelays(updated);
      return updated;
    });
  }
}

final relayProvider = AsyncNotifierProvider<RelayNotifier, List<Relay>>(RelayNotifier.new);
