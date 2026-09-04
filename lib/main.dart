import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'l10n/app_localizations.dart';
import 'providers/locale_provider.dart';
import 'providers/onboarding_provider.dart';
import 'providers/service_providers.dart';
import 'providers/sync_lifecycle_provider.dart';
import 'providers/theme_provider.dart';
import 'screens/home_screen.dart';
import 'screens/onboarding_screen.dart';
import 'utils/app_messenger.dart';
import 'utils/constants.dart';
import 'theme/echoes_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Read the persisted language/theme preferences before the first frame,
  // so they can be seeded into the container below and the app never
  // flashes the system locale or the wrong theme before switching to the
  // user's saved choice.
  final initialLocale = await LocaleNotifier.loadInitialLocale();
  final initialThemeMode = await ThemeModeNotifier.loadInitialThemeMode();

  // Manually created container (instead of a bare `ProviderScope`) so we
  // can initialize LocalStorageService (opening the Hive box) *before*
  // mounting the widget tree, avoiding a race condition on the first frame,
  // and seed the locale/theme overrides in one place.
  final container = ProviderContainer(
    overrides: [
      localeProvider.overrideWith(() => LocaleNotifier(initialLocale)),
      themeModeProvider.overrideWith(() => ThemeModeNotifier(initialThemeMode)),
    ],
  );
  await container.read(localStorageServiceProvider).init();

  // Force-initializes the auto-sync reactive wiring (see
  // [syncLifecycleProvider]): it has no UI of its own, so nothing would
  // ever `watch` it into existence otherwise.
  container.read(syncLifecycleProvider);

  runApp(UncontrolledProviderScope(container: container, child: const EchoesApp()));
}

class EchoesApp extends ConsumerWidget {
  const EchoesApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      // Lets background work report its result on whatever screen the user
      // ended up on — see [showAppSnackBar].
      scaffoldMessengerKey: appMessengerKey,
      // GrapheneOS/privacy-friendly default: dark theme as the primary
      // theme (see [ThemeModeNotifier]) — light is available from Settings.
      themeMode: themeMode,
      theme: echoesTheme(Brightness.light),
      darkTheme: echoesTheme(Brightness.dark),
      // `null` locale means "follow the device locale"; set when the user
      // picks an explicit language in Settings (see [LocaleNotifier]).
      locale: locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        _FallbackMaterialLocalizationsDelegate(),
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: const _AppRoot(),
    );
  }
}

// ── Material localizations fallback ────────────────────────────────────────

/// A [LocalizationsDelegate] for [MaterialLocalizations] that accepts every
/// locale but falls back to English when [GlobalMaterialLocalizations] does
/// not natively support the requested one.
///
/// Needed for EU official languages Echoes supports (Irish `ga`, Maltese
/// `mt`) that are not yet part of `flutter_localizations`. Without this
/// fallback, selecting one of them crashes widgets like [AppBar] with
/// "NoMaterialLocalizationsFound". Echoes' own translations
/// ([AppLocalizations]) are unaffected — only built-in Material strings
/// (e.g. the back-button tooltip) fall back to English for those locales.
class _FallbackMaterialLocalizationsDelegate extends LocalizationsDelegate<MaterialLocalizations> {
  const _FallbackMaterialLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<MaterialLocalizations> load(Locale locale) {
    final effective = GlobalMaterialLocalizations.delegate.isSupported(locale)
        ? locale
        : const Locale('en');
    return GlobalMaterialLocalizations.delegate.load(effective);
  }

  @override
  bool shouldReload(_FallbackMaterialLocalizationsDelegate old) => false;
}

/// Picks the first screen based on onboarding state: not completed yet ->
/// [OnboardingScreen], completed -> [HomeScreen] (which works whether or
/// not the user is actually signed in with a Nostr account — see
/// [NotesNotifier] for how local-only mode is handled once past onboarding).
///
/// If [OnboardingNotifier.build] fails for any reason, we default to
/// showing onboarding again rather than a crash screen; it's a short,
/// idempotent flow (re-doing it costs nothing since it can't lose data).
class _AppRoot extends ConsumerWidget {
  const _AppRoot();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboardingState = ref.watch(onboardingProvider);

    return onboardingState.when(
      data: (completed) => completed ? const HomeScreen() : const OnboardingScreen(),
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, stackTrace) => const OnboardingScreen(),
    );
  }
}
