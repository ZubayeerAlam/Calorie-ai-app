import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Two pill buttons, metric first (e.g. `kg` | `lb`).
class UnitToggle extends StatelessWidget {
  const UnitToggle({
    super.key,
    required this.useMetric,
    required this.onChanged,
    required this.metricLabel,
    required this.imperialLabel,
  });

  final bool useMetric;
  final ValueChanged<bool> onChanged;
  final String metricLabel;
  final String imperialLabel;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _UnitPill(
          label: metricLabel,
          selected: useMetric,
          onTap: () => onChanged(true),
        ),
        const SizedBox(width: 16),
        _UnitPill(
          label: imperialLabel,
          selected: !useMetric,
          onTap: () => onChanged(false),
        ),
      ],
    );
  }
}

class _UnitPill extends StatelessWidget {
  const _UnitPill({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        height: 49,
        constraints: const BoxConstraints(minWidth: 66),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.chipBorder,
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w500,
            color: AppColors.textDark,
          ),
        ),
      ),
    );
  }
}
