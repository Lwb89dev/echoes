import 'dart:async';
import 'dart:developer' as developer;

import 'package:connectivity_plus/connectivity_plus.dart';

import '../models/attachment.dart';
import '../models/note.dart';
import '../models/relay.dart';
import '../models/upload_provider.dart';
import '../models/user.dart';
import '../utils/constants.dart';
import 'attachment_upload_service.dart';
import 'local_storage_service.dart';
import 'nostr_service.dart';

/// Offline-first orchestrator: tracks network state and coordinates
/// [LocalStorageService] (local source of truth, always available) with
/// [NostrService] (remote source of truth, only reachable while online).
///
/// Publishing a note to Nostr is never implicit: saving a note in
/// [NotesNotifier] only ever writes to local storage, so it's always fast
/// and reliable regardless of network/relay/signer state. Syncing to Nostr
/// is a separate, explicit action — either per-note (the cloud button in
/// `NoteEditorScreen`, via [syncNote]) or in bulk (pull-to-refresh, via
/// [runSyncCycle]) — so failures are always visible to whoever asked for
/// them instead of silently leaving a note stuck `synced: false`.
class SyncService {
  // Public parameter names (no underscore) for a clean constructor call
  // site, assigned to private fields: preferred over `required this._field`,
  // which would expose the underscore-prefixed name to callers.
  SyncService({
    required LocalStorageService localStorageService,
    required NostrService nostrService,
    required AttachmentUploadService attachmentUploadService,
  })  : _localStorageService = localStorageService, // ignore: prefer_initializing_formals
        _nostrService = nostrService, // ignore: prefer_initializing_formals
        _attachmentUploadService = attachmentUploadService; // ignore: prefer_initializing_formals

  final LocalStorageService _localStorageService;
  final NostrService _nostrService;
  final AttachmentUploadService _attachmentUploadService;

  Timer? _pollTimer;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  /// Starts periodic polling ([AppConstants.syncPollInterval]) and
  /// subscribes to connectivity changes, so coming back online after being
  /// offline triggers a sync right away instead of waiting for the next
  /// scheduled tick.
  /// [onCycleCompleted] runs after every unattended cycle finishes
  /// (successfully or not — a cycle that failed halfway may still have
  /// written uploaded-attachment state for some notes before the failure).
  /// The caller uses it to refresh in-memory state from storage: these
  /// cycles write to [LocalStorageService] directly, invisibly to any
  /// provider holding notes in memory.
  void startAutoSync({
    required User author,
    required List<Relay> relays,
    required UploadProviderOption uploadProvider,
    void Function()? onCycleCompleted,
  }) {
    developer.log('SyncService.startAutoSync called', name: 'SyncService');
    stopAutoSync();

    Future<void> cycle() async {
      await runSyncCycle(author: author, relays: relays, uploadProvider: uploadProvider);
      onCycleCompleted?.call();
    }

    _pollTimer = Timer.periodic(AppConstants.syncPollInterval, (_) => cycle());

    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((results) {
      if (results.any((result) => result != ConnectivityResult.none)) {
        cycle();
      }
    });
  }

  void stopAutoSync() {
    developer.log('SyncService.stopAutoSync called', name: 'SyncService');
    _pollTimer?.cancel();
    _pollTimer = null;
    _connectivitySubscription?.cancel();
    _connectivitySubscription = null;
  }

  /// true if the device currently reports network connectivity (does not
  /// guarantee the relays themselves are reachable, only that a network
  /// interface is up).
  Future<bool> isOnline() async {
    final results = await Connectivity().checkConnectivity();
    return results.any((result) => result != ConnectivityResult.none);
  }

  /// Publishes [note] to Nostr right now, on explicit user request (the
  /// per-note sync button in `NoteEditorScreen`). Unlike [runSyncCycle],
  /// this does not swallow failures: the caller needs to know whether the
  /// sync actually succeeded so it can show clear success/failure feedback
  /// instead of a note silently staying unsynced with no explanation.
  Future<Note> syncNote({
    required Note note,
    required User author,
    required List<Relay> relays,
    required UploadProviderOption uploadProvider,
  }) async {
    developer.log('SyncService.syncNote called: ${note.id}', name: 'SyncService');
    if (!await isOnline()) {
      throw StateError('No network connection.');
    }
    final noteWithUploads = await _uploadPendingAttachments(
      note: note,
      author: author,
      uploadProvider: uploadProvider,
    );
    final event = await _nostrService.createNoteEvent(noteWithUploads, author);
    final eventId = await _nostrService.publishNote(event, relays);
    final syncedNote = noteWithUploads.copyWith(synced: true, nostrEventId: eventId);
    await _localStorageService.saveNote(syncedNote);
    return syncedNote;
  }

  /// Uploads every not-yet-uploaded attachment on [note] (encrypted, via
  /// [AttachmentUploadService]) and persists the result locally right away
  /// — so if publishing fails right after (offline, relay rejects the
  /// event...), retrying doesn't force an already-successful upload to
  /// happen all over again. No-op, and no extra local write, once every
  /// attachment is already uploaded (the common case: republishing an
  /// edited note whose attachments went out with it the first time).
  ///
  /// This is the one place all three publish paths — the editor's cloud
  /// button, the note list's multi-select sync, and the unattended
  /// auto-sync/pull-to-refresh cycle (see [runSyncCycle]) — share, so none
  /// of them can publish a note whose attachments still only point at a
  /// `localPath` that exists on this device alone.
  Future<Note> _uploadPendingAttachments({
    required Note note,
    required User author,
    required UploadProviderOption uploadProvider,
  }) async {
    if (note.attachments.every((a) => a.isUploaded)) return note;
    final uploaded = <Attachment>[];
    for (final attachment in note.attachments) {
      uploaded.add(
        attachment.isUploaded
            ? attachment
            : await _attachmentUploadService.upload(
                pending: attachment,
                provider: uploadProvider,
                author: author,
              ),
      );
    }
    final updated = note.copyWith(attachments: uploaded);
    await _localStorageService.saveNote(updated);
    return updated;
  }

  /// Republishes every note that has ever been synced (`nostrEventId !=
  /// null`) to every relay currently in [relays] — including one that was
  /// only just added (e.g. a self-hosted backup relay), which the normal
  /// per-note sync only ever reaches on that note's *next* edit, not
  /// retroactively. Notes that were never explicitly synced are left
  /// untouched and stay local-only, same as everywhere else sync happens in
  /// this app: this is a "backfill the relays I already share with", not a
  /// "publish literally everything" button.
  ///
  /// Best-effort per note, like [NostrService.syncLocalNotes]: one relay
  /// hiccup or a single note's failed upload doesn't abort the rest. Returns
  /// how many notes were successfully republished.
  Future<int> republishAllSyncedNotes({
    required List<Note> notes,
    required User author,
    required List<Relay> relays,
    required UploadProviderOption uploadProvider,
  }) async {
    developer.log(
      'SyncService.republishAllSyncedNotes called (${notes.length} notes)',
      name: 'SyncService',
    );
    if (!await isOnline()) {
      throw StateError('No network connection.');
    }
    if (relays.isEmpty) {
      throw StateError('No relay configured for syncing.');
    }

    var succeeded = 0;
    for (final note in notes.where((n) => n.nostrEventId != null)) {
      try {
        await syncNote(note: note, author: author, relays: relays, uploadProvider: uploadProvider);
        succeeded++;
      } catch (e) {
        developer.log('Failed to republish note ${note.id}: $e', name: 'SyncService');
      }
    }
    return succeeded;
  }

  /// Retracts [note] from the relays (NIP-09 deletion event) and clears its
  /// local sync state — the counterpart to [syncNote]. Same
  /// don't-swallow-failures rationale: the caller needs to know whether the
  /// retraction actually went through.
  Future<Note> unsyncNote({
    required Note note,
    required User author,
    required List<Relay> relays,
  }) async {
    developer.log('SyncService.unsyncNote called: ${note.id}', name: 'SyncService');
    if (!await isOnline()) {
      throw StateError('No network connection.');
    }
    await _nostrService.deleteNoteEvent(note: note, author: author, relays: relays);
    final unsyncedNote = note.copyWith(synced: false, nostrEventId: null);
    await _localStorageService.saveNote(unsyncedNote);
    return unsyncedNote;
  }

  /// One full bidirectional sync cycle:
  /// 1. push local notes that aren't synced yet;
  /// 2. fetch remote notes newer than the last known sync;
  /// 3. merge them into [LocalStorageService], newest `updatedAt` wins.
  ///
  /// [silent] controls what happens on failure:
  ///  - `true` (default): errors are logged and swallowed. Used for the
  ///    unattended poll timer / connectivity callback in [startAutoSync],
  ///    where a transient relay hiccup should just get retried next cycle
  ///    instead of surfacing as a crash with nothing to show it to.
  ///  - `false`: errors are rethrown. Used for a user-initiated refresh
  ///    (pull-to-refresh in `HomeScreen`, via [NotesNotifier.refreshFromRelays])
  ///    so a real failure (no relays configured, Amber not responding, relay
  ///    unreachable...) is visible instead of the refresh silently doing
  ///    nothing.
  Future<void> runSyncCycle({
    required User author,
    required List<Relay> relays,
    required UploadProviderOption uploadProvider,
    bool silent = true,
  }) async {
    developer.log('SyncService.runSyncCycle called', name: 'SyncService');
    if (!await isOnline()) {
      if (silent) return;
      throw StateError('No network connection.');
    }
    // Without this check, an empty relay list makes every step below a
    // silent no-op (nothing to push, nothing comes back from a fetch over
    // zero relays) — the cycle "succeeds" having synced nothing, with no
    // way to tell that apart from "everything was already up to date".
    if (relays.isEmpty) {
      if (silent) return;
      throw StateError('No relay configured for syncing.');
    }

    try {
      final localNotes = await _localStorageService.loadNotes();

      // Any note about to be (re)published that still has a pending
      // attachment must have it uploaded first — otherwise it would go out
      // with an attachment pointing only at a `localPath` that exists on
      // this device alone (see [_uploadPendingAttachments]). A note whose
      // upload fails here is left out of `readyToPublish` entirely rather
      // than published with a broken attachment reference: it stays
      // `synced: false` and gets a full retry (upload + publish) next cycle.
      final readyToPublish = <Note>[];
      for (final note in localNotes) {
        final needsUpload =
            !note.synced && note.nostrEventId != null && note.attachments.any((a) => !a.isUploaded);
        if (!needsUpload) {
          readyToPublish.add(note);
          continue;
        }
        try {
          readyToPublish.add(
            await _uploadPendingAttachments(note: note, author: author, uploadProvider: uploadProvider),
          );
        } catch (e) {
          developer.log(
            'Failed to upload attachments for note ${note.id}, will retry next cycle: $e',
            name: 'SyncService',
          );
        }
      }

      final justSynced = await _nostrService.syncLocalNotes(
        localNotes: readyToPublish,
        author: author,
        relays: relays,
      );
      for (final note in justSynced) {
        await _localStorageService.saveNote(note);
      }

      final since = await _localStorageService.loadLastSyncTime();
      final fetchResult = await _nostrService.fetchNotesFromRelay(
        author: author,
        relays: relays,
        since: since,
      );

      final currentLocalById = {
        for (final note in await _localStorageService.loadNotes()) note.id: note,
      };
      for (final remoteNote in fetchResult.notes) {
        final localNote = currentLocalById[remoteNote.id];
        if (localNote == null || remoteNote.updatedAt.isAfter(localNote.updatedAt)) {
          await _localStorageService.saveNote(remoteNote);
        }
      }

      // Only move the bookmark forward when every relay actually confirmed
      // it delivered everything it has (see `fetchNotesFromRelay`'s
      // `complete` doc) — advancing it after a timed-out, only-partially-
      // delivered fetch would permanently skip whatever didn't arrive in
      // time, since the next cycle would never ask for anything before
      // this point again. Rewound by a safety margin rather than the exact
      // cycle start time even then: re-fetched notes just no-op against an
      // already-up-to-date local copy (matched by id), so a minute of
      // overlap costs nothing and is comfortably wider than any one
      // relay's turnaround between "sent its last event" and "sent EOSE".
      if (fetchResult.complete) {
        await _localStorageService.saveLastSyncTime(
          DateTime.now().subtract(const Duration(minutes: 1)),
        );
      } else {
        developer.log(
          'runSyncCycle: relay fetch timed out before every relay reported '
          'done; leaving the sync bookmark where it was so the next cycle '
          'retries the same window instead of silently skipping it',
          name: 'SyncService',
        );
      }
    } catch (e) {
      developer.log('runSyncCycle failed${silent ? ', will retry next cycle' : ''}: $e', name: 'SyncService');
      if (!silent) rethrow;
    }
  }

  void dispose() {
    developer.log('SyncService.dispose called', name: 'SyncService');
    _pollTimer?.cancel();
    _connectivitySubscription?.cancel();
  }
}
