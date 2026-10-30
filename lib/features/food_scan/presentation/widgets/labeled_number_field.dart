import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_colors.dart';

/// Small filled number field with a label and unit, e.g. "Protein · 46.5 g".
class LabeledNumberField extends StatelessWidget {
  const LabeledNumberField({
    super.key,
    required this.controller,
    required this.label,
    required this.unit,
    required this.onChanged,
    this.decimals = true,
  });

  final TextEditingController controller;
  final String label;
  final String unit;
  final ValueChanged<String> onChanged;
  final bool decimals;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      keyboardType: TextInputType.numberWithOptions(decimal: decimals),
      inputFormatters: [
        FilteringTextInputFormatter.allow(
          decimals ? RegExp(r'^\d*\.?\d*') : RegExp(r'^\d*'),
        ),
      ],
      style: const TextStyle(fontSize: 15),
      decoration: InputDecoration(
        labelText: label,
        suffixText: unit,
        isDense: true,
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.line),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.line),
        ),
      ),
    );
  }
}
