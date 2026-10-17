import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/routes/app_routes.dart';
import '../../data/models/food_entry.dart';
import '../../providers/food_log_provider.dart';
import '../meal_type_labels.dart';

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
    final entry = FoodEntry(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      name: _name.text.trim(),
      calories: int.parse(_calories.text),
      protein: double.tryParse(_protein.text) ?? 0,
      carbs: double.tryParse(_carbs.text) ?? 0,
      fat: double.tryParse(_fat.text) ?? 0,
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
        if (v == null || v.isEmpty) return 'Required';
        return num.tryParse(v) == null ? 'Enter a number' : null;
      },
    );
  }

  Future<void> _scanPhoto() async {
    final path = await context.push<String>(AppRoutes.scan);
    if (path != null && mounted) setState(() => _imagePath = path);
  }

  @override
  Widget build(BuildContext context) {
    final imagePath = _imagePath;
    return Scaffold(
      appBar: AppBar(title: const Text('Add Food')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            OutlinedButton.icon(
              onPressed: _scanPhoto,
              icon: const Icon(Icons.camera_alt_outlined),
              label: Text(imagePath == null ? 'Scan a photo' : 'Change photo'),
            ),
            const SizedBox(height: 12),
            if (imagePath != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  File(imagePath),
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
            TextFormField(
              controller: _name,
              decoration: const InputDecoration(labelText: 'Food name'),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Required' : null,
            ),
            TextFormField(
              controller: _calories,
              decoration: const InputDecoration(labelText: 'Calories (kcal)'),
              keyboardType: TextInputType.number,
              validator: (v) =>
                  int.tryParse(v ?? '') == null ? 'Enter whole calories' : null,
            ),
            _numberField(_protein, 'Protein (g)'),
            _numberField(_carbs, 'Carbs (g)'),
            _numberField(_fat, 'Fat (g)'),
            const SizedBox(height: 12),
            DropdownButtonFormField<MealType>(
              initialValue: _mealType,
              decoration: const InputDecoration(labelText: 'Meal'),
              items: MealType.values
                  .map((m) => DropdownMenuItem(value: m, child: Text(m.label)))
                  .toList(),
              onChanged: (m) => setState(() => _mealType = m ?? _mealType),
            ),
            const SizedBox(height: 24),
            FilledButton(onPressed: _save, child: const Text('Save')),
          ],
        ),
      ),
    );
  }
}
