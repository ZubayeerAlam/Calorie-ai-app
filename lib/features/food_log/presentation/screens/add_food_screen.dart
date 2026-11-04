import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/calorie_calculator.dart';
import '../../../../shared/widgets/meal_photo.dart';
import '../../data/models/food_entry.dart';
import '../../providers/food_log_provider.dart';
import '../meal_type_labels.dart';
import '../../../../l10n/l10n.dart';

class AddFoodScreen extends StatefulWidget {
  const AddFoodScreen({super.key, this.imagePath, this.initialMeal});

  final String? imagePath;

  /// Preselected meal, e.g. when opened from a meal's + on Home.
  final MealType? initialMeal;

  @override
  State<AddFoodScreen> createState() => _AddFoodScreenState();
}

class _AddFoodScreenState extends State<AddFoodScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _calories = TextEditingController();
  final _protein = TextEditingController();
  final _carbs = TextEditingController();
  final _fat = TextEditingController();
  late MealType _mealType = widget.initialMeal ?? MealType.breakfast;
  late String? _imagePath = widget.imagePath;

  @override
  void dispose() {
    for (final c in [_name, _calories, _protein, _carbs, _fat]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final log = context.read<FoodLogProvider>();
    // Log on the day being viewed on Home, at the current time of day.
    final now = DateTime.now();
    final day = log.selectedDate;
    final calories = int.parse(_calories.text);
    // All three macros blank → estimate them from calories (50/30/20) so
    // the Home macro rings still move. Typed values are always kept as-is.
    final estimate = [_protein, _carbs, _fat].every((c) => c.text.isEmpty);
    final estimated = CalorieCalculator.estimateMacroGrams(calories);
    final entry = FoodEntry(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      name: _name.text.trim(),
      calories: calories,
      protein: estimate
          ? estimated.protein
          : double.tryParse(_protein.text) ?? 0,
      carbs: estimate ? estimated.carbs : double.tryParse(_carbs.text) ?? 0,
      fat: estimate ? estimated.fat : double.tryParse(_fat.text) ?? 0,
      macrosEstimated: estimate,
      mealType: _mealType,
      loggedAt: DateTime(
        day.year,
        day.month,
        day.day,
        now.hour,
        now.minute,
        now.second,
      ),
      imagePath: _imagePath,
    );
    await log.addEntry(entry);
    if (mounted) context.pop();
  }

  Widget _numberField(
    TextEditingController c,
    String label, {
    bool required = false,
  }) {
    return TextFormField(
      controller: c,
      decoration: InputDecoration(labelText: label),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      validator: (v) {
        if (!required && (v == null || v.isEmpty)) return null;
        if (v == null || v.isEmpty) return l10n.required;
        return num.tryParse(v) == null ? l10n.enterNumber : null;
      },
    );
  }

  Future<void> _scanPhoto() async {
    final path = await context.push<String>(
      AppRoutes.scanLocation(returnPhoto: true),
    );
    if (path != null && mounted) setState(() => _imagePath = path);
  }

  @override
  Widget build(BuildContext context) {
    final imagePath = _imagePath;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.addFoodTitle)),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            OutlinedButton.icon(
              onPressed: _scanPhoto,
              icon: const Icon(Icons.camera_alt_outlined),
              label: Text(
                imagePath == null ? l10n.scanPhoto : l10n.changePhoto,
              ),
            ),
            const SizedBox(height: 12),
            if (imagePath != null) MealPhoto(path: imagePath),
            TextFormField(
              controller: _name,
              decoration: InputDecoration(labelText: l10n.foodName),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? l10n.required : null,
            ),
            TextFormField(
              controller: _calories,
              decoration: InputDecoration(labelText: l10n.caloriesKcal),
              keyboardType: TextInputType.number,
              validator: (v) => int.tryParse(v ?? '') == null
                  ? l10n.enterWholeCalories
                  : null,
            ),
            Padding(
              padding: EdgeInsets.only(top: 12),
              child: Text(
                l10n.macrosBlankHint,
                style: TextStyle(fontSize: 12, color: AppColors.textGrey),
              ),
            ),
            _numberField(_protein, l10n.proteinG),
            _numberField(_carbs, l10n.carbsG),
            _numberField(_fat, l10n.fatG),
            const SizedBox(height: 12),
            DropdownButtonFormField<MealType>(
              initialValue: _mealType,
              decoration: InputDecoration(labelText: l10n.meal),
              items: MealType.values
                  .map((m) => DropdownMenuItem(value: m, child: Text(m.label)))
                  .toList(),
              onChanged: (m) => setState(() => _mealType = m ?? _mealType),
            ),
            const SizedBox(height: 24),
            FilledButton(onPressed: _save, child: Text(l10n.save)),
          ],
        ),
      ),
    );
  }
}
