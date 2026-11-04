import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Grey section title followed by a thin line: `Eaten ──────────`.
class SectionLabel extends StatelessWidget {
  const SectionLabel(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(text, style: TextStyle(fontSize: 13, color: AppColors.textLight)),
        const SizedBox(width: 14),
        Expanded(child: Divider(height: 1, color: AppColors.line)),
      ],
    );
  }
}
