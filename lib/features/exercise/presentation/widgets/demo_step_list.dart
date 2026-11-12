import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/l10n.dart';

/// Numbered instruction steps; [current] (the one the demo is showing) is
/// highlighted.
class DemoStepList extends StatelessWidget {
  const DemoStepList({super.key, required this.steps, this.current});

  final List<String> steps;
  final int? current;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final (i, step) in steps.indexed)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Semantics(
              label: l10n.stepNumber(i + 1),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 26,
                    height: 26,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: i == current ? AppColors.primary : AppColors.track,
                    ),
                    child: Text(
                      '${i + 1}',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: i == current
                            ? AppColors.onPrimary
                            : AppColors.textDark,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 3),
                      child: Text(
                        step,
                        style: TextStyle(
                          fontSize: 14.5,
                          fontWeight: i == current
                              ? FontWeight.w600
                              : FontWeight.w400,
                          color: AppColors.textDark,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
