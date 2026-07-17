import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/attachment.dart';
import '../models/note.dart';
import '../models/relay.dart';
import '../models/user.dart';
import '../utils/constants.dart';
import 'note_encryption_service.dart';

/// Single facade for all local persistence: notes (Hive), settings and relay
/// list (SharedPreferences), private key (secure storage).
///
/// Offline-first: every note write goes through here *before* being handed
/// to [NostrService] for syncing — the user must never lose a note just
/// because there is no network connection.
class LocalStorageService {
  LocalStorageService({required NoteEncryptionService noteEncryptionService})
      : _noteEncryption = noteEncryptionService;

  final NoteEncryptionService _noteEncryption;

  Box<Map>? _notesBox;

  /// Must be called once at app startup (before any note read/write),
  /// typically in `main()` right after `WidgetsFlutterBinding.ensureInitialized()`.
  Future<void> init() async {
    developer.log('LocalStorageService.init called', name: 'LocalStorageService');
    await Hive.initFlutter();
    _notesBox = await Hive.openBox<Map>(AppConstants.notesBoxName);
  }

  Box<Map> get _requireNotesBox {
    final box = _notesBox;
    if (box == null) {
      throw StateError('LocalStorageService.init() has not been called yet.');
    }
    return box;
  }

  // ---------------------------------------------------------------------
  // Notes (Hive). Every entry is stored as {'enc': bool, ...}: the note's
  // JSON is encrypted (AES-256-GCM via [NoteEncryptionService]) when the
  // user has turned on password protection, plain otherwise.
  // ---------------------------------------------------------------------

  /// Returns all cached notes, most recently updated first. If encryption
  /// is on but locked (no password entered this session), this throws —
  /// callers must check [isNotesUnlocked] before reaching this point.
  Future<List<Note>> loadNotes() async {
    developer.log('LocalStorageService.loadNotes called', name: 'LocalStorageService');
    final box = _requireNotesBox;
    final notes = <Note>[];
    for (final stored in box.values) {
      final json = await _decodeStoredNote(stored);
      notes.add(Note.fromJson(jsonDecode(json) as Map<String, dynamic>));
    }
    notes.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return notes;
  }

  /// Creates or updates a note in the local cache. Idempotent on [Note.id].
  ///
  /// Returns the note as actually stored, which may differ from [note] in
  /// one deliberate way: an attachment that the *stored* copy already has
  /// as uploaded (url + decryption key set) is never regressed back to
  /// pending by an incoming copy of the same attachment id — see
  /// [_mergeAttachmentUploadState]. Callers keeping an in-memory copy
  /// (e.g. `NotesNotifier`) should use the returned note, not [note].
  Future<Note> saveNote(Note note) async {
    developer.log('LocalStorageService.saveNote called: ${note.id}', name: 'LocalStorageService');
    final box = _requireNotesBox;
    final noteToStore = await _mergeAttachmentUploadState(note);
    final stored = await _encodeForStorage(jsonEncode(noteToStore.toJson()));
    await box.put(note.id, stored);
    return noteToStore;
  }

  /// Upgrades any still-pending attachment on [incoming] to the uploaded
  /// version (url + decryption key/nonce + hash) the currently *stored*
  /// copy of the same note already has for that attachment id, if any.
  ///
  /// This is the storage-level backstop for a race that otherwise loses
  /// attachments irrecoverably: a background sync cycle uploads a pending
  /// attachment (deleting its local plaintext file — see
  /// `AttachmentUploadService.upload`) and saves the note with the url and
  /// decryption key... and then a concurrent writer still holding the
  /// *pre-upload* snapshot (most likely the editor's debounced autosave)
  /// writes that stale copy back over it. Without this merge, that final
  /// write discards the only copy of the decryption key in existence while
  /// the plaintext file is already gone — the attachment's bytes still sit
  /// encrypted on the file host, permanently undecryptable. Enforcing
  /// "uploaded never regresses to pending" here, at the single choke point
  /// every write goes through, protects every current and future writer at
  /// once instead of each of them having to re-discover this race.
  ///
  /// Deliberately does *not* resurrect attachments absent from [incoming]:
  /// removing an attachment is a legitimate edit, and its id simply not
  /// being in the incoming list is how that looks.
  Future<Note> _mergeAttachmentUploadState(Note incoming) async {
    if (incoming.attachments.every((a) => a.isUploaded)) return incoming;
    final storedRaw = _requireNotesBox.get(incoming.id);
    if (storedRaw == null) return incoming;

    final Note existing;
    try {
      final json = await _decodeStoredNote(storedRaw);
      existing = Note.fromJson(jsonDecode(json) as Map<String, dynamic>);
    } catch (e) {
      // Undecodable stored copy (corrupt, or the encryption key was
      // rotated out from under it) — nothing usable to merge from.
      developer.log('Could not decode stored note ${incoming.id} for merge: $e', name: 'LocalStorageService');
      return incoming;
    }

    final uploadedById = {
      for (final attachment in existing.attachments)
        if (attachment.isUploaded) attachment.id: attachment,
    };
    if (uploadedById.isEmpty) return incoming;

    var upgradedCount = 0;
    final merged = <Attachment>[];
    for (final attachment in incoming.attachments) {
      final uploaded = uploadedById[attachment.id];
      if (!attachment.isUploaded && uploaded != null) {
        merged.add(uploaded);
        upgradedCount++;
      } else {
        merged.add(attachment);
      }
    }
    if (upgradedCount == 0) return incoming;
    developer.log(
      'Preserved uploaded state for $upgradedCount attachment(s) on note ${incoming.id}',
      name: 'LocalStorageService',
    );
    return incoming.copyWith(attachments: merged);
  }

  /// Removes a note from the local cache.
  Future<void> deleteNote(String noteId) async {
    developer.log('LocalStorageService.deleteNote called: $noteId', name: 'LocalStorageService');
    final box = _requireNotesBox;
    await box.delete(noteId);
  }

  /// Serializes locally stored notes (already decrypted, if at-rest
  /// encryption is on) into one portable payload, for backup/transfer
  /// between devices.
  ///
  /// [noteIds] restricts the export to those ids (Settings' "export all"
  /// button passes null; the note list's multi-select "export selected"
  /// action passes the selected ids).
  ///
  /// If [password] is given, the notes JSON is encrypted with a key
  /// derived fresh from it (see
  /// [NoteEncryptionService.encryptExportWithNewPassword]) before being
  /// wrapped in the payload — this is a separate concern from at-rest
  /// encryption above (which only protects the *local* copy): a note's
  /// JSON carries its attachments' decryption keys in the clear, so an
  /// unencrypted export file is exactly as sensitive as the images/voice
  /// notes it references, not just the note text. Without [password] the
  /// export is plain JSON, matching the previous, pre-encryption-support
  /// format other than the added `encrypted: false` marker.
  Future<String> exportNotesAsJson({Iterable<String>? noteIds, String? password}) async {
    developer.log('LocalStorageService.exportNotesAsJson called', name: 'LocalStorageService');
    final notes = await loadNotes();
    final selected = noteIds == null ? notes : notes.where((n) => noteIds.contains(n.id)).toList();
    final notesJson = selected.map((n) => n.toJson()).toList();

    if (password == null) {
      return jsonEncode({
        'version': 1,
        'exportedAt': DateTime.now().toIso8601String(),
        'encrypted': false,
        'notes': notesJson,
      });
    }

    final encrypted = await _noteEncryption.encryptExportWithNewPassword(jsonEncode(notesJson), password);
    return jsonEncode({
      'version': 1,
      'exportedAt': DateTime.now().toIso8601String(),
      'encrypted': true,
      ...encrypted,
    });
  }

  /// Peeks at an export file (without decrypting anything) to tell whether
  /// [importNotesFromJson] will need a [String] password — lets the import
  /// UI prompt for one upfront instead of failing once first. Returns
  /// false for anything that isn't a recognizable encrypted export,
  /// including a malformed file (the actual parse failure surfaces from
  /// [importNotesFromJson] itself, with a clearer error).
  static bool isExportEncrypted(String json) {
    try {
      return (jsonDecode(json) as Map<String, dynamic>)['encrypted'] == true;
    } catch (_) {
      return false;
    }
  }

  /// Imports notes from a JSON string produced by [exportNotesAsJson].
  /// [password] is required if (and only if) the export was encrypted —
  /// see [isExportEncrypted] — and a wrong one surfaces as
  /// [SecretBoxAuthenticationError] from [NoteEncryptionService.decryptExportWithPassword].
  ///
  /// Merges by [Note.id]: an incoming note only overwrites a local one with
  /// the same id if its `updatedAt` is newer — the same last-write-wins
  /// rule used when merging notes pulled from a relay (see
  /// [SyncService.runSyncCycle]), so re-importing an old backup can never
  /// clobber newer local edits. Returns how many notes were actually
  /// written (new or updated).
  Future<int> importNotesFromJson(String json, {String? password}) async {
    developer.log('LocalStorageService.importNotesFromJson called', name: 'LocalStorageService');
    final decoded = jsonDecode(json) as Map<String, dynamic>;

    final List<dynamic> rawNotes;
    if (decoded['encrypted'] == true) {
      if (password == null) {
        throw StateError('This export is encrypted: a password is required to import it.');
      }
      final notesJson = await _noteEncryption.decryptExportWithPassword(decoded, password);
      rawNotes = jsonDecode(notesJson) as List<dynamic>;
    } else {
      rawNotes = decoded['notes'] as List<dynamic>? ?? const [];
    }
    final incomingNotes = rawNotes.map((e) => Note.fromJson(e as Map<String, dynamic>)).toList();

    final existingById = {for (final note in await loadNotes()) note.id: note};
    var written = 0;
    for (final incoming in incomingNotes) {
      final existing = existingById[incoming.id];
      if (existing == null || incoming.updatedAt.isAfter(existing.updatedAt)) {
        await saveNote(incoming);
        written++;
      }
    }
    return written;
  }

  Future<Map<String, dynamic>> _encodeForStorage(String json) async {
    if (await _noteEncryption.isEnabled()) {
      final encrypted = await _noteEncryption.encryptString(json);
      return {'enc': true, ...encrypted};
    }
    return {'enc': false, 'json': json};
  }

  Future<String> _decodeStoredNote(Map<dynamic, dynamic> stored) async {
    if (stored['enc'] == true) {
      return _noteEncryption.decryptString(stored);
    }
    return stored['json'] as String;
  }

  // ---------------------------------------------------------------------
  // Note encryption (optional, password-protected) — see
  // [NoteEncryptionService] for the actual cryptography.
  // ---------------------------------------------------------------------

  Future<bool> isNoteEncryptionEnabled() => _noteEncryption.isEnabled();

  Future<bool> isNotesUnlocked() => _noteEncryption.isUnlocked();

  void lockNotes() => _noteEncryption.lock();

  Future<bool> unlockNotes(String password) => _noteEncryption.unlock(password);

  /// Checks [password] against the saved verifier without unlocking the
  /// session — used to confirm a password before using it to encrypt a
  /// note export (see [exportNotesAsJson]) rather than to read notes.
  Future<bool> verifyNoteEncryptionPassword(String password) => _noteEncryption.verifyPassword(password);

  /// Turns encryption on with [password]: reads back the existing notes
  /// (still plaintext at this point), derives the key, then rewrites every
  /// note encrypted.
  Future<void> enableNoteEncryption(String password) async {
    developer.log('LocalStorageService.enableNoteEncryption called', name: 'LocalStorageService');
    if (await _noteEncryption.isEnabled()) {
      throw StateError('Note encryption is already enabled.');
    }
    final existingNotes = await loadNotes();
    await _noteEncryption.enable(password);
    for (final note in existingNotes) {
      await saveNote(note);
    }
  }

  /// Turns encryption off: verifies [password], decrypts every note and
  /// rewrites it in plaintext. Throws [StateError] if the password is wrong.
  Future<void> disableNoteEncryption(String password) async {
    developer.log('LocalStorageService.disableNoteEncryption called', name: 'LocalStorageService');
    if (!await _noteEncryption.isEnabled()) {
      throw StateError('Note encryption is not enabled.');
    }
    if (!await _noteEncryption.unlock(password)) {
      throw StateError('Wrong password.');
    }
    final existingNotes = await loadNotes();
    await _noteEncryption.disable();
    for (final note in existingNotes) {
      await saveNote(note);
    }
  }

  // ---------------------------------------------------------------------
  // Account private key (flutter_secure_storage — NEVER in plaintext
  // SharedPreferences). Only relevant for [LoginMethod.privateKey]: with
  // [LoginMethod.amber] there is no private key to store here at all.
  // ---------------------------------------------------------------------

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<SharedPreferences> get _prefs => SharedPreferences.getInstance();

  /// Persists the private key (hex) in the native keystore/keychain. Only
  /// used for [LoginMethod.privateKey]: with Amber there is no key to save.
  Future<void> savePrivateKey(String privateKeyHex) async {
    developer.log('LocalStorageService.savePrivateKey called', name: 'LocalStorageService');
    await _secureStorage.write(
      key: AppConstants.secureStoragePrivateKeyKey,
      value: privateKeyHex,
    );
  }

  /// Reads the saved private key, if any (null when there is no local
  /// session, including the Amber case).
  Future<String?> loadPrivateKey() async {
    developer.log('LocalStorageService.loadPrivateKey called', name: 'LocalStorageService');
    return _secureStorage.read(key: AppConstants.secureStoragePrivateKeyKey);
  }

  /// Clears the private key, if any.
  Future<void> clearPrivateKey() async {
    developer.log('LocalStorageService.clearPrivateKey called', name: 'LocalStorageService');
    await _secureStorage.delete(key: AppConstants.secureStoragePrivateKeyKey);
  }

  /// Clears the whole local session (private key + pubkey + login method):
  /// used on logout, valid for both [LoginMethod.privateKey] and
  /// [LoginMethod.amber].
  Future<void> clearSession() async {
    developer.log('LocalStorageService.clearSession called', name: 'LocalStorageService');
    await clearPrivateKey();
    final prefs = await _prefs;
    await prefs.remove(AppConstants.prefsPublicKeyKey);
    await prefs.remove(AppConstants.prefsLoginMethodKey);
  }

  // ---------------------------------------------------------------------
  // Public key + login method (SharedPreferences — not sensitive data: the
  // public key is public by definition).
  // ---------------------------------------------------------------------

  Future<void> savePublicKey(String publicKeyHex) async {
    developer.log('LocalStorageService.savePublicKey called', name: 'LocalStorageService');
    final prefs = await _prefs;
    await prefs.setString(AppConstants.prefsPublicKeyKey, publicKeyHex);
  }

  Future<String?> loadPublicKey() async {
    developer.log('LocalStorageService.loadPublicKey called', name: 'LocalStorageService');
    final prefs = await _prefs;
    return prefs.getString(AppConstants.prefsPublicKeyKey);
  }

  /// Persists how the user authenticated ([LoginMethod.privateKey] or
  /// [LoginMethod.amber]), so [AuthNotifier.build] can rebuild the right
  /// kind of session on app restart.
  Future<void> saveLoginMethod(LoginMethod method) async {
    developer.log('LocalStorageService.saveLoginMethod called: $method', name: 'LocalStorageService');
    final prefs = await _prefs;
    await prefs.setString(AppConstants.prefsLoginMethodKey, method.name);
  }

  /// Returns the saved login method, or null if no session is active.
  Future<LoginMethod?> loadLoginMethod() async {
    developer.log('LocalStorageService.loadLoginMethod called', name: 'LocalStorageService');
    final prefs = await _prefs;
    final raw = prefs.getString(AppConstants.prefsLoginMethodKey);
    if (raw == null) return null;
    return LoginMethod.values.byName(raw);
  }

  // ---------------------------------------------------------------------
  // Onboarding (SharedPreferences)
  // ---------------------------------------------------------------------

  Future<bool> isOnboardingComplete() async {
    developer.log('LocalStorageService.isOnboardingComplete called', name: 'LocalStorageService');
    final prefs = await _prefs;
    return prefs.getBool(AppConstants.prefsOnboardingCompleteKey) ?? false;
  }

  Future<void> setOnboardingComplete() async {
    developer.log('LocalStorageService.setOnboardingComplete called', name: 'LocalStorageService');
    final prefs = await _prefs;
    await prefs.setBool(AppConstants.prefsOnboardingCompleteKey, true);
  }

  // ---------------------------------------------------------------------
  // Relay list (SharedPreferences, JSON-encoded)
  // ---------------------------------------------------------------------

  Future<List<Relay>> loadRelays() async {
    developer.log('LocalStorageService.loadRelays called', name: 'LocalStorageService');
    final prefs = await _prefs;
    final raw = prefs.getString(AppConstants.prefsRelaysKey);
    if (raw == null) return const [];
    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map((e) => Relay.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveRelays(List<Relay> relays) async {
    developer.log(
      'LocalStorageService.saveRelays called (${relays.length} relays)',
      name: 'LocalStorageService',
    );
    final prefs = await _prefs;
    final encoded = jsonEncode(relays.map((r) => r.toJson()).toList());
    await prefs.setString(AppConstants.prefsRelaysKey, encoded);
  }

  // ---------------------------------------------------------------------
  // Last sync timestamp (SharedPreferences) — lets [SyncService] fetch only
  // events newer than the last successful sync instead of full history.
  // ---------------------------------------------------------------------

  Future<DateTime?> loadLastSyncTime() async {
    developer.log('LocalStorageService.loadLastSyncTime called', name: 'LocalStorageService');
    final prefs = await _prefs;
    final raw = prefs.getString(AppConstants.prefsLastSyncKey);
    return raw == null ? null : DateTime.parse(raw);
  }

  Future<void> saveLastSyncTime(DateTime time) async {
    developer.log('LocalStorageService.saveLastSyncTime called: $time', name: 'LocalStorageService');
    final prefs = await _prefs;
    await prefs.setString(AppConstants.prefsLastSyncKey, time.toIso8601String());
  }

  /// Rewinds the bookmark back to "never synced" so the next cycle asks
  /// relays for a note's entire history again instead of only whatever's
  /// newer than it. Recovery valve for [SyncService.runSyncCycle] leaving
  /// it stuck in the past: e.g. one relay in the configured list being
  /// unreachable means every cycle's fetch reports incomplete and correctly
  /// never advances the bookmark, but if it *was* mistakenly advanced past
  /// some notes before that relay ever entered the picture, nothing pulls
  /// them back down until this runs — see Settings' "Force full resync".
  Future<void> clearLastSyncTime() async {
    developer.log('LocalStorageService.clearLastSyncTime called', name: 'LocalStorageService');
    final prefs = await _prefs;
    await prefs.remove(AppConstants.prefsLastSyncKey);
  }
}
