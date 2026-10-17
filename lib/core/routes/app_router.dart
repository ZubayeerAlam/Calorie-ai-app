import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/food_log/presentation/screens/add_food_screen.dart';
import '../../features/food_scan/presentation/screens/food_scan_screen.dart';
import '../../features/home/presentation/screens/home_shell.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/onboarding/providers/onboarding_provider.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/profile/providers/profile_provider.dart';
import 'app_routes.dart';

/// Builds the app's router.
///
/// Until [profile] is onboarded every location redirects to onboarding;
/// once it is, onboarding redirects to home. The router re-checks whenever
/// [profile] notifies, so finishing onboarding moves the user on.
GoRouter createAppRouter(ProfileProvider profile) {
  return GoRouter(
    initialLocation: AppRoutes.home,
    refreshListenable: profile,
    redirect: (context, state) {
      final atOnboarding = state.matchedLocation == AppRoutes.onboarding;
      if (!profile.isOnboarded) {
        return atOnboarding ? null : AppRoutes.onboarding;
      }
      return atOnboarding ? AppRoutes.home : null;
    },
    errorBuilder: (context, state) =>
        const Scaffold(body: Center(child: Text('Page not found'))),
    routes: [
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => ChangeNotifierProvider(
          create: (_) => OnboardingProvider(),
          child: const OnboardingScreen(),
        ),
      ),
      // Bottom-nav tabs; each branch keeps its own navigation stack.
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            HomeShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                builder: (context, state) => const DashboardScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.scan,
                builder: (context, state) => const FoodScanScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.profile,
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
      // Top-level so it covers the bottom bar when pushed.
      GoRoute(
        path: AppRoutes.addFood,
        builder: (context, state) => AddFoodScreen(
          imagePath: state.uri.queryParameters[AppRoutes.imagePathParam],
        ),
      ),
    ],
  );
}
