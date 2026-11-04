import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../core/utils/number_format.dart';
import '../../../activity/providers/activity_log_provider.dart';
import '../../../food_log/data/models/food_entry.dart';
import '../../../food_log/presentation/meal_type_labels.dart';
import '../../../food_log/providers/food_log_provider.dart';
import '../../../profile/data/models/user_goals.dart';
import '../../../profile/data/models/user_profile.dart';
import '../../../profile/presentation/profile_labels.dart';
import '../../../profile/providers/profile_provider.dart';
import '../../../reminders/providers/reminder_provider.dart';
import '../widgets/burned_section.dart';
import '../widgets/calorie_overview.dart';
import '../widgets/calorie_plan_card.dart';
import '../widgets/dashboard_card.dart';
import '../widgets/date_selector.dart';
import '../widgets/empty_log_hint.dart';
import '../widgets/header_wave_background.dart';
import '../widgets/home_header.dart';
import '../widgets/log_activity_sheet.dart';
import '../widgets/macros_row.dart';
import '../widgets/meal_entries_sheet.dart';
import '../widgets/meal_tile.dart';
import '../widgets/meals_card.dart';
import '../widgets/profile_summary_card.dart';
import '../widgets/section_label.dart';
import '../../../../shared/widgets/meal_illustration.dart';
import '../../../../l10n/l10n.dart';

/// Home tab: daily calories, macros, burned calories and meals for the
/// selected day.
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  static const double _headerHeight = 64;

  /// Used for walking kcal until a profile exists.
  static const double _fallbackWeightKg = 70;

  @override
  void initState() {
    super.initState();
    // Ask for step access and start counting once Home is shown.
    context.read<ActivityLogProvider>().startStepTracking();
  }

  static String? _walkingCaption(ActivityLogProvider activity, int steps) =>
      switch (activity.stepStatus) {
        StepTrackingStatus.tracking => l10n.stepsCount(
          AppNumbers.thousands(steps),
        ),
        StepTrackingStatus.denied => l10n.allowStepAccess,
        StepTrackingStatus.unavailable => l10n.noStepSensor,
        StepTrackingStatus.off => null,
      };

  Future<void> _pickDate(BuildContext context, FoodLogProvider log) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: log.selectedDate,
      firstDate: DateTime(2020),
      lastDate: AppDates.today(),
    );
    if (picked != null) await log.selectDate(picked);
  }

  Future<void> _logActivity(
    BuildContext context,
    ActivityLogProvider activity,
    DateTime date,
  ) async {
    final kcal = await LogActivitySheet.show(
      context,
      date: date,
      initialKcal: activity.burnedOn(date),
      importedKcal: activity.workoutKcalOn(date),
    );
    if (kcal != null) await activity.setBurned(date, kcal);
  }

  @override
  Widget build(BuildContext context) {
    final log = context.watch<FoodLogProvider>();
    final activity = context.watch<ActivityLogProvider>();
    // Profile, targets and calculator breakdown, all from local storage.
    final profileState = context.watch<ProfileProvider>();
    final UserGoals goals = profileState.goals;
    final UserProfile? profile = profileState.profile;
    final breakdown = profileState.calorieBreakdown;
    final weightKg = profile?.weightKg ?? _fallbackWeightKg;
    final date = log.selectedDate;
    final topInset = MediaQuery.paddingOf(context).top;

    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            HeaderWaveBackground(height: topInset + _headerHeight + 150),
            Padding(
              // Extra bottom space so the raised camera button never covers content.
              padding: EdgeInsets.fromLTRB(20, topInset, 20, 56),
              child: Column(
                children: [
                  HomeHeader(
                    name: profile?.name ?? '',
                    subtitle: profile == null
                        ? l10n.dailyGoalKcal('${goals.dailyCalories}')
                        : l10n.goalKcalADay(
                            profile.goal.label,
                            '${goals.dailyCalories}',
                          ),
                    hasUnread: context.watch<ReminderProvider>().hasMissed,
                    onNotificationsPressed: () =>
                        context.push(AppRoutes.reminders),
                  ),
                  const SizedBox(height: 12),
                  DashboardCard(
                    padding: const EdgeInsets.fromLTRB(12, 12, 12, 20),
                    child: Column(
                      children: [
                        DateSelector(
                          date: date,
                          onPrevious: log.previousDay,
                          onNext: log.isToday ? null : log.nextDay,
                          onPick: () => _pickDate(context, log),
                        ),
                        const SizedBox(height: 16),
                        CalorieOverview(
                          target: goals.dailyCalories,
                          eaten: log.totalCalories,
                          burned: activity.totalBurnedOn(
                            date,
                            weightKg: weightKg,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: SectionLabel(l10n.eaten),
                        ),
                        const SizedBox(height: 20),
                        MacrosRow(
                          goals: goals,
                          carbs: log.totalCarbs,
                          protein: log.totalProtein,
                          fat: log.totalFat,
                        ),
                        const SizedBox(height: 24),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: SectionLabel(l10n.burned),
                        ),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: BurnedSection(
                            walking: activity.walkingOn(
                              date,
                              weightKg: weightKg,
                            ),
                            walkingCaption: _walkingCaption(
                              activity,
                              activity.stepsOn(date),
                            ),
                            activity: activity.activityOn(date),
                            onAddActivity: () =>
                                _logActivity(context, activity, date),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (log.entries.isEmpty && !log.isLoading) ...[
                    const SizedBox(height: 16),
                    EmptyLogHint(isToday: log.isToday),
                  ],
                  const SizedBox(height: 16),
                  MealsCard(
                    tiles: [
                      for (final meal in MealType.values)
                        MealTile(
                          picture: MealIllustration(meal: meal),
                          title: meal.label,
                          eaten: log.caloriesFor(meal),
                          target: meal.targetCalories(goals.dailyCalories),
                          addButtonKey: ValueKey('add-meal-${meal.name}'),
                          onAdd: () => context.push(
                            AppRoutes.addFoodLocation(meal: meal),
                          ),
                          onTap: () => MealEntriesSheet.show(context, meal),
                        ),
                    ],
                  ),
                  if (profile != null) ...[
                    const SizedBox(height: 16),
                    ProfileSummaryCard(profile: profile),
                  ],
                  if (breakdown != null) ...[
                    const SizedBox(height: 16),
                    CaloriePlanCard(
                      breakdown: breakdown,
                      goals: goals,
                      customized: profileState.goalsCustomized,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
