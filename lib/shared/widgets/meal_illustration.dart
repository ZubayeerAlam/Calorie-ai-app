import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../features/food_log/data/models/food_entry.dart';

/// Flat illustration of a meal, drawn in code so it stays sharp at any
/// size: toast and egg (breakfast), a rice bowl (lunch), a salad plate
/// (dinner), and an apple with a cookie (snacks).
class MealIllustration extends StatelessWidget {
  const MealIllustration({super.key, required this.meal, this.size = 52});

  final MealType meal;
  final double size;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    // Decorative: the meal name is always shown next to it.
    return ExcludeSemantics(
      child: SizedBox.square(
        dimension: size,
        child: CustomPaint(painter: _MealPainter(meal, dark: dark)),
      ),
    );
  }
}

class _MealPainter extends CustomPainter {
  _MealPainter(this.meal, {required this.dark});

  final MealType meal;
  final bool dark;

  // Food colours (the same in light and dark mode).
  static const _plate = Color(0xFFFFFFFF);
  static const _plateEdge = Color(0xFFE3E3E3);
  static const _toast = Color(0xFFEDB565);
  static const _crust = Color(0xFFC4843A);
  static const _yolk = Color(0xFFFFC233);
  static const _bowl = Color(0xFF4F9DA6);
  static const _bowlRim = Color(0xFF3D7F87);
  static const _rice = Color(0xFFFFFDF7);
  static const _chopstick = Color(0xFF9C6B3D);
  static const _leaf = Color(0xFF7BC043);
  static const _leafDark = Color(0xFF4E9F3D);
  static const _tomato = Color(0xFFE5533D);
  static const _carrot = Color(0xFFF39C34);
  static const _apple = Color(0xFFE5483B);
  static const _stem = Color(0xFF7A4E2D);
  static const _cookie = Color(0xFFD9A35F);
  static const _chip = Color(0xFF5B3A23);

  Color get _background => switch (meal) {
    MealType.breakfast =>
      dark ? const Color(0xFF4A3C22) : const Color(0xFFFFF1D6),
    MealType.lunch => dark ? const Color(0xFF2F4421) : const Color(0xFFE9F5D8),
    MealType.dinner => dark ? const Color(0xFF4A2B27) : const Color(0xFFFDE2DE),
    MealType.snack => dark ? const Color(0xFF263552) : const Color(0xFFE6EEFB),
  };

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width;
    Offset p(double x, double y) => Offset(x * s, y * s);
    Paint fill(Color c) => Paint()..color = c;

    canvas.drawCircle(p(0.5, 0.5), s / 2, fill(_background));

    switch (meal) {
      case MealType.breakfast:
        _plateAt(canvas, p, s);
        // Toast: a rounded slice with a darker crust.
        final toast = RRect.fromRectAndCorners(
          Rect.fromLTRB(0.2 * s, 0.3 * s, 0.5 * s, 0.64 * s),
          topLeft: Radius.circular(0.12 * s),
          topRight: Radius.circular(0.12 * s),
          bottomLeft: Radius.circular(0.04 * s),
          bottomRight: Radius.circular(0.04 * s),
        );
        canvas.drawRRect(toast, fill(_crust));
        canvas.drawRRect(toast.deflate(0.03 * s), fill(_toast));
        // Fried egg: a soft white blob and a yolk.
        final white = Path()
          ..addOval(Rect.fromCircle(center: p(0.64, 0.52), radius: 0.17 * s))
          ..addOval(Rect.fromCircle(center: p(0.74, 0.44), radius: 0.1 * s));
        canvas.drawPath(white, fill(_plate));
        canvas.drawCircle(
          p(0.64, 0.52),
          0.17 * s,
          Paint()
            ..color = _plateEdge
            ..style = PaintingStyle.stroke
            ..strokeWidth = 0.012 * s,
        );
        canvas.drawCircle(p(0.66, 0.5), 0.075 * s, fill(_yolk));
        canvas.drawCircle(p(0.64, 0.475), 0.022 * s, fill(_plate));

      case MealType.lunch:
        // Chopsticks behind the bowl.
        final stick = Paint()
          ..color = _chopstick
          ..strokeWidth = 0.035 * s
          ..strokeCap = StrokeCap.round;
        canvas.drawLine(p(0.58, 0.16), p(0.86, 0.5), stick);
        canvas.drawLine(p(0.66, 0.13), p(0.9, 0.44), stick);
        // Rice mound with a few grains.
        canvas.drawOval(
          Rect.fromLTRB(0.22 * s, 0.3 * s, 0.78 * s, 0.62 * s),
          fill(_rice),
        );
        final grain = fill(_plateEdge);
        for (final (x, y) in [
          (0.38, 0.4),
          (0.5, 0.36),
          (0.6, 0.43),
          (0.45, 0.48),
        ]) {
          canvas.save();
          canvas.translate(x * s, y * s);
          canvas.rotate(0.6);
          canvas.drawOval(
            Rect.fromCenter(
              center: Offset.zero,
              width: 0.05 * s,
              height: 0.022 * s,
            ),
            grain,
          );
          canvas.restore();
        }
        canvas.drawCircle(p(0.56, 0.37), 0.04 * s, fill(_leaf));
        // Bowl: a half-ellipse with a rim.
        final bowl = Path()
          ..moveTo(0.16 * s, 0.5 * s)
          ..quadraticBezierTo(0.5 * s, 1.0 * s, 0.84 * s, 0.5 * s)
          ..close();
        canvas.drawPath(bowl, fill(_bowl));
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTRB(0.14 * s, 0.47 * s, 0.86 * s, 0.54 * s),
            Radius.circular(0.035 * s),
          ),
          fill(_bowlRim),
        );
        canvas.drawRect(
          Rect.fromLTRB(0.38 * s, 0.73 * s, 0.62 * s, 0.79 * s),
          fill(_bowlRim),
        );

      case MealType.dinner:
        _plateAt(canvas, p, s);
        // Salad: overlapping leaves, tomato slices and carrot sticks.
        for (final (x, y, angle, color) in [
          (0.36, 0.52, -0.5, _leafDark),
          (0.62, 0.5, 0.6, _leafDark),
          (0.48, 0.42, 0.1, _leaf),
          (0.4, 0.6, 0.9, _leaf),
          (0.6, 0.62, -0.8, _leaf),
        ]) {
          canvas.save();
          canvas.translate(x * s, y * s);
          canvas.rotate(angle);
          canvas.drawOval(
            Rect.fromCenter(
              center: Offset.zero,
              width: 0.26 * s,
              height: 0.14 * s,
            ),
            fill(color),
          );
          canvas.restore();
        }
        for (final (x, y) in [(0.44, 0.5), (0.62, 0.42)]) {
          canvas.drawCircle(p(x, y), 0.065 * s, fill(_tomato));
          canvas.drawCircle(
            p(x, y),
            0.03 * s,
            fill(_yolk.withValues(alpha: 0.5)),
          );
        }
        final carrot = Paint()
          ..color = _carrot
          ..strokeWidth = 0.035 * s
          ..strokeCap = StrokeCap.round;
        canvas.drawLine(p(0.5, 0.6), p(0.62, 0.55), carrot);
        canvas.drawLine(p(0.32, 0.44), p(0.4, 0.38), carrot);

      case MealType.snack:
        // Cookie with chocolate chips.
        canvas.drawCircle(p(0.66, 0.62), 0.17 * s, fill(_cookie));
        for (final (x, y) in [
          (0.6, 0.56),
          (0.71, 0.6),
          (0.64, 0.7),
          (0.74, 0.69),
        ]) {
          canvas.drawCircle(p(x, y), 0.025 * s, fill(_chip));
        }
        // Apple with a stem and a leaf.
        final apple = Path()
          ..addOval(Rect.fromCircle(center: p(0.34, 0.5), radius: 0.17 * s))
          ..addOval(Rect.fromCircle(center: p(0.46, 0.5), radius: 0.15 * s));
        canvas.drawPath(apple, fill(_apple));
        canvas.drawCircle(
          p(0.33, 0.44),
          0.04 * s,
          fill(_plate.withValues(alpha: 0.45)),
        );
        canvas.drawLine(
          p(0.41, 0.36),
          p(0.43, 0.26),
          Paint()
            ..color = _stem
            ..strokeWidth = 0.03 * s
            ..strokeCap = StrokeCap.round,
        );
        canvas.save();
        canvas.translate(0.5 * s, 0.29 * s);
        canvas.rotate(-math.pi / 6);
        canvas.drawOval(
          Rect.fromCenter(
            center: Offset.zero,
            width: 0.13 * s,
            height: 0.07 * s,
          ),
          fill(_leaf),
        );
        canvas.restore();
    }
  }

  /// A white plate seen from slightly above.
  void _plateAt(Canvas canvas, Offset Function(double, double) p, double s) {
    final rect = Rect.fromCenter(
      center: p(0.5, 0.56),
      width: 0.8 * s,
      height: 0.52 * s,
    );
    canvas.drawOval(rect, Paint()..color = _plateEdge);
    canvas.drawOval(rect.deflate(0.02 * s), Paint()..color = _plate);
    canvas.drawOval(
      rect.deflate(0.1 * s),
      Paint()
        ..color = _plateEdge
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.01 * s,
    );
  }

  @override
  bool shouldRepaint(_MealPainter old) => old.meal != meal || old.dark != dark;
}
