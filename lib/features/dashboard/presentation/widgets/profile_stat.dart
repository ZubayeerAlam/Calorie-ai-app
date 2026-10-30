import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// A value with a small label under it (e.g. "70.0 kg" / "Weight").
class ProfileStat extends StatelessWidget {
  const ProfileStat({
    super.key,
    required this.value,
    required this.label,
    this.caption,
  });

  final String value;
  final String label;

  /// Optional extra line, e.g. the BMI category.
  final String? caption;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FittedBox(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: AppColors.textGrey),
        ),
        if (caption != null)
          Text(
            caption!,
            style: const TextStyle(fontSize: 11, color: AppColors.primary),
          ),
      ],
    );
  }
}
