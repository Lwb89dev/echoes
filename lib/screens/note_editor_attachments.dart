// Part of note_editor_screen.dart — the widgets that render a note's
// attachments in the read/preview view: image thumbnails, the markdown
// body (with inline images and voice bubbles), and the voice-message
// player bubble. Split out to shrink the editor's main file; `part of`
// keeps them file-private and sharing the library's imports unchanged.
part of 'note_editor_screen.dart';

/// An image attachment's thumbnail: the local file directly while it's
/// still pending upload, or the decrypted-and-cached file once uploaded
/// (see `AttachmentUploadService.getDecrypted`) — never the raw remote
/// URL, since that's only ever encrypted bytes.
///
/// A `ConsumerStatefulWidget` on purpose, not the simpler `ConsumerWidget`
/// it used to be: that version called `getDecrypted` directly inline in
/// `build()`, which built a *brand new* `Future` every single rebuild —
/// and `FutureBuilder` resets to "waiting" whenever the `future` it's
/// passed isn't identical to the previous one. Since this widget sits
/// inside `NoteEditorScreen`'s body, *any* `setState` there (typing a
/// character, toggling a checklist item, anything) rebuilt it and
/// silently restarted the download-and-decrypt from scratch, so a slow or
/// briefly-unreachable host could keep it stuck "loading" (or flipping
/// back to broken) indefinitely, no matter how many times it retried.
/// Caching the `Future` once per attachment identity (here, in State)
/// lets it actually run to completion and settle.
class _ImageAttachmentPreview extends ConsumerStatefulWidget {
  const _ImageAttachmentPreview({required this.attachment, this.fit = BoxFit.cover});

  final Attachment attachment;
  final BoxFit fit;

  @override
  ConsumerState<_ImageAttachmentPreview> createState() => _ImageAttachmentPreviewState();
}

class _ImageAttachmentPreviewState extends ConsumerState<_ImageAttachmentPreview> {
  /// The still-on-disk local original, when there is one — checked once
  /// per attachment identity (not on every build) in [_resolveSource].
  File? _localFile;
  Future<File>? _decryptFuture;

  @override
  void initState() {
    super.initState();
    _resolveSource();
  }

  @override
  void didUpdateWidget(covariant _ImageAttachmentPreview oldWidget) {
    super.didUpdateWidget(oldWidget);
    // A note editor reuses this Element across rebuilds, but the
    // attachment it's showing can genuinely change (e.g. right after an
    // upload fills in `url` for the first time) — only then does the
    // cached source decision need to be redone.
    if (oldWidget.attachment.url != widget.attachment.url ||
        oldWidget.attachment.localPath != widget.attachment.localPath) {
      _resolveSource();
    }
  }

  /// Decides where this image's bytes come from, in order of preference:
  /// the original local file if it still exists, else download-and-decrypt
  /// if it was ever uploaded, else nothing — rendered as a neutral
  /// missing-attachment placeholder by [build], *never* left to
  /// `Image.file` on a dead path (whose unhandled exception is Flutter's
  /// red ErrorWidget box). A dead path is a real state, not a fluke: the
  /// OS purging a cache-dir file, or a note synced from another device
  /// whose `localPath` never meant anything here.
  void _resolveSource() {
    final localPath = widget.attachment.localPath;
    _localFile = localPath != null && File(localPath).existsSync() ? File(localPath) : null;
    _decryptFuture = _localFile == null && widget.attachment.isUploaded
        ? ref.read(attachmentUploadServiceProvider).getDecrypted(widget.attachment)
        : null;
  }

  Widget _missingPlaceholder(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      color: colorScheme.surfaceContainerHighest,
      padding: const EdgeInsets.all(12),
      child: Center(child: Icon(Icons.image_not_supported_outlined, color: colorScheme.outline)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localFile = _localFile;
    if (localFile != null) {
      return Image.file(
        localFile,
        fit: widget.fit,
        // The file passing existsSync in [_resolveSource] doesn't
        // guarantee it decodes (truncated write, deleted since) — degrade
        // to the placeholder, never Flutter's red error box.
        errorBuilder: (context, error, stackTrace) => _missingPlaceholder(context),
      );
    }
    if (_decryptFuture == null) {
      // No local file *and* never uploaded: the bytes are gone. Nothing
      // to retry — show it honestly instead of an eternal spinner.
      return _missingPlaceholder(context);
    }
    return FutureBuilder<File>(
      future: _decryptFuture,
      builder: (context, snapshot) {
        final file = snapshot.data;
        if (file == null) {
          return Container(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: snapshot.hasError
                ? IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: () => setState(_resolveSource),
                  )
                : const Center(child: CircularProgressIndicator(strokeWidth: 2)),
          );
        }
        return Image.file(
          file,
          fit: widget.fit,
          errorBuilder: (context, error, stackTrace) => _missingPlaceholder(context),
        );
      },
    );
  }
}

/// Renders a note's body as markdown — used by the read-only view (see
/// [_NoteEditorScreenState._buildViewBody]) — with inline
/// `attachment://<id>` tokens (see [_NoteEditorScreenState._insertImageToken]/
/// [_NoteEditorScreenState._insertVoiceToken]) resolved to the actual
/// attachment: an image at its chosen width, or a full-width playable
/// voice message bubble.
class _MarkdownPreview extends StatelessWidget {
  const _MarkdownPreview({
    required this.text,
    required this.attachments,
    required this.onTapImage,
    required this.onRemoveVoice,
    required this.onSetVoiceTimestamp,
  });

  final String text;
  final List<Attachment> attachments;

  /// Called with the tapped image's attachment and its current size
  /// keyword (null if the token had none/an unrecognized one).
  final void Function(Attachment attachment, String? currentSize) onTapImage;

  /// Wired to an inline voice bubble's own remove (✕) button — unlike
  /// images (whose removal sits behind the resize sheet), a voice message
  /// exposes it directly, same as everywhere else [_VoiceMessageBubble] is
  /// used.
  final void Function(Attachment attachment) onRemoveVoice;

  final void Function(Attachment attachment, DateTime timestamp) onSetVoiceTimestamp;

  Attachment? _findAttachment(String id) {
    for (final attachment in attachments) {
      if (attachment.id == id) return attachment;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    if (text.trim().isEmpty) return const SizedBox.shrink();
    // `MarkdownStyleSheet.styles` has no constructor slot for a `u` tag —
    // it only takes the fixed set of standard elements — but its getter
    // hands back the same mutable map the builder reads from, so adding the
    // underline style this way (rather than forking the package) is enough
    // for `UnderlineSyntax`'s `u` elements (see underline_syntax.dart) to
    // pick it up like any of the built-in tags.
    final styleSheet = MarkdownStyleSheet.fromTheme(Theme.of(context));
    styleSheet.styles['u'] = const TextStyle(decoration: TextDecoration.underline);
    return MarkdownBody(
      data: text,
      // Plain, normally-aligned text: the theme defaults leave paragraphs
      // left-aligned (start), which is how prose should read. An earlier
      // experiment set this to justify (`WrapAlignment.spaceBetween`), but on
      // short lines it stretched the spacing so the text looked centered/
      // spread rather than tidy — reverted.
      styleSheet: styleSheet,
      inlineSyntaxes: [UnderlineSyntax()],
      imageBuilder: (uri, title, alt) {
        final attachment = _findAttachment(uri.host);
        if (attachment == null) {
          // A token whose attachment was removed some other way (e.g. an
          // older export/import round trip) — nothing sane to render.
          return const SizedBox.shrink();
        }
        if (attachment.type == AttachmentType.audio) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: SizedBox(
              width: double.infinity,
              child: _VoiceMessageBubble(
                key: ValueKey(attachment.id),
                attachment: attachment,
                onRemove: () => onRemoveVoice(attachment),
                onSetTimestamp: (timestamp) => onSetVoiceTimestamp(attachment, timestamp),
              ),
            ),
          );
        }
        return _InlineAttachmentImage(
          attachment: attachment,
          widthKeyword: title,
          onTap: () => onTapImage(attachment, title),
        );
      },
    );
  }
}

/// A single inline image within [_MarkdownPreview]: constrained to a
/// fraction of the available width per its size keyword (small/medium/
/// full — see [_NoteEditorScreenState._pickImageSize]), tappable to change
/// that size or remove it.
class _InlineAttachmentImage extends StatelessWidget {
  const _InlineAttachmentImage({
    required this.attachment,
    required this.widthKeyword,
    required this.onTap,
  });

  final Attachment attachment;
  final String? widthKeyword;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final widthFactor = switch (widthKeyword) {
      'small' => 0.35,
      'full' => 1.0,
      _ => 0.65,
    };
    return GestureDetector(
      onTap: onTap,
      child: FractionallySizedBox(
        widthFactor: widthFactor,
        alignment: Alignment.centerLeft,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: _ImageAttachmentPreview(attachment: attachment, fit: BoxFit.contain),
        ),
      ),
    );
  }
}

/// A voice attachment shown as a Telegram-style "voice message" bubble: a
/// play/pause button, a waveform that traces the actual recorded audio
/// (extracted on-device by `audio_waveforms`, not a generic placeholder)
/// and fills in to show playback progress, and the recording's duration.
/// Long-pressing it (anywhere except the play/remove buttons themselves,
/// which claim that gesture first) offers setting/editing
/// [Attachment.recordedAt] — allowed everywhere this bubble appears,
/// read-only view included, same as playback itself: neither is really an
/// "editing" action the way adding/removing an attachment is.
class _VoiceMessageBubble extends ConsumerStatefulWidget {
  const _VoiceMessageBubble({
    super.key,
    required this.attachment,
    required this.onSetTimestamp,
    this.onRemove,
  });

  final Attachment attachment;

  final void Function(DateTime timestamp) onSetTimestamp;

  /// Null in the read-only view: hides the remove (✕) button but leaves
  /// playback fully working — listening to a voice note isn't an editing
  /// intent, unlike everything else on that screen (see
  /// [_NoteEditorScreenState._buildViewBody]).
  final VoidCallback? onRemove;

  @override
  ConsumerState<_VoiceMessageBubble> createState() => _VoiceMessageBubbleState();
}

class _VoiceMessageBubbleState extends ConsumerState<_VoiceMessageBubble> {
  final _playerController = PlayerController();
  bool _ready = false;
  Object? _error;

  @override
  void initState() {
    super.initState();
    // `audio_waveforms` has no Linux/Windows implementation (see
    // [PlatformSupport.supportsVoiceNotes]) — preparing the player there
    // would just throw `MissingPluginException` on every attempt, so
    // [build] shows a static "not supported here" bubble instead of an
    // endless retry loop, and there's nothing to prepare.
    if (!PlatformSupport.supportsVoiceNotes) return;
    // Fire-and-forget: the file needs a local path (waiting on a decrypt
    // download if not yet cached) before the player can prepare, both of
    // which are async — the widget renders a loading spinner in the
    // meantime (see [build]) rather than blocking the first frame on it.
    _prepare();
  }

  @override
  void didUpdateWidget(covariant _VoiceMessageBubble oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!PlatformSupport.supportsVoiceNotes) return;
    // The attachment can gain its `url` while this bubble is on screen (a
    // background sync uploading it — which also deletes the local file
    // the player was prepared from). Re-preparing from the decrypted
    // cache is what keeps the play button working across that handoff;
    // ExoPlayer only opens the file at play time, so a stale prepared
    // path fails exactly then (seen as a FileNotFoundException/ENOENT
    // playback error in logcat), not at prepare time.
    if (oldWidget.attachment.url != widget.attachment.url ||
        oldWidget.attachment.localPath != widget.attachment.localPath) {
      _prepare();
    }
  }

  @override
  void dispose() {
    // Never touched on unsupported platforms (see [initState]) — disposing
    // it anyway would reach for the same missing native implementation.
    if (PlatformSupport.supportsVoiceNotes) _playerController.dispose();
    super.dispose();
  }

  Future<void> _prepare() async {
    setState(() {
      _error = null;
      _ready = false;
    });
    try {
      if (_playerController.playerState == PlayerState.playing) {
        await _playerController.stopPlayer();
      }
      // Prefer the local original only while it actually exists on disk —
      // never trust `localPath` blindly: the OS may have purged it (old
      // cache-dir recordings) or it may have come from another device
      // entirely. Fall back to download-and-decrypt when uploaded;
      // otherwise the audio is genuinely gone and the error state (with
      // its tap-to-retry) is the honest answer.
      final localPath = widget.attachment.localPath;
      final String path;
      if (localPath != null && File(localPath).existsSync()) {
        path = localPath;
      } else if (widget.attachment.isUploaded) {
        path =
            (await ref.read(attachmentUploadServiceProvider).getDecrypted(widget.attachment)).path;
      } else {
        throw StateError('Voice note file is missing locally and was never uploaded.');
      }
      await _playerController.preparePlayer(path: path, noOfSamples: 60);
      if (!mounted) return;
      setState(() => _ready = true);
    } catch (e) {
      developer.log(
        'Could not prepare voice note ${widget.attachment.id} for playback: $e',
        name: '_VoiceMessageBubble',
      );
      if (!mounted) return;
      setState(() => _error = e);
    }
  }

  Future<void> _toggle() async {
    if (!_ready) return;
    if (_playerController.playerState == PlayerState.playing) {
      await _playerController.pausePlayer();
    } else {
      await _playerController.startPlayer();
    }
    if (mounted) setState(() {});
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  Future<void> _showTimestampMenu() async {
    final l = AppLocalizations.of(context);
    final hasTimestamp = widget.attachment.recordedAt != null;
    await showModalBottomSheet<void>(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: ListTile(
          leading: const Icon(Icons.schedule_outlined),
          title: Text(hasTimestamp ? l.editVoiceTimestampButton : l.addVoiceTimestampButton),
          onTap: () {
            Navigator.of(sheetContext).pop();
            _pickTimestamp();
          },
        ),
      ),
    );
  }

  /// Defaults to [Attachment.recordedAt] if already set, or to now — not
  /// the moment recording actually stopped, since that's only meaningful
  /// as the *initial* default (already applied in
  /// [_NoteEditorScreenState._onVoiceRecorded]); re-opening this picker
  /// later has no way to recover that original moment, so "now" is the
  /// more honest fallback for an edit happening well after the fact.
  Future<void> _pickTimestamp() async {
    final now = DateTime.now();
    final initial = widget.attachment.recordedAt ?? now;
    final date = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(now.year - 100),
      lastDate: now.add(const Duration(days: 1)),
    );
    if (date == null || !mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initial),
    );
    if (time == null || !mounted) return;
    widget.onSetTimestamp(DateTime(date.year, date.month, date.day, time.hour, time.minute));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onBubble = theme.colorScheme.onSecondaryContainer;
    final duration = widget.attachment.durationSeconds;
    final recordedAt = widget.attachment.recordedAt;

    // No playback backend on this platform (see [initState]) — still show
    // the bubble (duration, timestamp, remove button all keep working; the
    // attachment itself, and its encryption, is entirely unaffected), just
    // without a play button or waveform that could never do anything.
    if (!PlatformSupport.supportsVoiceNotes) {
      return GestureDetector(
        onLongPress: _showTimestampMenu,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          decoration: BoxDecoration(
            color: theme.colorScheme.secondaryContainer,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Icon(Icons.mic_off_outlined, color: onBubble),
                  ),
                  Expanded(
                    child: Text(
                      AppLocalizations.of(context).voiceNoteUnsupportedOnPlatform,
                      style: theme.textTheme.bodySmall?.copyWith(color: onBubble),
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (duration != null)
                    Text(
                      _formatDuration(duration),
                      style: theme.textTheme.bodySmall?.copyWith(color: onBubble),
                    ),
                  if (widget.onRemove != null)
                    IconButton(
                      icon: Icon(Icons.close, size: 18, color: onBubble),
                      onPressed: widget.onRemove,
                    ),
                ],
              ),
              if (recordedAt != null)
                Padding(
                  padding: const EdgeInsets.only(left: 16, bottom: 4),
                  child: Text(
                    Formatter.voiceTimestampLabel(recordedAt, Localizations.localeOf(context)),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: onBubble.withValues(alpha: 0.7),
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
    }

    final playing = _playerController.playerState == PlayerState.playing;

    return GestureDetector(
      onLongPress: _showTimestampMenu,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        decoration: BoxDecoration(
          color: theme.colorScheme.secondaryContainer,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                IconButton(
                  icon: _error != null
                      ? Icon(Icons.error_outline, color: onBubble)
                      : Icon(playing ? Icons.pause : Icons.play_arrow, color: onBubble),
                  // Tapping the error state retries preparation instead of
                  // doing nothing — matches `_ImageAttachmentPreview`'s own
                  // retry-on-tap for the same "download/decrypt failed"
                  // situation.
                  onPressed: _error != null ? _prepare : (_ready ? _toggle : null),
                ),
                Expanded(
                  child: _ready
                      ? LayoutBuilder(
                          builder: (context, constraints) => AudioFileWaveforms(
                            size: Size(constraints.maxWidth, 36),
                            playerController: _playerController,
                            waveformType: WaveformType.fitWidth,
                            enableSeekGesture: true,
                            playerWaveStyle: PlayerWaveStyle(
                              fixedWaveColor: onBubble.withValues(alpha: 0.35),
                              liveWaveColor: onBubble,
                              spacing: 4,
                              waveThickness: 2,
                            ),
                          ),
                        )
                      : SizedBox(
                          height: 36,
                          child: Center(
                            child: _error != null
                                ? null
                                : const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  ),
                          ),
                        ),
                ),
                const SizedBox(width: 8),
                if (duration != null)
                  Text(
                    _formatDuration(duration),
                    style: theme.textTheme.bodySmall?.copyWith(color: onBubble),
                  ),
                if (widget.onRemove != null)
                  IconButton(
                    icon: Icon(Icons.close, size: 18, color: onBubble),
                    onPressed: widget.onRemove,
                  ),
              ],
            ),
            if (recordedAt != null)
              Padding(
                padding: const EdgeInsets.only(left: 16, bottom: 4),
                child: Text(
                  Formatter.voiceTimestampLabel(recordedAt, Localizations.localeOf(context)),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: onBubble.withValues(alpha: 0.7),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
