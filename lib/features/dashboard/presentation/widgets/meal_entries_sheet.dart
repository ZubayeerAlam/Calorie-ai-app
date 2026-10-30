import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../food_log/data/models/food_entry.dart';
import '../../../food_log/presentation/meal_type_labels.dart';
import '../../../food_log/presentation/widgets/food_entry_tile.dart';
import '../../../food_log/providers/food_log_provider.dart';

/// Bottom sheet listing what was logged for one meal, with delete.
class MealEntriesSheet extends StatelessWidget {
  const MealEntriesSheet({super.key, required this.meal});

  final MealType meal;

  static Future<void> show(BuildContext context, MealType meal) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => MealEntriesSheet(meal: meal),
    );
  }

  @override
  Widget build(BuildContext context) {
    final log = context.watch<FoodLogProvider>();
    final entries = log.entriesFor(meal);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 20, 8, 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                '${meal.emoji}  ${meal.label}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                ),
              ),
            ),
            const SizedBox(height: 8),
            if (entries.isEmpty)
              const SizedBox(
                height: 160,
                child: EmptyState(
                  icon: Icons.restaurant_menu,
                  message: 'Nothing logged yet',
                ),
              )
            else
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    for (final entry in entries)
                      FoodEntryTile(
                        entry: entry,
                        onDelete: () => log.removeEntry(entry.id),
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
