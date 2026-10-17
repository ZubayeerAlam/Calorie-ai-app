import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../features/food_log/presentation/screens/add_food_screen.dart';
import '../../features/home/presentation/screens/home_shell.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/onboarding/providers/onboarding_provider.dart';

class AppRoutes {
  AppRoutes._();

  static const String home = '/';
  static const String addFood = '/add-food';
  static const String onboarding = '/onboarding';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const HomeShell());
      case onboarding:
        return MaterialPageRoute(
          builder: (_) => ChangeNotifierProvider(
            create: (_) => OnboardingProvider(),
            child: const OnboardingScreen(),
          ),
        );
      case addFood:
        final imagePath = settings.arguments as String?;
        return MaterialPageRoute(
          builder: (_) => AddFoodScreen(imagePath: imagePath),
        );
      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('Page not found'))),
        );
    }
  }
}
