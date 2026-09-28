import 'package:flutter/material.dart';

import '../theme/echoes_theme.dart';

/// Local (open ring) or Echoed (filled ring). One quiet ripple the moment a
/// note first becomes echoed while this widget is on screen — never on
/// launch, and never on a loop.
class EchoMark extends StatefulWidget {
  const EchoMark({
    super.key,
    required this.identity,
    required this.echoed,
    required this.label,
    this.color,
    this.size = 16,
    this.announce = true,
  });

  /// Note id. When a list recycles this widget onto another note, the
  /// ripple must not play just because the new note's sync bit differs.
  final String identity;
  final bool echoed;
  final String label;
  final Color? color;
  final double size;
  final bool announce;

  @override
  State<EchoMark> createState() => _EchoMarkState();
}

class _EchoMarkState extends State<EchoMark> with SingleTickerProviderStateMixin {
  late final AnimationController _ripple = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 280),
  );
  bool _armed = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _armed = true;
    });
  }

  @override
  void didUpdateWidget(EchoMark oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.identity != widget.identity) return;
    final becameEchoed = _armed && !oldWidget.echoed && widget.echoed;
    if (!becameEchoed || !echoesMotionEnabled(context)) return;
    _ripple.forward(from: 0);
  }

  @override
  void dispose() {
    _ripple.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = EchoesPalette.of(context);
    final color = widget.color ?? (widget.echoed ? palette.syncEchoed : palette.syncLocal);
    final mark = SizedBox.square(
      dimension: widget.size,
      child: AnimatedBuilder(
        animation: _ripple,
        builder: (context, _) {
          return CustomPaint(
            painter: _EchoPainter(echoed: widget.echoed, color: color, ripple: _ripple.value),
          );
        },
      ),
    );
    if (!widget.announce) return mark;
    return Semantics(
      label: widget.label,
      child: ExcludeSemantics(child: mark),
    );
  }
}

class _EchoPainter extends CustomPainter {
  const _EchoPainter({required this.echoed, required this.color, required this.ripple});

  final bool echoed;
  final Color color;
  final double ripple;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.28;
    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;
    if (ripple > 0 && ripple < 1) {
      final ring = Paint()
        ..color = color.withValues(alpha: (1 - ripple) * 0.7)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2;
      canvas.drawCircle(center, radius + ripple * size.width * 0.45, ring);
    }
    canvas.drawCircle(center, radius, stroke);
    if (!echoed) return;
    canvas.drawCircle(center, radius * 0.55, Paint()..color = color);
  }

  @override
  bool shouldRepaint(_EchoPainter oldDelegate) {
    return oldDelegate.echoed != echoed ||
        oldDelegate.color != color ||
        oldDelegate.ripple != ripple;
  }
}
