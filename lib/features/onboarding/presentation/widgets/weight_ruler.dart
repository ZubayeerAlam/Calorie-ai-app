import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Horizontal ruler: drag left/right to change the value.
/// One tick = 1 unit, a long labelled tick every 10 units.
class WeightRuler extends StatelessWidget {
  const WeightRuler({
    super.key,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  static const double _tickSpacing = 11.2;

  final double value;
  final double min;
  final double max;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onHorizontalDragUpdate: (details) =>
          onChanged((value - details.delta.dx / _tickSpacing).clamp(min, max)),
      // Snap to one decimal place when the finger lifts.
      onHorizontalDragEnd: (_) => onChanged((value * 10).roundToDouble() / 10),
      child: SizedBox(
        height: 130,
        width: double.infinity,
        child: ClipRect(
          child: CustomPaint(
            painter: _RulerPainter(
              value: value,
              min: min,
              max: max,
              spacing: _tickSpacing,
            ),
          ),
        ),
      ),
    );
  }
}

class _RulerPainter extends CustomPainter {
  _RulerPainter({
    required this.value,
    required this.min,
    required this.max,
    required this.spacing,
  });

  final double value;
  final double min;
  final double max;
  final double spacing;

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final tickPaint = Paint()
      ..color = AppColors.tick
      ..strokeWidth = 1.5;

    for (int i = min.ceil(); i <= max.floor(); i++) {
      final x = centerX + (i - value) * spacing;
      if (x < -20 || x > size.width + 20) continue;

      final isMajor = i % 10 == 0;
      canvas.drawLine(Offset(x, 0), Offset(x, isMajor ? 99 : 49), tickPaint);

      if (isMajor) {
        final label = TextPainter(
          text: TextSpan(
            text: '$i',
            style: const TextStyle(
              fontFamily: 'Outfit',
              fontSize: 18,
              color: AppColors.tickLabel,
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout();
        label.paint(canvas, Offset(x - label.width / 2, 103));
      }
    }

    final indicatorPaint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(centerX, 2.5),
      Offset(centerX, 76.5),
      indicatorPaint,
    );
  }

  @override
  bool shouldRepaint(_RulerPainter oldDelegate) =>
      oldDelegate.value != value ||
      oldDelegate.min != min ||
      oldDelegate.max != max;
}
