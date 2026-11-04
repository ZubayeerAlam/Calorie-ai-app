import 'package:cal_ai_app/core/services/local_storage_service.dart';
import 'package:cal_ai_app/features/food_log/data/models/food_entry.dart';
import 'package:cal_ai_app/features/food_log/data/repositories/food_log_repository.dart';
import 'package:cal_ai_app/features/profile/data/models/user_profile.dart';
import 'package:cal_ai_app/features/profile/providers/profile_provider.dart';
import 'package:cal_ai_app/features/reminders/data/meal_reminder.dart';
import 'package:cal_ai_app/features/reminders/providers/reminder_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'fake_notification_service.dart';

// 10:00 on a Monday: breakfast (8:00) has passed, lunch (13:00) hasn't.
final _now = DateTime(2026, 11, 2, 10);

UserProfile _profile() => UserProfile(
  name: 'Sam',
  gender: Gender.female,
  birthday: DateTime(1995, 6, 1),
  heightCm: 170,
  weightKg: 70,
  goal: GoalType.maintain,
  activityLevel: ActivityLevel.moderate,
  dietType: DietType.classic,
  dinnerHour: 19,
  dinnerMinute: 15,
);

void main() {
  late LocalStorageService storage;
  late FakeNotificationService notifications;
  late ProfileProvider profile;
  late ChangeNotifier foodChanges;
  late FoodLogRepository food;

  ReminderProvider provider() => ReminderProvider(
    storage: storage,
    notifications: notifications,
    profile: profile,
    food: food,
    foodChanges: foodChanges,
    clock: () => _now,
  );

  Future<void> logFood(MealType meal) async {
    await food.add(
      FoodEntry(
        id: meal.name,
        name: 'x',
        calories: 100,
        mealType: meal,
        loggedAt: _now,
      ),
    );
    // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
    foodChanges.notifyListeners();
    await pumpEventQueue();
  }

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    storage = await LocalStorageService.init();
    notifications = FakeNotificationService();
    profile = ProfileProvider(profile: _profile(), storage: storage);
    foodChanges = ChangeNotifier();
    food = FoodLogRepository(storage);
  });

  test('all reminders start off; dinner follows the profile', () {
    final reminders = provider();
    expect(reminders.anyEnabled, isFalse);
    expect(reminders.reminderFor(MealType.breakfast).hour, 8);
    final dinner = reminders.reminderFor(MealType.dinner);
    expect((dinner.hour, dinner.minute), (19, 15));
    expect(notifications.scheduled, isEmpty);
  });

  test('turning one on schedules it for the coming days', () async {
    final reminders = provider();
    expect(await reminders.setEnabled(MealType.lunch, true), isTrue);

    final times = notifications.timesFor('lunch');
    expect(times, hasLength(ReminderProvider.daysAhead));
    expect(times.first, DateTime(2026, 11, 2, 13));
    expect(times.last, DateTime(2026, 11, 8, 13));
    expect(notifications.timesFor('breakfast'), isEmpty);
  });

  test("a time that already passed today starts tomorrow", () async {
    await provider().setEnabled(MealType.breakfast, true);
    final times = notifications.timesFor('breakfast');
    expect(times.first, DateTime(2026, 11, 3, 8));
    expect(times, hasLength(ReminderProvider.daysAhead - 1));
  });

  test("logging the meal skips today's reminder", () async {
    final reminders = provider();
    await reminders.setEnabled(MealType.lunch, true);
    await logFood(MealType.lunch);
    expect(notifications.timesFor('lunch').first, DateTime(2026, 11, 3, 13));
    expect(reminders.statusOf(MealType.lunch), ReminderStatus.done);
  });

  test('refused permission keeps the reminder off', () async {
    notifications.granted = false;
    final reminders = provider();
    expect(await reminders.setEnabled(MealType.lunch, true), isFalse);
    expect(reminders.reminderFor(MealType.lunch).enabled, isFalse);
    expect(notifications.scheduled, isEmpty);
  });

  test('changing a time reschedules, and is saved', () async {
    final reminders = provider();
    await reminders.setEnabled(MealType.lunch, true);
    await reminders.setTime(MealType.lunch, 12, 30);
    expect(
      notifications.timesFor('lunch').first,
      DateTime(2026, 11, 2, 12, 30),
    );
    final relaunched = provider();
    final lunch = relaunched.reminderFor(MealType.lunch);
    expect((lunch.enabled, lunch.hour, lunch.minute), (true, 12, 30));
  });

  test('the dinner time is the profile dinner time', () async {
    final reminders = provider();
    await reminders.setEnabled(MealType.dinner, true);
    await reminders.setTime(MealType.dinner, 18, 45);
    await pumpEventQueue();
    expect(profile.profile!.dinnerHour, 18);
    expect(
      notifications.timesFor('dinner').first,
      DateTime(2026, 11, 2, 18, 45),
    );
  });

  test('missed: time passed and meal not logged (the bell dot)', () async {
    final reminders = provider();
    await reminders.setEnabled(MealType.lunch, true);
    expect(reminders.hasMissed, isFalse); // lunch is at 13:00
    await reminders.setEnabled(MealType.breakfast, true);
    expect(reminders.statusOf(MealType.breakfast), ReminderStatus.missed);
    expect(reminders.hasMissed, isTrue);
    await logFood(MealType.breakfast);
    expect(reminders.hasMissed, isFalse);
  });

  test('turning off cancels everything for that meal', () async {
    final reminders = provider();
    await reminders.setEnabled(MealType.lunch, true);
    await reminders.setEnabled(MealType.lunch, false);
    expect(notifications.scheduled, isEmpty);
  });
}
