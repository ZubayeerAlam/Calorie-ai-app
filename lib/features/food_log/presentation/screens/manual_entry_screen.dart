import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../food_scan/data/models/food_description.dart';
import '../../../food_scan/presentation/screens/analyze_food_screen.dart';
import '../widgets/detail_field.dart';

/// "Add manually": describe the meal in words (plus optional details) and
/// let the AI work out the nutrition. "Enter numbers myself" opens the
/// classic Add Food form instead.
class ManualEntryScreen extends StatefulWidget {
  const ManualEntryScreen({super.key});

  @override
  State<ManualEntryScreen> createState() => _ManualEntryScreenState();
}

class _ManualEntryScreenState extends State<ManualEntryScreen> {
  final _text = TextEditingController();
  final _portion = TextEditingController();
  final _cooking = TextEditingController();
  final _brand = TextEditingController();
  final _ingredients = TextEditingController();

  bool get _canAnalyze => _text.text.trim().length > 1;

  @override
  void dispose() {
    for (final c in [_text, _portion, _cooking, _brand, _ingredients]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _analyze() async {
    FocusScope.of(context).unfocus();
    final description = FoodDescription(
      text: _text.text.trim(),
      portion: _portion.text,
      cookingMethod: _cooking.text,
      brand: _brand.text,
      ingredients: _ingredients.text,
    );
    final outcome = await context.push<AnalysisOutcome>(
      AppRoutes.analyzeFood,
      extra: description,
    );
    if (!mounted) return;
    switch (outcome) {
      // Saved: this form is done too.
      case AnalysisOutcome.saved:
        context.pop();
      case AnalysisOutcome.enterNumbers:
        _enterNumbers();
      // Back pressed: keep the text so it can be edited.
      case null:
        break;
    }
  }

  /// The classic Add Food form, replacing this screen so Back returns to
  /// the tab.
  void _enterNumbers() => context.pushReplacement(AppRoutes.addFoodLocation());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add manually')),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              children: [
                const Text(
                  'What did you eat?',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Describe your meal and the AI will estimate calories and '
                  'macros. List several foods with commas.',
                  style: TextStyle(fontSize: 14, color: AppColors.textGrey),
                ),
                const SizedBox(height: 16),
                DetailField(
                  key: const ValueKey('manual-description'),
                  controller: _text,
                  label: 'Your meal',
                  hint:
                      'e.g. 2 scrambled eggs, toast with butter, black coffee',
                  maxLines: 5,
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 24),
                const Text(
                  'More details (optional)',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'These help the estimate be more accurate.',
                  style: TextStyle(fontSize: 13, color: AppColors.textGrey),
                ),
                const SizedBox(height: 12),
                DetailField(
                  controller: _portion,
                  label: 'Portion size',
                  hint: 'e.g. 1 large plate, 250 g',
                ),
                const SizedBox(height: 10),
                DetailField(
                  controller: _cooking,
                  label: 'Cooking method',
                  hint: 'e.g. fried in oil, grilled, boiled',
                ),
                const SizedBox(height: 10),
                DetailField(
                  controller: _brand,
                  label: 'Brand or restaurant',
                  hint: 'e.g. Starbucks, Nestlé',
                ),
                const SizedBox(height: 10),
                DetailField(
                  controller: _ingredients,
                  label: 'Ingredients',
                  hint: 'e.g. olive oil, cheese, sugar',
                  textInputAction: TextInputAction.done,
                ),
                const SizedBox(height: 20),
                Center(
                  child: TextButton.icon(
                    onPressed: _enterNumbers,
                    icon: const Icon(Icons.dialpad_rounded),
                    label: const Text('Enter numbers myself'),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.divider),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton.icon(
                  key: const ValueKey('analyze-description'),
                  onPressed: _canAnalyze ? _analyze : null,
                  icon: const Icon(Icons.auto_awesome_rounded),
                  label: const Text(
                    'Analyze with AI',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.textDark,
                    disabledBackgroundColor: AppColors.primary.withValues(
                      alpha: 0.4,
                    ),
                    elevation: 0,
                    shape: const StadiumBorder(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
