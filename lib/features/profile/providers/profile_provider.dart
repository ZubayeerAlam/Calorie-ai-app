import 'package:flutter/foundation.dart';

import '../data/models/user_goals.dart';
import '../data/models/user_profile.dart';

class ProfileProvider extends ChangeNotifier {
  ProfileProvider({UserProfile? profile, UserGoals goals = const UserGoals()})
    : _profile = profile,
      _goals = goals;

  UserProfile? _profile;
  UserGoals _goals;

  UserProfile? get profile => _profile;
  UserGoals get goals => _goals;
  bool get isOnboarded => _profile != null;

  void completeOnboarding(UserProfile profile, UserGoals goals) {
    _profile = profile;
    _goals = goals;
    notifyListeners();
  }

  void updateGoals(UserGoals goals) {
    _goals = goals;
    notifyListeners();
  }
}
