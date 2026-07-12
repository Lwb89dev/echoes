import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Whether [HomeScreen]'s "new note" speed-dial FAB is currently expanded.
///
/// Lives outside the FAB widget itself (rather than as private `State`)
/// so tapping anywhere else on the screen — not just the FAB again — can
/// collapse it: [HomeScreen] renders a full-screen tap barrier while this
/// is true, which closing needs to reach into the FAB's own animation.
class FabMenuNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void toggle() => state = !state;

  void close() => state = false;
}

final fabMenuProvider = NotifierProvider<FabMenuNotifier, bool>(FabMenuNotifier.new);
