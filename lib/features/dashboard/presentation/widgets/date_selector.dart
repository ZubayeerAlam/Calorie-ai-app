import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../l10n/l10n.dart';

/// `‹  Today, Dec 22 📅  ›` — step a day back/forward or pick a date.
/// [onNext] is null when [date] is today (no future days).
class DateSelector extends StatelessWidget {
  const DateSelector({
    super.key,
    required this.date,
    required this.onPrevious,
    required this.onNext,
    required this.onPick,
  });

  final DateTime date;
  final VoidCallback onPrevious;
  final VoidCallback? onNext;
  final VoidCallback onPick;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          tooltip: l10n.previousDay,
          onPressed: onPrevious,
          icon: const Icon(Icons.chevron_left_rounded, size: 28),
          color: AppColors.textDark,
        ),
        Expanded(
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: onPick,
            // At least 48 px tall so it's easy to tap.
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 48),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      AppDates.dayLabel(date),
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textDark,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.calendar_month_outlined,
                    size: 20,
                    color: AppColors.textDark,
                  ),
                ],
              ),
            ),
          ),
        ),
        IconButton(
          tooltip: l10n.nextDay,
          onPressed: onNext,
          icon: const Icon(Icons.chevron_right_rounded, size: 28),
          color: AppColors.textDark,
          disabledColor: AppColors.tick,
        ),
      ],
    );
  }
}
