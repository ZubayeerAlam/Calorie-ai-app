import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/l10n.dart';

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
              isToday ? l10n.emptyToday : l10n.emptyDay,
              style: TextStyle(fontSize: 14, color: AppColors.textDark),
            ),
          ),
        ],
      ),
    );
  }
}
