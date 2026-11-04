import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import 'dashboard_card.dart';

/// The card listing the meal rows, with thin dividers between them.
class MealsCard extends StatelessWidget {
  const MealsCard({super.key, required this.tiles});

  final List<Widget> tiles;

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Column(
        children: [
          for (var i = 0; i < tiles.length; i++) ...[
            if (i > 0) Divider(height: 1, color: AppColors.line),
            tiles[i],
          ],
        ],
      ),
    );
  }
}
