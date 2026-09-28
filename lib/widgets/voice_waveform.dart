import 'package:flutter/material.dart';

import '../utils/voice_bars.dart';

/// A static voice silhouette. Bars come from [voiceBarHeights], so painting
/// a list of memos never touches the audio file.
class VoiceWaveform extends StatelessWidget {
  const VoiceWaveform({
    super.key,
    required this.seed,
    required this.color,
    this.durationLabel = '',
    this.barCount = 22,
    this.height = 28,
  });

  final String seed;
  final Color color;
  final String durationLabel;
  final int barCount;
  final double height;

  @override
  Widget build(BuildContext context) {
    final bars = voiceBarHeights(seed, count: barCount);
    return Row(
      children: [
        Icon(Icons.play_arrow_rounded, size: height, color: color),
        const SizedBox(width: 4),
        Expanded(
          child: SizedBox(
            height: height,
            child: CustomPaint(
              painter: _BarsPainter(bars: bars, color: color),
            ),
          ),
        ),
        if (durationLabel.isNotEmpty) ...[
          const SizedBox(width: 8),
          Text(
            durationLabel,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(color: color),
          ),
        ],
      ],
    );
  }
}

class _BarsPainter extends CustomPainter {
  const _BarsPainter({required this.bars, required this.color});

  final List<double> bars;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (bars.isEmpty) return;
    final paint = Paint()
      ..color = color
      ..strokeCap = StrokeCap.round;
    final gap = size.width / bars.length;
    final barWidth = gap * 0.46;
    paint.strokeWidth = barWidth;
    for (var i = 0; i < bars.length; i++) {
      final x = gap * i + gap / 2;
      final barHeight = size.height * bars[i];
      final top = (size.height - barHeight) / 2;
      canvas.drawLine(Offset(x, top), Offset(x, top + barHeight), paint);
    }
  }

  @override
  bool shouldRepaint(_BarsPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.bars != bars;
}
