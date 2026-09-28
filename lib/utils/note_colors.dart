import 'package:flutter/material.dart';

/// A user-selectable background for a single [Note]. `null` on [Note.color]
/// means "no override, use the desk surface".
///
/// The names are the original persisted values (`color.name` in the note
/// JSON). Renaming them would make existing notes fail to load, including
/// on an older install that syncs with this one. The stationery materials
/// in [stationeryPalette] are a curated view over those names — see each
/// swatch below. Colors outside that palette still render, for notes that
/// already use them, but the picker does not offer them for new choices.
enum NoteColor { yellow, red, purple, blue, green, orange, white, pink, teal, indigo, brown, lime }

/// Picker order. Stored names stay the enum values so relays and older
/// builds keep reading the field; the labels shown to people are the
/// materials (paper, sand, sage, …).
const List<NoteColor> stationeryPalette = [
  NoteColor.white,
  NoteColor.yellow,
  NoteColor.green,
  NoteColor.orange,
  NoteColor.purple,
  NoteColor.blue,
  NoteColor.brown,
];

extension NoteColorSwatch on NoteColor {
  /// Stained-glass sheets: saturated enough to feel like a color, still light
  /// or dark enough that [onBackground] clears WCAG AA. Names stay the stored
  /// enum values.
  Color get background => switch (this) {
    // Paper
    NoteColor.white => const Color(0xFFFFF4E8),
    // Sand — bright gold
    NoteColor.yellow => const Color(0xFFFFC44D),
    // Sage — vivid glass green
    NoteColor.green => const Color(0xFF8BE3A8),
    // Terracotta — warm coral
    NoteColor.orange => const Color(0xFFFF8F6B),
    // Lavender
    NoteColor.purple => const Color(0xFFD4B0FF),
    // Cobalt, the old "ocean" slot, deliberately not a teal
    NoteColor.blue => const Color(0xFF8EB0FF),
    // Charcoal — deep plum so the dark sheet matches the iris glass
    NoteColor.brown => const Color(0xFF2A1B45),
    NoteColor.red => const Color(0xFFFF8FA3),
    NoteColor.pink => const Color(0xFFFFA3D1),
    NoteColor.teal => const Color(0xFF7EE7EF),
    NoteColor.indigo => const Color(0xFFB0B4FF),
    NoteColor.lime => const Color(0xFFD6F26A),
  };

  /// The color to render text in on top of [background].
  Color get onBackground => readableTextColorOn(background);
}

/// Picks whichever of black or white gives the higher contrast ratio against
/// [background], per WCAG 2.x: relative luminance via [Color.computeLuminance],
/// then `(lighter + 0.05) / (darker + 0.05)`.
Color readableTextColorOn(Color background) {
  final bgLuminance = background.computeLuminance();
  final contrastWithBlack = _contrastRatio(bgLuminance, 0.0);
  final contrastWithWhite = _contrastRatio(bgLuminance, 1.0);
  return contrastWithBlack >= contrastWithWhite ? Colors.black : Colors.white;
}

double _contrastRatio(double luminanceA, double luminanceB) {
  final lighter = luminanceA > luminanceB ? luminanceA : luminanceB;
  final darker = luminanceA > luminanceB ? luminanceB : luminanceA;
  return (lighter + 0.05) / (darker + 0.05);
}

/// Body and metadata ink on a colored note. As soft as it can be while
/// still clearing WCAG AA (4.5:1) against [background]. A fixed blend looked
/// pale on gold, coral and lilac and disappeared into the sheet.
Color mutedTextColorOn(Color background) {
  final ink = readableTextColorOn(background);
  var lo = 0.0;
  var hi = 1.0;
  var best = ink;
  for (var i = 0; i < 10; i++) {
    final mid = (lo + hi) / 2;
    final candidate = Color.alphaBlend(ink.withValues(alpha: mid), background);
    final ratio = _contrastRatio(candidate.computeLuminance(), background.computeLuminance());
    if (ratio >= 4.5) {
      best = candidate;
      hi = mid;
    } else {
      lo = mid;
    }
  }
  return best;
}
