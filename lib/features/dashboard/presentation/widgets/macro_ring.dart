import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/progress_ring.dart';
import '../../../../l10n/l10n.dart';

/// One macro: a ring with "eaten / target g" inside and its name below.
class MacroRing extends StatelessWidget {
  const MacroRing({
    super.key,
    required this.label,
    required this.eatenGrams,
    required this.targetGrams,
  });

  final String label;
  final int eatenGrams;
  final int targetGrams;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ProgressRing(
          value: targetGrams == 0 ? 0 : eatenGrams / targetGrams,
          size: 82,
          strokeWidth: 6,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$eatenGrams',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w500,
                  height: 1.1,
                  color: AppColors.textDark,
                ),
              ),
              Text(
                '/ ${l10n.gramsValue('$targetGrams')}',
                style: TextStyle(fontSize: 10, color: AppColors.textGrey),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Text(label, style: TextStyle(fontSize: 13, color: AppColors.textDark)),
      ],
    );
  }
}
