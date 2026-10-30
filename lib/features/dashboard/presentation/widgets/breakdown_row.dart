import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// One line of the calorie plan: emoji, label (+ optional detail) and value.
class BreakdownRow extends StatelessWidget {
  const BreakdownRow({
    super.key,
    required this.emoji,
    required this.label,
    required this.value,
    this.detail,
    this.highlight = false,
  });

  final String emoji;
  final String label;
  final String value;
  final String? detail;

  /// Bold, green value for the final result.
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 28,
            child: Text(emoji, style: const TextStyle(fontSize: 18)),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: highlight ? FontWeight.w600 : FontWeight.w400,
                    color: AppColors.textDark,
                  ),
                ),
                if (detail != null)
                  Text(
                    detail!,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textGrey,
                    ),
                  ),
              ],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: highlight ? 18 : 15,
              fontWeight: highlight ? FontWeight.w600 : FontWeight.w500,
              color: highlight ? AppColors.primary : AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }
}
