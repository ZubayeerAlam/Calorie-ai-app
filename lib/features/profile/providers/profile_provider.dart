import 'package:flutter/foundation.dart';

import '../../../core/services/local_storage_service.dart';
import '../../../core/utils/calorie_calculator.dart';
import '../data/models/user_goals.dart';
import '../data/models/user_profile.dart';

class ProfileProvider extends ChangeNotifier {
  /// With [storage], the saved profile and goals are loaded (unless given
  /// explicitly) and every change is saved. Without it, state is in-memory.
  ///
  /// On load, calorie and macro targets are recalculated from the saved
  /// profile with [CalorieCalculator], unless the user changed them by hand
  /// (see [goalsCustomized]). Passing [goals] explicitly skips this.
  ProfileProvider({
    UserProfile? profile,
    UserGoals? goals,
    LocalStorageService? storage,
  }) : _storage = storage,
       _profile = profile ?? _loadProfile(storage),
       _goalsCustomized =
           storage?.getBool(StorageKeys.goalsCustomized) ?? false,
       _goals = goals ?? _loadGoals(storage) ?? const UserGoals() {
    if (goals == null) _syncGoalsWithProfile();
  }

  final LocalStorageService? _storage;
  UserProfile? _profile;
  UserGoals _goals;
  bool _goalsCustomized;

  UserProfile? get profile => _profile;
  UserGoals get goals => _goals;
  bool get isOnboarded => _profile != null;

  /// True once the user edits targets on Account; recalculation then stops
  /// until they reset to the recommended values.
  bool get goalsCustomized => _goalsCustomized;

  /// Targets the calculator recommends for the saved profile.
  UserGoals? get recommendedGoals =>
      _profile == null ? null : CalorieCalculator.calculate(_profile!);

  /// How the recommended target was worked out from the saved profile.
  CalorieBreakdown? get calorieBreakdown =>
      _profile == null ? null : CalorieCalculator.breakdown(_profile!);

  void completeOnboarding(UserProfile profile, UserGoals goals) {
    _profile = profile;
    _goals = goals;
    _goalsCustomized = false;
    notifyListeners();
    _storage?.setJson(StorageKeys.userProfile, profile.toJson());
    _saveGoals();
  }

  /// A hand edit (e.g. the calorie slider on Account).
  void updateGoals(UserGoals goals) {
    _goals = goals;
    _goalsCustomized = true;
    notifyListeners();
    _saveGoals();
  }

  /// Drops hand edits and goes back to the calculated targets.
  void resetGoalsToRecommended() {
    final recommended = recommendedGoals;
    if (recommended == null) return;
    _goals = recommended;
    _goalsCustomized = false;
    notifyListeners();
    _saveGoals();
  }

  /// Keeps targets in step with the profile and the current calculator,
  /// e.g. after the formula changes in an app update.
  void _syncGoalsWithProfile() {
    final recommended = recommendedGoals;
    if (_goalsCustomized || recommended == null) return;
    if (_sameGoals(_goals, recommended)) return;
    _goals = recommended;
    _saveGoals();
  }

  void _saveGoals() {
    _storage?.setJson(StorageKeys.userGoals, _goals.toJson());
    _storage?.setBool(StorageKeys.goalsCustomized, _goalsCustomized);
  }

  static bool _sameGoals(UserGoals a, UserGoals b) =>
      a.dailyCalories == b.dailyCalories &&
      a.protein == b.protein &&
      a.carbs == b.carbs &&
      a.fat == b.fat;

  // A saved profile means onboarding is done, so the router skips it.
  static UserProfile? _loadProfile(LocalStorageService? storage) =>
      storage?.readObject(StorageKeys.userProfile, UserProfile.fromJson);

  static UserGoals? _loadGoals(LocalStorageService? storage) =>
      storage?.readObject(StorageKeys.userGoals, UserGoals.fromJson);
}
