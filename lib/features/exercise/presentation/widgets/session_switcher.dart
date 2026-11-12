import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/l10n.dart';

/// The plan's sessions as chips; today's is marked. Picking one shows it
/// on the dashboard.
class SessionSwitcher extends StatelessWidget {
  const SessionSwitcher({
    super.key,
    required this.names,
    required this.selected,
    required this.today,
    required this.onSelected,
  });

  /// Each session's name, in order.
  final List<String> names;
  final int selected;
  final int today;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final (i, name) in names.indexed)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                key: ValueKey('session-$i'),
                label: Text(i == today ? '$name · ${l10n.today}' : name),
                selected: i == selected,
                showCheckmark: false,
                onSelected: (_) => onSelected(i),
                selectedColor: AppColors.primary,
                backgroundColor: AppColors.surface,
                side: BorderSide(color: AppColors.chipBorder),
                labelStyle: TextStyle(
                  color: i == selected
                      ? AppColors.onPrimary
                      : AppColors.textDark,
                  fontWeight: i == today ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
