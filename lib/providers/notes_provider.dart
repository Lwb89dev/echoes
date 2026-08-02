import 'dart:developer' as developer;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/note.dart';
import 'auth_provider.dart';
import 'relay_provider.dart';
import 'service_providers.dart';
import 'upload_settings_provider.dart';

/// Note list shown in [HomeScreen]. `build()` loads from the local cache
/// (instant, offline-first); mutations (create/update/delete) write to
/// local storage right away and update the in-memory state.
///
/// Only ever watched once note encryption is confirmed unlocked (see
/// [NoteEncryptionState] and [HomeScreen]) — [build] would otherwise throw
/// when [LocalStorageService.loadNotes] hits a locked, encrypted box.
class NotesNotifier extends AsyncNotifier<List<Note>> {
  @override
  Future<List<Note>> build() async {
    developer.log('NotesNotifier.build called (loading from local cache)', name: 'NotesNotifier');
    final localStorageService = ref.read(localStorageServiceProvider);
    return localStorageService.loadNotes();
  }

  /// Creates or updates a note in local storage only — always fast and
  /// reliable, regardless of network state, relay availability, or Amber
  /// being reachable. Publishing to Nostr is a separate, explicit action
  /// (see [syncNote]): tying it to every save meant a slow/failing signer
  /// or relay silently made saving *feel* broken, with no feedback at all.
  Future<void> saveNote(Note note) async {
    developer.log('NotesNotifier.saveNote called: ${note.id}', name: 'NotesNotifier');
    final current = state.value ?? const <Note>[];
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      // What comes back may differ from what went in: the storage layer
      // upgrades any attachment a concurrent sync already uploaded (see
      // LocalStorageService.saveNote) — the in-memory list must reflect
      // the stored truth, not the possibly-stale input.
      final stored = await ref.read(localStorageServiceProvider).saveNote(note);
      final index = current.indexWhere((n) => n.id == stored.id);
      if (index >= 0) {
        return [for (final n in current) n.id == stored.id ? stored : n];
      }
      return [stored, ...current];
    });
  }

  /// Re-reads the note list from local storage without touching the
  /// relays — called after a background auto-sync cycle (see
  /// `syncLifecycleProvider`), which writes uploaded-attachment state and
  /// remote-fetched notes straight to storage behind this provider's back.
  /// Without this, the home list (and anything opened from it) keeps
  /// serving pre-sync snapshots whose attachments still claim a
  /// `localPath` the upload already deleted.
  ///
  /// Best-effort on purpose: if the box is locked (user locked notes while
  /// a cycle was in flight) the current state is simply kept — never
  /// replaced with an error over a background refresh nobody asked for.
  Future<void> reloadFromLocal() async {
    developer.log('NotesNotifier.reloadFromLocal called', name: 'NotesNotifier');
    try {
      final notes = await ref.read(localStorageServiceProvider).loadNotes();
      state = AsyncData(notes);
    } catch (e) {
      developer.log('reloadFromLocal skipped: $e', name: 'NotesNotifier');
    }
  }

  /// Deletes [note] from local storage, and — if it had ever been synced —
  /// best-effort retracts it from the relays too (NIP-09 deletion event,
  /// see [NostrService.deleteNoteEvent]).
  ///
  /// The local delete always happens regardless of whether the retraction
  /// does: relay state is a separate, best-effort concern from local
  /// storage, same as everywhere else sync happens in this app. A
  /// retraction failure is rethrown afterwards (after the note is already
  /// gone locally) so `HomeScreen` can warn that it may still be visible on
  /// the relay, instead of silently leaving a "deleted" note there forever.
  Future<void> deleteNote(Note note) async {
    developer.log('NotesNotifier.deleteNote called: ${note.id}', name: 'NotesNotifier');
    final current = state.value ?? const <Note>[];
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(localStorageServiceProvider).deleteNote(note.id);
      return current.where((n) => n.id != note.id).toList();
    });

    // Deleting the note's record must also delete its attachments' local
    // traces (a pending recording's only copy, a decrypted-cache image) —
    // "deleted" can't mean "the text is gone but the photo is still on
    // disk for anyone with filesystem access". Best-effort, like the
    // relay retraction below: the note is already gone either way.
    final uploadService = ref.read(attachmentUploadServiceProvider);
    for (final attachment in note.attachments) {
      await uploadService.discardLocalData(attachment);
    }

    final author = ref.read(authProvider).value;
    if (note.nostrEventId != null && author != null) {
      final relays = ref.read(relayProvider).value ?? const [];
      await ref
          .read(nostrServiceProvider)
          .deleteNoteEvent(note: note, author: author, relays: relays);
    }
  }

  /// Explicitly publishes a single [note] to Nostr right now — the cloud
  /// button in `NoteEditorScreen`. Requires a logged-in Nostr account.
  ///
  /// Unlike [saveNote], this does *not* swallow failures into the provider's
  /// error state (which would blank out the whole note list over one failed
  /// sync): it rethrows so the editor screen can show an inline error and
  /// leave the cloud icon showing "not synced", while [state] keeps
  /// reflecting the last known-good note list.
  Future<Note> syncNote(Note note) async {
    developer.log('NotesNotifier.syncNote called: ${note.id}', name: 'NotesNotifier');
    final author = ref.read(authProvider).value;
    if (author == null) {
      throw StateError('Cannot sync without a Nostr account.');
    }
    final relays = ref.read(relayProvider).value ?? const [];
    final uploadProvider = ref.read(uploadProviderProvider);
    final syncedNote = await ref
        .read(syncServiceProvider)
        .syncNote(note: note, author: author, relays: relays, uploadProvider: uploadProvider);

    final current = state.value ?? const <Note>[];
    final index = current.indexWhere((n) => n.id == syncedNote.id);
    state = AsyncData(
      index >= 0
          ? [for (final n in current) n.id == syncedNote.id ? syncedNote : n]
          : [syncedNote, ...current],
    );
    return syncedNote;
  }

  /// Retracts a previously-synced [note] from the relays (NIP-09 deletion
  /// event) and clears its local `synced`/`nostrEventId` state — the
  /// counterpart to [syncNote], triggered by tapping the same cloud button
  /// once it's already showing "synced". Requires a logged-in Nostr
  /// account. Rethrows on failure, same rationale as [syncNote].
  Future<Note> unsyncNote(Note note) async {
    developer.log('NotesNotifier.unsyncNote called: ${note.id}', name: 'NotesNotifier');
    final author = ref.read(authProvider).value;
    if (author == null) {
      throw StateError('Cannot unsync without a Nostr account.');
    }
    final relays = ref.read(relayProvider).value ?? const [];
    final unsyncedNote = await ref
        .read(syncServiceProvider)
        .unsyncNote(note: note, author: author, relays: relays);

    final current = state.value ?? const <Note>[];
    final index = current.indexWhere((n) => n.id == unsyncedNote.id);
    state = AsyncData(
      index >= 0
          ? [for (final n in current) n.id == unsyncedNote.id ? unsyncedNote : n]
          : [unsyncedNote, ...current],
    );
    return unsyncedNote;
  }

  // -------------------------------------------------------------------
  // Sharing (see [NoteSharing])
  // -------------------------------------------------------------------

  /// Shares [note] (which I must own) with [recipients] (hex pubkeys),
  /// publishing right away. Rethrows on failure so the UI can report it.
  Future<Note> shareNote(Note note, List<String> recipients) async {
    developer.log('NotesNotifier.shareNote called: ${note.id}', name: 'NotesNotifier');
    final author = ref.read(authProvider).value;
    if (author == null) {
      throw StateError('Cannot share without a Nostr account.');
    }
    final relays = ref.read(relayProvider).value ?? const [];
    final uploadProvider = ref.read(uploadProviderProvider);
    final shared = await ref
        .read(syncServiceProvider)
        .shareNote(
          note: note,
          recipients: recipients,
          author: author,
          relays: relays,
          uploadProvider: uploadProvider,
        );
    _replaceInState(shared);
    return shared;
  }

  /// Stops sharing [note] with one recipient (hex pubkey). Rethrows on failure.
  Future<Note> stopSharingWith(Note note, String recipientPubHex) async {
    developer.log('NotesNotifier.stopSharingWith called: ${note.id}', name: 'NotesNotifier');
    final author = ref.read(authProvider).value;
    if (author == null) {
      throw StateError('Cannot change sharing without a Nostr account.');
    }
    final relays = ref.read(relayProvider).value ?? const [];
    final updated = await ref
        .read(syncServiceProvider)
        .stopSharingWith(
          note: note,
          recipientPubHex: recipientPubHex,
          author: author,
          relays: relays,
        );
    _replaceInState(updated);
    return updated;
  }

  /// Abandons a note shared *with* me: permanent (it can never re-hook, see
  /// [SyncService.abandonSharedNote]), removes it locally along with its
  /// attachment traces, and best-effort tells the owner to drop me.
  Future<void> abandonSharedNote(Note note) async {
    developer.log('NotesNotifier.abandonSharedNote called: ${note.id}', name: 'NotesNotifier');
    final author = ref.read(authProvider).value;
    if (author == null) {
      throw StateError('Cannot abandon without a Nostr account.');
    }
    final relays = ref.read(relayProvider).value ?? const [];

    await ref
        .read(syncServiceProvider)
        .abandonSharedNote(note: note, author: author, relays: relays);

    await ref.read(localStorageServiceProvider).deleteNote(note.id);
    final uploadService = ref.read(attachmentUploadServiceProvider);
    for (final attachment in note.attachments) {
      await uploadService.discardLocalData(attachment);
    }

    final current = state.value ?? const <Note>[];
    state = AsyncData(current.where((n) => n.id != note.id).toList());
  }

  /// Replaces (or inserts) [note] in the in-memory list by id.
  void _replaceInState(Note note) {
    final current = state.value ?? const <Note>[];
    final index = current.indexWhere((n) => n.id == note.id);
    state = AsyncData(
      index >= 0 ? [for (final n in current) n.id == note.id ? note : n] : [note, ...current],
    );
  }

  /// Forces a manual sync cycle (e.g. pull-to-refresh in [HomeScreen]):
  /// pushes every unsynced local note and pulls remote changes.
  ///
  /// Unlike the unattended background auto-sync, a failure here is not
  /// swallowed: the local note list is reloaded and shown regardless (so a
  /// failed remote sync never blanks out notes that are already on the
  /// device), but the error is rethrown afterwards so `HomeScreen` can
  /// surface it — otherwise a failed refresh (no relays configured, Amber
  /// not responding, relay unreachable...) would look identical to "there
  /// was simply nothing new to sync".
  ///
  /// In local-only mode there is nothing to sync with, so this just
  /// re-reads the local cache (harmless, and keeps pull-to-refresh working
  /// as a general "reload" gesture either way).
  Future<void> refreshFromRelays() async {
    developer.log('NotesNotifier.refreshFromRelays called', name: 'NotesNotifier');
    final author = ref.read(authProvider).value;
    final localStorageService = ref.read(localStorageServiceProvider);

    Object? syncError;
    if (author != null) {
      try {
        final relays = ref.read(relayProvider).value ?? const [];
        final uploadProvider = ref.read(uploadProviderProvider);
        await ref
            .read(syncServiceProvider)
            .runSyncCycle(
              author: author,
              relays: relays,
              uploadProvider: uploadProvider,
              silent: false,
            );
      } catch (e) {
        syncError = e;
      }
    }

    state = await AsyncValue.guard(localStorageService.loadNotes);
    if (syncError != null) throw syncError;
  }

  /// Rewinds the pull-side sync bookmark back to "never synced" and
  /// refreshes right away — for when it's stuck skipping over notes that
  /// are actually still out there (see
  /// [LocalStorageService.clearLastSyncTime]), e.g. after fixing an
  /// unreachable relay that was configured before the bookmark first
  /// managed to fetch everything a relay-reachability problem caused it to
  /// pull.
  Future<void> forceFullResync() async {
    developer.log('NotesNotifier.forceFullResync called', name: 'NotesNotifier');
    await ref.read(localStorageServiceProvider).clearLastSyncTime();
    await refreshFromRelays();
  }

  /// Republishes every previously-synced note to every currently configured
  /// relay — for backfilling a relay that was just added (e.g. a
  /// self-hosted backup node) with notes that already went out to the
  /// others before it existed. See [SyncService.republishAllSyncedNotes].
  /// Returns how many notes were successfully republished.
  Future<int> republishAllToRelays() async {
    developer.log('NotesNotifier.republishAllToRelays called', name: 'NotesNotifier');
    final author = ref.read(authProvider).value;
    if (author == null) {
      throw StateError('Cannot sync without a Nostr account.');
    }
    final relays = ref.read(relayProvider).value ?? const [];
    final uploadProvider = ref.read(uploadProviderProvider);
    final notes = state.value ?? const <Note>[];
    final count = await ref
        .read(syncServiceProvider)
        .republishAllSyncedNotes(
          notes: notes,
          author: author,
          relays: relays,
          uploadProvider: uploadProvider,
        );
    state = await AsyncValue.guard(() => ref.read(localStorageServiceProvider).loadNotes());
    return count;
  }

  /// Serializes local notes into a single JSON string for backup — see
  /// `SettingsScreen`'s "Export notes" action ([noteIds] null) and the note
  /// list's multi-select "export selected" action ([noteIds] set). Passing
  /// [password] encrypts the export (see
  /// [LocalStorageService.exportNotesAsJson]) — the export dialog in
  /// `note_actions.dart` is what decides whether/which password to collect.
  Future<String> exportNotes({Iterable<String>? noteIds, String? password}) {
    developer.log('NotesNotifier.exportNotes called', name: 'NotesNotifier');
    return ref
        .read(localStorageServiceProvider)
        .exportNotesAsJson(noteIds: noteIds, password: password);
  }

  /// Imports notes from a JSON string previously produced by [exportNotes]
  /// and refreshes the in-memory list to reflect what was written. Returns
  /// how many notes were actually imported/updated (see
  /// [LocalStorageService.importNotesFromJson] for the merge rule).
  /// [password] is required if the export was encrypted.
  Future<int> importNotes(String json, {String? password}) async {
    developer.log('NotesNotifier.importNotes called', name: 'NotesNotifier');
    final localStorageService = ref.read(localStorageServiceProvider);
    final count = await localStorageService.importNotesFromJson(json, password: password);
    state = const AsyncLoading();
    state = await AsyncValue.guard(localStorageService.loadNotes);
    return count;
  }
}

final notesProvider = AsyncNotifierProvider<NotesNotifier, List<Note>>(NotesNotifier.new);
