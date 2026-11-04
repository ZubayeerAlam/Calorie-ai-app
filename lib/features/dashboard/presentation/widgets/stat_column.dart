import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/l10n.dart';

/// Small "🔥 Burned" label, a big number and a unit underneath.
class StatColumn extends StatelessWidget {
  const StatColumn({
    super.key,
    required this.emoji,
    required this.label,
    required this.value,
    this._unit,
    this.caption,
  });

  final String emoji;
  final String label;
  final int value;
  final String? _unit;

  /// Defaults to kcal.
  String get unit => _unit ?? l10n.unitKcal;

  /// Optional small line under the unit (e.g. step count).
  final String? caption;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 12)),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 12, color: AppColors.textGrey),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          '$value',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w500,
            height: 1.1,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 6),
        Text(unit, style: TextStyle(fontSize: 12, color: AppColors.textGrey)),
        if (caption != null) ...[
          const SizedBox(height: 2),
          Text(
            caption!,
            style: TextStyle(fontSize: 11, color: AppColors.accent),
          ),
        ],
      ],
    );
  }
}
