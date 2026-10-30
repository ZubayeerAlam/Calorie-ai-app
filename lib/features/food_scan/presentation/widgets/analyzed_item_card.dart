import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../data/models/food_analysis.dart';
import 'labeled_number_field.dart';

/// One food the AI found, with every value editable and a remove button.
class AnalyzedItemCard extends StatefulWidget {
  const AnalyzedItemCard({
    super.key,
    required this.item,
    required this.onChanged,
    required this.onRemove,
  });

  final AnalyzedFoodItem item;
  final ValueChanged<AnalyzedFoodItem> onChanged;
  final VoidCallback onRemove;

  @override
  State<AnalyzedItemCard> createState() => _AnalyzedItemCardState();
}

class _AnalyzedItemCardState extends State<AnalyzedItemCard> {
  late final _name = TextEditingController(text: widget.item.name);
  late final _portion = TextEditingController(text: widget.item.portion);
  late final _calories = TextEditingController(text: '${widget.item.calories}');
  late final _protein = TextEditingController(
    text: _grams(widget.item.protein),
  );
  late final _carbs = TextEditingController(text: _grams(widget.item.carbs));
  late final _fat = TextEditingController(text: _grams(widget.item.fat));

  /// "46.5" or "0" (no trailing ".0").
  static String _grams(double value) => value == value.roundToDouble()
      ? value.toInt().toString()
      : value.toString();

  static double _parse(String text) => double.tryParse(text) ?? 0;

  @override
  void dispose() {
    for (final c in [_name, _portion, _calories, _protein, _carbs, _fat]) {
      c.dispose();
    }
    super.dispose();
  }

  void _emit() => widget.onChanged(
    AnalyzedFoodItem(
      name: _name.text,
      portion: _portion.text.trim(),
      calories: _parse(_calories.text).round(),
      protein: _parse(_protein.text),
      carbs: _parse(_carbs.text),
      fat: _parse(_fat.text),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 8, 6, 14),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _name,
                  onChanged: (_) => _emit(),
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Food name',
                    border: InputBorder.none,
                    errorText: _name.text.trim().isEmpty ? 'Add a name' : null,
                  ),
                ),
              ),
              IconButton(
                tooltip: 'Remove ${widget.item.name}',
                onPressed: widget.onRemove,
                icon: const Icon(
                  Icons.delete_outline,
                  color: AppColors.textGrey,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: TextField(
                        controller: _portion,
                        onChanged: (_) => _emit(),
                        style: const TextStyle(fontSize: 15),
                        decoration: InputDecoration(
                          labelText: 'Portion',
                          isDense: true,
                          filled: true,
                          fillColor: AppColors.surface,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: AppColors.line),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: AppColors.line),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 2,
                      child: LabeledNumberField(
                        controller: _calories,
                        label: 'Calories',
                        unit: 'kcal',
                        decimals: false,
                        onChanged: (_) => _emit(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    for (final (label, controller) in [
                      ('Protein', _protein),
                      ('Carbs', _carbs),
                      ('Fat', _fat),
                    ]) ...[
                      if (label != 'Protein') const SizedBox(width: 8),
                      Expanded(
                        child: LabeledNumberField(
                          controller: controller,
                          label: label,
                          unit: 'g',
                          onChanged: (_) => _emit(),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
