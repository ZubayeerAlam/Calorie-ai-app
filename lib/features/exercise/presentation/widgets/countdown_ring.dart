import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/l10n.dart';
import '../../../../shared/widgets/progress_ring.dart';

/// A ring that empties as [secondsLeft] counts down from [totalSeconds],
/// with the time ("1:05") in the middle.
class CountdownRing extends StatelessWidget {
  const CountdownRing({
    super.key,
    required this.secondsLeft,
    required this.totalSeconds,
    this.caption,
  });

  final int secondsLeft;
  final int totalSeconds;
  final String? caption;

  /// "0:45", "1:05", "10:00".
  static String clock(int seconds) =>
      '${seconds ~/ 60}:${(seconds % 60).toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: l10n.secondsLeftLabel(secondsLeft),
      liveRegion: false,
      child: ExcludeSemantics(
        child: ProgressRing(
          value: totalSeconds == 0 ? 0 : secondsLeft / totalSeconds,
          size: 170,
          strokeWidth: 12,
          // Shrinks the text to fit inside the ring at large text sizes.
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (caption != null)
                    Text(
                      caption!,
                      style: TextStyle(fontSize: 14, color: AppColors.textGrey),
                    ),
                  Text(
                    clock(secondsLeft),
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
