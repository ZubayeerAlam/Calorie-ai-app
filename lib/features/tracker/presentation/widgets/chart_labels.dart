import '../../../../core/utils/date_utils.dart';

/// Labels under the Tracker's day bars.
class ChartLabels {
  ChartLabels._();

  /// A week shows weekday initials; a month shows the date every fifth
  /// day, counted back from today so today is always labelled.
  static List<String> forDays(List<DateTime> days) {
    if (days.length <= 7) {
      return [for (final d in days) AppDates.weekdayInitial(d)];
    }
    return [
      for (var i = 0; i < days.length; i++)
        (days.length - 1 - i) % 5 == 0 ? '${days[i].day}' : '',
    ];
  }
}
