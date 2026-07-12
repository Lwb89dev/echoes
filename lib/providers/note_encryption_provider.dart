import 'dart:developer' as developer;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'service_providers.dart';

/// Snapshot of the note-encryption feature: whether the user turned it on,
/// and whether this session currently has the key unlocked (so notes are
/// readable). When [enabled] is false, [unlocked] is always true — there is
/// nothing to protect.
class NoteEncryptionState {
  const NoteEncryptionState({required this.enabled, required this.unlocked});

  final bool enabled;
  final bool unlocked;
}

/// Drives the "protect notes with a password" setting end to end: reads the
/// persisted on/off flag at startup, and exposes enable/disable/unlock/lock
/// actions that delegate to [LocalStorageService] (which in turn delegates
/// the actual cryptography to [NoteEncryptionService]).
///
/// [HomeScreen] watches this provider to decide whether to show the note
/// list or an unlock prompt; [NotesNotifier] is never even asked to load
/// notes while locked, so it never hits the "locked" exception from
/// [LocalStorageService.loadNotes].
class NoteEncryptionNotifier extends AsyncNotifier<NoteEncryptionState> {
  @override
  Future<NoteEncryptionState> build() async {
    developer.log('NoteEncryptionNotifier.build called', name: 'NoteEncryptionNotifier');
    final localStorageService = ref.read(localStorageServiceProvider);
    final enabled = await localStorageService.isNoteEncryptionEnabled();
    final unlocked = await localStorageService.isNotesUnlocked();
    return NoteEncryptionState(enabled: enabled, unlocked: unlocked);
  }

  /// Tries [password] against the saved verifier. Returns true and unlocks
  /// the session on success; returns false (state left untouched) on a
  /// wrong password.
  Future<bool> unlock(String password) async {
    developer.log('NoteEncryptionNotifier.unlock called', name: 'NoteEncryptionNotifier');
    final localStorageService = ref.read(localStorageServiceProvider);
    final ok = await localStorageService.unlockNotes(password);
    if (ok) {
      state = const AsyncData(NoteEncryptionState(enabled: true, unlocked: true));
    }
    return ok;
  }

  /// Checks [password] against the saved verifier without unlocking the
  /// session — used to confirm a password before using it for something
  /// other than reading notes, e.g. encrypting a note export (see
  /// `note_actions.dart`'s export dialog).
  Future<bool> verifyPassword(String password) {
    developer.log('NoteEncryptionNotifier.verifyPassword called', name: 'NoteEncryptionNotifier');
    return ref.read(localStorageServiceProvider).verifyNoteEncryptionPassword(password);
  }

  /// Discards the in-memory key, locking notes again.
  void lock() {
    developer.log('NoteEncryptionNotifier.lock called', name: 'NoteEncryptionNotifier');
    ref.read(localStorageServiceProvider).lockNotes();
    state = const AsyncData(NoteEncryptionState(enabled: true, unlocked: false));
  }

  /// Turns encryption on with a brand-new [password], re-encrypting every
  /// note that is currently stored in plaintext.
  Future<void> enable(String password) async {
    developer.log('NoteEncryptionNotifier.enable called', name: 'NoteEncryptionNotifier');
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(localStorageServiceProvider).enableNoteEncryption(password);
      return const NoteEncryptionState(enabled: true, unlocked: true);
    });
  }

  /// Turns encryption off after verifying [password], rewriting every note
  /// in plaintext. Throws (state left untouched) if the password is wrong —
  /// callers should catch this to show an inline "wrong password" message
  /// instead of a full-screen provider error.
  Future<void> disable(String password) async {
    developer.log('NoteEncryptionNotifier.disable called', name: 'NoteEncryptionNotifier');
    await ref.read(localStorageServiceProvider).disableNoteEncryption(password);
    state = const AsyncData(NoteEncryptionState(enabled: false, unlocked: true));
  }
}

final noteEncryptionProvider =
    AsyncNotifierProvider<NoteEncryptionNotifier, NoteEncryptionState>(NoteEncryptionNotifier.new);
