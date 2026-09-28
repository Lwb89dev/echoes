import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

import '../l10n/app_localizations.dart';
import '../models/attachment.dart';
import '../models/note.dart';
import '../theme/echoes_theme.dart';
import '../utils/formatter.dart';
import '../utils/note_colors.dart';
import '../utils/note_links.dart';
import '../utils/voice_bars.dart';
import 'echo_mark.dart';
import 'voice_waveform.dart';

/// A note as a sheet of paper on the desk: its own height, a soft shadow,
/// a press that settles, and a horizontal swipe that pins or archives.
///
/// Swipe is a shortcut. The same actions are exposed as semantics actions
/// and as buttons in the selection bar, so nothing here is gesture-only.
class NoteCard extends StatefulWidget {
  const NoteCard({
    super.key,
    required this.note,
    required this.selected,
    required this.selectionMode,
    required this.pinned,
    required this.archived,
    required this.onTap,
    required this.onLongPress,
    required this.onTogglePin,
    required this.onToggleArchive,
    this.previewLines = 6,
  });

  final Note note;
  final bool selected;
  final bool selectionMode;
  final bool pinned;
  final bool archived;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final VoidCallback onTogglePin;
  final VoidCallback onToggleArchive;
  final int previewLines;

  @override
  State<NoteCard> createState() => _NoteCardState();
}

class _NoteCardState extends State<NoteCard> {
  double _offset = 0;
  bool _pressed = false;

  @override
  void didUpdateWidget(NoteCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.note.id != widget.note.id) {
      _offset = 0;
      _pressed = false;
    }
  }

  void _drag(DragUpdateDetails details) {
    if (widget.selectionMode) return;
    setState(() => _offset = (_offset + details.delta.dx).clamp(-88.0, 88.0));
  }

  void _end(DragEndDetails details) {
    final pin = _offset > 56;
    final archive = _offset < -56;
    setState(() => _offset = 0);
    if (pin) widget.onTogglePin();
    if (archive) widget.onToggleArchive();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final palette = EchoesPalette.of(context);
    final pinLabel = widget.pinned ? l.unpinNote : l.pinNote;
    final archiveLabel = widget.archived ? l.unarchiveNote : l.archiveNote;
    final motion = echoesMotionEnabled(context);
    final scale = _pressed && motion ? 0.985 : 1.0;

    return Semantics(
      customSemanticsActions: {
        CustomSemanticsAction(label: pinLabel): widget.onTogglePin,
        CustomSemanticsAction(label: archiveLabel): widget.onToggleArchive,
      },
      child: Stack(
        children: [
          Positioned.fill(
            child: _SwipeGutter(offset: _offset, palette: palette),
          ),
          Transform.translate(
            offset: Offset(widget.selectionMode ? 0 : _offset, 0),
            child: GestureDetector(
              onHorizontalDragUpdate: widget.selectionMode ? null : _drag,
              onHorizontalDragEnd: widget.selectionMode ? null : _end,
              child: AnimatedScale(
                scale: scale,
                duration: EchoesTokens.shortMotion,
                curve: Curves.easeOut,
                child: _CardFace(
                  note: widget.note,
                  selected: widget.selected,
                  selectionMode: widget.selectionMode,
                  pinned: widget.pinned,
                  archived: widget.archived,
                  previewLines: widget.previewLines,
                  onTap: widget.onTap,
                  onLongPress: widget.onLongPress,
                  onPressChanged: (down) {
                    if (_pressed == down) return;
                    setState(() => _pressed = down);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SwipeGutter extends StatelessWidget {
  const _SwipeGutter({required this.offset, required this.palette});

  final double offset;
  final EchoesPalette palette;

  @override
  Widget build(BuildContext context) {
    final pinning = offset >= 0;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: pinning ? palette.accentSoft : palette.surfacePressed,
        borderRadius: BorderRadius.circular(EchoesTokens.radiusMd),
      ),
      child: Align(
        alignment: pinning ? Alignment.centerLeft : Alignment.centerRight,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Icon(
            pinning ? Icons.push_pin_outlined : Icons.archive_outlined,
            color: palette.accentPrimary,
          ),
        ),
      ),
    );
  }
}

class _CardFace extends StatelessWidget {
  const _CardFace({
    required this.note,
    required this.selected,
    required this.selectionMode,
    required this.pinned,
    required this.archived,
    required this.previewLines,
    required this.onTap,
    required this.onLongPress,
    required this.onPressChanged,
  });

  final Note note;
  final bool selected;
  final bool selectionMode;
  final bool pinned;
  final bool archived;
  final int previewLines;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final ValueChanged<bool> onPressChanged;

  @override
  Widget build(BuildContext context) {
    final palette = EchoesPalette.of(context);
    final dark = Theme.of(context).brightness == Brightness.dark;
    final scheme = Theme.of(context).colorScheme;
    final tint = selected
        ? scheme.primaryContainer
        : (note.color?.background ?? palette.surfacePaper);
    final foreground = selected
        ? scheme.onPrimaryContainer
        : (note.color?.onBackground ?? palette.textPrimary);
    // Same rule on every sheet, including the plain one: metadata stays
    // softer than the title and still clears the color it sits on.
    final muted = mutedTextColorOn(tint);
    final shadow = [
      BoxShadow(
        color: palette.accentPrimary.withValues(alpha: dark ? 0.28 : 0.14),
        blurRadius: 18,
        offset: const Offset(0, 8),
      ),
      ...EchoesTokens.raisedShadow(palette.shadowSoft),
    ];

    return DecoratedBox(
      decoration: echoesGlassDecoration(
        tint: tint,
        dark: dark,
        borderColor: selected ? scheme.primary : null,
        shadow: shadow,
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: BorderRadius.circular(EchoesTokens.radiusMd),
          onTap: onTap,
          onLongPress: onLongPress,
          onHighlightChanged: onPressChanged,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_localImage(note) case final file?) _CardImage(file: file),
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                child: _CardBody(
                  note: note,
                  foreground: foreground,
                  muted: muted,
                  previewLines: previewLines,
                  selectionMode: selectionMode,
                  selected: selected,
                  pinned: pinned,
                  archived: archived,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

File? _localImage(Note note) {
  for (final attachment in note.attachments) {
    if (attachment.type != AttachmentType.image) continue;
    final path = attachment.localPath;
    if (path == null || path.isEmpty) continue;
    return File(path);
  }
  return null;
}

class _CardImage extends StatelessWidget {
  const _CardImage({required this.file});

  final File file;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(EchoesTokens.radiusMd)),
      child: Image.file(
        file,
        height: 120,
        width: double.infinity,
        fit: BoxFit.cover,
        cacheWidth: 480,
        filterQuality: FilterQuality.low,
        errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
      ),
    );
  }
}

class _CardBody extends StatelessWidget {
  const _CardBody({
    required this.note,
    required this.foreground,
    required this.muted,
    required this.previewLines,
    required this.selectionMode,
    required this.selected,
    required this.pinned,
    required this.archived,
  });

  final Note note;
  final Color foreground;
  final Color muted;
  final int previewLines;
  final bool selectionMode;
  final bool selected;
  final bool pinned;
  final bool archived;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final title = note.title.trim();
    final audio = _firstAudio(note);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (selectionMode) _SelectionMark(selected: selected, color: foreground),
        if (title.isNotEmpty)
          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: foreground,
              fontWeight: FontWeight.w600,
              height: 1.25,
            ),
          ),
        if (note.isChecklist)
          _ChecklistPreview(note: note, color: foreground, muted: muted)
        else
          _ProsePreview(note: note, muted: muted, maxLines: previewLines),
        if (audio != null) ...[
          const SizedBox(height: 8),
          VoiceWaveform(
            seed: audio.id,
            color: muted,
            durationLabel: voiceDurationLabel(audio.durationSeconds),
          ),
        ],
        const SizedBox(height: 10),
        _CardFooter(
          note: note,
          muted: muted,
          foreground: foreground,
          pinned: pinned,
          archived: archived,
          sharedLabel: note.isSharedWithMe ? l.sharedWithMeHeader : null,
        ),
      ],
    );
  }
}

Attachment? _firstAudio(Note note) {
  for (final attachment in note.attachments) {
    if (attachment.type == AttachmentType.audio) return attachment;
  }
  return null;
}

class _SelectionMark extends StatelessWidget {
  const _SelectionMark({required this.selected, required this.color});

  final bool selected;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Icon(selected ? Icons.check_circle : Icons.circle_outlined, size: 18, color: color),
    );
  }
}

class _ProsePreview extends StatelessWidget {
  const _ProsePreview({required this.note, required this.muted, required this.maxLines});

  final Note note;
  final Color muted;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    final text = plainNoteExcerpt(note.body);
    if (text.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Text(
        text,
        maxLines: maxLines,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: muted, height: 1.4),
      ),
    );
  }
}

class _ChecklistPreview extends StatelessWidget {
  const _ChecklistPreview({required this.note, required this.color, required this.muted});

  final Note note;
  final Color color;
  final Color muted;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final open = note.items.where((item) => !item.done && item.text.trim().isNotEmpty).take(4);
    final rows = open.toList();
    if (rows.isEmpty && note.items.isNotEmpty) {
      final done = note.items.where((item) => item.done).length;
      return Padding(
        padding: const EdgeInsets.only(top: 6),
        child: Text(
          l.checklistProgress(done, note.items.length),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: muted),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final item in rows)
            Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: Row(
                children: [
                  Icon(Icons.circle_outlined, size: 14, color: muted),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      item.text.trim(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: color, height: 1.3),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _CardFooter extends StatelessWidget {
  const _CardFooter({
    required this.note,
    required this.muted,
    required this.foreground,
    required this.pinned,
    required this.archived,
    required this.sharedLabel,
  });

  final Note note;
  final Color muted;
  final Color foreground;
  final bool pinned;
  final bool archived;
  final String? sharedLabel;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final echoed = note.synced;
    final label = echoed
        ? l.syncEchoedLabel
        : (note.nostrEventId != null ? l.syncPendingLabel : l.syncLocalLabel);
    return Row(
      children: [
        Flexible(
          child: Text(
            Formatter.relativeTimestamp(note.updatedAt, l),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(color: muted),
          ),
        ),
        if (pinned) ...[
          const SizedBox(width: 8),
          Icon(Icons.push_pin, size: 14, color: muted, semanticLabel: l.pinnedLabel),
        ],
        if (archived) ...[
          const SizedBox(width: 8),
          Text(
            l.archiveTitle,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(color: muted),
          ),
        ],
        if (sharedLabel != null) ...[
          const SizedBox(width: 8),
          Icon(Icons.person_outline, size: 14, color: muted, semanticLabel: sharedLabel),
        ],
        const Spacer(),
        EchoMark(
          identity: note.id,
          echoed: echoed,
          label: label,
          color: echoed ? foreground : muted,
          size: 16,
        ),
      ],
    );
  }
}
