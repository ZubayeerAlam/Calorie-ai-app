import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../activity/providers/activity_log_provider.dart';
import '../../../food_log/data/models/food_entry.dart';
import '../../../food_log/presentation/meal_type_labels.dart';
import '../../../food_log/providers/food_log_provider.dart';
import '../../../profile/data/models/user_goals.dart';
import '../../../profile/providers/profile_provider.dart';
import '../widgets/burned_section.dart';
import '../widgets/calorie_overview.dart';
import '../widgets/dashboard_card.dart';
import '../widgets/date_selector.dart';
import '../widgets/header_wave_background.dart';
import '../widgets/home_header.dart';
import '../widgets/log_activity_sheet.dart';
import '../widgets/macros_row.dart';
import '../widgets/meal_entries_sheet.dart';
import '../widgets/meal_tile.dart';
import '../widgets/meals_card.dart';
import '../widgets/section_label.dart';

/// Home tab: daily calories, macros, burned calories and meals for the
/// selected day.
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  static const double _headerHeight = 64;

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
    );
    if (kcal != null) await activity.setBurned(date, kcal);
  }

  @override
  Widget build(BuildContext context) {
    final log = context.watch<FoodLogProvider>();
    final activity = context.watch<ActivityLogProvider>();
    final goals = context.select<ProfileProvider, UserGoals>((p) => p.goals);
    final date = log.selectedDate;
    final topInset = MediaQuery.paddingOf(context).top;

    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            HeaderWaveBackground(height: topInset + _headerHeight + 150),
            Padding(
              padding: EdgeInsets.fromLTRB(20, topInset, 20, 24),
              child: Column(
                children: [
                  HomeHeader(
                    onNotificationsPressed: () => ScaffoldMessenger.of(context)
                        .showSnackBar(
                          const SnackBar(content: Text('No new notifications')),
                        ),
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
                          burned: activity.totalBurnedOn(date),
                        ),
                        const SizedBox(height: 24),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: SectionLabel('Eaten'),
                        ),
                        const SizedBox(height: 20),
                        MacrosRow(
                          goals: goals,
                          carbs: log.totalCarbs,
                          protein: log.totalProtein,
                          fat: log.totalFat,
                        ),
                        const SizedBox(height: 24),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: SectionLabel('Burned'),
                        ),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: BurnedSection(
                            walking: activity.walkingOn(date),
                            activity: activity.burnedOn(date),
                            onAddActivity: () =>
                                _logActivity(context, activity, date),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  MealsCard(
                    tiles: [
                      for (final meal in MealType.values)
                        MealTile(
                          image: meal.emoji,
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
