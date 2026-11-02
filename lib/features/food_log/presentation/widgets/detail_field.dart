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
    this.keyboardType,
  });

  final TextEditingController controller;
  final String label;
  final String? hint;
  final int maxLines;
  final ValueChanged<String>? onChanged;
  final TextInputAction textInputAction;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      minLines: maxLines > 1 ? 3 : 1,
      maxLines: maxLines,
      keyboardType: keyboardType,
      // Email addresses must not start with a capital letter.
      textCapitalization: keyboardType == TextInputType.emailAddress
          ? TextCapitalization.none
          : TextCapitalization.sentences,
      autocorrect: keyboardType != TextInputType.emailAddress,
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
