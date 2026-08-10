import 'dart:async';
import 'dart:developer' as developer;

import 'package:connectivity_plus/connectivity_plus.dart';

import '../models/attachment.dart';
import '../models/note.dart';
import '../models/relay.dart';
import '../models/upload_provider.dart';
import '../models/user.dart';
import '../utils/constants.dart';
import '../utils/note_sharing.dart';
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
  }) : // Public constructor names intentionally differ from private fields.
       // ignore: prefer_initializing_formals
       _localStorageService = localStorageService,
       _nostrService = nostrService, // ignore: prefer_initializing_formals
       // ignore: prefer_initializing_formals
       _attachmentUploadService = attachmentUploadService;

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

    Future<void> cycle({bool repairAttachments = false}) async {
      await runSyncCycle(
        author: author,
        relays: relays,
        uploadProvider: uploadProvider,
        repairAttachments: repairAttachments,
      );
      onCycleCompleted?.call();
    }

    // Sync once right now, not only on the next timer tick. This is what
    // starts auto-sync at app open (see [syncLifecycleProvider], which starts
    // it the moment an account resolves), so notes are pulled fresh on launch
    // instead of up to [AppConstants.syncPollInterval] later — the periodic
    // timer below only fires *after* its first interval, and the connectivity
    // listener only fires on a *change*, so with a connection already up at
    // launch neither would trigger an initial sync. Fire-and-forget and
    // `silent` (the default): a launch-time relay hiccup must never surface as
    // an error, and cycles are serialized so this can't race the ones below.
    // Local-only notes (never synced, no `nostrEventId`) are untouched, same
    // as every cycle — see [syncLocalNotes].
    //
    // The launch cycle is also the one that checks whether file hosts have
    // garbage-collected any attachment blobs (see [_repairMissingAttachments]).
    // Once per app start, not on every poll: it costs one request per
    // uploaded attachment, and blobs don't vanish minute to minute.
    cycle(repairAttachments: true);

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
  Future<({Note note, int accepted, int total})> syncNote({
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
    if (noteWithUploads.ownerPubkey != null) {
      final proposal = await _publishEditProposal(noteWithUploads, author: author, relays: relays);
      return (note: proposal, accepted: relays.length, total: relays.length);
    }

    final event = await _nostrService.createNoteEvent(noteWithUploads, author);
    // Per-relay result, not just "someone took it": a note accepted by only
    // one of several relays is still missing from the others, which is what
    // makes it look synced here and absent on another device.
    final publish = await _nostrService.publishNoteToRelays(event, relays);
    final publishing = noteWithUploads.copyWith(synced: false, nostrEventId: publish.eventId);
    await _localStorageService.saveNote(publishing);
    await _publishRecipientCopies(publishing, author: author, relays: relays);
    final syncedNote = publishing.copyWith(synced: true);
    await _localStorageService.saveNote(syncedNote);
    return (note: syncedNote, accepted: publish.accepted, total: publish.total);
  }

  Future<Note> _publishEditProposal(
    Note note, {
    required User author,
    required List<Relay> relays,
  }) async {
    final event = await _nostrService.createEditProposalEvent(
      note: note,
      author: author,
      ownerPubHex: note.ownerPubkey!,
    );
    await _nostrService.publishNote(event, relays);
    final synced = note.copyWith(synced: true);
    await _localStorageService.saveNote(synced);
    return synced;
  }

  Future<void> _publishRecipientCopies(
    Note note, {
    required User author,
    required List<Relay> relays,
  }) async {
    for (final recipient in note.sharedWith) {
      final event = await _nostrService.createSharedNoteEvent(
        note: note,
        author: author,
        recipientPubHex: recipient,
      );
      await _nostrService.publishNote(event, relays);
    }
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

  // -------------------------------------------------------------------
  // Note sharing (see [NoteSharing])
  // -------------------------------------------------------------------

  /// Shares [note] (which the local user must own) with [recipients] (hex
  /// pubkeys), publishing immediately: attachments uploaded first (recipients
  /// download them from the file host), then the owner's self copy (so the
  /// owner's own devices learn the note is shared and with whom), then one
  /// NIP-44 copy encrypted per recipient. Recipients already on the note are
  /// merged in, and the owner's own pubkey is never added as a recipient.
  Future<Note> shareNote({
    required Note note,
    required List<String> recipients,
    required User author,
    required List<Relay> relays,
    required UploadProviderOption uploadProvider,
  }) async {
    developer.log('SyncService.shareNote called: ${note.id}', name: 'SyncService');
    if (note.ownerPubkey != null) {
      throw StateError('Only the owner can share this note.');
    }
    if (!await isOnline()) throw StateError('No network connection.');
    if (relays.isEmpty) throw StateError('No relay configured for syncing.');

    final merged = {...note.sharedWith, ...recipients}..remove(author.publicKeyHex);
    final updated = note.copyWith(sharedWith: merged.toList(), synced: false);
    // Persist the user's intent before touching the network. If any publish
    // fails, auto-sync can resume instead of forgetting recipients that were
    // already partially published.
    await _localStorageService.saveNote(updated);
    final uploaded = await _uploadPendingAttachments(
      note: updated,
      author: author,
      uploadProvider: uploadProvider,
    );

    final selfEvent = await _nostrService.createNoteEvent(uploaded, author);
    final eventId = await _nostrService.publishNote(selfEvent, relays);
    final publishing = uploaded.copyWith(synced: false, nostrEventId: eventId);
    await _localStorageService.saveNote(publishing);
    await _publishRecipientCopies(publishing, author: author, relays: relays);
    final result = publishing.copyWith(synced: true);
    await _localStorageService.saveNote(result);
    return result;
  }

  /// Stops sharing [note] with [recipientPubHex]: deletes that recipient's
  /// copy from the relays (NIP-09) so future updates never reach them, and
  /// republishes the owner's self copy with the shortened recipient list.
  /// Whatever the recipient already decrypted locally is beyond recall —
  /// only future updates are cut off.
  Future<Note> stopSharingWith({
    required Note note,
    required String recipientPubHex,
    required User author,
    required List<Relay> relays,
  }) async {
    developer.log('SyncService.stopSharingWith called: ${note.id}', name: 'SyncService');
    if (note.ownerPubkey != null) {
      throw StateError('Only the owner can change sharing.');
    }
    if (!await isOnline()) throw StateError('No network connection.');
    if (relays.isEmpty) throw StateError('No relay configured for syncing.');

    final remaining = note.sharedWith.where((r) => r != recipientPubHex).toList();
    final updated = note.copyWith(sharedWith: remaining, synced: false);
    await _localStorageService.saveNote(updated);
    final selfEvent = await _nostrService.createNoteEvent(updated, author);
    final eventId = await _nostrService.publishNote(selfEvent, relays);
    final result = updated.copyWith(synced: true, nostrEventId: eventId);
    await _localStorageService.saveNote(result);
    try {
      await _nostrService.deleteSharedNoteEvent(
        noteId: note.id,
        recipientPubHex: recipientPubHex,
        author: author,
        relays: relays,
      );
    } catch (e) {
      // The canonical and local copies already exclude this recipient, so no
      // future update can reach them. Retraction of already-shared data is
      // best-effort, just like data they may already have downloaded.
      developer.log('Could not retract removed recipient copy: $e', name: 'SyncService');
    }
    return result;
  }

  /// Abandons a note that was shared *with* the local user: tombstones its id
  /// first (local, unconditional — this is what makes it permanent, so the
  /// note can never re-hook even if the owner keeps publishing to us) and
  /// then, best-effort, tells the owner to drop us. Deletion of the local
  /// copy (and its attachment traces) is the caller's job afterwards.
  Future<void> abandonSharedNote({
    required Note note,
    required User author,
    required List<Relay> relays,
  }) async {
    developer.log('SyncService.abandonSharedNote called: ${note.id}', name: 'SyncService');
    await _localStorageService.addAbandonedShareId(note.id);

    final owner = note.ownerPubkey;
    if (owner != null && relays.isNotEmpty && await isOnline()) {
      try {
        final leaveEvent = await _nostrService.createLeaveControlEvent(
          noteId: note.id,
          author: author,
          ownerPubHex: owner,
        );
        await _nostrService.publishNote(leaveEvent, relays);
      } catch (e) {
        // The tombstone above already guarantees we can't re-hook; the
        // owner-side drop is a bonus, not required for correctness.
        developer.log(
          'Abandon leave-signal failed (tombstone still applies): $e',
          name: 'SyncService',
        );
      }
    }
  }

  /// Fetches everything addressed to me and applies it, with strict
  /// authorization so an untrusted relay (or a stranger) can't inject or
  /// hijack notes. Runs inside [runSyncCycle].
  Future<void> _processIncomingShares({required User author, required List<Relay> relays}) async {
    final since = await _localStorageService.loadLastShareSyncTime();
    final fetch = await _nostrService.fetchSharesAddressedTo(
      me: author,
      relays: relays,
      since: since,
    );
    if (fetch.items.isEmpty) {
      if (fetch.complete) {
        await _localStorageService.saveLastShareSyncTime(
          DateTime.now().subtract(const Duration(minutes: 1)),
        );
      }
      return;
    }

    final abandoned = await _localStorageService.loadAbandonedShareIds();

    // Newest-first, capped: bounds how much a flood of unsolicited shares
    // (anyone can publish an event addressed to me) can make one cycle do,
    // without letting old spam crowd out a genuinely recent share.
    final items = [...fetch.items]..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    final bounded = items.take(AppConstants.maxIncomingSharesPerCycle);

    for (final item in bounded) {
      try {
        if (item.isControl) {
          await _applyControl(item, author: author, relays: relays);
          continue;
        }
        final note = item.note!;
        if (abandoned.contains(note.id)) {
          continue; // Permanently left — never re-hook.
        }
        await _applyIncomingNote(note: note, sender: item.sender, author: author);
      } catch (e) {
        developer.log(
          'Skipped a bad incoming shared item from ${item.sender}: $e',
          name: 'SyncService',
        );
      }
    }

    // Advance the bookmark only when every relay finished AND we didn't hit
    // the per-cycle cap: if there were more items than we applied, some are
    // still unprocessed and moving the bookmark past them would drop them
    // for good. Leaving it lets the next cycle pick up the remainder.
    if (fetch.complete && items.length <= AppConstants.maxIncomingSharesPerCycle) {
      await _localStorageService.saveLastShareSyncTime(
        DateTime.now().subtract(const Duration(minutes: 1)),
      );
    }
  }

  Note? _noteById(List<Note> notes, String id) {
    for (final note in notes) {
      if (note.id == id) return note;
    }
    return null;
  }

  /// Applies one decrypted, signature-verified inbound note per the
  /// authorization rules. `sender` is the note event's *signed* author.
  Future<void> _applyIncomingNote({
    required Note note,
    required String sender,
    required User author,
  }) async {
    final existing = _noteById(await _localStorageService.loadNotes(), note.id);

    if (existing == null) {
      // Brand-new note shared with me. Owner = the signer; strip any
      // sharing/sync bookkeeping the payload might carry and store it as
      // shared-in, up to date with what I just received.
      final stored = note.copyWith(
        ownerPubkey: sender,
        sharedWith: const [],
        synced: true,
        nostrEventId: null,
      );
      await _localStorageService.saveNote(stored);
      return;
    }

    if (existing.ownerPubkey == null) {
      // I own this note. The only inbound events allowed to touch it are
      // edit proposals from an actual current recipient of it.
      if (!existing.sharedWith.contains(sender)) {
        developer.log(
          'Rejected inbound edit for owned note ${note.id} from non-recipient $sender',
          name: 'SyncService',
        );
        return;
      }
      if (!note.updatedAt.isAfter(existing.updatedAt)) {
        return; // Not newer: keep mine.
      }
      // Adopt the recipient's content but stay the owner and keep my
      // recipient list; synced=false makes the next cycle re-publish the
      // merged version to the self copy and every recipient (convergence).
      final merged = note.copyWith(
        ownerPubkey: null,
        sharedWith: existing.sharedWith,
        synced: false,
        nostrEventId: existing.nostrEventId,
      );
      await _localStorageService.saveNote(merged);
      return;
    }

    // I hold this as a note shared with me. Only its real owner may update it.
    if (existing.ownerPubkey != sender) {
      developer.log(
        'Rejected inbound update for ${note.id}: sender $sender is not owner ${existing.ownerPubkey}',
        name: 'SyncService',
      );
      return;
    }
    if (!note.updatedAt.isAfter(existing.updatedAt)) {
      return; // My local edit (or copy) is newer: keep it.
    }
    await _localStorageService.saveNote(
      note.copyWith(ownerPubkey: sender, sharedWith: const [], synced: true, nostrEventId: null),
    );
  }

  /// Applies a control message (currently only "leave"): if I own the note
  /// and the sender really is one of its recipients, drop them and delete
  /// their copy from the relays.
  Future<void> _applyControl(
    IncomingShare item, {
    required User author,
    required List<Relay> relays,
  }) async {
    if (item.controlType != NoteSharing.controlLeave) return;
    final noteId = item.controlNoteId!;
    final owned = _noteById(await _localStorageService.loadNotes(), noteId);
    if (owned == null || owned.ownerPubkey != null || !owned.sharedWith.contains(item.sender)) {
      return;
    }

    final remaining = owned.sharedWith.where((r) => r != item.sender).toList();
    // synced=false so the next cycle republishes the self copy with the
    // shortened recipient list — that's how my *other* devices learn the
    // recipient left, too.
    await _localStorageService.saveNote(owned.copyWith(sharedWith: remaining, synced: false));
    try {
      await _nostrService.deleteSharedNoteEvent(
        noteId: noteId,
        recipientPubHex: item.sender,
        author: author,
        relays: relays,
      );
    } catch (e) {
      developer.log('Could not delete left recipient\'s copy for $noteId: $e', name: 'SyncService');
    }
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
    bool repairAttachments = false,
  }) async {
    developer.log('SyncService.runSyncCycle called', name: 'SyncService');
    // Serialize cycles: the poll timer, the connectivity listener (which can
    // fire several events in a burst when a network comes back) and
    // pull-to-refresh can all request a cycle at the same time. Overlapping
    // cycles would race: the same pending attachment uploaded twice, the
    // same note published twice, and two interleaved writers of the sync
    // bookmark. A caller arriving while a cycle is in flight *joins* that
    // cycle (same session, same effective params) instead of starting
    // another; error handling stays per-caller — the shared cycle completes
    // with its error, and each joiner independently swallows (silent) or
    // rethrows (explicit refresh) it.
    final cycle = _cycleInFlight ??= _runSyncCycleExclusive(
      author: author,
      relays: relays,
      uploadProvider: uploadProvider,
      repairAttachments: repairAttachments,
    ).whenComplete(() => _cycleInFlight = null);
    try {
      await cycle;
    } catch (e) {
      developer.log(
        'runSyncCycle failed${silent ? ', will retry next cycle' : ''}: $e',
        name: 'SyncService',
      );
      if (!silent) rethrow;
    }
  }

  Future<void>? _cycleInFlight;

  /// Re-uploads attachments whose blob the file host has garbage-collected,
  /// then republishes the notes that carry them so every device picks up the
  /// new url and key.
  ///
  /// Without this, a purged blob is permanent: the note keeps pointing at a
  /// url that 404s and the image or voice note is simply gone everywhere,
  /// even though this device may still hold the decrypted bytes (voice notes
  /// keep a durable local copy for exactly this reason). Only notes *I* own
  /// are touched — a note shared with me is its owner's to repair, and I
  /// have no right to republish it.
  ///
  /// Entirely best-effort: any failure is logged and the rest continues, so
  /// one unreachable host can't stall a sync cycle.
  Future<void> _repairMissingAttachments({
    required User author,
    required List<Relay> relays,
    required UploadProviderOption uploadProvider,
  }) async {
    final notes = await _localStorageService.loadNotes();
    for (final note in notes) {
      // Never-synced and shared-with-me notes are out of scope: the first has
      // nothing published to repair, the second isn't mine to republish.
      if (note.ownerPubkey != null || note.nostrEventId == null) continue;
      if (!note.attachments.any((a) => a.isUploaded)) continue;

      var changed = false;
      final repaired = <Attachment>[];
      for (final attachment in note.attachments) {
        try {
          final fresh = await _attachmentUploadService.reuploadIfMissing(
            attachment: attachment,
            provider: uploadProvider,
            author: author,
          );
          repaired.add(fresh ?? attachment);
          changed = changed || fresh != null;
        } catch (e) {
          developer.log('Could not repair attachment ${attachment.id}: $e', name: 'SyncService');
          repaired.add(attachment);
        }
      }
      if (!changed) continue;

      // Same updatedAt on purpose: the note's *content* did not change, only
      // where its attachment bytes live. Bumping it would make this device
      // win every last-write-wins merge for a repair nobody edited.
      final updated = note.copyWith(attachments: repaired, synced: false);
      await _localStorageService.saveNote(updated);
      try {
        await syncNote(
          note: updated,
          author: author,
          relays: relays,
          uploadProvider: uploadProvider,
        );
      } catch (e) {
        developer.log(
          'Repaired attachments for note ${note.id} but could not republish: $e',
          name: 'SyncService',
        );
      }
    }
  }

  /// The actual cycle body, run at most once at a time (see [runSyncCycle]).
  /// Always throws on failure — the caller-facing wrapper decides per
  /// caller whether that surfaces or just gets logged.
  Future<void> _runSyncCycleExclusive({
    required User author,
    required List<Relay> relays,
    required UploadProviderOption uploadProvider,
    bool repairAttachments = false,
  }) async {
    if (!await isOnline()) {
      throw StateError('No network connection.');
    }
    // Without this check, an empty relay list makes every step below a
    // silent no-op (nothing to push, nothing comes back from a fetch over
    // zero relays) — the cycle "succeeds" having synced nothing, with no
    // way to tell that apart from "everything was already up to date".
    if (relays.isEmpty) {
      throw StateError('No relay configured for syncing.');
    }

    {
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
        // A note will be published this cycle if it's unsynced and either an
        // owned note the user has already synced once, or a note shared with
        // me that I've edited (published as an edit proposal). Those, and
        // only those, need their attachments uploaded first.
        final ownedPublishIntent = note.nostrEventId != null || note.sharedWith.isNotEmpty;
        final willPublish = !note.synced && (note.ownerPubkey == null ? ownedPublishIntent : true);
        final needsUpload = willPublish && note.attachments.any((a) => !a.isUploaded);
        if (!needsUpload) {
          readyToPublish.add(note);
          continue;
        }
        try {
          readyToPublish.add(
            await _uploadPendingAttachments(
              note: note,
              author: author,
              uploadProvider: uploadProvider,
            ),
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
        // Never let a self-note fetch (authors = me) overwrite a note someone
        // else shared with me that happens to collide on id — that note's
        // canonical source is its owner's events, processed separately below.
        if (localNote != null && localNote.isSharedWithMe) continue;
        if (localNote == null || remoteNote.updatedAt.isAfter(localNote.updatedAt)) {
          await _localStorageService.saveNote(remoteNote);
        }
      }

      // Pull and apply everything addressed to me (shares from owners, edit
      // proposals from my recipients, leave signals) — its own bookmark,
      // its own don't-advance-on-incomplete rule.
      await _processIncomingShares(author: author, relays: relays);

      if (repairAttachments) {
        await _repairMissingAttachments(
          author: author,
          relays: relays,
          uploadProvider: uploadProvider,
        );
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
    }
  }

  void dispose() {
    developer.log('SyncService.dispose called', name: 'SyncService');
    _pollTimer?.cancel();
    _connectivitySubscription?.cancel();
  }
}
