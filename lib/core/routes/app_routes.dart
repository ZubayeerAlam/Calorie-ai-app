import '../../features/food_log/data/models/food_entry.dart';

/// Route paths used with go_router (`context.go` / `context.push`).
class AppRoutes {
  AppRoutes._();

  // Bottom-nav tabs
  static const String home = '/';
  static const String tracker = '/tracker';
  static const String exercise = '/exercise';
  static const String account = '/account';

  // Pushed screens
  static const String addFood = '/add-food';
  static const String scan = '/scan';
  static const String analyzeFood = '/analyze-food';
  static const String addManually = '/add-manually';
  static const String onboarding = '/onboarding';
  static const String signIn = '/sign-in';
  static const String editProfile = '/edit-profile';
  static const String reminders = '/reminders';
  static const String exerciseSetup = '/exercise-setup';

  /// Query parameters for [addFood].
  static const String imagePathParam = 'imagePath';
  static const String mealParam = 'meal';

  /// Query parameter for [scan]: when true, the scan screen hands the chosen
  /// photo back to the screen that opened it (Add Food). Otherwise it sends
  /// the photo for AI analysis.
  static const String returnPhotoParam = 'returnPhoto';

  /// Analysis of a photo. (A typed description is passed as the route's
  /// `extra` instead: `context.push(analyzeFood, extra: description)`.)
  static String analyzeFoodLocation(String imagePath) => Uri(
    path: analyzeFood,
    queryParameters: {imagePathParam: imagePath},
  ).toString();

  static String scanLocation({bool returnPhoto = false}) => Uri(
    path: scan,
    queryParameters: returnPhoto ? {returnPhotoParam: 'true'} : null,
  ).toString();

  static String addFoodLocation({MealType? meal, String? imagePath}) {
    final query = {
      if (meal != null) mealParam: meal.name,
      imagePathParam: ?imagePath,
    };
    return Uri(
      path: addFood,
      queryParameters: query.isEmpty ? null : query,
    ).toString();
  }
}
