import 'package:flutter/material.dart';

import '../../../../core/services/food_analysis_service.dart';
import '../../../../core/theme/app_colors.dart';

/// Explains why the analysis failed and offers a way forward.
class AnalysisErrorView extends StatelessWidget {
  const AnalysisErrorView({
    super.key,
    required this.failure,
    required this.onRetry,
    required this.onNotFoodAction,
    this.forPhoto = true,
    required this.onEnterManually,
  });

  final FoodAnalysisFailure failure;
  final VoidCallback onRetry;

  /// For "not food": take another photo, or go back and edit the text.
  final VoidCallback onNotFoodAction;

  /// Wording for a photo (true) or a typed description (false).
  final bool forPhoto;
  final VoidCallback onEnterManually;

  @override
  Widget build(BuildContext context) {
    final (icon, title, message) = switch (failure) {
      FoodAnalysisFailure.notFood when forPhoto => (
        Icons.no_food_outlined,
        'No food found',
        'We couldn\'t spot any food in this photo. Try another photo, or '
            'enter the food yourself.',
      ),
      FoodAnalysisFailure.notFood => (
        Icons.no_food_outlined,
        'No food recognised',
        'We couldn\'t find any food in what you wrote. Try describing it '
            'differently, or enter the numbers yourself.',
      ),
      FoodAnalysisFailure.network => (
        Icons.wifi_off_rounded,
        'Can\'t reach the analysis service',
        'Check your connection and try again.',
      ),
      FoodAnalysisFailure.invalidResponse || FoodAnalysisFailure.unknown => (
        Icons.error_outline_rounded,
        'Something went wrong',
        'The analysis didn\'t work this time. Try again, or enter the food '
            'yourself.',
      ),
    };
    final isNotFood = failure == FoodAnalysisFailure.notFood;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Icon(icon, size: 56, color: AppColors.textLight),
          const SizedBox(height: 16),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 15, color: AppColors.textGrey),
          ),
          const SizedBox(height: 28),
          SizedBox(
            height: 52,
            child: ElevatedButton(
              onPressed: isNotFood ? onNotFoodAction : onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.textDark,
                elevation: 0,
                shape: const StadiumBorder(),
              ),
              child: Text(
                !isNotFood
                    ? 'Try again'
                    : forPhoto
                    ? 'Try another photo'
                    : 'Edit description',
              ),
            ),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: onEnterManually,
            child: Text(
              forPhoto ? 'Enter it manually' : 'Enter numbers myself',
            ),
          ),
        ],
      ),
    );
  }
}
