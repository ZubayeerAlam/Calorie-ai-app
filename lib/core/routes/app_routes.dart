/// Route paths used with go_router (`context.go` / `context.push`).
class AppRoutes {
  AppRoutes._();

  static const String home = '/';
  static const String scan = '/scan';
  static const String profile = '/profile';
  static const String addFood = '/add-food';
  static const String onboarding = '/onboarding';

  /// Query parameter carrying the scanned photo's file path to [addFood].
  static const String imagePathParam = 'imagePath';

  static String addFoodLocation({String? imagePath}) => Uri(
    path: addFood,
    queryParameters: imagePath == null ? null : {imagePathParam: imagePath},
  ).toString();
}
