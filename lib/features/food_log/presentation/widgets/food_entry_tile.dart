import 'dart:io';

import 'package:flutter/material.dart';

import '../../data/models/food_entry.dart';

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
        '${entry.mealType.name} · P ${entry.protein.toStringAsFixed(0)}g '
        'C ${entry.carbs.toStringAsFixed(0)}g F ${entry.fat.toStringAsFixed(0)}g',
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('${entry.calories} kcal'),
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
