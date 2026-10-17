import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/constants/app_constants.dart';
import 'core/routes/app_routes.dart';
import 'core/services/image_picker_service.dart';
import 'core/services/permission_service.dart';
import 'core/theme/app_theme.dart';
import 'features/food_log/data/repositories/food_log_repository.dart';
import 'features/food_log/providers/food_log_provider.dart';
import 'features/food_scan/providers/food_scan_provider.dart';
import 'features/home/providers/navigation_provider.dart';
import 'features/profile/providers/profile_provider.dart';

class CalAiApp extends StatelessWidget {
  const CalAiApp({super.key, this.initialRoute = AppRoutes.onboarding});

  /// Defaults to onboarding; tests pass [AppRoutes.home] to skip it.
  final String initialRoute;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Services
        Provider(create: (_) => PermissionService()),
        Provider(create: (_) => ImagePickerService()),
        Provider(create: (_) => FoodLogRepository()),

        // Feature state
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(
          create: (ctx) => FoodLogProvider(ctx.read<FoodLogRepository>()),
        ),
        ChangeNotifierProvider(
          create: (ctx) => FoodScanProvider(
            ctx.read<ImagePickerService>(),
            ctx.read<PermissionService>(),
          ),
        ),
      ],
      child: MaterialApp(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        initialRoute: initialRoute,
        onGenerateRoute: AppRoutes.onGenerateRoute,
      ),
    );
  }
}
