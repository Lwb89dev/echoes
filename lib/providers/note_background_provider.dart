import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Per-note custom background photos, as a map of note id to a file path
/// inside the app's own storage.
///
/// The picked photo is **copied** into app-private storage rather than
/// referenced where it sits: a gallery path can be moved, deleted or (on
/// Android, where the picker often hands back a cached copy) purged by the
/// system, and a note whose background silently disappears is worse than one
/// that never had it. The copy lives in the support directory, which the OS
/// does not reclaim, alongside durable voice-note copies.
///
/// Device-local, like the manual note order: the image never leaves the
/// device, and nothing is added to the note's published payload — older
/// clients would strip an unknown field on their next save anyway. The
/// trade-off is that a background doesn't follow the note to another device.
class NoteBackgroundNotifier extends Notifier<Map<String, String>> {
  static const _prefsKey = 'echoes.note_backgrounds';

  @override
  Map<String, String> build() {
    _load();
    return const {};
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_prefsKey);
    if (raw == null) return;
    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      // Drop entries whose file is gone (storage cleared, app data reset) so
      // the UI never tries to paint a missing file.
      state = {
        for (final entry in decoded.entries)
          if (entry.value is String && File(entry.value as String).existsSync())
            entry.key: entry.value as String,
      };
    } catch (e) {
      developer.log('Could not read saved note backgrounds: $e', name: 'NoteBackgroundNotifier');
    }
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, jsonEncode(state));
  }

  /// Copies [sourcePath] into app storage and makes it [noteId]'s background,
  /// replacing (and deleting) any previous one.
  Future<void> setBackground(String noteId, String sourcePath) async {
    final base = await getApplicationSupportDirectory();
    final dir = Directory('${base.path}/note_backgrounds');
    if (!await dir.exists()) await dir.create(recursive: true);

    final extension = sourcePath.split('.').last.toLowerCase();
    // The note id is a UUID, so it's already a safe file name; the timestamp
    // makes each pick a distinct file, so replacing a background can't be
    // served a stale image out of any image cache keyed by path.
    final target = File(
      '${dir.path}/${noteId}_${DateTime.now().millisecondsSinceEpoch}.$extension',
    );
    await File(sourcePath).copy(target.path);

    await _deleteFileFor(noteId);
    state = {...state, noteId: target.path};
    await _persist();
  }

  /// Clears [noteId]'s background and deletes the stored copy.
  Future<void> clearBackground(String noteId) async {
    await _deleteFileFor(noteId);
    state = {...state}..remove(noteId);
    await _persist();
  }

  /// Best-effort removal of the file backing [noteId], if any — a failed
  /// delete leaves a stray file, never a failed user action.
  Future<void> _deleteFileFor(String noteId) async {
    final path = state[noteId];
    if (path == null) return;
    try {
      final file = File(path);
      if (await file.exists()) await file.delete();
    } catch (e) {
      developer.log('Could not delete old note background: $e', name: 'NoteBackgroundNotifier');
    }
  }
}

final noteBackgroundProvider = NotifierProvider<NoteBackgroundNotifier, Map<String, String>>(
  NoteBackgroundNotifier.new,
);
