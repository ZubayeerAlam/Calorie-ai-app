import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/meal_photo.dart';
import '../../data/models/food_description.dart';
import 'description_summary.dart';

/// The photo (or typed description) with a spinner while the AI works.
class AnalysisLoadingView extends StatelessWidget {
  const AnalysisLoadingView({super.key, this.imagePath, this.description});

  final String? imagePath;
  final FoodDescription? description;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          if (imagePath != null)
            MealPhoto(path: imagePath!, height: 240)
          else if (description != null)
            DescriptionSummary(description: description!),
          const Spacer(),
          const SizedBox.square(
            dimension: 44,
            child: CircularProgressIndicator(
              strokeWidth: 4,
              color: AppColors.primary,
              backgroundColor: AppColors.ringTrack,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Analyzing your meal…',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'This usually takes a few seconds.',
            style: TextStyle(fontSize: 14, color: AppColors.textGrey),
          ),
          const Spacer(flex: 2),
        ],
      ),
    );
  }
}
