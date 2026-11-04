import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../features/account/presentation/screens/sign_in_screen.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/food_log/data/models/food_entry.dart';
import '../../features/food_log/presentation/screens/add_food_screen.dart';
import '../../features/food_log/presentation/screens/manual_entry_screen.dart';
import '../../features/food_scan/data/models/analysis_request.dart';
import '../../features/food_scan/data/models/food_description.dart';
import '../../features/food_scan/presentation/screens/analyze_food_screen.dart';
import '../../features/food_scan/presentation/screens/food_scan_screen.dart';
import '../../features/food_scan/providers/food_analysis_controller.dart';
import '../services/food_analysis_service.dart';
import '../../features/home/presentation/screens/home_shell.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/onboarding/providers/onboarding_provider.dart';
import '../../features/profile/presentation/screens/edit_profile_screen.dart';
import '../../features/reminders/presentation/screens/reminders_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/profile/providers/profile_provider.dart';
import '../../features/tracker/presentation/screens/tracker_screen.dart';
import 'app_routes.dart';
import '../../l10n/l10n.dart';

/// Builds the app's router.
///
/// Until [profile] is onboarded every location redirects to onboarding
/// (except sign-in, to restore an account); once it is, onboarding
/// redirects to home. The router re-checks whenever onboarding status
/// changes, so finishing onboarding (or logging out) moves the user on.
GoRouter createAppRouter(ProfileProvider profile) {
  return GoRouter(
    initialLocation: AppRoutes.home,
    refreshListenable: profile.onboardedListenable,
    redirect: (context, state) {
      final atOnboarding = state.matchedLocation == AppRoutes.onboarding;
      if (!profile.isOnboarded) {
        final allowed =
            atOnboarding || state.matchedLocation == AppRoutes.signIn;
        return allowed ? null : AppRoutes.onboarding;
      }
      return atOnboarding ? AppRoutes.home : null;
    },
    errorBuilder: (context, state) =>
        Scaffold(body: Center(child: Text(l10n.pageNotFound))),
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
          _tab(AppRoutes.home, (_) => const DashboardScreen()),
          _tab(AppRoutes.tracker, (_) => const TrackerScreen()),
          _tab(AppRoutes.account, (_) => const ProfileScreen()),
        ],
      ),
      // Pushed above the tabs so they cover the bottom bar.
      GoRoute(
        path: AppRoutes.addFood,
        builder: (context, state) {
          final query = state.uri.queryParameters;
          return AddFoodScreen(
            imagePath: query[AppRoutes.imagePathParam],
            initialMeal: MealType.values
                .asNameMap()[query[AppRoutes.mealParam]],
          );
        },
      ),
      // Optional account: sign in or create one (cloud backup and sync).
      GoRoute(
        path: AppRoutes.signIn,
        builder: (context, state) => const SignInScreen(),
      ),
      // The Home bell: today's meals and the reminder settings.
      GoRoute(
        path: AppRoutes.reminders,
        builder: (context, state) => const RemindersScreen(),
      ),
      // Account → Edit profile.
      GoRoute(
        path: AppRoutes.editProfile,
        builder: (context, state) => const EditProfileScreen(),
      ),
      // Describe a meal in words, then send it for AI analysis.
      GoRoute(
        path: AppRoutes.addManually,
        builder: (context, state) => const ManualEntryScreen(),
      ),
      // AI analysis of a photo (`?imagePath=`) or a typed description
      // (`extra: FoodDescription`), then review and save.
      GoRoute(
        path: AppRoutes.analyzeFood,
        builder: (context, state) {
          final extra = state.extra;
          final imagePath = state.uri.queryParameters[AppRoutes.imagePathParam];
          final AnalysisRequest? request = extra is FoodDescription
              ? TextAnalysisRequest(extra)
              : imagePath != null
              ? PhotoAnalysisRequest(imagePath)
              : null;
          // e.g. a description lost on a web refresh: nothing to analyse.
          if (request == null) return const _NothingToAnalyze();
          return ChangeNotifierProvider(
            create: (ctx) => FoodAnalysisController(
              service: ctx.read<FoodAnalysisService>(),
              request: request,
            ),
            child: const AnalyzeFoodScreen(),
          );
        },
      ),
      // Opened from the camera chooser, or from Add Food (returnPhoto).
      GoRoute(
        path: AppRoutes.scan,
        builder: (context, state) => FoodScanScreen(
          returnPhoto:
              state.uri.queryParameters[AppRoutes.returnPhotoParam] == 'true',
        ),
      ),
    ],
  );
}

class _NothingToAnalyze extends StatelessWidget {
  const _NothingToAnalyze();

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(),
    body: Center(child: Text(l10n.nothingToAnalyze)),
  );
}

StatefulShellBranch _tab(String path, WidgetBuilder builder) =>
    StatefulShellBranch(
      routes: [
        GoRoute(path: path, builder: (context, state) => builder(context)),
      ],
    );
