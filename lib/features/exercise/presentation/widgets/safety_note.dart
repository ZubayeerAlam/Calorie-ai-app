import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// A small note with an info icon (safety and estimate disclaimers).
class SafetyNote extends StatelessWidget {
  const SafetyNote({
    super.key,
    required this.text,
    this.icon = Icons.info_outline_rounded,
  });

  final String text;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: AppColors.textGrey),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 12.5, color: AppColors.textGrey),
          ),
        ),
      ],
    );
  }
}
