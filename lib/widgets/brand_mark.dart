import 'package:flutter/material.dart';

/// The Echoes notebook-and-quill mark, presented on a subtle tonal surface
/// instead of as a standalone app tile.
class BrandMark extends StatelessWidget {
  const BrandMark({super.key, this.size = 112});

  final double size;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final radius = BorderRadius.circular(size * 0.3);

    return SizedBox.square(
      dimension: size,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: radius,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              scheme.primary.withValues(alpha: 0.16),
              scheme.primary.withValues(alpha: 0.04),
            ],
          ),
          border: Border.all(color: scheme.primary.withValues(alpha: 0.12)),
        ),
        child: Padding(
          padding: EdgeInsets.all(size * 0.035),
          child: Image.asset(
            'assets/splash/splash_icon.png',
            fit: BoxFit.contain,
            filterQuality: FilterQuality.high,
          ),
        ),
      ),
    );
  }
}
