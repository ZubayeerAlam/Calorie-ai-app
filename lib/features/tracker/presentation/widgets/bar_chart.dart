import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Simple vertical bar chart: one bar per value, an optional dashed
/// [target] line, and a label under each bar ('' for none).
class BarChart extends StatelessWidget {
  const BarChart({
    super.key,
    required this.values,
    required this.labels,
    this.target,
    this.colorFor,
    this.height = 140,
  }) : assert(values.length == labels.length);

  final List<num> values;
  final List<String> labels;
  final num? target;

  /// Bar colour by index; defaults to the brand green.
  final Color Function(int index)? colorFor;
  final double height;

  @override
  Widget build(BuildContext context) {
    final top = math.max(
      values.fold<num>(0, (m, v) => math.max(m, v)),
      target ?? 0,
    );
    // Headroom so the tallest bar and the target line don't touch the top.
    final maxValue = top <= 0 ? 1.0 : top * 1.15;
    final gap = values.length > 10 ? 2.0 : 8.0;

    return Column(
      children: [
        SizedBox(
          height: height,
          child: Stack(
            children: [
              // Fill the chart's height so bars grow up from the bottom.
              Positioned.fill(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    for (var i = 0; i < values.length; i++)
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: gap / 2),
                          child: FractionallySizedBox(
                            heightFactor: (values[i] / maxValue).clamp(
                              0.0,
                              1.0,
                            ),
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              decoration: BoxDecoration(
                                color: colorFor?.call(i) ?? AppColors.primary,
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(4),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              if (target != null && target! > 0)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: height * (target! / maxValue) - 1,
                  child: const _DashedLine(),
                ),
            ],
          ),
        ),
        Divider(height: 1, color: AppColors.line),
        const SizedBox(height: 6),
        Row(
          children: [
            for (final label in labels)
              Expanded(
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.visible,
                  softWrap: false,
                  style: TextStyle(fontSize: 11, color: AppColors.textLight),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _DashedLine extends StatelessWidget {
  const _DashedLine();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const dash = 5.0;
        final count = (constraints.maxWidth / (dash * 2)).floor();
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            count,
            (_) => Container(width: dash, height: 2, color: AppColors.textGrey),
          ),
        );
      },
    );
  }
}
