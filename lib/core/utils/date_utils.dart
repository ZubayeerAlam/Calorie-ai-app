/// Small date helpers (no intl dependency needed for these formats).
class AppDates {
  AppDates._();

  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', //
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];
  static const _weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

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

  /// "Today, Dec 22", "Yesterday, Dec 21" or "Mon, Dec 20".
  static String dayLabel(DateTime date, {DateTime? now}) {
    final today = dateOnly(now ?? DateTime.now());
    final day = dateOnly(date);
    final monthDay = '${_months[day.month - 1]} ${day.day}';
    if (day == today) return 'Today, $monthDay';
    if (day == today.subtract(const Duration(days: 1))) {
      return 'Yesterday, $monthDay';
    }
    return '${_weekdays[day.weekday - 1]}, $monthDay';
  }
}
