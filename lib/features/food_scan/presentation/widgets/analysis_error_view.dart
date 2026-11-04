import 'package:flutter/material.dart';

import '../../../../core/services/food_analysis_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/l10n.dart';

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
        l10n.noFoodFound,
        l10n.noFoodFoundPhoto,
      ),
      FoodAnalysisFailure.notFood => (
        Icons.no_food_outlined,
        l10n.noFoodRecognised,
        l10n.noFoodRecognisedText,
      ),
      FoodAnalysisFailure.network => (
        Icons.wifi_off_rounded,
        l10n.cantReachAnalysis,
        l10n.checkConnection,
      ),
      FoodAnalysisFailure.invalidResponse || FoodAnalysisFailure.unknown => (
        Icons.error_outline_rounded,
        l10n.somethingWentWrong,
        l10n.analysisFailed,
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
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15, color: AppColors.textGrey),
          ),
          const SizedBox(height: 28),
          SizedBox(
            height: 52,
            child: ElevatedButton(
              onPressed: isNotFood ? onNotFoodAction : onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.onPrimary,
                elevation: 0,
                shape: const StadiumBorder(),
              ),
              child: Text(
                !isNotFood
                    ? l10n.tryAgain
                    : forPhoto
                    ? l10n.tryAnotherPhoto
                    : l10n.editDescription,
              ),
            ),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: onEnterManually,
            child: Text(
              forPhoto ? l10n.enterItManually : l10n.enterNumbersMyself,
            ),
          ),
        ],
      ),
    );
  }
}
