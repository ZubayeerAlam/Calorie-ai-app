import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../food_log/presentation/meal_type_labels.dart';
import '../../data/meal_reminder.dart';
import '../../../../l10n/l10n.dart';

/// One meal in the "Today" list: logged, coming up, or missed (tap to log).
class TodayReminderRow extends StatelessWidget {
  const TodayReminderRow({
    super.key,
    required this.reminder,
    required this.status,
    required this.onLog,
  });

  final MealReminder reminder;
  final ReminderStatus status;
  final VoidCallback onLog;

  @override
  Widget build(BuildContext context) {
    final time = AppDates.timeLabel(reminder.hour, reminder.minute);
    final (IconData icon, Color color, String text) = switch (status) {
      ReminderStatus.done => (
        Icons.check_circle_rounded,
        AppColors.primary,
        l10n.logged,
      ),
      ReminderStatus.upcoming => (
        Icons.schedule_rounded,
        AppColors.textLight,
        l10n.reminderAt(time),
      ),
      ReminderStatus.missed => (
        Icons.error_outline_rounded,
        AppColors.badge,
        l10n.notLoggedYet(time),
      ),
    };
    return ListTile(
      key: ValueKey('today-${reminder.meal.name}'),
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: color),
      title: Text(reminder.meal.label),
      subtitle: Text(text),
      trailing: status == ReminderStatus.done
          ? null
          : TextButton(onPressed: onLog, child: Text(l10n.logNow)),
    );
  }
}
