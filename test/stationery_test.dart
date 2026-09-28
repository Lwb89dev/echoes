import 'package:echoes/models/note.dart';
import 'package:echoes/theme/echoes_theme.dart';
import 'package:echoes/utils/note_colors.dart';
import 'package:echoes/utils/voice_bars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('every note color keeps readable text', () {
    for (final color in NoteColor.values) {
      final background = color.background;
      final ink = color.onBackground;
      final ratio = _contrast(background.computeLuminance(), ink.computeLuminance());
      expect(ratio, greaterThanOrEqualTo(4.5), reason: color.name);
      final muted = mutedTextColorOn(background);
      final mutedRatio = _contrast(background.computeLuminance(), muted.computeLuminance());
      expect(mutedRatio, greaterThanOrEqualTo(4.5), reason: '${color.name} muted');
    }
  });

  test('ui ink stays readable on the glass and on the glow', () {
    void check(EchoesPalette palette, List<Color> grounds) {
      final inks = [palette.textPrimary, palette.textSecondary, palette.textMuted];
      for (final ground in grounds) {
        for (final ink in inks) {
          final ratio = _contrast(ground.computeLuminance(), ink.computeLuminance());
          expect(
            ratio,
            greaterThanOrEqualTo(4.5),
            reason: '${ink.toARGB32()} on ${ground.toARGB32()}',
          );
        }
      }
    }

    check(EchoesPalette.light, [EchoesPalette.light.surfacePaper, ...EchoesPalette.lightGlow]);
    check(EchoesPalette.dark, [EchoesPalette.dark.surfacePaper, ...EchoesPalette.darkGlow]);
  });

  test('a saved color name still loads', () {
    final note = Note.fromJson({
      'id': 'n',
      'title': 'T',
      'body': '',
      'createdAt': '2026-01-01T00:00:00.000Z',
      'updatedAt': '2026-01-01T00:00:00.000Z',
      'color': 'brown',
    });
    expect(note.color, NoteColor.brown);
  });

  test('voice bars are stable and stay inside the painter range', () {
    final first = voiceBarHeights('memo-1');
    final again = voiceBarHeights('memo-1');
    expect(again, first);
    expect(voiceBarHeights('memo-2'), isNot(first));
    for (final bar in first) {
      expect(bar, inInclusiveRange(0.15, 1));
    }
    expect(voiceDurationLabel(37), '0:37');
    expect(voiceDurationLabel(null), isEmpty);
  });
}

double _contrast(double a, double b) {
  final lighter = a > b ? a : b;
  final darker = a > b ? b : a;
  return (lighter + 0.05) / (darker + 0.05);
}
