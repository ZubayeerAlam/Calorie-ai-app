import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/l10n.dart';

/// "Set 2 of 3" with a dot per set: done, current, still to do.
class SetIndicator extends StatelessWidget {
  const SetIndicator({
    super.key,
    required this.current,
    required this.total,
    required this.done,
  });

  final int current;
  final int total;
  final int done;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: l10n.setsDoneLabel(done, total),
      child: Column(
        children: [
          Text(
            l10n.setOfTotal(current, total),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 10),
          ExcludeSemantics(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var i = 0; i < total; i++)
                  Container(
                    width: 14,
                    height: 14,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: i < done ? AppColors.primary : AppColors.track,
                      border: i == done && done < total
                          ? Border.all(color: AppColors.accent, width: 2)
                          : null,
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
