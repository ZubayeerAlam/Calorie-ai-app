import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/models/food_entry.dart';
import '../../providers/food_log_provider.dart';

class AddFoodScreen extends StatefulWidget {
  const AddFoodScreen({super.key, this.imagePath});

  final String? imagePath;

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
  MealType _mealType = MealType.breakfast;

  @override
  void dispose() {
    for (final c in [_name, _calories, _protein, _carbs, _fat]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final entry = FoodEntry(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      name: _name.text.trim(),
      calories: int.parse(_calories.text),
      protein: double.tryParse(_protein.text) ?? 0,
      carbs: double.tryParse(_carbs.text) ?? 0,
      fat: double.tryParse(_fat.text) ?? 0,
      mealType: _mealType,
      loggedAt: DateTime.now(),
      imagePath: widget.imagePath,
    );
    await context.read<FoodLogProvider>().addEntry(entry);
    if (mounted) Navigator.of(context).pop();
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

  @override
  Widget build(BuildContext context) {
    final imagePath = widget.imagePath;
    return Scaffold(
      appBar: AppBar(title: const Text('Add Food')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
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
                  .map((m) => DropdownMenuItem(value: m, child: Text(m.name)))
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
