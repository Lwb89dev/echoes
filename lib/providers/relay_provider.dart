import 'dart:developer' as developer;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/relay.dart';
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
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final localStorageService = ref.read(localStorageServiceProvider);
      final updated = [...current, Relay(url: url)];
      await localStorageService.saveRelays(updated);
      return updated;
    });
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
