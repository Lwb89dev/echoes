import 'dart:math' as math;

/// Deterministic bar heights in `0.15…1` for a voice-note preview.
///
/// Derived from [seed] (an attachment id) so the same memo always draws the
/// same silhouette, with no audio decode on the list. Real waveforms stay
/// in the editor, where a single note is open and the cost is paid once.
List<double> voiceBarHeights(String seed, {int count = 24}) {
  var hash = 2166136261;
  for (final unit in seed.codeUnits) {
    hash = (hash ^ unit) * 16777619;
  }
  hash &= 0x7fffffff;
  final bars = <double>[];
  for (var i = 0; i < count; i++) {
    hash = (hash * 1103515245 + 12345 + i * 97) & 0x7fffffff;
    final noise = (hash % 1000) / 1000;
    final across = count == 1 ? 0.5 : i / (count - 1);
    final envelope = 0.45 + 0.55 * math.sin(across * math.pi);
    bars.add(0.18 + 0.82 * noise * envelope);
  }
  return bars;
}

/// `m:ss` for a voice-note duration. Empty when the length was never stored.
String voiceDurationLabel(int? seconds) {
  if (seconds == null || seconds < 0) return '';
  final minutes = seconds ~/ 60;
  final remain = seconds % 60;
  return '$minutes:${remain.toString().padLeft(2, '0')}';
}
