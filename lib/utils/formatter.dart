import 'package:flutter/widgets.dart' show Locale;
import 'package:intl/intl.dart';

import '../l10n/app_localizations.dart';

/// UI formatting helpers.
class Formatter {
  Formatter._();

  /// Compact relative timestamp for the list view ("now", "5m ago", "2d ago"...).
  static String relativeTimestamp(DateTime dateTime, AppLocalizations l) {
    final diff = DateTime.now().difference(dateTime);

    if (diff.inSeconds < 60) return l.timeJustNow;
    if (diff.inMinutes < 60) return l.timeMinutesAgo(diff.inMinutes);
    if (diff.inHours < 24) return l.timeHoursAgo(diff.inHours);
    if (diff.inDays < 7) return l.timeDaysAgo(diff.inDays);

    return '${dateTime.day.toString().padLeft(2, '0')}/'
        '${dateTime.month.toString().padLeft(2, '0')}/'
        '${dateTime.year}';
  }

  /// Truncates a hex/npub key for display (e.g. "npub1abc…wxyz").
  static String truncateKey(String key, {int head = 8, int tail = 4}) {
    if (key.length <= head + tail) return key;
    return '${key.substring(0, head)}…${key.substring(key.length - tail)}';
  }

  /// Compares two [DateTime]s by calendar day alone, ignoring time of day —
  /// shared by [diaryDateLabel] and [DiaryScreen]'s day grouping so "today"/
  /// "yesterday" can't be thrown off by an entry logged late at night.
  static int _daysBetween(DateTime from, DateTime to) {
    final f = DateTime(from.year, from.month, from.day);
    final t = DateTime(to.year, to.month, to.day);
    return t.difference(f).inDays;
  }

  /// A diary entry's date, formatted for display: "Today"/"Yesterday"
  /// (localized) for the two most recent days, otherwise a full localized
  /// date ("12 July 2026") — used both for [NoteEditorScreen]'s date chip
  /// and [DiaryScreen]'s day headers.
  static String diaryDateLabel(DateTime date, AppLocalizations l, Locale locale) {
    final diff = _daysBetween(date, DateTime.now());
    if (diff == 0) return l.diaryToday;
    if (diff == 1) return l.diaryYesterday;
    return DateFormat.yMMMMd(locale.toString()).format(date);
  }

  /// A voice note's manually-set timestamp (see `Attachment.recordedAt`),
  /// formatted compactly ("12 Jul, 14:30") for display right under its
  /// bubble — deliberately not reusing [diaryDateLabel]'s "Today"/
  /// "Yesterday" wording, since a specific time-of-day matters here in a
  /// way it doesn't for a diary entry's whole-day date.
  static String voiceTimestampLabel(DateTime dateTime, Locale locale) {
    return DateFormat.MMMd(locale.toString()).add_Hm().format(dateTime);
  }
}
