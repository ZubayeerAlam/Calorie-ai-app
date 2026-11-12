import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// A value with a small label under it, e.g. "5" / "Exercises".
class WorkoutStat extends StatelessWidget {
  const WorkoutStat({super.key, required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12, color: AppColors.textGrey),
        ),
      ],
    );
  }
}
