import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Filled, rounded text field used on the manual entry screen.
class DetailField extends StatelessWidget {
  const DetailField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.maxLines = 1,
    this.onChanged,
    this.textInputAction = TextInputAction.next,
  });

  final TextEditingController controller;
  final String label;
  final String? hint;
  final int maxLines;
  final ValueChanged<String>? onChanged;
  final TextInputAction textInputAction;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      minLines: maxLines > 1 ? 3 : 1,
      maxLines: maxLines,
      textCapitalization: TextCapitalization.sentences,
      textInputAction: maxLines > 1 ? TextInputAction.newline : textInputAction,
      style: const TextStyle(fontSize: 16),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        alignLabelWithHint: maxLines > 1,
        filled: true,
        fillColor: AppColors.card,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
    );
  }
}
