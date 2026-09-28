import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../l10n/app_localizations.dart';
import '../models/note.dart';
import '../theme/echoes_theme.dart';
import 'note_card.dart';

/// The diary as a stationery timeline: a sticky month, then each day as a
/// numeral beside a rule, with that day's pages hanging from it.
class DiaryTimeline extends StatelessWidget {
  const DiaryTimeline({
    super.key,
    required this.notes,
    required this.selectedIds,
    required this.selectionMode,
    required this.pinnedIds,
    required this.archivedIds,
    required this.onOpen,
    required this.onLongPress,
    required this.onTogglePin,
    required this.onToggleArchive,
  });

  final List<Note> notes;
  final Set<String> selectedIds;
  final bool selectionMode;
  final Set<String> pinnedIds;
  final Set<String> archivedIds;
  final void Function(Note note) onOpen;
  final void Function(Note note) onLongPress;
  final void Function(Note note) onTogglePin;
  final void Function(Note note) onToggleArchive;

  @override
  Widget build(BuildContext context) {
    final sections = _months(notes);
    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        for (final section in sections) ...[
          SliverPersistentHeader(pinned: true, delegate: _MonthHeader(month: section.month)),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(EchoesTokens.lg, 4, EchoesTokens.lg, 8),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                return _DayColumn(
                  day: section.days[index],
                  selectedIds: selectedIds,
                  selectionMode: selectionMode,
                  pinnedIds: pinnedIds,
                  archivedIds: archivedIds,
                  onOpen: onOpen,
                  onLongPress: onLongPress,
                  onTogglePin: onTogglePin,
                  onToggleArchive: onToggleArchive,
                );
              }, childCount: section.days.length),
            ),
          ),
        ],
        const SliverToBoxAdapter(child: SizedBox(height: 96)),
      ],
    );
  }
}

class _MonthGroup {
  const _MonthGroup(this.month, this.days);

  final DateTime month;
  final List<_DayGroup> days;
}

class _DayGroup {
  const _DayGroup(this.day, this.notes);

  final DateTime day;
  final List<Note> notes;
}

List<_MonthGroup> _months(List<Note> notes) {
  final sorted = [...notes]
    ..sort((a, b) => (b.entryDate ?? b.updatedAt).compareTo(a.entryDate ?? a.updatedAt));
  final months = <_MonthGroup>[];
  for (final note in sorted) {
    final date = note.entryDate ?? note.updatedAt;
    final day = DateTime(date.year, date.month, date.day);
    final month = DateTime(date.year, date.month);
    final needsMonth = months.isEmpty || months.last.month != month;
    if (needsMonth) months.add(_MonthGroup(month, []));
    final days = months.last.days;
    final needsDay = days.isEmpty || days.last.day != day;
    if (needsDay) days.add(_DayGroup(day, []));
    days.last.notes.add(note);
  }
  return months;
}

class _MonthHeader extends SliverPersistentHeaderDelegate {
  _MonthHeader({required this.month});

  final DateTime month;

  @override
  double get minExtent => 42;

  @override
  double get maxExtent => 42;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final palette = EchoesPalette.of(context);
    final locale = Localizations.localeOf(context).toString();
    final pattern = month.year == DateTime.now().year ? 'MMMM' : 'yMMMM';
    final label = DateFormat(pattern, locale).format(month).toUpperCase();
    return GlassPane(
      radius: 0,
      child: SizedBox.expand(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: EchoesTokens.lg),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              label,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: palette.accentPrimary,
                letterSpacing: 1.6,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(_MonthHeader oldDelegate) => oldDelegate.month != month;
}

class _DayColumn extends StatelessWidget {
  const _DayColumn({
    required this.day,
    required this.selectedIds,
    required this.selectionMode,
    required this.pinnedIds,
    required this.archivedIds,
    required this.onOpen,
    required this.onLongPress,
    required this.onTogglePin,
    required this.onToggleArchive,
  });

  final _DayGroup day;
  final Set<String> selectedIds;
  final bool selectionMode;
  final Set<String> pinnedIds;
  final Set<String> archivedIds;
  final void Function(Note note) onOpen;
  final void Function(Note note) onLongPress;
  final void Function(Note note) onTogglePin;
  final void Function(Note note) onToggleArchive;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final palette = EchoesPalette.of(context);
    final today = DateTime.now();
    final start = DateTime(today.year, today.month, today.day);
    final delta = start.difference(day.day).inDays;
    final caption = delta == 0 ? l.diaryToday : (delta == 1 ? l.diaryYesterday : null);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 46,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${day.day.day}',
                  style: Theme.of(
                    context,
                  ).textTheme.headlineSmall?.copyWith(color: palette.textPrimary),
                ),
                if (caption != null)
                  Text(
                    caption,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(
                      context,
                    ).textTheme.labelSmall?.copyWith(color: palette.textMuted),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border(left: BorderSide(color: palette.borderSubtle, width: 1.5)),
              ),
              padding: const EdgeInsets.only(left: 12),
              child: Column(
                children: [
                  for (final note in day.notes)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: NoteCard(
                        key: ValueKey(note.id),
                        note: note,
                        selected: selectedIds.contains(note.id),
                        selectionMode: selectionMode,
                        pinned: pinnedIds.contains(note.id),
                        archived: archivedIds.contains(note.id),
                        previewLines: 3,
                        onTap: () => onOpen(note),
                        onLongPress: () => onLongPress(note),
                        onTogglePin: () => onTogglePin(note),
                        onToggleArchive: () => onToggleArchive(note),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
