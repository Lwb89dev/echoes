import 'dart:developer' as developer;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'service_providers.dart';

/// Whether the first-launch onboarding carousel has been completed.
///
/// `false` on a fresh install routes [_AppRoot] to [OnboardingScreen];
/// `true` routes straight to [HomeScreen], regardless of whether the user
/// is logged in with a Nostr account or chose to stay local-only during
/// onboarding (see [AuthNotifier] / [NotesNotifier] for how local-only mode
/// is handled once past onboarding).
class OnboardingNotifier extends AsyncNotifier<bool> {
  @override
  Future<bool> build() async {
    developer.log('OnboardingNotifier.build called', name: 'OnboardingNotifier');
    return ref.read(localStorageServiceProvider).isOnboardingComplete();
  }

  /// Marks onboarding as done. Called once, at the end of the carousel.
  Future<void> complete() async {
    developer.log('OnboardingNotifier.complete called', name: 'OnboardingNotifier');
    await ref.read(localStorageServiceProvider).setOnboardingComplete();
    state = const AsyncData(true);
  }
}

final onboardingProvider = AsyncNotifierProvider<OnboardingNotifier, bool>(OnboardingNotifier.new);
