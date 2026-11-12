class AppConstants {
  AppConstants._();

  static const String appName = 'Cal AI';
  static const int defaultDailyCalorieGoal = 2000;
  static const int defaultProteinGoal = 150;
  static const int defaultCarbsGoal = 200;
  static const int defaultFatGoal = 65;
  static const int imageQuality = 80;

  /// Largest text scale the app follows (the phone may ask for more).
  static const double maxTextScale = 1.3;

  /// Photos are scaled down to fit this many pixels on their longest side,
  /// which keeps AI uploads small and fast.
  static const double imageMaxDimension = 1600;

  /// Gemini model used for food analysis (Firebase AI Logic).
  static const String foodAnalysisModel = 'gemini-3.5-flash-lite';

  /// Gemini model used for workout plans (Firebase AI Logic).
  static const String workoutPlanModel = 'gemini-3.5-flash-lite';
}
