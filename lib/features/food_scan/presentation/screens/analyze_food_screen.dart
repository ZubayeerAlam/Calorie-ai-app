import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../food_log/presentation/meal_type_labels.dart';
import '../../../food_log/providers/food_log_provider.dart';
import '../../providers/food_analysis_controller.dart';
import '../widgets/analysis_error_view.dart';
import '../widgets/analysis_loading_view.dart';
import '../widgets/analysis_review_view.dart';

/// How the analysis screen was closed (null: Back was pressed).
enum AnalysisOutcome {
  /// The food was saved to the log.
  saved,

  /// The user chose to type the numbers in themselves.
  enterNumbers,
}

/// Photo or typed description → AI analysis → review → save to the food
/// log. Opened by the Scan screen (photo, replacing it) or by the manual
/// entry screen (description, on top of it). It closes with an
/// [AnalysisOutcome] so the manual entry screen knows what to do next.
class AnalyzeFoodScreen extends StatelessWidget {
  const AnalyzeFoodScreen({super.key});

  Future<void> _save(
    BuildContext context,
    FoodAnalysisController controller,
  ) async {
    final log = context.read<FoodLogProvider>();
    final messenger = ScaffoldMessenger.of(context);
    final entries = controller.toEntries(log.selectedDate);
    await log.addEntries(entries);
    if (!context.mounted) return;
    context.pop(AnalysisOutcome.saved);
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          'Added ${entries.length} '
          '${entries.length == 1 ? 'item' : 'items'} to '
          '${controller.meal.label}',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<FoodAnalysisController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Your meal')),
      body: switch (controller.status) {
        AnalysisStatus.analyzing => AnalysisLoadingView(
          imagePath: controller.imagePath,
          description: controller.description,
        ),
        AnalysisStatus.failed => AnalysisErrorView(
          failure: controller.failure!,
          forPhoto: controller.imagePath != null,
          onRetry: controller.analyze,
          // Photo: take another one. Text: back to the form to edit it.
          onNotFoodAction: controller.imagePath != null
              ? () => context.pushReplacement(AppRoutes.scanLocation())
              : () => context.pop(),
          // Photo: Add Food with the photo. Text: the manual entry screen
          // underneath swaps itself for Add Food.
          onEnterManually: controller.imagePath != null
              ? () => context.pushReplacement(
                  AppRoutes.addFoodLocation(imagePath: controller.imagePath),
                )
              : () => context.pop(AnalysisOutcome.enterNumbers),
        ),
        AnalysisStatus.ready => AnalysisReviewView(
          controller: controller,
          onSave: () => _save(context, controller),
        ),
      },
    );
  }
}
