import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/app_localizations.dart';
import '../../models/note.dart';
import '../../providers/note_encryption_provider.dart';
import '../../providers/notes_provider.dart';

/// Shared note actions used from more than one screen (the note list's
/// long-press/multi-select menu in `home_screen.dart`, the editor's trash
/// button, and Settings' export tile) — kept in one place so the three
/// entry points can't drift into subtly different confirmation copy or
/// error handling.

/// Confirms, then deletes, every note in [notes] (works for both "delete
/// this one note" — a single-element list, e.g. from the editor's trash
/// button — and "delete everything selected" from multi-select). Local
/// deletion always succeeds per note; a relay-retraction failure is
/// summarized in one SnackBar afterwards rather than one per note (see
/// [NotesNotifier.deleteNote]).
///
/// Returns true if the user confirmed (regardless of whether every relay
/// retraction succeeded), false if they cancelled.
Future<bool> deleteNotes(
  BuildContext context,
  WidgetRef ref,
  AppLocalizations l,
  List<Note> notes,
) async {
  if (notes.isEmpty) return false;

  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(notes.length == 1 ? l.deleteNoteConfirmTitle : l.deleteNotesConfirmTitle(notes.length)),
      content: Text(notes.length == 1 ? l.deleteNoteConfirmBody : l.deleteNotesConfirmBody),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(false),
          child: Text(l.cancelButton),
        ),
        FilledButton(
          onPressed: () => Navigator.of(dialogContext).pop(true),
          child: Text(l.deleteNoteButton),
        ),
      ],
    ),
  );
  if (confirmed != true) return false;
  if (!context.mounted) return false;

  // Deleting talks to the relays (a NIP-09 retraction per synced note), so
  // for anything more than a note or two this can take a visible moment —
  // shown fire-and-forget (not awaited) so it runs alongside the loop below
  // rather than blocking it, and dismissed programmatically once that loop
  // finishes.
  final progress = ValueNotifier<int>(0);
  final total = notes.length;
  unawaited(
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => _DeletionProgressDialog(l: l, progress: progress, total: total),
    ),
  );

  var relayFailures = 0;
  Object? lastError;
  final notesNotifier = ref.read(notesProvider.notifier);
  for (final note in notes) {
    try {
      await notesNotifier.deleteNote(note);
    } catch (e) {
      relayFailures++;
      lastError = e;
    }
    progress.value++;
  }

  if (context.mounted) Navigator.of(context, rootNavigator: true).pop();
  progress.dispose();

  if (context.mounted && relayFailures > 0) {
    final message = notes.length == 1
        ? l.deleteNoteRelayError(lastError.toString())
        : l.deleteNotesRelayError(relayFailures);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
  return true;
}

/// Publishes every note in [notes] to Nostr (best-effort per note — see
/// [NotesNotifier.syncNote]), then shows one summary SnackBar rather than
/// one per note. Used by the note list's multi-select "sync selected"
/// action; the editor's own cloud button handles a single note directly
/// since it also needs to update its own in-screen synced/event-id state.
Future<void> syncNotes(
  BuildContext context,
  WidgetRef ref,
  AppLocalizations l,
  List<Note> notes,
) async {
  var failures = 0;
  for (final note in notes) {
    try {
      await ref.read(notesProvider.notifier).syncNote(note);
    } catch (_) {
      failures++;
    }
  }
  if (!context.mounted) return;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(failures == 0 ? l.syncSelectedSuccess : l.syncSelectedPartialError(failures)),
    ),
  );
}

/// Exports notes (all of them if [noteIds] is null, otherwise just those
/// ids) to a JSON file the user picks a destination for. Used by Settings'
/// "export all" tile and the note list's multi-select "export selected"
/// action.
///
/// Always confirms first, with an "encrypt this file" choice: a note's
/// exported JSON carries its attachments' decryption keys in the clear
/// (see `LocalStorageService.exportNotesAsJson`), so an unencrypted export
/// is exactly as sensitive as the photos/voice notes it references, not
/// just the note text — encryption is opt-out (defaults on), not opt-in.
Future<void> exportNotesToFile(
  BuildContext context,
  WidgetRef ref,
  AppLocalizations l, {
  Iterable<String>? noteIds,
}) async {
  final choice = await _confirmExportEncryption(context, ref, l);
  if (choice == null) return; // Cancelled somewhere in the dialog cascade.
  if (!context.mounted) return;

  try {
    final json = await ref.read(notesProvider.notifier).exportNotes(noteIds: noteIds, password: choice.password);
    final bytes = utf8.encode(json);
    final fileName = 'echoes-notes-${DateTime.now().toIso8601String().split('T').first}.json';

    final savedPath = await FilePicker.platform.saveFile(
      dialogTitle: l.exportNotesButton,
      fileName: fileName,
      bytes: bytes,
      type: FileType.custom,
      allowedExtensions: ['json'],
    );

    // On Android/iOS, `saveFile` writes `bytes` itself. On desktop it only
    // returns the chosen path, so we write it ourselves too — doing this
    // unconditionally is harmless (same bytes either way).
    if (savedPath != null && !kIsWeb) {
      await File(savedPath).writeAsBytes(bytes);
    }

    if (savedPath != null && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.exportNotesSuccess)),
      );
    }
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.exportNotesError(e.toString()))),
      );
    }
  }
}

/// [_ExportChoice.password] is null for "export unencrypted" — a real,
/// deliberate choice — which is why the outer flow needs its own separate
/// null ([_ExportChoice]? itself) to mean "cancelled, don't export at all".
class _ExportChoice {
  const _ExportChoice(this.password);
  final String? password;
}

/// Shows the export confirmation dialog (with the encrypt toggle), then —
/// only if encryption was chosen — cascades into whichever password dialog
/// fits the account's current state: a single "enter your password" field
/// if note encryption is already set up (see [NoteEncryptionState.enabled]),
/// or a "set a password for this export" dialog (password + confirm) if
/// not. Returns null if the user backs out at any point.
Future<_ExportChoice?> _confirmExportEncryption(
  BuildContext context,
  WidgetRef ref,
  AppLocalizations l,
) async {
  var encrypt = true;
  final proceed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => StatefulBuilder(
      builder: (dialogContext, setState) => AlertDialog(
        title: Text(l.exportConfirmTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l.exportConfirmBody),
            const SizedBox(height: 8),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(l.exportEncryptToggleLabel),
              subtitle: Text(l.exportEncryptToggleSubtitle),
              value: encrypt,
              onChanged: (value) => setState(() => encrypt = value),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l.cancelButton),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l.exportNotesButton),
          ),
        ],
      ),
    ),
  );
  if (proceed != true) return null;
  if (!encrypt) return const _ExportChoice(null);
  if (!context.mounted) return null;

  final alreadyEnabled = ref.read(noteEncryptionProvider).value?.enabled ?? false;
  final password = alreadyEnabled
      ? await _promptExistingPassword(context, ref, l)
      : await _promptNewExportPassword(context, l);
  return password == null ? null : _ExportChoice(password);
}

/// Single-field password prompt for when note encryption is already set up
/// — verified against the real saved verifier (see
/// [NoteEncryptionNotifier.verifyPassword]) so a typo is caught immediately
/// rather than surfacing as a confusing "wrong password" on a later import.
Future<String?> _promptExistingPassword(BuildContext context, WidgetRef ref, AppLocalizations l) async {
  final controller = TextEditingController();
  var submitting = false;
  String? errorText;

  final result = await showDialog<String>(
    context: context,
    builder: (dialogContext) => StatefulBuilder(
      builder: (dialogContext, setState) => AlertDialog(
        title: Text(l.exportPasswordDialogTitle),
        content: TextField(
          controller: controller,
          obscureText: true,
          autofocus: true,
          decoration: InputDecoration(labelText: l.passwordLabel, errorText: errorText),
        ),
        actions: [
          TextButton(
            onPressed: submitting ? null : () => Navigator.of(dialogContext).pop(),
            child: Text(l.cancelButton),
          ),
          FilledButton(
            onPressed: submitting
                ? null
                : () async {
                    setState(() {
                      submitting = true;
                      errorText = null;
                    });
                    final ok = await ref.read(noteEncryptionProvider.notifier).verifyPassword(controller.text);
                    if (!ok) {
                      setState(() {
                        submitting = false;
                        errorText = l.wrongPasswordError;
                      });
                      return;
                    }
                    if (dialogContext.mounted) Navigator.of(dialogContext).pop(controller.text);
                  },
            child: Text(l.exportNotesButton),
          ),
        ],
      ),
    ),
  );
  controller.dispose();
  return result;
}

/// Password + confirm prompt for when note encryption has never been set
/// up — this password only protects this one export file, it does not
/// turn on at-rest encryption for locally stored notes (that's a separate,
/// persistent choice made from Settings).
Future<String?> _promptNewExportPassword(BuildContext context, AppLocalizations l) async {
  final formKey = GlobalKey<FormState>();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();

  final result = await showDialog<String>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(l.exportSetPasswordDialogTitle),
      content: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: passwordController,
              obscureText: true,
              autofocus: true,
              decoration: InputDecoration(labelText: l.passwordLabel),
              validator: (value) => (value == null || value.length < 8) ? l.passwordTooShortError : null,
            ),
            TextFormField(
              controller: confirmController,
              obscureText: true,
              decoration: InputDecoration(labelText: l.confirmPasswordLabel),
              validator: (value) => value != passwordController.text ? l.passwordsDoNotMatchError : null,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(),
          child: Text(l.cancelButton),
        ),
        FilledButton(
          onPressed: () {
            if (!formKey.currentState!.validate()) return;
            Navigator.of(dialogContext).pop(passwordController.text);
          },
          child: Text(l.exportNotesButton),
        ),
      ],
    ),
  );
  passwordController.dispose();
  confirmController.dispose();
  return result;
}

/// Non-dismissible progress dialog shown while [deleteNotes] works through
/// its list — [progress] is updated by the caller (one relay round-trip per
/// note completed), this widget just reflects it live.
class _DeletionProgressDialog extends StatelessWidget {
  const _DeletionProgressDialog({
    required this.l,
    required this.progress,
    required this.total,
  });

  final AppLocalizations l;
  final ValueNotifier<int> progress;
  final int total;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: AlertDialog(
        title: Text(l.deletingNotesTitle),
        content: ValueListenableBuilder<int>(
          valueListenable: progress,
          builder: (context, completed, _) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LinearProgressIndicator(value: total == 0 ? 0 : completed / total),
                const SizedBox(height: 12),
                Text(l.deletingNotesProgress(completed, total)),
              ],
            );
          },
        ),
      ),
    );
  }
}
