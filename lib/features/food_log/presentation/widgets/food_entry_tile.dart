import 'dart:io';

import 'package:flutter/material.dart';

import '../../data/models/food_entry.dart';
import '../meal_type_labels.dart';
import '../../../../l10n/l10n.dart';

class FoodEntryTile extends StatelessWidget {
  const FoodEntryTile({super.key, required this.entry, this.onDelete});

  final FoodEntry entry;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final imagePath = entry.imagePath;
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: imagePath != null ? FileImage(File(imagePath)) : null,
        child: imagePath == null ? const Icon(Icons.restaurant) : null,
      ),
      title: Text(entry.name),
      subtitle: Text(
        '${entry.mealType.label}'
        '${entry.portion?.isNotEmpty ?? false ? ' · ${entry.portion}' : ''}'
        ' · ${l10n.macroShort(entry.protein.toStringAsFixed(0), entry.carbs.toStringAsFixed(0), entry.fat.toStringAsFixed(0))}'
        '${entry.aiEstimated
            ? ' ${l10n.aiEstimateTag}'
            : entry.macrosEstimated
            ? ' ${l10n.estimatedTag}'
            : ''}',
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(l10n.kcalValue('${entry.calories}')),
          if (onDelete != null)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: onDelete,
            ),
        ],
      ),
    );
  }
}
