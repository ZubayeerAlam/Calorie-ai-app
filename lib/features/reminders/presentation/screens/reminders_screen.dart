import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../dashboard/presentation/widgets/dashboard_card.dart';
import '../../../food_log/data/models/food_entry.dart';
import '../../data/meal_reminder.dart';
import '../../providers/reminder_provider.dart';
import '../widgets/reminder_switch_tile.dart';
import '../widgets/today_reminder_row.dart';
import '../../../../l10n/l10n.dart';

/// Behind the Home bell: today's meals at a glance and the reminder
/// settings.
class RemindersScreen extends StatelessWidget {
  const RemindersScreen({super.key});

  Future<void> _toggle(
    BuildContext context,
    ReminderProvider reminders,
    MealType meal,
    bool on,
  ) async {
    final messenger = ScaffoldMessenger.of(context);
    if (!await reminders.setEnabled(meal, on)) {
      messenger.showSnackBar(SnackBar(content: Text(l10n.notificationsOff)));
    }
  }

  Future<void> _pickTime(
    BuildContext context,
    ReminderProvider reminders,
    MealReminder reminder,
  ) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: reminder.hour, minute: reminder.minute),
    );
    if (picked != null) {
      await reminders.setTime(reminder.meal, picked.hour, picked.minute);
    }
  }

  @override
  Widget build(BuildContext context) {
    final reminders = context.watch<ReminderProvider>();
    final enabled = [
      for (final r in reminders.reminders)
        if (r.enabled) r,
    ];

    return Scaffold(
      appBar: AppBar(title: Text(l10n.reminders)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          if (enabled.isEmpty)
            Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: Text(
                l10n.remindersIntro,
                style: TextStyle(fontSize: 14, color: AppColors.textGrey),
              ),
            )
          else ...[
            _Heading(l10n.today),
            DashboardCard(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  for (final r in enabled)
                    TodayReminderRow(
                      reminder: r,
                      status: reminders.statusOf(r.meal),
                      onLog: () =>
                          context.push(AppRoutes.addFoodLocation(meal: r.meal)),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
          _Heading(l10n.mealReminders),
          DashboardCard(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                for (final r in reminders.reminders)
                  ReminderSwitchTile(
                    reminder: r,
                    hint: r.meal == MealType.dinner
                        ? l10n.dinnerTimeFromProfile
                        : null,
                    onChanged: (on) => _toggle(context, reminders, r.meal, on),
                    onPickTime: () => _pickTime(context, reminders, r),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Heading extends StatelessWidget {
  const _Heading(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: AppColors.textDark,
        ),
      ),
    );
  }
}
