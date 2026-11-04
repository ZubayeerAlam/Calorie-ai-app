import 'package:intl/intl.dart';

import '../../l10n/l10n.dart';

/// Small date helpers. English uses fixed formats ("Today, Dec 22",
/// "8:30 PM"); other languages use their own date formats (via intl), with
/// Western digits like the rest of the app.
class AppDates {
  AppDates._();

  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', //
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];
  static const _weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  static bool get _english => l10n.localeName.startsWith('en');

  /// [pattern] in the current language, or null if its data isn't loaded.
  static String? _format(
    DateFormat Function(String locale) pattern,
    DateTime d,
  ) {
    try {
      return (pattern(l10n.localeName)..useNativeDigits = false).format(d);
    } catch (_) {
      return null;
    }
  }

  /// [date] with the time stripped.
  static DateTime dateOnly(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  static DateTime today() => dateOnly(DateTime.now());

  static bool isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  /// Stable storage key, e.g. `2026-10-18`.
  static String key(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';

  /// A clock time as "8:30 PM".
  static String timeLabel(int hour, int minute) {
    if (!_english) {
      final local = _format(DateFormat.jm, DateTime(2000, 1, 1, hour, minute));
      if (local != null) return local;
    }
    final hour12 = hour % 12 == 0 ? 12 : hour % 12;
    final period = hour >= 12 ? 'PM' : 'AM';
    return '$hour12:${minute.toString().padLeft(2, '0')} $period';
  }

  /// "Today, Dec 22", "Yesterday, Dec 21" or "Mon, Dec 20".
  static String dayLabel(DateTime date, {DateTime? now}) {
    final today = dateOnly(now ?? DateTime.now());
    final day = dateOnly(date);
    final monthDay = monthDayLabel(day);
    if (day == today) return l10n.todayDate(monthDay);
    if (day == today.subtract(const Duration(days: 1))) {
      return l10n.yesterdayDate(monthDay);
    }
    return '${weekdayLabel(day)}, $monthDay';
  }

  /// "Dec 22".
  static String monthDayLabel(DateTime date) =>
      (_english ? null : _format(DateFormat.MMMd, date)) ??
      '${_months[date.month - 1]} ${date.day}';

  /// "Mon".
  static String weekdayLabel(DateTime date) =>
      (_english ? null : _format(DateFormat.E, date)) ??
      _weekdays[date.weekday - 1];

  /// "M" (for chart labels).
  static String weekdayInitial(DateTime date) =>
      (_english ? null : _format((l) => DateFormat('EEEEE', l), date)) ??
      _weekdays[date.weekday - 1][0];
}
