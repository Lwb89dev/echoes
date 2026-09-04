import 'package:flutter/material.dart';

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
      color: color.withValues(alpha: 0.08 * intensity),
      blurRadius: 18,
      offset: const Offset(0, 7),
    ),
    BoxShadow(
      color: Colors.white.withValues(alpha: 0.2 * intensity),
      blurRadius: 1,
      offset: const Offset(0, -1),
    ),
  ];

  static List<BoxShadow> tealShadow() => [
    BoxShadow(color: deepTeal.withValues(alpha: 0.28), blurRadius: 16, offset: const Offset(0, 7)),
    BoxShadow(
      color: Colors.white.withValues(alpha: 0.18),
      blurRadius: 1,
      offset: const Offset(0, -1),
    ),
  ];
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
    final surfaceColor = color ?? (inset ? scheme.surfaceContainer : scheme.surfaceContainerLowest);
    final decoration = BoxDecoration(
      color: surfaceColor,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: scheme.outlineVariant.withValues(alpha: inset ? 0.35 : 0.22)),
      boxShadow: inset
          ? null
          : EchoesTokens.raisedShadow(scheme.shadow, intensity: shadowIntensity),
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
  final scheme = ColorScheme.fromSeed(seedColor: EchoesTokens.teal, brightness: brightness)
      .copyWith(
        primary: isDark ? const Color(0xFF79D8D3) : EchoesTokens.teal,
        onPrimary: isDark ? EchoesTokens.deepTeal : Colors.white,
        primaryContainer: isDark ? const Color(0xFF0D5152) : const Color(0xFFC5E9E5),
        onPrimaryContainer: isDark ? const Color(0xFFC9F6F1) : EchoesTokens.deepTeal,
        secondary: isDark ? const Color(0xFFB7CBC8) : const Color(0xFF526B6B),
        onSecondary: isDark ? const Color(0xFF223836) : Colors.white,
        secondaryContainer: isDark ? const Color(0xFF334A49) : const Color(0xFFD7E8E4),
        onSecondaryContainer: isDark ? const Color(0xFFD6EAE7) : const Color(0xFF183331),
        tertiary: isDark ? const Color(0xFF91E0DA) : EchoesTokens.aqua,
        onTertiary: isDark ? EchoesTokens.deepTeal : Colors.white,
        surface: isDark ? EchoesTokens.darkSurface : EchoesTokens.ivory,
        onSurface: isDark ? const Color(0xFFF7F1E8) : EchoesTokens.ink,
        onSurfaceVariant: isDark ? const Color(0xFFBBCDCA) : EchoesTokens.inkMuted,
        surfaceContainerLowest: isDark ? EchoesTokens.darkInset : EchoesTokens.paperRaised,
        surfaceContainerLow: isDark ? const Color(0xFF112D2E) : const Color(0xFFF9F6F0),
        surfaceContainer: isDark ? EchoesTokens.darkRaised : EchoesTokens.paper,
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
      backgroundColor: scheme.surface,
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
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(EchoesTokens.radiusMd)),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: scheme.surfaceContainerLowest,
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
