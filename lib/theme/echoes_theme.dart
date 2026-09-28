import 'dart:ui';

import 'package:flutter/material.dart';

import '../utils/note_colors.dart';

/// The small set of visual tokens shared by every Echoes surface. Keeping
/// these values here prevents individual screens from slowly becoming a
/// collection of unrelated Material defaults.
abstract final class EchoesTokens {
  static const teal = Color(0xFF006F70);
  static const deepTeal = Color(0xFF003F40);
  static const aqua = Color(0xFF4E9A98);
  static const ivory = Color(0xFFFFFAF3);
  static const paper = Color(0xFFF6F0E7);
  static const paperRaised = Color(0xFFFFFDF8);
  static const paperInset = Color(0xFFEDE7DD);
  static const ink = Color(0xFF173536);
  static const inkMuted = Color(0xFF667977);
  static const darkSurface = Color(0xFF0B2526);
  static const darkRaised = Color(0xFF173233);
  static const darkInset = Color(0xFF061B1C);

  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 24.0;
  static const xxl = 32.0;

  static const radiusSm = 12.0;
  static const radiusMd = 18.0;
  static const radiusLg = 24.0;
  static const radiusPill = 999.0;

  static const shortMotion = Duration(milliseconds: 180);
  static const standardMotion = Duration(milliseconds: 280);
  static const motionCurve = Curves.easeOutCubic;

  static List<BoxShadow> raisedShadow(Color color, {double intensity = 1}) => [
    BoxShadow(
      color: color.withValues(alpha: 0.05 * intensity),
      blurRadius: 14,
      offset: const Offset(0, 6),
    ),
    BoxShadow(
      color: color.withValues(alpha: 0.04 * intensity),
      blurRadius: 2,
      offset: const Offset(0, 1),
    ),
  ];

  static List<BoxShadow> liftedShadow(Color color) => [
    BoxShadow(color: color.withValues(alpha: 0.16), blurRadius: 22, offset: const Offset(0, 12)),
    BoxShadow(color: color.withValues(alpha: 0.06), blurRadius: 4, offset: const Offset(0, 2)),
  ];
}

/// Semantic colors for the stationery desk. Screens read these instead of
/// picking their own hex values. Dark is its own warm ink palette, not an
/// inversion of the ivory one.
class EchoesPalette {
  const EchoesPalette({
    required this.backgroundPrimary,
    required this.backgroundSecondary,
    required this.surfacePaper,
    required this.surfaceElevated,
    required this.surfacePressed,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.accentPrimary,
    required this.accentSecondary,
    required this.accentSoft,
    required this.borderSubtle,
    required this.shadowSoft,
    required this.semanticSuccess,
    required this.semanticWarning,
    required this.semanticError,
    required this.syncLocal,
    required this.syncEchoed,
    required this.onAccent,
    required this.accentContainer,
    required this.onAccentContainer,
  });

  final Color backgroundPrimary;
  final Color backgroundSecondary;
  final Color surfacePaper;
  final Color surfaceElevated;
  final Color surfacePressed;
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color accentPrimary;
  final Color accentSecondary;
  final Color accentSoft;
  final Color borderSubtle;
  final Color shadowSoft;
  final Color semanticSuccess;
  final Color semanticWarning;
  final Color semanticError;
  final Color syncLocal;
  final Color syncEchoed;
  final Color onAccent;
  final Color accentContainer;
  final Color onAccentContainer;

  static const light = EchoesPalette(
    backgroundPrimary: Color(0xFFF6EEFF),
    backgroundSecondary: Color(0xFFFFE4F1),
    surfacePaper: Color(0xFFF8F2FF),
    surfaceElevated: Color(0xFFFFF7FB),
    surfacePressed: Color(0xFFE7D8FF),
    textPrimary: Color(0xFF1C1233),
    textSecondary: Color(0xFF3A2A58),
    textMuted: Color(0xFF4A3868),
    accentPrimary: Color(0xFF6A35F0),
    accentSecondary: Color(0xFFFF4F78),
    accentSoft: Color(0xFFE6D6FF),
    borderSubtle: Color(0x66FFFFFF),
    shadowSoft: Color(0xFF3A1870),
    semanticSuccess: Color(0xFF1F8A4C),
    semanticWarning: Color(0xFFB86A00),
    semanticError: Color(0xFFC6284A),
    syncLocal: Color(0xFF4A3868),
    syncEchoed: Color(0xFF6A35F0),
    onAccent: Color(0xFFFFFFFF),
    accentContainer: Color(0xFFE9DCFF),
    onAccentContainer: Color(0xFF2A1166),
  );

  static const dark = EchoesPalette(
    backgroundPrimary: Color(0xFF160C28),
    backgroundSecondary: Color(0xFF2A1244),
    surfacePaper: Color(0xFF241438),
    surfaceElevated: Color(0xFF321C4C),
    surfacePressed: Color(0xFF1C1030),
    textPrimary: Color(0xFFF8F2FF),
    textSecondary: Color(0xFFE4D8FF),
    textMuted: Color(0xFFD2C4F2),
    accentPrimary: Color(0xFFC4A6FF),
    accentSecondary: Color(0xFFFF8AA8),
    accentSoft: Color(0xFF3A2468),
    borderSubtle: Color(0x55FFFFFF),
    shadowSoft: Color(0xFF000000),
    semanticSuccess: Color(0xFF8EE8B0),
    semanticWarning: Color(0xFFFFC56A),
    semanticError: Color(0xFFFF8A9E),
    syncLocal: Color(0xFFD2C4F2),
    syncEchoed: Color(0xFFC4A6FF),
    onAccent: Color(0xFF2A1160),
    accentContainer: Color(0xFF3A2270),
    onAccentContainer: Color(0xFFF3E9FF),
  );

  /// Aurora behind the glass. Light stops stay pale so dark ink still reads;
  /// dark stops stay deep so light ink still reads.
  static const lightGlow = <Color>[
    Color(0xFFFFD0E6),
    Color(0xFFE4D0FF),
    Color(0xFFFFE0C4),
    Color(0xFFD4E2FF),
  ];

  static const darkGlow = <Color>[
    Color(0xFF2A0E44),
    Color(0xFF4A1868),
    Color(0xFF6A2458),
    Color(0xFF1A1860),
  ];

  static EchoesPalette of(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? dark : light;
  }
}

/// False when the system asks for reduced motion. New motion should check
/// this and skip the flourish; the state change itself still happens.
bool echoesMotionEnabled(BuildContext context) => !MediaQuery.disableAnimationsOf(context);

/// The wash every screen sits on. One gradient for the whole app, so cards
/// can stay solid enough to read and still feel like glass over light.
class EchoesBackdrop extends StatelessWidget {
  const EchoesBackdrop({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: dark ? EchoesPalette.darkGlow : EchoesPalette.lightGlow,
        ),
      ),
      child: const SizedBox.expand(),
    );
  }
}

/// Frosted chrome: search, the tab bar, a menu chip. Blur stays on these
/// few surfaces. Note cards do not use it — a blur per card while scrolling
/// is how a list gets sticky.
class GlassPane extends StatelessWidget {
  const GlassPane({
    super.key,
    required this.child,
    this.radius = EchoesTokens.radiusPill,
    this.padding,
  });

  final Widget child;
  final double radius;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final radius = BorderRadius.circular(this.radius);
    final fill = dark ? const Color(0xCC241438) : const Color(0xBFFFFFFF);
    final edge = dark ? const Color(0x55FFFFFF) : const Color(0xEEFFFFFF);
    return ClipRRect(
      borderRadius: radius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: radius,
            border: Border.all(color: edge),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withValues(alpha: dark ? 0.16 : 0.55),
                fill,
              ],
            ),
          ),
          child: Padding(padding: padding ?? EdgeInsets.zero, child: child),
        ),
      ),
    );
  }
}

/// The same top-to-bottom gloss the home cards use. The editor paints this
/// full-screen so an opened note is the card, not a flat fill.
LinearGradient echoesSheetGradient(Color tint) {
  final lightInk = readableTextColorOn(tint) == Colors.white;
  final top = lightInk
      ? Color.alphaBlend(Colors.white.withValues(alpha: 0.10), tint)
      : Color.alphaBlend(Colors.white.withValues(alpha: 0.42), tint);
  return LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [top, tint],
  );
}

/// A sheet of tinted glass. The fill stays close to [tint] so text chosen
/// for that tint still clears it; the gloss is a light top edge, not a wash
/// that fades the words.
BoxDecoration echoesGlassDecoration({
  required Color tint,
  required bool dark,
  double radius = EchoesTokens.radiusMd,
  Color? borderColor,
  List<BoxShadow>? shadow,
}) {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(radius),
    gradient: echoesSheetGradient(tint),
    border: Border.all(
      color: borderColor ?? (dark ? const Color(0x66FFFFFF) : const Color(0xEEFFFFFF)),
    ),
    boxShadow: shadow,
  );
}

class EchoesSurface extends StatelessWidget {
  const EchoesSurface({
    super.key,
    required this.child,
    this.padding,
    this.color,
    this.radius = EchoesTokens.radiusMd,
    this.inset = false,
    this.shadowIntensity = 1,
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final double radius;
  final bool inset;
  final double shadowIntensity;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = color ?? (inset ? scheme.surfaceContainer : scheme.surfaceContainerLowest);
    final decoration = inset
        ? BoxDecoration(
            color: surfaceColor,
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.35)),
          )
        : echoesGlassDecoration(
            tint: surfaceColor,
            dark: dark,
            radius: radius,
            shadow: EchoesTokens.raisedShadow(scheme.shadow, intensity: shadowIntensity),
          );
    final content = Padding(padding: padding ?? EdgeInsets.zero, child: child);
    return DecoratedBox(
      decoration: decoration,
      child: onTap == null
          ? content
          : Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(radius),
                onTap: onTap,
                child: content,
              ),
            ),
    );
  }
}

class EchoesSectionLabel extends StatelessWidget {
  const EchoesSectionLabel(this.label, {super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        EchoesTokens.lg,
        EchoesTokens.xl,
        EchoesTokens.lg,
        EchoesTokens.sm,
      ),
      child: Text(
        label.toUpperCase(),
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: scheme.primary,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.3,
        ),
      ),
    );
  }
}

ThemeData echoesTheme(Brightness brightness) {
  final isDark = brightness == Brightness.dark;
  final palette = isDark ? EchoesPalette.dark : EchoesPalette.light;
  final scheme = ColorScheme.fromSeed(seedColor: palette.accentPrimary, brightness: brightness)
      .copyWith(
        primary: palette.accentPrimary,
        onPrimary: palette.onAccent,
        primaryContainer: palette.accentContainer,
        onPrimaryContainer: palette.onAccentContainer,
        secondary: palette.accentSecondary,
        onSecondary: isDark ? const Color(0xFF3A1020) : Colors.white,
        secondaryContainer: isDark ? const Color(0xFF4A2040) : const Color(0xFFFFD6E4),
        onSecondaryContainer: isDark ? const Color(0xFFFFE4EE) : const Color(0xFF5A1830),
        tertiary: palette.semanticSuccess,
        onTertiary: isDark ? const Color(0xFF063018) : Colors.white,
        error: palette.semanticError,
        onError: isDark ? const Color(0xFF2C1210) : Colors.white,
        surface: palette.backgroundPrimary,
        onSurface: palette.textPrimary,
        onSurfaceVariant: palette.textSecondary,
        surfaceContainerLowest: palette.surfacePaper,
        surfaceContainerLow: palette.backgroundSecondary,
        surfaceContainer: isDark ? palette.surfacePaper : const Color(0xFFF3EBDF),
        surfaceContainerHigh: palette.surfaceElevated,
        surfaceContainerHighest: palette.surfacePressed,
        outline: palette.textMuted,
        outlineVariant: palette.borderSubtle,
        shadow: palette.shadowSoft,
      );
  final base = ThemeData(
    colorScheme: scheme,
    useMaterial3: true,
    scaffoldBackgroundColor: Colors.transparent,
  );
  final inputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(EchoesTokens.radiusMd),
    borderSide: BorderSide(color: scheme.outlineVariant.withValues(alpha: 0.7)),
  );
  final display = base.textTheme.displaySmall?.copyWith(
    fontFamily: 'serif',
    fontWeight: FontWeight.w600,
    letterSpacing: -0.5,
  );
  return base.copyWith(
    textTheme: base.textTheme
        .apply(bodyColor: scheme.onSurface, displayColor: scheme.onSurface)
        .copyWith(
          displaySmall: display,
          headlineMedium: display,
          headlineSmall: display,
          titleLarge: base.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: scheme.onSurface,
      surfaceTintColor: Colors.transparent,
      scrolledUnderElevation: 0,
      elevation: 0,
      centerTitle: false,
    ),
    cardTheme: CardThemeData(
      color: scheme.surfaceContainerLowest,
      elevation: 0,
      margin: EdgeInsets.zero,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(EchoesTokens.radiusMd)),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: scheme.surfaceContainerLowest,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(EchoesTokens.radiusLg)),
    ),
    dividerTheme: DividerThemeData(color: scheme.outlineVariant.withValues(alpha: 0.5), space: 1),
    listTileTheme: ListTileThemeData(
      iconColor: scheme.primary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(EchoesTokens.radiusMd)),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: EchoesTokens.lg,
        vertical: EchoesTokens.xs,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: scheme.surfaceContainerLowest,
      contentPadding: const EdgeInsets.symmetric(horizontal: EchoesTokens.lg, vertical: 15),
      border: inputBorder,
      enabledBorder: inputBorder,
      focusedBorder: inputBorder.copyWith(borderSide: BorderSide(color: scheme.primary, width: 2)),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
        padding: const EdgeInsets.symmetric(horizontal: EchoesTokens.xl, vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(EchoesTokens.radiusSm)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: scheme.primary,
        side: BorderSide(color: scheme.outlineVariant),
        padding: const EdgeInsets.symmetric(horizontal: EchoesTokens.xl, vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(EchoesTokens.radiusSm)),
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: scheme.primary,
      foregroundColor: scheme.onPrimary,
      elevation: 6,
      highlightElevation: 8,
      shape: const CircleBorder(),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      indicatorColor: scheme.primaryContainer,
      labelTextStyle: WidgetStatePropertyAll(
        base.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: scheme.inverseSurface,
      contentTextStyle: TextStyle(color: scheme.onInverseSurface),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(EchoesTokens.radiusSm)),
    ),
  );
}
