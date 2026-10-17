import 'package:flutter/foundation.dart';

import '../../profile/data/models/user_goals.dart';
import '../../profile/data/models/user_profile.dart';
import '../../profile/data/services/nutrition_calculator.dart';

enum OnboardingStep {
  name,
  gender,
  birthday,
  height,
  weight,
  goal,
  activity,
  diet,
  dinner,
  plan,
}

class OnboardingProvider extends ChangeNotifier {
  OnboardingProvider({
    NutritionCalculator calculator = const NutritionCalculator(),
  }) : _calculator = calculator;

  static const int minAge = 13;
  static const int maxAge = 100;

  final NutritionCalculator _calculator;

  OnboardingStep _step = OnboardingStep.name;
  String _name = '';
  Gender? _gender;
  DateTime _birthday = DateTime(2000, 1, 1);
  int _heightCm = 170;
  double _weightKg = 70;
  bool _useMetric = true;
  GoalType? _goal;
  ActivityLevel? _activityLevel;
  DietType? _dietType;
  int _dinnerHour = 20;
  int _dinnerMinute = 30;
  bool _planReady = false;

  OnboardingStep get step => _step;
  int get stepIndex => _step.index;
  int get stepCount => OnboardingStep.values.length;
  double get progress => (stepIndex + 1) / stepCount;
  bool get isFirstStep => _step == OnboardingStep.values.first;
  bool get isLastStep => _step == OnboardingStep.values.last;

  String get name => _name;
  Gender? get gender => _gender;
  DateTime get birthday => _birthday;
  int get heightCm => _heightCm;
  double get weightKg => _weightKg;
  bool get useMetric => _useMetric;
  GoalType? get goal => _goal;
  ActivityLevel? get activityLevel => _activityLevel;
  DietType? get dietType => _dietType;
  int get dinnerHour => _dinnerHour;
  int get dinnerMinute => _dinnerMinute;
  bool get planReady => _planReady;

  bool get canContinue => switch (_step) {
    OnboardingStep.name => _name.trim().isNotEmpty,
    OnboardingStep.gender => _gender != null,
    OnboardingStep.birthday => _isAgeValid,
    OnboardingStep.height ||
    OnboardingStep.weight ||
    OnboardingStep.dinner => true,
    OnboardingStep.goal => _goal != null,
    OnboardingStep.activity => _activityLevel != null,
    OnboardingStep.diet => _dietType != null,
    OnboardingStep.plan => _planReady,
  };

  bool get _isAgeValid {
    final age = _draftProfile().age;
    return age >= minAge && age <= maxAge;
  }

  /// Only valid once every step before [OnboardingStep.plan] is complete.
  UserProfile get profile => UserProfile(
    name: _name.trim(),
    gender: _gender!,
    birthday: _birthday,
    heightCm: _heightCm,
    weightKg: _weightKg,
    goal: _goal!,
    activityLevel: _activityLevel!,
    dietType: _dietType!,
    useMetric: _useMetric,
  );

  UserGoals get goals => _calculator.calculate(profile);
  double get weeklyChangeKg => _calculator.weeklyChangeKg(profile);

  // Profile with placeholders, used only for age validation mid-flow.
  UserProfile _draftProfile() => UserProfile(
    name: _name,
    gender: _gender ?? Gender.other,
    birthday: _birthday,
    heightCm: _heightCm,
    weightKg: _weightKg,
    goal: _goal ?? GoalType.maintain,
    activityLevel: _activityLevel ?? ActivityLevel.sedentary,
    dietType: _dietType ?? DietType.classic,
  );

  void next() {
    if (!canContinue || isLastStep) return;
    _step = OnboardingStep.values[stepIndex + 1];
    notifyListeners();
  }

  void back() {
    if (isFirstStep) return;
    _step = OnboardingStep.values[stepIndex - 1];
    _planReady = false;
    notifyListeners();
  }

  void setName(String value) => _update(() => _name = value);
  void setGender(Gender value) => _update(() => _gender = value);
  void setBirthday(DateTime value) => _update(() => _birthday = value);
  void setHeightCm(int value) => _update(() => _heightCm = value);
  void setWeightKg(double value) => _update(() => _weightKg = value);
  void setUseMetric(bool value) => _update(() => _useMetric = value);
  void setGoal(GoalType value) => _update(() => _goal = value);
  void setActivityLevel(ActivityLevel value) =>
      _update(() => _activityLevel = value);
  void setDietType(DietType value) => _update(() => _dietType = value);
  void setDinnerHour(int value) => _update(() => _dinnerHour = value);
  void setDinnerMinute(int value) => _update(() => _dinnerMinute = value);
  void markPlanReady() => _update(() => _planReady = true);

  void _update(VoidCallback change) {
    change();
    notifyListeners();
  }
}
