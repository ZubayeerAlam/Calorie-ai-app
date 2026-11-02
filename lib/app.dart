import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'core/constants/app_constants.dart';
import 'core/routes/app_router.dart';
import 'core/services/auth_service.dart';
import 'core/services/cloud_store.dart';
import 'core/services/demo_food_analysis_service.dart';
import 'core/services/food_analysis_service.dart';
import 'core/services/health_service.dart';
import 'core/services/image_picker_service.dart';
import 'core/services/local_storage_service.dart';
import 'core/services/permission_service.dart';
import 'core/services/step_counter_service.dart';
import 'core/theme/app_theme.dart';
import 'features/account/data/sync_service.dart';
import 'features/account/providers/account_provider.dart';
import 'features/activity/data/activity_log_repository.dart';
import 'features/activity/data/step_log_repository.dart';
import 'features/activity/providers/activity_log_provider.dart';
import 'features/food_log/data/repositories/food_log_repository.dart';
import 'features/food_log/providers/food_log_provider.dart';
import 'features/food_scan/providers/food_scan_provider.dart';
import 'features/profile/providers/profile_provider.dart';
import 'features/tracker/data/weight_log_repository.dart';
import 'features/tracker/providers/weight_log_provider.dart';

class CalAiApp extends StatefulWidget {
  const CalAiApp({
    super.key,
    required this.storage,
    this.profileProvider,
    this.stepCounter,
    this.imagePicker,
    this.foodAnalysis,
    this.health,
    this.auth,
    this.cloudStore,
  });

  /// Local storage, initialised in `main` before the app starts.
  final LocalStorageService storage;

  /// Optional pre-built profile state; tests pass an onboarded one to start
  /// on the dashboard instead of onboarding.
  final ProfileProvider? profileProvider;

  /// Step source; defaults to the phone's pedometer. Tests pass a fake.
  final StepCounterService? stepCounter;

  /// Photo source; defaults to the phone's camera and gallery. Tests pass a fake.
  final ImagePickerService? imagePicker;

  /// Photo analysis; defaults to the demo service, `main` passes the real
  /// AI (Firebase AI Logic). Tests pass a fake.
  final FoodAnalysisService? foodAnalysis;

  /// Apple Health / Health Connect; off by default (tests), `main` passes
  /// the real one.
  final HealthService? health;

  /// Accounts; off by default (tests), `main` passes Firebase Auth.
  final AuthService? auth;

  /// Cloud backup for signed-in users; `main` passes Firestore.
  final CloudStore? cloudStore;

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
        Provider(create: (_) => widget.imagePicker ?? ImagePickerService()),
        Provider<FoodAnalysisService>(
          create: (_) => widget.foodAnalysis ?? const DemoFoodAnalysisService(),
        ),
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
        Provider(
          create: (ctx) => WeightLogRepository(ctx.read<LocalStorageService>()),
        ),
        Provider(
          create: (ctx) => SyncService(
            storage: ctx.read<LocalStorageService>(),
            cloud: widget.cloudStore ?? const UnavailableCloudStore(),
          ),
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
            health: widget.health ?? const UnavailableHealthService(),
          ),
        ),
        ChangeNotifierProvider(
          create: (ctx) =>
              WeightLogProvider(ctx.read<WeightLogRepository>(), _profile),
        ),
        // Created at start so a signed-in user syncs right away.
        ChangeNotifierProvider(
          lazy: false,
          create: (ctx) => AccountProvider(
            auth: widget.auth ?? const UnavailableAuthService(),
            sync: ctx.read<SyncService>(),
            storage: ctx.read<LocalStorageService>(),
            onDataChanged: () {
              _profile.reload();
              ctx.read<FoodLogProvider>().load();
              ctx.read<ActivityLogProvider>().reload();
              ctx.read<WeightLogProvider>().reload();
            },
          )..start(),
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
