import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Shown above the meals while nothing is logged for the selected day.
class EmptyLogHint extends StatelessWidget {
  const EmptyLogHint({super.key, required this.isToday});

  final bool isToday;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Text('🍽️', style: TextStyle(fontSize: 20)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              isToday
                  ? 'Nothing logged yet today. Tap ＋ on a meal to log food.'
                  : 'Nothing logged on this day. Tap ＋ on a meal to add it.',
              style: const TextStyle(fontSize: 14, color: AppColors.textDark),
            ),
          ),
        ],
      ),
    );
  }
}
