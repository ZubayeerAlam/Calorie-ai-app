import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// A line through [points] (oldest first), placed by date so gaps between
/// weigh-ins show as longer segments. Needs at least two points.
class LineChart extends StatelessWidget {
  const LineChart({super.key, required this.points, this.height = 120})
    : assert(points.length >= 2);

  final List<({DateTime date, double value})> points;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: CustomPaint(painter: _LinePainter(points)),
    );
  }
}

class _LinePainter extends CustomPainter {
  _LinePainter(this.points);

  final List<({DateTime date, double value})> points;

  @override
  void paint(Canvas canvas, Size size) {
    const pad = 8.0;
    final values = points.map((p) => p.value);
    var low = values.reduce(math.min);
    var high = values.reduce(math.max);
    // A flat line sits in the middle instead of on an edge.
    if (high - low < 1) {
      low -= 1;
      high += 1;
    }
    final first = points.first.date.millisecondsSinceEpoch;
    final span = math.max(points.last.date.millisecondsSinceEpoch - first, 1);

    Offset at(({DateTime date, double value}) p) => Offset(
      pad +
          (size.width - pad * 2) *
              (p.date.millisecondsSinceEpoch - first) /
              span,
      pad + (size.height - pad * 2) * (1 - (p.value - low) / (high - low)),
    );

    final grid = Paint()
      ..color = AppColors.line
      ..strokeWidth = 1;
    for (final y in [pad, size.height / 2, size.height - pad]) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }

    final path = Path()..moveTo(at(points.first).dx, at(points.first).dy);
    for (final p in points.skip(1)) {
      path.lineTo(at(p).dx, at(p).dy);
    }
    canvas.drawPath(
      path,
      Paint()
        ..color = AppColors.primary
        ..strokeWidth = 3
        ..style = PaintingStyle.stroke
        ..strokeJoin = StrokeJoin.round,
    );
    final dot = Paint()..color = AppColors.primary;
    final hole = Paint()..color = AppColors.surface;
    for (final p in points) {
      canvas.drawCircle(at(p), 5, dot);
      canvas.drawCircle(at(p), 2.5, hole);
    }
  }

  @override
  bool shouldRepaint(_LinePainter old) => old.points != points;
}
