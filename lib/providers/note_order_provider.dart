import 'dart:developer' as developer;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/note.dart';

/// The user's hand-arranged note order, as a list of note ids.
///
/// Deliberately **device-local** (SharedPreferences), not part of the note
/// payload: adding a field to the wire format would have every older client
/// strip it again on its next last-write-wins publish — the same trap that
/// makes new note fields dangerous — and an ordering is a per-device view
/// preference, not content. The cost is that the arrangement doesn't follow
/// you to another device; the alternative was risking other people's edits.
///
/// Ids of notes that were never dragged simply aren't in here, which is what
/// keeps this list from having to be kept in step with creations and
/// deletions: [applyNoteOrder] treats "absent" as "newest first, as before",
/// and a stale id for a deleted note is ignored on the next read.
class NoteOrderNotifier extends Notifier<List<String>> {
  static const _prefsKey = 'echoes.note_order';

  @override
  List<String> build() {
    _load();
    return const [];
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getStringList(_prefsKey) ?? const [];
  }

  /// Persists [ids] as the new arrangement, newest position first.
  Future<void> setOrder(List<String> ids) async {
    state = List.unmodifiable(ids);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_prefsKey, ids);
    developer.log('Saved a manual order of ${ids.length} note(s)', name: 'NoteOrderNotifier');
  }
}

final noteOrderProvider = NotifierProvider<NoteOrderNotifier, List<String>>(NoteOrderNotifier.new);

/// [notes] arranged by the user's manual [order].
///
/// Anything not in [order] — a note just created, or one that arrived from a
/// relay — keeps the incoming order and sits **first**, so a new note never
/// hides at the bottom of a long hand-sorted list. Everything else follows in
/// the arranged sequence.
List<Note> applyNoteOrder(List<Note> notes, List<String> order) {
  if (order.isEmpty) return notes;
  final position = {for (var i = 0; i < order.length; i++) order[i]: i};
  final unordered = <Note>[];
  final ordered = <Note>[];
  for (final note in notes) {
    (position.containsKey(note.id) ? ordered : unordered).add(note);
  }
  ordered.sort((a, b) => position[a.id]!.compareTo(position[b.id]!));
  return [...unordered, ...ordered];
}
