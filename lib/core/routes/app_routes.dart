import '../../features/food_log/data/models/food_entry.dart';

/// Route paths used with go_router (`context.go` / `context.push`).
class AppRoutes {
  AppRoutes._();

  // Bottom-nav tabs
  static const String home = '/';
  static const String tracker = '/tracker';
  static const String insights = '/insights';
  static const String articles = '/articles';
  static const String account = '/account';

  // Pushed screens
  static const String addFood = '/add-food';
  static const String scan = '/scan';
  static const String onboarding = '/onboarding';

  /// Query parameters for [addFood].
  static const String imagePathParam = 'imagePath';
  static const String mealParam = 'meal';

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
