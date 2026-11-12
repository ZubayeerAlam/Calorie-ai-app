import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'core/constants/app_constants.dart';
import 'core/routes/app_router.dart';
import 'core/routes/app_routes.dart';
import 'core/services/auth_service.dart';
import 'core/services/cloud_store.dart';
import 'core/services/demo_food_analysis_service.dart';
import 'core/services/food_analysis_service.dart';
import 'core/services/health_service.dart';
import 'core/services/image_picker_service.dart';
import 'core/services/local_storage_service.dart';
import 'core/services/notification_service.dart';
import 'core/services/permission_service.dart';
import 'core/services/rule_based_workout_plan_service.dart';
import 'core/services/step_counter_service.dart';
import 'core/services/workout_plan_service.dart';
import 'core/theme/app_colors.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/appearance_controller.dart';
import 'features/account/data/sync_service.dart';
import 'features/account/providers/account_provider.dart';
import 'features/activity/data/activity_log_repository.dart';
import 'features/activity/data/step_log_repository.dart';
import 'features/activity/providers/activity_log_provider.dart';
import 'features/food_log/data/models/food_entry.dart';
import 'features/food_log/data/repositories/food_log_repository.dart';
import 'features/food_log/providers/food_log_provider.dart';
import 'features/food_scan/providers/food_scan_provider.dart';
import 'features/profile/providers/profile_provider.dart';
import 'features/reminders/providers/reminder_provider.dart';
import 'features/tracker/data/weight_log_repository.dart';
import 'features/tracker/providers/weight_log_provider.dart';
import 'l10n/l10n.dart';
import 'l10n/language_controller.dart';

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
    this.notifications,
    this.workoutPlans,
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

  /// Meal reminders; off by default (tests), `main` passes the real one.
  final NotificationService? notifications;

  /// Workout plans; defaults to the built-in rules (no AI), `main` passes
  /// Gemini (Firebase AI Logic).
  final WorkoutPlanService? workoutPlans;

  @override
  State<CalAiApp> createState() => _CalAiAppState();
}

class _CalAiAppState extends State<CalAiApp> with WidgetsBindingObserver {
  // Created once so the router (which listens to the profile) is never
  // rebuilt and navigation state survives app rebuilds.
  late final ProfileProvider _profile =
      widget.profileProvider ?? ProfileProvider(storage: widget.storage);
  late final GoRouter _router = createAppRouter(_profile);
  late final NotificationService _notifications =
      widget.notifications ?? const UnavailableNotificationService();
  late final AppearanceController _appearance = AppearanceController(
    widget.storage,
  )..addListener(_applyAppearance);
  late final LanguageController _language = LanguageController(widget.storage)
    ..addListener(_applyAppearance);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Tapping a meal reminder opens Add Food for that meal.
    _notifications.onTap = (payload) => _router.push(
      AppRoutes.addFoodLocation(meal: MealType.values.asNameMap()[payload]),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _appearance.dispose();
    _language.dispose();
    _notifications.onTap = null;
    _router.dispose();
    if (widget.profileProvider == null) _profile.dispose();
    super.dispose();
  }

  // The phone switched between light and dark.
  @override
  void didChangePlatformBrightness() => _applyAppearance();

  // The phone's language changed.
  @override
  void didChangeLocales(List<Locale>? locales) => _applyAppearance();

  /// Rebuilds every widget with the new palette or language, including
  /// `const` ones that read [AppColors] or [l10n] (they would otherwise
  /// keep the old colours and text).
  void _applyAppearance() {
    if (!mounted) return;
    setState(() {});
    void rebuild(Element element) {
      element.markNeedsBuild();
      element.visitChildren(rebuild);
    }

    (context as Element).visitChildren(rebuild);
  }

  @override
  Widget build(BuildContext context) {
    // Pick the palette before anything below reads a colour.
    AppColors.useDark(
      _appearance.isDark(
        WidgetsBinding.instance.platformDispatcher.platformBrightness,
      ),
    );
    return MultiProvider(
      providers: [
        // Services
        Provider.value(value: widget.storage),
        ChangeNotifierProvider.value(value: _appearance),
        ChangeNotifierProvider.value(value: _language),
        Provider(create: (_) => PermissionService()),
        Provider(create: (_) => widget.imagePicker ?? ImagePickerService()),
        Provider<FoodAnalysisService>(
          create: (_) => widget.foodAnalysis ?? const DemoFoodAnalysisService(),
        ),
        Provider<WorkoutPlanService>(
          create: (_) =>
              widget.workoutPlans ?? const RuleBasedWorkoutPlanService(),
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
        // Created at start so reminders are scheduled right away.
        ChangeNotifierProvider(
          lazy: false,
          create: (ctx) => ReminderProvider(
            storage: ctx.read<LocalStorageService>(),
            notifications: _notifications,
            profile: _profile,
            food: ctx.read<FoodLogRepository>(),
            foodChanges: ctx.read<FoodLogProvider>(),
            languageChanges: _language,
          ),
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
        // Built from the palette chosen above (light or dark).
        theme: AppTheme.current(),
        // English or Bangla: the phone's language, or the one chosen on
        // Account.
        locale: _language.locale,
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        // Follow the phone's text size, up to the largest the fixed
        // dashboard layouts were checked at.
        builder: (context, child) {
          // Screens, labels and reminders read the text through `l10n`.
          useLocalizations(AppLocalizations.of(context));
          return MediaQuery.withClampedTextScaling(
            maxScaleFactor: AppConstants.maxTextScale,
            child: child!,
          );
        },
        routerConfig: _router,
      ),
    );
  }
}
