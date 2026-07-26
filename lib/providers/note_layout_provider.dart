import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// How [HomeScreen]'s note list is displayed: a single-column list (the
/// original layout) or a Google-Keep-style staggered grid of cards.
enum NoteLayout { list, grid }

/// Persisted display preference — same "return a default immediately, load
/// the real value async" pattern as [UploadProviderNotifier]: this is a
/// non-critical UI choice, so a brief flash of the default on cold start
/// before the saved preference loads is an acceptable trade-off for not
/// needing to plumb it through `main()` like locale/theme.
class NoteLayoutNotifier extends Notifier<NoteLayout> {
  static const _prefsKey = 'echoes.note_layout';

  @override
  NoteLayout build() {
    _load();
    // Grid (Google-Keep-style post-it cards) is the default look: a single
    // full-width column reads as a plain to-do list and is the weaker first
    // impression for a notes app. A user who prefers the list still gets it —
    // their explicit choice is saved and reapplied by [_load]; only the
    // never-chosen default changes.
    return NoteLayout.grid;
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_prefsKey);
    for (final layout in NoteLayout.values) {
      if (layout.name == raw) {
        state = layout;
        return;
      }
    }
  }

  Future<void> setLayout(NoteLayout layout) async {
    state = layout;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, layout.name);
  }
}

final noteLayoutProvider = NotifierProvider<NoteLayoutNotifier, NoteLayout>(NoteLayoutNotifier.new);
