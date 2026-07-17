import 'package:flutter/widgets.dart';

/// Desktop windows are routinely 3-4x wider than the phone screens this UI
/// was originally built for. Centering content at a readable maximum width
/// — rather than letting a single column of list tiles or a note's body
/// text stretch edge-to-edge across a maximized window — is what keeps
/// both readable there, while staying a complete no-op at any narrower
/// width: [ConstrainedBox] only ever *caps* the width, so on a phone
/// (always under [maxWidth]) this centers nothing and changes nothing.
class MaxWidthCenter extends StatelessWidget {
  const MaxWidthCenter({super.key, required this.child, this.maxWidth = 720});

  final Widget child;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}

/// Column count for the notes grid, scaled to the available [width]
/// instead of a fixed count: two columns is right for a phone, but wastes
/// most of a maximized desktop window. Targets roughly [targetTileWidth]
/// per column, clamped to [minColumns]/[maxColumns] so it never collapses
/// under a narrow split-screen phone width or turns into a wall of tiny
/// tiles on an ultrawide monitor.
int gridColumnsForWidth(
  double width, {
  double targetTileWidth = 220,
  int minColumns = 2,
  int maxColumns = 6,
}) {
  final columns = (width / targetTileWidth).floor();
  return columns.clamp(minColumns, maxColumns);
}
