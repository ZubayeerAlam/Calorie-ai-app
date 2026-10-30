import 'package:cal_ai_app/features/profile/data/models/user_profile.dart';
import 'package:cal_ai_app/features/profile/presentation/profile_labels.dart';
import 'package:flutter_test/flutter_test.dart';

UserProfile _profile({int hour = 20, int minute = 30}) => UserProfile(
  name: 'Sam',
  gender: Gender.female,
  birthday: DateTime(1995, 6, 1),
  heightCm: 170,
  weightKg: 70,
  goal: GoalType.maintain,
  activityLevel: ActivityLevel.moderate,
  dietType: DietType.classic,
  dinnerHour: hour,
  dinnerMinute: minute,
);

void main() {
  test('dinner time survives a JSON round trip', () {
    final restored = UserProfile.fromJson(
      _profile(hour: 19, minute: 5).toJson(),
    );
    expect(restored.dinnerHour, 19);
    expect(restored.dinnerMinute, 5);
  });

  test('a profile saved before dinner time existed gets the default', () {
    final old = _profile().toJson()
      ..remove('dinnerHour')
      ..remove('dinnerMinute');
    final restored = UserProfile.fromJson(old);
    expect(restored.dinnerHour, UserProfile.defaultDinnerHour);
    expect(restored.dinnerMinute, UserProfile.defaultDinnerMinute);
  });

  test('dinner label uses a 12-hour clock', () {
    expect(_profile(hour: 20, minute: 30).dinnerLabel, '8:30 PM');
    expect(_profile(hour: 0, minute: 5).dinnerLabel, '12:05 AM');
    expect(_profile(hour: 12, minute: 0).dinnerLabel, '12:00 PM');
  });
}
