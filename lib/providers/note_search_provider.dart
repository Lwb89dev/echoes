import 'package:flutter_riverpod/flutter_riverpod.dart';

/// [HomeScreen]'s inline search query — empty means "not searching", so
/// both the Notes and Diary tabs show every note. Not persisted: same as
/// [FabMenuNotifier]/[HomeTabNotifier], transient UI-only state that
/// resets the moment the app restarts.
class NoteSearchNotifier extends Notifier<String> {
  @override
  String build() => '';

  void setQuery(String query) => state = query;

  void clear() => state = '';
}

final noteSearchProvider = NotifierProvider<NoteSearchNotifier, String>(NoteSearchNotifier.new);
