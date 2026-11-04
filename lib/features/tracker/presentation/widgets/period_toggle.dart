import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../data/tracker_stats.dart';

/// Week / Month switch at the top of the Tracker.
class PeriodToggle extends StatelessWidget {
  const PeriodToggle({super.key, required this.value, required this.onChanged});

  final TrackerPeriod value;
  final ValueChanged<TrackerPeriod> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: SegmentedButton<TrackerPeriod>(
        segments: [
          for (final period in TrackerPeriod.values)
            ButtonSegment(value: period, label: Text(period.label)),
        ],
        selected: {value},
        showSelectedIcon: false,
        onSelectionChanged: (selection) => onChanged(selection.first),
        style: SegmentedButton.styleFrom(
          backgroundColor: AppColors.surface,
          selectedBackgroundColor: AppColors.primary,
          selectedForegroundColor: AppColors.onPrimary,
          foregroundColor: AppColors.textGrey,
          side: BorderSide(color: AppColors.line),
        ),
      ),
    );
  }
}
