import 'package:flutter/material.dart';

class CalorieSummaryCard extends StatelessWidget {
  const CalorieSummaryCard({
    super.key,
    required this.consumed,
    required this.goal,
  });

  final int consumed;
  final int goal;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final remaining = goal - consumed;
    final progress = goal == 0 ? 0.0 : (consumed / goal).clamp(0.0, 1.0);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Today', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(
              remaining >= 0
                  ? '$remaining kcal left'
                  : '${-remaining} kcal over',
              style: theme.textTheme.headlineMedium,
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(value: progress, minHeight: 8),
            const SizedBox(height: 8),
            Text('$consumed / $goal kcal'),
          ],
        ),
      ),
    );
  }
}
