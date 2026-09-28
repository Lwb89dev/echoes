import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/app_localizations.dart';
import '../models/note.dart';
import '../providers/notes_provider.dart';
import '../theme/echoes_theme.dart';
import '../utils/note_links.dart';

/// Backlinks and outgoing links for the note being read, plus a way to
/// add one. A small constellation when the neighborhood is tiny; the list
/// underneath is what stays readable and accessible either way.
class NoteEchoesSection extends ConsumerWidget {
  const NoteEchoesSection({
    super.key,
    required this.noteId,
    required this.body,
    required this.onInsert,
    required this.onOpen,
  });

  final String noteId;
  final String body;

  /// Writes a `[[title|id]]` reference into the note. The editor owns the
  /// text field, so this widget never touches storage itself.
  final ValueChanged<Note> onInsert;
  final ValueChanged<Note> onOpen;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    // Ink comes from the note surface, not the app accent. On a coloured
    // sheet — and in dark mode, where the accent is a light lilac — the
    // accent sits on top of itself and disappears.
    final ink = scheme.onSurface;
    final muted = scheme.onSurfaceVariant;
    final notes = ref.watch(notesProvider).value ?? const <Note>[];
    final index = NoteLinkIndex.from(notes);
    final self = index.byId[noteId] ?? _placeholder(noteId, body);
    final outgoing = index.outgoing(self);
    final incoming = index.incoming(noteId);
    final neighbors = _union(incoming, outgoing);

    return Padding(
      padding: const EdgeInsets.only(top: EchoesTokens.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l.echoesSectionTitle,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: ink,
              letterSpacing: 1.2,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (neighbors.isNotEmpty && neighbors.length <= 5) ...[
            const SizedBox(height: 8),
            _Constellation(center: _titleOf(self, l), neighbors: neighbors, onOpen: onOpen),
          ],
          if (incoming.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              incoming.length == 1 ? l.echoesFromOneNote : l.echoesFromNotes(incoming.length),
              style: Theme.of(context).textTheme.titleSmall?.copyWith(color: muted),
            ),
            for (final note in incoming) _EchoRow(note: note, onOpen: onOpen),
          ],
          if (outgoing.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              l.echoesLinked,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(color: muted),
            ),
            for (final note in outgoing) _EchoRow(note: note, onOpen: onOpen),
          ],
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              style: TextButton.styleFrom(foregroundColor: ink),
              onPressed: () => _pick(context, ref, l),
              icon: Icon(Icons.subdirectory_arrow_right, color: ink),
              label: Text(l.linkANote),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pick(BuildContext context, WidgetRef ref, AppLocalizations l) async {
    final notes = ref.read(notesProvider).value ?? const <Note>[];
    final choices = notes.where((note) => note.id != noteId).toList();
    if (choices.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l.noNotesToLink)));
      return;
    }
    final palette = EchoesPalette.of(context);
    final picked = await showModalBottomSheet<Note>(
      context: context,
      backgroundColor: palette.surfacePaper,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(EchoesTokens.radiusLg)),
      ),
      builder: (sheetContext) => _NotePicker(title: l.pickNoteToLink, notes: choices),
    );
    if (picked != null) onInsert(picked);
  }
}

Note _placeholder(String id, String body) {
  final now = DateTime.now();
  return Note(id: id, title: '', body: body, createdAt: now, updatedAt: now);
}

List<Note> _union(List<Note> first, List<Note> second) {
  final seen = <String>{};
  final notes = <Note>[];
  for (final note in [...first, ...second]) {
    if (seen.add(note.id)) notes.add(note);
  }
  return notes;
}

String _titleOf(Note note, AppLocalizations l) {
  final title = note.title.trim();
  if (title.isNotEmpty) return title;
  return l.untitledNote;
}

class _EchoRow extends StatelessWidget {
  const _EchoRow({required this.note, required this.onOpen});

  final Note note;
  final ValueChanged<Note> onOpen;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final ink = Theme.of(context).colorScheme.onSurface;
    return InkWell(
      onTap: () => onOpen(note),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Icon(Icons.north_east, size: 16, color: ink),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                _titleOf(note, l),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Constellation extends StatelessWidget {
  const _Constellation({required this.center, required this.neighbors, required this.onOpen});

  final String center;
  final List<Note> neighbors;
  final ValueChanged<Note> onOpen;

  @override
  Widget build(BuildContext context) {
    final ink = Theme.of(context).colorScheme.onSurface;
    return Semantics(
      excludeSemantics: true,
      child: SizedBox(
        height: 168,
        width: double.infinity,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final cx = constraints.maxWidth / 2;
            const cy = 78.0;
            final radius = math.min(cx - 58, 72.0).clamp(36.0, 72.0);
            return Stack(
              children: [
                CustomPaint(
                  size: Size(constraints.maxWidth, 168),
                  painter: _SpokePainter(
                    count: neighbors.length,
                    center: Offset(cx, cy),
                    radius: radius,
                    color: ink.withValues(alpha: 0.55),
                  ),
                ),
                Positioned(
                  left: cx - 46,
                  top: cy - 16,
                  width: 92,
                  height: 36,
                  child: _Node(label: center, filled: true),
                ),
                for (var i = 0; i < neighbors.length; i++)
                  _placedNeighbor(
                    index: i,
                    count: neighbors.length,
                    cx: cx,
                    cy: cy,
                    radius: radius,
                    note: neighbors[i],
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _placedNeighbor({
    required int index,
    required int count,
    required double cx,
    required double cy,
    required double radius,
    required Note note,
  }) {
    final angle = -math.pi / 2 + (2 * math.pi * index / count);
    final left = cx + radius * math.cos(angle) - 48;
    final top = cy + radius * math.sin(angle) - 18;
    return Positioned(
      left: left,
      top: top,
      width: 96,
      height: 40,
      child: _Node(
        label: note.title.trim().isEmpty ? '…' : note.title.trim(),
        onTap: () => onOpen(note),
      ),
    );
  }
}

class _Node extends StatelessWidget {
  const _Node({required this.label, this.filled = false, this.onTap});

  final String label;
  final bool filled;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final ink = Theme.of(context).colorScheme.onSurface;
    final box = DecoratedBox(
      decoration: BoxDecoration(
        color: ink.withValues(alpha: filled ? 0.16 : 0.08),
        borderRadius: BorderRadius.circular(EchoesTokens.radiusSm),
        border: Border.all(color: ink.withValues(alpha: 0.55)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        child: Text(
          label,
          maxLines: 2,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(color: ink),
        ),
      ),
    );
    if (onTap == null) return box;
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(EchoesTokens.radiusSm),
        child: box,
      ),
    );
  }
}

class _SpokePainter extends CustomPainter {
  const _SpokePainter({
    required this.count,
    required this.center,
    required this.radius,
    required this.color,
  });

  final int count;
  final Offset center;
  final double radius;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;
    for (var i = 0; i < count; i++) {
      final angle = -math.pi / 2 + (2 * math.pi * i / count);
      final end = center + Offset(math.cos(angle), math.sin(angle)) * (radius - 18);
      canvas.drawLine(center, end, paint);
    }
  }

  @override
  bool shouldRepaint(_SpokePainter oldDelegate) =>
      oldDelegate.count != count || oldDelegate.radius != radius;
}

class _NotePicker extends StatelessWidget {
  const _NotePicker({required this.title, required this.notes});

  final String title;
  final List<Note> notes;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(title, style: Theme.of(context).textTheme.titleMedium),
            ),
          ),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];
                final label = note.title.trim().isEmpty ? l.untitledNote : note.title.trim();
                return ListTile(
                  title: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
                  onTap: () => Navigator.of(context).pop(note),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
