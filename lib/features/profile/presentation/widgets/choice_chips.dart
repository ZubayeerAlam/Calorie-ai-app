import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Chips for picking options: one ([multiple] false) or several.
class OptionChips<T> extends StatelessWidget {
  const OptionChips({
    super.key,
    required this.options,
    required this.selected,
    required this.labelOf,
    required this.onChanged,
    this.multiple = false,
  });

  final List<T> options;
  final Set<T> selected;
  final String Function(T option) labelOf;

  /// The new selection after a tap.
  final ValueChanged<Set<T>> onChanged;
  final bool multiple;

  void _toggle(T option) {
    if (!multiple) {
      onChanged({option});
      return;
    }
    final next = {...selected};
    if (!next.remove(option)) next.add(option);
    onChanged(next);
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final option in options)
          ChoiceChip(
            label: Text(labelOf(option)),
            selected: selected.contains(option),
            onSelected: (_) => _toggle(option),
            showCheckmark: multiple,
            selectedColor: AppColors.primary,
            backgroundColor: AppColors.surface,
            side: const BorderSide(color: AppColors.chipBorder),
            labelStyle: const TextStyle(color: AppColors.textDark),
          ),
      ],
    );
  }
}
