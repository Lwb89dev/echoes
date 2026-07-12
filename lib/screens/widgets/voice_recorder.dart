import 'dart:async';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

import '../../l10n/app_localizations.dart';

/// Inline microphone recorder embedded in `NoteEditorScreen` when creating
/// a voice note. Records straight to a file under the app's private cache
/// directory; [onRecorded] hands that file's path (plus how long the
/// recording ran) back to the caller once the user stops, which is what
/// turns it into a pending `Attachment` — the recording itself never
/// leaves the device until the note is explicitly synced (same as an
/// added image).
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

class _VoiceRecorderState extends State<VoiceRecorder> {
  final _recorder = AudioRecorder();
  Timer? _ticker;
  Duration _elapsed = Duration.zero;
  _RecorderPhase _phase = _RecorderPhase.idle;

  Future<void> _start() async {
    setState(() => _phase = _RecorderPhase.starting);
    if (!await _recorder.hasPermission()) {
      if (mounted) widget.onCancel();
      return;
    }
    final dir = await getApplicationCacheDirectory();
    final path = '${dir.path}/echoes_recording_${DateTime.now().millisecondsSinceEpoch}.m4a';
    await _recorder.start(const RecordConfig(encoder: AudioEncoder.aacLc), path: path);
    if (!mounted) return;
    setState(() => _phase = _RecorderPhase.recording);
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _elapsed += const Duration(seconds: 1));
    });
  }

  Future<void> _stop() async {
    _ticker?.cancel();
    final path = await _recorder.stop();
    if (path != null) {
      widget.onRecorded(path, _elapsed);
    } else {
      widget.onCancel();
    }
  }

  Future<void> _cancel() async {
    _ticker?.cancel();
    // Discards the in-progress recording file too — cancelling really
    // means "never mind", not "keep a silent/partial attachment around".
    // Harmless to call even from the idle phase, before anything started.
    if (_phase == _RecorderPhase.recording) await _recorder.stop();
    widget.onCancel();
  }

  @override
  void dispose() {
    _ticker?.cancel();
    _recorder.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    if (_phase == _RecorderPhase.idle) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Icon(Icons.mic_none, color: Theme.of(context).colorScheme.onSurfaceVariant, size: 16),
            const SizedBox(width: 8),
            Expanded(child: Text(l.recordVoiceNoteTooltip)),
            IconButton(
              icon: const Icon(Icons.close),
              tooltip: l.cancelRecordingTooltip,
              onPressed: _cancel,
            ),
            IconButton.filled(
              icon: const Icon(Icons.fiber_manual_record),
              tooltip: l.recordVoiceNoteTooltip,
              onPressed: _start,
            ),
          ],
        ),
      );
    }

    final starting = _phase == _RecorderPhase.starting;
    final minutes = _elapsed.inMinutes.toString().padLeft(2, '0');
    final seconds = (_elapsed.inSeconds % 60).toString().padLeft(2, '0');

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(Icons.fiber_manual_record, color: Theme.of(context).colorScheme.error, size: 16),
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
            onPressed: starting ? null : _stop,
          ),
        ],
      ),
    );
  }
}
