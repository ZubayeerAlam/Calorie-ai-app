import 'package:flutter/foundation.dart';

import '../../../core/services/local_storage_service.dart';
import '../data/models/user_goals.dart';
import '../data/models/user_profile.dart';

class ProfileProvider extends ChangeNotifier {
  /// With [storage], the saved profile and goals are loaded (unless given
  /// explicitly) and every change is saved. Without it, state is in-memory.
  ProfileProvider({
    UserProfile? profile,
    UserGoals? goals,
    LocalStorageService? storage,
  }) : _storage = storage,
       _profile = profile ?? _loadProfile(storage),
       _goals = goals ?? _loadGoals(storage) ?? const UserGoals();

  final LocalStorageService? _storage;
  UserProfile? _profile;
  UserGoals _goals;

  UserProfile? get profile => _profile;
  UserGoals get goals => _goals;
  bool get isOnboarded => _profile != null;

  void completeOnboarding(UserProfile profile, UserGoals goals) {
    _profile = profile;
    _goals = goals;
    notifyListeners();
    _storage?.setJson(StorageKeys.userProfile, profile.toJson());
    _storage?.setJson(StorageKeys.userGoals, goals.toJson());
  }

  void updateGoals(UserGoals goals) {
    _goals = goals;
    notifyListeners();
    _storage?.setJson(StorageKeys.userGoals, goals.toJson());
  }

  // A saved profile means onboarding is done, so the router skips it.
  static UserProfile? _loadProfile(LocalStorageService? storage) =>
      storage?.readObject(StorageKeys.userProfile, UserProfile.fromJson);

  static UserGoals? _loadGoals(LocalStorageService? storage) =>
      storage?.readObject(StorageKeys.userGoals, UserGoals.fromJson);
}
