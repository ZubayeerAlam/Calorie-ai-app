import 'package:flutter/widgets.dart';

import '../../../core/services/local_storage_service.dart';
import '../../../core/services/notification_service.dart';
import '../../../core/utils/date_utils.dart';
import '../../food_log/data/models/food_entry.dart';
import '../../food_log/data/repositories/food_log_repository.dart';
import '../../profile/providers/profile_provider.dart';
import '../data/meal_reminder.dart';
import '../../../l10n/l10n.dart';

/// Meal reminders: breakfast, lunch and dinner notifications.
///
/// Each reminder is scheduled for the next [daysAhead] days, one
/// notification per day, so today's can be skipped once the meal is
/// logged. The schedule is refreshed at start, when food is logged, and
/// when settings or the dinner time change. Settings stay on this phone.
class ReminderProvider extends ChangeNotifier {
  ReminderProvider({
    required this._storage,
    required this._notifications,
    required this._profile,
    required this._food,
    required this._foodChanges,
    this._languageChanges,
    DateTime Function()? clock,
  }) : _clock = clock ?? DateTime.now {
    _reminders = _load();
    _profile.addListener(_onProfileChanged);
    _foodChanges.addListener(_onFoodChanged);
    _languageChanges?.addListener(_onLanguageChanged);
    _dinner = _dinnerTime();
    reschedule();
  }

  static const int daysAhead = 7;

  final LocalStorageService _storage;
  final NotificationService _notifications;
  final ProfileProvider _profile;
  final FoodLogRepository _food;

  /// Notifies when food is logged or removed.
  final Listenable _foodChanges;

  /// Notifies when the app's language changes (reminder texts follow).
  final Listenable? _languageChanges;
  final DateTime Function() _clock;

  late Map<MealType, MealReminder> _reminders;
  (int, int)? _dinner;

  List<MealReminder> get reminders => [
    for (final d in MealReminder.defaults) reminderFor(d.meal),
  ];

  /// The reminder for [meal]; dinner uses the profile's dinner time.
  MealReminder reminderFor(MealType meal) {
    final reminder = _reminders[meal]!;
    final dinner = _dinner;
    if (meal == MealType.dinner && dinner != null) {
      return reminder.copyWith(hour: dinner.$1, minute: dinner.$2);
    }
    return reminder;
  }

  bool get anyEnabled => _reminders.values.any((r) => r.enabled);

  /// Where each turned-on reminder stands today.
  ReminderStatus statusOf(MealType meal) {
    final reminder = reminderFor(meal);
    final now = _clock();
    if (_loggedOn(now, meal)) return ReminderStatus.done;
    final due = DateTime(
      now.year,
      now.month,
      now.day,
      reminder.hour,
      reminder.minute,
    );
    return now.isBefore(due) ? ReminderStatus.upcoming : ReminderStatus.missed;
  }

  /// True when a turned-on reminder's time has passed today without the
  /// meal being logged (the red dot on the Home bell).
  bool get hasMissed => reminders.any(
    (r) => r.enabled && statusOf(r.meal) == ReminderStatus.missed,
  );

  /// Turns a reminder on (asking for permission first) or off. Returns
  /// false when notifications aren't allowed.
  Future<bool> setEnabled(MealType meal, bool enabled) async {
    if (enabled && !await _notifications.requestPermission()) return false;
    _reminders[meal] = _reminders[meal]!.copyWith(enabled: enabled);
    await _save();
    notifyListeners();
    await reschedule();
    return true;
  }

  /// Changes a reminder's time; for dinner this changes the profile's
  /// dinner time.
  Future<void> setTime(MealType meal, int hour, int minute) async {
    if (meal == MealType.dinner) {
      final profile = _profile.profile;
      if (profile != null) {
        _profile.updateProfile(
          profile.copyWith(dinnerHour: hour, dinnerMinute: minute),
        );
      }
      return; // _onProfileChanged reschedules.
    }
    _reminders[meal] = _reminders[meal]!.copyWith(hour: hour, minute: minute);
    await _save();
    notifyListeners();
    await reschedule();
  }

  /// Cancels and re-creates every reminder for the coming days.
  Future<void> reschedule() async {
    for (final reminder in MealReminder.defaults) {
      for (var day = 0; day < daysAhead; day++) {
        await _scheduleDay(reminder.meal, day);
      }
    }
  }

  /// Notification id: one per meal and day ahead.
  @visibleForTesting
  static int idFor(MealType meal, int day) => meal.index * 10 + day;

  Future<void> _scheduleDay(MealType meal, int day) async {
    final id = idFor(meal, day);
    await _notifications.cancel(id);
    final reminder = reminderFor(meal);
    // No reminders before setup is done (or after Reset all data).
    if (!reminder.enabled || !_profile.isOnboarded) return;
    final now = _clock();
    final at = DateTime(
      now.year,
      now.month,
      now.day + day,
      reminder.hour,
      reminder.minute,
    );
    if (!at.isAfter(now)) return;
    if (day == 0 && _loggedOn(now, meal)) return;
    await _notifications.schedule(
      id: id,
      at: at,
      title: _titleFor(meal),
      body: l10n.reminderBody,
      payload: meal.name,
    );
  }

  static String _titleFor(MealType meal) => switch (meal) {
    MealType.breakfast => l10n.reminderBreakfast,
    MealType.lunch => l10n.reminderLunch,
    MealType.dinner => l10n.reminderDinner,
    MealType.snack => l10n.reminderSnack,
  };

  bool _loggedOn(DateTime day, MealType meal) => _food.allEntries().any(
    (e) => e.mealType == meal && AppDates.isSameDay(e.loggedAt, day),
  );

  (int, int)? _dinnerTime() {
    final profile = _profile.profile;
    return profile == null ? null : (profile.dinnerHour, profile.dinnerMinute);
  }

  void _onProfileChanged() {
    final dinner = _dinnerTime();
    // Reset all data removed the saved settings too.
    final cleared =
        anyEnabled && _storage.getRaw(StorageKeys.reminders) == null;
    if (dinner == _dinner && !cleared) return;
    _dinner = dinner;
    if (cleared) _reminders = _load();
    notifyListeners();
    reschedule();
  }

  // Logging a meal skips today's reminder for it.
  void _onFoodChanged() {
    notifyListeners();
    for (final reminder in MealReminder.defaults) {
      _scheduleDay(reminder.meal, 0);
    }
  }

  // Scheduled reminders keep their text; re-create them in the new
  // language once it is in use (after the next frame).
  void _onLanguageChanged() =>
      WidgetsBinding.instance.addPostFrameCallback((_) => reschedule());

  Map<MealType, MealReminder> _load() {
    final saved = _storage.readObject(StorageKeys.reminders, (json) => json);
    return {
      for (final d in MealReminder.defaults)
        d.meal: switch (saved?[d.meal.name]) {
          final Map<String, dynamic> json => MealReminder.fromJson(
            d.meal,
            json,
          ),
          _ => d,
        },
    };
  }

  Future<void> _save() => _storage.setJson(StorageKeys.reminders, {
    for (final r in _reminders.values) r.meal.name: r.toJson(),
  });

  @override
  void dispose() {
    _profile.removeListener(_onProfileChanged);
    _foodChanges.removeListener(_onFoodChanged);
    _languageChanges?.removeListener(_onLanguageChanged);
    super.dispose();
  }
}
