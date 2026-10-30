import 'dart:io';

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// A meal photo from a file, with rounded corners. Shows a placeholder if
/// the file is missing or unreadable.
class MealPhoto extends StatelessWidget {
  const MealPhoto({super.key, required this.path, this.height = 200});

  final String path;
  final double height;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.file(
        File(path),
        height: height,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => Container(
          height: height,
          alignment: Alignment.center,
          color: AppColors.card,
          child: const Icon(
            Icons.image_not_supported_outlined,
            color: AppColors.textLight,
          ),
        ),
      ),
    );
  }
}
