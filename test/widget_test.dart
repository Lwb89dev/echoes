// Smoke test: verifies the app starts and shows the onboarding carousel's
// intro page when there is no saved state yet (empty SharedPreferences,
// mocked below) — see OnboardingNotifier for the completion flag that
// would otherwise skip straight to HomeScreen.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:echoes/main.dart';

void main() {
  testWidgets('shows the onboarding intro on first launch', (WidgetTester tester) async {
    // OnboardingNotifier.build() and AuthNotifier.build() read from
    // SharedPreferences: without this mock, calling an unregistered
    // platform channel leaves the provider stuck in a loading state.
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(
      const ProviderScope(child: EchoesApp()),
    );
    await tester.pumpAndSettle();

    expect(find.text('Welcome to Echoes'), findsOneWidget);
    expect(find.text('Next'), findsOneWidget);
  });
}
