import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/add_circle_button.dart';
import 'stat_column.dart';
import '../../../../l10n/l10n.dart';

/// Walking | Activity kcal, with a + to log activity.
class BurnedSection extends StatelessWidget {
  const BurnedSection({
    super.key,
    required this.walking,
    required this.activity,
    required this.onAddActivity,
    this.walkingCaption,
  });

  /// Shown under Walking, e.g. "4,210 steps" or why steps are off.
  final String? walkingCaption;
  final int walking;
  final int activity;
  final VoidCallback onAddActivity;

  @override
  Widget build(BuildContext context) {
    // Stretch so both columns start at the top even when Walking has an
    // extra steps line, and the divider spans the full height.
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: StatColumn(
              emoji: '👣',
              label: l10n.walking,
              value: walking,
              caption: walkingCaption,
            ),
          ),
          VerticalDivider(width: 1, thickness: 1, color: AppColors.line),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: StatColumn(
                    emoji: '💪',
                    label: l10n.activity,
                    value: activity,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 22),
                  child: AddCircleButton(
                    key: const ValueKey('add-activity'),
                    tooltip: l10n.logActivity,
                    onPressed: onAddActivity,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
