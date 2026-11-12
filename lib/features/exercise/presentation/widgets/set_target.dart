import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/l10n.dart';
import 'countdown_ring.dart';

/// What to do in this set: "12 reps" (confirmed by hand), or a countdown
/// for timed sets.
class SetTarget extends StatelessWidget {
  const SetTarget({
    super.key,
    this.reps,
    this.secondsLeft,
    this.totalSeconds,
    this.timeUp = false,
  });

  final int? reps;
  final int? secondsLeft;
  final int? totalSeconds;
  final bool timeUp;

  @override
  Widget build(BuildContext context) {
    final hintStyle = TextStyle(fontSize: 14, color: AppColors.textGrey);
    final left = secondsLeft;
    if (left != null) {
      return Column(
        children: [
          CountdownRing(secondsLeft: left, totalSeconds: totalSeconds ?? left),
          const SizedBox(height: 8),
          Text(
            timeUp ? l10n.timeUpHint : l10n.tapWhenDone,
            textAlign: TextAlign.center,
            style: timeUp
                ? hintStyle.copyWith(
                    color: AppColors.accent,
                    fontWeight: FontWeight.w600,
                  )
                : hintStyle,
          ),
        ],
      );
    }
    return Column(
      children: [
        Text(
          l10n.repsCount(reps ?? 0),
          style: TextStyle(
            fontSize: 44,
            fontWeight: FontWeight.w700,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 4),
        Text(l10n.tapWhenDone, textAlign: TextAlign.center, style: hintStyle),
      ],
    );
  }
}
