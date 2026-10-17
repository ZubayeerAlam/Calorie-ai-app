import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../food_log/presentation/widgets/food_entry_tile.dart';
import '../../../food_log/providers/food_log_provider.dart';
import '../../../profile/providers/profile_provider.dart';
import '../widgets/calorie_summary_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final log = context.watch<FoodLogProvider>();
    final goal = context.select<ProfileProvider, int>(
      (p) => p.goals.dailyCalories,
    );

    return Scaffold(
      appBar: AppBar(title: const Text(AppConstants.appName)),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(AppRoutes.addFoodLocation()),
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: CalorieSummaryCard(consumed: log.totalCalories, goal: goal),
          ),
          Expanded(
            child: log.isLoading
                ? const Center(child: CircularProgressIndicator())
                : log.entries.isEmpty
                ? const EmptyState(
                    icon: Icons.restaurant_menu,
                    message: 'No meals logged today',
                  )
                : ListView.builder(
                    itemCount: log.entries.length,
                    itemBuilder: (_, i) {
                      final entry = log.entries[i];
                      return FoodEntryTile(
                        entry: entry,
                        onDelete: () => log.removeEntry(entry.id),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
