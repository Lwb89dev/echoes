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

  // Palette sampled from the app icon: deep teal, an aqua edge-light, warm
  // ivory paper, and a charcoal-teal ink. Keeping these explicit prevents
  // Material's generated green tones from drifting away from the brand.
  static const _brandTeal = Color(0xFF006F70);
  static const _deepTeal = Color(0xFF003F40);
  static const _aqua = Color(0xFF257F80);
  static const _ivory = Color(0xFFFFFAF3);
  static const _ink = Color(0xFF173536);

  static ThemeData _theme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final scheme = ColorScheme.fromSeed(seedColor: _brandTeal, brightness: brightness).copyWith(
      primary: isDark ? const Color(0xFF79D8D3) : _brandTeal,
      onPrimary: isDark ? _deepTeal : Colors.white,
      primaryContainer: isDark ? const Color(0xFF0D5152) : const Color(0xFFC5E9E5),
      onPrimaryContainer: isDark ? const Color(0xFFC9F6F1) : _deepTeal,
      secondary: isDark ? const Color(0xFFB7CBC8) : const Color(0xFF526B6B),
      onSecondary: isDark ? const Color(0xFF223836) : Colors.white,
      secondaryContainer: isDark ? const Color(0xFF334A49) : const Color(0xFFD7E8E4),
      onSecondaryContainer: isDark ? const Color(0xFFD6EAE7) : const Color(0xFF183331),
      tertiary: isDark ? const Color(0xFF91E0DA) : _aqua,
      onTertiary: isDark ? _deepTeal : Colors.white,
      tertiaryContainer: isDark ? const Color(0xFF165553) : const Color(0xFFBDEBE6),
      onTertiaryContainer: isDark ? const Color(0xFFC9F5EF) : const Color(0xFF003D3C),
      surface: isDark ? const Color(0xFF0B2526) : _ivory,
      onSurface: isDark ? const Color(0xFFF7F1E8) : _ink,
      onSurfaceVariant: isDark ? const Color(0xFFBBCDCA) : const Color(0xFF516765),
      surfaceContainerLowest: isDark ? const Color(0xFF061B1C) : Colors.white,
      surfaceContainerLow: isDark ? const Color(0xFF112D2E) : const Color(0xFFF9F6F0),
      surfaceContainer: isDark ? const Color(0xFF173233) : const Color(0xFFF2F0E9),
      surfaceContainerHigh: isDark ? const Color(0xFF1E3939) : const Color(0xFFECEFEA),
      surfaceContainerHighest: isDark ? const Color(0xFF294443) : const Color(0xFFE4EAE5),
      outline: isDark ? const Color(0xFF8EA7A3) : const Color(0xFF718582),
      outlineVariant: isDark ? const Color(0xFF3D5755) : const Color(0xFFC0D0CC),
    );
    final base = ThemeData(
      colorScheme: scheme,
      useMaterial3: true,
      scaffoldBackgroundColor: scheme.surface,
    );
    final roundedBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: scheme.outlineVariant),
    );

    return base.copyWith(
      textTheme: base.textTheme.apply(bodyColor: scheme.onSurface, displayColor: scheme.onSurface),
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
      ),
      cardTheme: CardThemeData(
        color: scheme.surfaceContainerLowest,
        elevation: 0,
        margin: EdgeInsets.zero,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: scheme.surfaceContainerLowest,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      dividerTheme: DividerThemeData(color: scheme.outlineVariant, space: 1),
      listTileTheme: ListTileThemeData(iconColor: scheme.primary),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainerLowest,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: roundedBorder,
        enabledBorder: roundedBorder,
        focusedBorder: roundedBorder.copyWith(
          borderSide: BorderSide(color: scheme.primary, width: 2),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: scheme.primary,
          side: BorderSide(color: scheme.outlineVariant),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: scheme.inverseSurface,
        contentTextStyle: TextStyle(color: scheme.onInverseSurface),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }

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
      theme: _theme(Brightness.light),
      darkTheme: _theme(Brightness.dark),
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
