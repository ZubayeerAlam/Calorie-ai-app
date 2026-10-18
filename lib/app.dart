import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'core/constants/app_constants.dart';
import 'core/routes/app_router.dart';
import 'core/services/image_picker_service.dart';
import 'core/services/local_storage_service.dart';
import 'core/services/permission_service.dart';
import 'core/services/step_counter_service.dart';
import 'core/theme/app_theme.dart';
import 'features/activity/data/activity_log_repository.dart';
import 'features/activity/data/step_log_repository.dart';
import 'features/activity/providers/activity_log_provider.dart';
import 'features/food_log/data/repositories/food_log_repository.dart';
import 'features/food_log/providers/food_log_provider.dart';
import 'features/food_scan/providers/food_scan_provider.dart';
import 'features/profile/providers/profile_provider.dart';

class CalAiApp extends StatefulWidget {
  const CalAiApp({
    super.key,
    required this.storage,
    this.profileProvider,
    this.stepCounter,
  });

  /// Local storage, initialised in `main` before the app starts.
  final LocalStorageService storage;

  /// Optional pre-built profile state; tests pass an onboarded one to start
  /// on the dashboard instead of onboarding.
  final ProfileProvider? profileProvider;

  /// Step source; defaults to the phone's pedometer. Tests pass a fake.
  final StepCounterService? stepCounter;

  @override
  State<CalAiApp> createState() => _CalAiAppState();
}

class _CalAiAppState extends State<CalAiApp> {
  // Created once so the router (which listens to the profile) is never
  // rebuilt and navigation state survives app rebuilds.
  late final ProfileProvider _profile =
      widget.profileProvider ?? ProfileProvider(storage: widget.storage);
  late final GoRouter _router = createAppRouter(_profile);

  @override
  void dispose() {
    _router.dispose();
    if (widget.profileProvider == null) _profile.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Services
        Provider.value(value: widget.storage),
        Provider(create: (_) => PermissionService()),
        Provider(create: (_) => ImagePickerService()),
        Provider(
          create: (ctx) => FoodLogRepository(ctx.read<LocalStorageService>()),
        ),
        Provider(
          create: (ctx) =>
              ActivityLogRepository(ctx.read<LocalStorageService>()),
        ),
        Provider(
          create: (ctx) => StepLogRepository(ctx.read<LocalStorageService>()),
        ),
        Provider<StepCounterService>(
          create: (ctx) =>
              widget.stepCounter ??
              PedometerStepCounter(ctx.read<PermissionService>()),
        ),

        // Feature state
        ChangeNotifierProvider.value(value: _profile),
        ChangeNotifierProvider(
          create: (ctx) => FoodLogProvider(ctx.read<FoodLogRepository>()),
        ),
        ChangeNotifierProvider(
          create: (ctx) => ActivityLogProvider(
            ctx.read<ActivityLogRepository>(),
            ctx.read<StepLogRepository>(),
            ctx.read<StepCounterService>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (ctx) => FoodScanProvider(
            ctx.read<ImagePickerService>(),
            ctx.read<PermissionService>(),
          ),
        ),
      ],
      child: MaterialApp.router(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        // The current designs are light-only.
        themeMode: ThemeMode.light,
        routerConfig: _router,
      ),
    );
  }
}
