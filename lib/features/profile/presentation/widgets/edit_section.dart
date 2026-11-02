import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// A labelled group on the Edit profile screen.
class EditSection extends StatelessWidget {
  const EditSection({
    super.key,
    required this.title,
    required this.child,
    this.hint,
  });

  final String title;
  final String? hint;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
          ),
          if (hint != null) ...[
            const SizedBox(height: 2),
            Text(
              hint!,
              style: const TextStyle(fontSize: 13, color: AppColors.textLight),
            ),
          ],
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}
