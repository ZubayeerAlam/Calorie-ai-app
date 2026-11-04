import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../food_log/presentation/meal_type_labels.dart';
import '../../data/meal_reminder.dart';
import '../../../../shared/widgets/meal_illustration.dart';
import '../../../../l10n/l10n.dart';

/// A meal reminder's on/off switch with its time, which opens a picker.
class ReminderSwitchTile extends StatelessWidget {
  const ReminderSwitchTile({
    super.key,
    required this.reminder,
    required this.onChanged,
    required this.onPickTime,
    this.hint,
  });

  final MealReminder reminder;
  final ValueChanged<bool> onChanged;
  final VoidCallback onPickTime;
  final String? hint;

  @override
  Widget build(BuildContext context) {
    final meal = reminder.meal;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          MealIllustration(meal: meal, size: 40),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  meal.label,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                ),
                TextButton(
                  key: ValueKey('reminder-time-${meal.name}'),
                  onPressed: onPickTime,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(0, 32),
                    alignment: Alignment.centerLeft,
                  ),
                  child: Text(
                    AppDates.timeLabel(reminder.hour, reminder.minute),
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
                if (hint != null)
                  Text(
                    hint!,
                    style: TextStyle(fontSize: 12, color: AppColors.textLight),
                  ),
              ],
            ),
          ),
          Semantics(
            label: l10n.mealReminder(meal.label),
            child: Switch(
              key: ValueKey('reminder-switch-${meal.name}'),
              value: reminder.enabled,
              onChanged: onChanged,
              activeTrackColor: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
