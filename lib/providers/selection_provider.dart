import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Note ids currently selected in [HomeScreen]'s multi-select mode.
///
/// An empty set means "not in selection mode" at all — there is no separate
/// boolean to keep in sync with it: entering selection mode is just the
/// first [toggle] making the set non-empty, and leaving it is [clear] (or
/// the set naturally emptying out as the last selected note is toggled off).
class SelectionNotifier extends Notifier<Set<String>> {
  @override
  Set<String> build() => const {};

  /// Adds [noteId] if not already selected, removes it otherwise. Used for
  /// both "start selecting" (long-press on the first note) and "select
  /// another"/"deselect" (tap on any note while already selecting).
  void toggle(String noteId) {
    final updated = {...state};
    if (!updated.remove(noteId)) updated.add(noteId);
    state = updated;
  }

  void clear() => state = const {};
}

final selectionProvider = NotifierProvider<SelectionNotifier, Set<String>>(SelectionNotifier.new);
