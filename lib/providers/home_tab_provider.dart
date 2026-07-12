import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Which top-level section [HomeScreen] is showing: the regular note list
/// or the diary timeline (see `DiaryScreen`-equivalent `_DiaryList` in
/// `home_screen.dart`). Not persisted — same as [FabMenuNotifier], this is
/// transient navigation state that resets to Notes on every app start.
enum HomeTab { notes, diary }

class HomeTabNotifier extends Notifier<HomeTab> {
  @override
  HomeTab build() => HomeTab.notes;

  void select(HomeTab tab) => state = tab;
}

final homeTabProvider = NotifierProvider<HomeTabNotifier, HomeTab>(HomeTabNotifier.new);
