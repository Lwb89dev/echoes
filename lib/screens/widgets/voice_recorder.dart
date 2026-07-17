import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../l10n/app_localizations.dart';

/// Inline microphone recorder embedded in `NoteEditorScreen` when creating
/// a voice note. Records straight to a file under the app's private
/// *documents* directory — deliberately not [getApplicationCacheDirectory],
/// which the OS is explicitly allowed to purge under storage pressure at
/// any time. `FileCacheService`'s own cache (decrypted attachments) is
/// fine living there because it's re-derivable — a re-download/decrypt
/// away from the encrypted blob still sitting on the relay/file host. A
/// not-yet-uploaded recording has no such backup: until the note is
/// synced, this file *is* the only copy of it that exists anywhere, so it
/// needs to survive exactly as long as any other unsynced local edit does.
/// [onRecorded] hands that file's path (plus how long the recording ran)
/// back to the caller once the user stops, which is what turns it into a
/// pending `Attachment` — the recording itself never leaves the device
/// until the note is explicitly synced (same as an added image).
///
/// Slides in from the side on mount and slides back out (then calls
/// [onCancel]/[onRecorded]) on the way out, rather than just popping in
/// and out of the layout — see [_VoiceRecorderState]'s `_slideController`.
class VoiceRecorder extends StatefulWidget {
  const VoiceRecorder({super.key, required this.onRecorded, required this.onCancel});

  final void Function(String path, Duration duration) onRecorded;
  final VoidCallback onCancel;

  @override
  State<VoiceRecorder> createState() => _VoiceRecorderState();
}

/// Idle: waiting for the user to tap the record button. Starting: permission
/// check + recorder setup in flight. Recording: mic is live.
enum _RecorderPhase { idle, starting, recording }

class _VoiceRecorderState extends State<VoiceRecorder> with SingleTickerProviderStateMixin {
  final _recorder = AudioRecorder();
  Timer? _ticker;
  Duration _elapsed = Duration.zero;
  _RecorderPhase _phase = _RecorderPhase.idle;

  /// Where the current take is being written, from [_start] until it's
  /// either handed off to [VoiceRecorder.onRecorded] (see [_stop]) or
  /// deleted as abandoned (see [_deleteAbandonedRecording]). Null whenever
  /// no take exists on disk that this recorder is still responsible for.
  String? _recordingPath;

  /// Slides the whole panel in from the trailing edge on mount; reversing
  /// this (then waiting for it to finish) is what makes closing — either
  /// via [_cancel] or a completed [_stop] — animate back out instead of
  /// just vanishing the instant the user taps something.
  late final AnimationController _slideController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 220),
  )..forward();

  late final Animation<Offset> _slide = CurvedAnimation(
    parent: _slideController,
    curve: Curves.easeOutCubic,
    reverseCurve: Curves.easeInCubic,
  ).drive(Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero));

  Future<void> _start() async {
    setState(() => _phase = _RecorderPhase.starting);
    if (!await _recorder.hasPermission()) {
      if (mounted) await _closeWith(widget.onCancel);
      return;
    }
    final dir = await getApplicationDocumentsDirectory();
    final path = '${dir.path}/echoes_recording_${DateTime.now().millisecondsSinceEpoch}.m4a';
    _recordingPath = path;
    await _recorder.start(const RecordConfig(encoder: AudioEncoder.aacLc), path: path);
    if (!mounted) return;
    // A recording in progress shouldn't be cut off (or need babysitting)
    // just because the screen timed out.
    await WakelockPlus.enable();
    setState(() => _phase = _RecorderPhase.recording);
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _elapsed += const Duration(seconds: 1));
    });
  }

  Future<void> _stop() async {
    _ticker?.cancel();
    await WakelockPlus.disable();
    final path = await _recorder.stop();
    final elapsed = _elapsed;
    if (path != null) {
      // Handed off: the file is the pending Attachment's problem now, not
      // this recorder's — must not be cleaned up by [dispose] below.
      _recordingPath = null;
      await _closeWith(() => widget.onRecorded(path, elapsed));
    } else {
      await _closeWith(widget.onCancel);
    }
  }

  Future<void> _cancel() async {
    _ticker?.cancel();
    await WakelockPlus.disable();
    // Discards the in-progress recording *file* too, not just the recorder
    // session — cancelling really means "never mind", and a cancelled
    // take must not keep sitting on disk as an orphaned audio file nobody
    // can see or remove from the UI. Harmless from the idle phase, before
    // anything started ([_recordingPath] still null).
    if (_phase == _RecorderPhase.recording) await _recorder.stop();
    await _deleteAbandonedRecording();
    await _closeWith(widget.onCancel);
  }

  /// Removes the recording file of a take that will never become an
  /// attachment (cancelled, or the whole screen torn down mid-recording).
  /// Best-effort: a failed delete only means a stray file, never a failed
  /// cancel.
  Future<void> _deleteAbandonedRecording() async {
    final path = _recordingPath;
    _recordingPath = null;
    if (path == null) return;
    try {
      await File(path).delete();
    } catch (_) {
      // Nothing useful to do with a cleanup failure here.
    }
  }

  /// Plays the close (reverse slide) animation, then invokes [action] —
  /// shared tail end of every way this panel can go away, so all of them
  /// animate out consistently instead of only the explicit-cancel path.
  Future<void> _closeWith(VoidCallback action) async {
    await _slideController.reverse();
    if (mounted) action();
  }

  @override
  void dispose() {
    _ticker?.cancel();
    _recorder.dispose();
    _slideController.dispose();
    // Best-effort: if this screen is being torn down entirely (e.g. system
    // back) mid-recording rather than through _stop/_cancel, neither the
    // wakelock nor the half-written recording file must outlive it —
    // an abandoned take is [_cancel]'s case, just without the animation.
    WakelockPlus.disable();
    _deleteAbandonedRecording();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    // A plain, saturated red for the record button specifically — the
    // universal "this button records" color in every camera/voice-memo
    // app, deliberately not tied to the theme's own (teal) accent color,
    // which wouldn't carry that same immediate meaning.
    const recordRed = Colors.red;

    if (_phase == _RecorderPhase.idle) {
      return SlideTransition(
        position: _slide,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Icon(Icons.mic_none, color: colorScheme.onSurfaceVariant, size: 16),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  l.recordVoiceNoteInstructions,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                tooltip: l.cancelRecordingTooltip,
                onPressed: _cancel,
              ),
              IconButton.filled(
                icon: const Icon(Icons.fiber_manual_record),
                tooltip: l.recordVoiceNoteTooltip,
                style: IconButton.styleFrom(backgroundColor: recordRed, foregroundColor: Colors.white),
                onPressed: _start,
              ),
            ],
          ),
        ),
      );
    }

    final starting = _phase == _RecorderPhase.starting;
    final minutes = _elapsed.inMinutes.toString().padLeft(2, '0');
    final seconds = (_elapsed.inSeconds % 60).toString().padLeft(2, '0');

    return SlideTransition(
      position: _slide,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Icon(Icons.fiber_manual_record, color: recordRed, size: 16),
            const SizedBox(width: 8),
            Text(starting ? '…' : '$minutes:$seconds'),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.close),
              tooltip: l.cancelRecordingTooltip,
              onPressed: _cancel,
            ),
            IconButton.filled(
              icon: const Icon(Icons.stop),
              tooltip: l.stopRecordingTooltip,
              style: IconButton.styleFrom(backgroundColor: recordRed, foregroundColor: Colors.white),
              onPressed: starting ? null : _stop,
            ),
          ],
        ),
      ),
    );
  }
}
