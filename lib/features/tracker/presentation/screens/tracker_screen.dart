import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../activity/providers/activity_log_provider.dart';
import '../../../food_log/data/repositories/food_log_repository.dart';
import '../../../food_log/providers/food_log_provider.dart';
import '../../../profile/providers/profile_provider.dart';
import '../../data/tracker_stats.dart';
import '../../providers/weight_log_provider.dart';
import '../widgets/calories_card.dart';
import '../widgets/history_card.dart';
import '../widgets/log_weight_sheet.dart';
import '../widgets/macro_averages_card.dart';
import '../widgets/period_toggle.dart';
import '../widgets/steps_card.dart';
import '../widgets/summary_tiles.dart';
import '../widgets/weight_card.dart';
import '../widgets/weight_units.dart';

/// Tracker tab: weight, calories, macros and steps over the last week or
/// month, plus the daily history.
class TrackerScreen extends StatefulWidget {
  const TrackerScreen({super.key});

  @override
  State<TrackerScreen> createState() => _TrackerScreenState();
}

class _TrackerScreenState extends State<TrackerScreen> {
  /// Used for walking kcal until a profile exists.
  static const double _fallbackWeightKg = 70;

  TrackerPeriod _period = TrackerPeriod.week;

  @override
  void initState() {
    super.initState();
    context.read<ActivityLogProvider>().syncHealth(days: _period.days);
  }

  void _selectPeriod(TrackerPeriod period) {
    setState(() => _period = period);
    context.read<ActivityLogProvider>().syncHealth(days: period.days);
  }

  Future<void> _logWeight(WeightUnits units, double currentKg) async {
    final weights = context.read<WeightLogProvider>();
    final kg = await LogWeightSheet.show(
      context,
      units: units,
      initialKg: currentKg,
    );
    if (kg != null) await weights.logWeight(AppDates.today(), kg);
  }

  /// Shows [day] on Home.
  Future<void> _openDay(DateTime day) async {
    await context.read<FoodLogProvider>().selectDate(day);
    if (mounted) context.go(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    // Watched so the charts update when food, activity or weight change.
    context.watch<FoodLogProvider>();
    final activity = context.watch<ActivityLogProvider>();
    final profileState = context.watch<ProfileProvider>();
    final weights = context.watch<WeightLogProvider>();
    final profile = profileState.profile;
    final weightKg = profile?.weightKg ?? _fallbackWeightKg;
    final units = WeightUnits(metric: profile?.useMetric ?? true);

    final stats = TrackerStats.build(
      period: _period,
      today: AppDates.today(),
      entries: context.read<FoodLogRepository>().allEntries(),
      stepsOn: activity.stepsOn,
      burnedOn: (day) => activity.totalBurnedOn(day, weightKg: weightKg),
      weights: weights.entries,
      goals: profileState.goals,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Tracker')),
      body: ListView(
        // Extra bottom space so the raised camera button never covers content.
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 56),
        children: [
          PeriodToggle(value: _period, onChanged: _selectPeriod),
          const SizedBox(height: 16),
          SummaryTiles(stats: stats),
          const SizedBox(height: 16),
          WeightCard(
            currentKg: weightKg,
            weights: stats.weights,
            change: stats.weightChange,
            units: units,
            onLogWeight: () => _logWeight(units, weightKg),
          ),
          const SizedBox(height: 16),
          CaloriesCard(stats: stats),
          const SizedBox(height: 16),
          MacroAveragesCard(stats: stats),
          const SizedBox(height: 16),
          StepsCard(stats: stats),
          const SizedBox(height: 16),
          HistoryCard(stats: stats, onOpenDay: _openDay),
        ],
      ),
    );
  }
}
