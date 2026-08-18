// Part of note_editor_screen.dart — the note-colour picker widgets
// (swatch options, the circular colour-reveal animation and its clipper),
// split out to keep the editor library's main file focused on the screen
// itself. `part of` deliberately, not a standalone library: these stay
// file-private to the editor and share its imports unchanged.
part of 'note_editor_screen.dart';

/// A single swatch in [_NoteEditorScreenState._pickColor]'s bottom sheet:
/// a colored circle (or, for [color] null, an outlined one with a "reset"
/// icon — the "no override, use the app's normal surface" option) with its
/// label underneath and a check overlay when it's the current selection.
class _ColorSwatchOption extends StatelessWidget {
  const _ColorSwatchOption({
    required this.color,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final NoteColor? color;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final swatchColor = color?.background;
    final iconColor = color?.onBackground ?? colorScheme.onSurfaceVariant;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: swatchColor ?? colorScheme.surface,
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected ? colorScheme.primary : colorScheme.outlineVariant,
                  width: selected ? 3 : 1,
                ),
              ),
              child: Icon(
                swatchColor == null ? Icons.format_color_reset_outlined : Icons.check,
                color: swatchColor == null
                    ? iconColor
                    : (selected ? iconColor : Colors.transparent),
                size: 20,
              ),
            ),
            const SizedBox(height: 4),
            Text(label, style: Theme.of(context).textTheme.labelSmall),
          ],
        ),
      ),
    );
  }
}

/// Paints [child] over a solid fill of [color] that transitions to a newly
/// picked [color] with a circular "reverb" — a ring of the new color
/// growing outward from dead center until it covers the whole area —
/// instead of just snapping. Used behind the note editor's body so
/// choosing a color (see [_NoteEditorScreenState._pickColor]) visibly
/// *happens* rather than silently becoming true on the next frame.
///
/// Purely a background effect: [child] (the actual title/body/checklist
/// content, already re-colored for legibility by
/// [_NoteEditorScreenState._applyNoteColorTheme]) sits on top, unclipped,
/// and updates its own text color on the normal build cycle — only the
/// fill underneath animates.
class _NoteColorReveal extends StatefulWidget {
  const _NoteColorReveal({required this.color, required this.child, this.backgroundPhotoPath});

  final Color color;
  final Widget child;

  /// Optional user-chosen photo, painted over the colour fill and under the
  /// note's content (see [noteBackgroundProvider]). Null for the usual case
  /// of a plain colour.
  final String? backgroundPhotoPath;

  @override
  State<_NoteColorReveal> createState() => _NoteColorRevealState();
}

class _NoteColorRevealState extends State<_NoteColorReveal> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 450),
  );
  late final Animation<double> _progress = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeOutCubic,
  );

  late Color _fromColor = widget.color;
  late Color _toColor = widget.color;

  @override
  void didUpdateWidget(covariant _NoteColorReveal oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.color == widget.color) return;
    // Jumping in from wherever the previous reveal had gotten to (rather
    // than always restarting from the old target) means picking a second
    // color before the first reveal finishes doesn't stutter back to a
    // half-applied color first.
    _fromColor = Color.lerp(_fromColor, _toColor, _progress.value) ?? _toColor;
    _toColor = widget.color;
    _controller.forward(from: 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        AnimatedBuilder(
          animation: _progress,
          builder: (context, _) {
            return Stack(
              fit: StackFit.expand,
              children: [
                ColoredBox(color: _fromColor),
                if (_progress.value > 0)
                  ClipPath(
                    clipper: _CircleRevealClipper(fraction: _progress.value),
                    child: ColoredBox(color: _toColor),
                  ),
              ],
            );
          },
        ),
        if (widget.backgroundPhotoPath != null)
          _NoteBackgroundPhoto(path: widget.backgroundPhotoPath!),
        widget.child,
      ],
    );
  }
}

/// A note's custom background photo: covers the screen, with a scrim over it
/// so body text stays legible whatever the picture happens to be. The scrim
/// follows the theme, so it darkens a photo in dark mode and lightens it in
/// light mode rather than fighting the text colour.
///
/// A missing file (storage cleared, photo removed) simply paints nothing —
/// the note falls back to its colour instead of showing a broken image.
class _NoteBackgroundPhoto extends StatelessWidget {
  const _NoteBackgroundPhoto({required this.path});

  final String path;

  @override
  Widget build(BuildContext context) {
    final file = File(path);
    if (!file.existsSync()) return const SizedBox.shrink();
    final surface = Theme.of(context).colorScheme.surface;
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.file(file, fit: BoxFit.cover, errorBuilder: (_, _, _) => const SizedBox.shrink()),
        ColoredBox(color: surface.withValues(alpha: 0.72)),
      ],
    );
  }
}

/// Clips to a circle centered on the widget's own center, growing from
/// radius 0 (at [fraction] 0) to fully covering every corner (at
/// [fraction] 1) — corners are equidistant from a true center, so one
/// radius calculation covers all four regardless of aspect ratio.
class _CircleRevealClipper extends CustomClipper<Path> {
  const _CircleRevealClipper({required this.fraction});

  final double fraction;

  @override
  Path getClip(Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = center.distance; // (0,0) to center == any corner to center
    return Path()..addOval(Rect.fromCircle(center: center, radius: maxRadius * fraction));
  }

  @override
  bool shouldReclip(covariant _CircleRevealClipper oldClipper) => oldClipper.fraction != fraction;
}

/// The "use a photo" (and "remove photo") entry in the colour sheet, shaped
/// like a swatch so it reads as one more choice in the same row rather than a
/// separate feature bolted on beside them.
class _PhotoBackgroundOption extends StatelessWidget {
  const _PhotoBackgroundOption({
    required this.label,
    required this.selected,
    required this.onTap,
    this.icon = Icons.image_outlined,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        width: 72,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colorScheme.surfaceContainerHighest,
                border: Border.all(
                  color: selected ? colorScheme.primary : colorScheme.outlineVariant,
                  width: selected ? 3 : 1,
                ),
              ),
              child: Icon(icon, size: 22, color: colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              maxLines: 2,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
