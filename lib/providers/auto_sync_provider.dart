import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Whether saving a note that is **already published** should publish the new
/// version straight away, instead of waiting for the next background cycle.
///
/// Scoped deliberately narrowly: it only ever affects notes the user has
/// already synced at least once. A note that has never left the device stays
/// local-only no matter what this is set to — nothing here can turn a private
/// note into a published one, which is the whole reason it can default to on.
class AutoSyncOnSaveNotifier extends Notifier<bool> {
  static const _prefsKey = 'echoes.auto_sync_on_save';

  @override
  bool build() {
    _load();
    // On by default: for a note already on the relays, "save" almost always
    // means "and keep the copy out there current". The preference exists for
    // people who'd rather publish on their own schedule (metered data, a
    // slow self-hosted relay).
    return true;
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getBool(_prefsKey);
    if (saved != null) state = saved;
  }

  Future<void> setEnabled(bool enabled) async {
    state = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefsKey, enabled);
  }
}

final autoSyncOnSaveProvider = NotifierProvider<AutoSyncOnSaveNotifier, bool>(
  AutoSyncOnSaveNotifier.new,
);
