import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/note.dart';

/// Pin and archive, as device-local sets of note ids.
///
/// These are a view of the desk, like the manual order: they are not fields
/// on the note. Putting them in the encrypted payload would make an older
/// client drop them the next time it republishes, and a pinned note must
/// never start syncing just because it was pinned. The cost is that the
/// arrangement stays on this device.
class NoteDesk {
  const NoteDesk({this.pinned = const {}, this.archived = const {}, this.viewingArchive = false});

  final Set<String> pinned;
  final Set<String> archived;

  /// Transient. Not persisted — opening the app returns to the desk.
  final bool viewingArchive;

  NoteDesk copyWith({Set<String>? pinned, Set<String>? archived, bool? viewingArchive}) {
    return NoteDesk(
      pinned: pinned ?? this.pinned,
      archived: archived ?? this.archived,
      viewingArchive: viewingArchive ?? this.viewingArchive,
    );
  }
}

class NoteDeskNotifier extends Notifier<NoteDesk> {
  static const _pinKey = 'echoes.pinned_notes';
  static const _archiveKey = 'echoes.archived_notes';

  @override
  NoteDesk build() {
    _load();
    return const NoteDesk();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final pinned = prefs.getStringList(_pinKey) ?? const <String>[];
    final archived = prefs.getStringList(_archiveKey) ?? const <String>[];
    state = state.copyWith(pinned: pinned.toSet(), archived: archived.toSet());
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_pinKey, state.pinned.toList());
    await prefs.setStringList(_archiveKey, state.archived.toList());
  }

  void togglePin(String id) {
    final next = {...state.pinned};
    if (!next.add(id)) next.remove(id);
    state = state.copyWith(pinned: next);
    _persist();
  }

  /// Pins every id when any of them is unpinned, otherwise unpins them all.
  void pinAll(Iterable<String> ids) {
    final list = ids.toList();
    final allPinned = list.isNotEmpty && list.every(state.pinned.contains);
    final next = {...state.pinned};
    if (allPinned) {
      next.removeAll(list);
    } else {
      next.addAll(list);
    }
    state = state.copyWith(pinned: next);
    _persist();
  }

  void archive(String id) {
    if (state.archived.contains(id)) return;
    state = state.copyWith(archived: {...state.archived, id});
    _persist();
  }

  void unarchive(String id) {
    if (!state.archived.contains(id)) return;
    state = state.copyWith(archived: {...state.archived}..remove(id));
    _persist();
  }

  void setArchived(Iterable<String> ids, bool archived) {
    final next = {...state.archived};
    if (archived) {
      next.addAll(ids);
    } else {
      next.removeAll(ids);
    }
    state = state.copyWith(archived: next);
    _persist();
  }

  void toggleViewingArchive() {
    state = state.copyWith(viewingArchive: !state.viewingArchive);
  }
}

final noteDeskProvider = NotifierProvider<NoteDeskNotifier, NoteDesk>(NoteDeskNotifier.new);

/// Whether [note] belongs on the surface currently open.
///
/// Search always includes the archive, so a note set aside can still be found.
bool noteVisibleOnDesk(Note note, NoteDesk desk, {required bool searching}) {
  if (searching) return true;
  final archived = desk.archived.contains(note.id);
  return desk.viewingArchive ? archived : !archived;
}

/// Pinned notes keep their relative order and sit above everything else.
List<Note> pinFirst(List<Note> notes, Set<String> pinned) {
  if (pinned.isEmpty) return notes;
  final top = <Note>[];
  final rest = <Note>[];
  for (final note in notes) {
    (pinned.contains(note.id) ? top : rest).add(note);
  }
  return [...top, ...rest];
}
