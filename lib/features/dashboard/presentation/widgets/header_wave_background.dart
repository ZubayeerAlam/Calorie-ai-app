import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Green block behind the top of the dashboard, with soft wave lines.
class HeaderWaveBackground extends StatelessWidget {
  const HeaderWaveBackground({super.key, required this.height});

  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: CustomPaint(painter: _WavePainter()),
    );
  }
}

class _WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = AppColors.primary);

    final glow = Paint()
      ..color = Colors.white.withValues(alpha: 0.10)
      ..style = PaintingStyle.fill;
    canvas.drawPath(
      Path()
        ..moveTo(0, size.height * 0.35)
        ..quadraticBezierTo(
          size.width * 0.35,
          size.height * 0.05,
          size.width * 0.6,
          size.height * 0.45,
        )
        ..quadraticBezierTo(
          size.width * 0.8,
          size.height * 0.75,
          0,
          size.height,
        )
        ..close(),
      glow,
    );

    final line = Paint()
      ..color = Colors.white.withValues(alpha: 0.18)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    for (var i = 0; i < 8; i++) {
      final dy = i * 9.0;
      canvas.drawPath(
        Path()
          ..moveTo(-20, size.height * 0.15 + dy)
          ..cubicTo(
            size.width * 0.3,
            size.height * 0.55 + dy,
            size.width * 0.55,
            -size.height * 0.1 + dy,
            size.width + 20,
            size.height * 0.4 + dy,
          ),
        line,
      );
    }
  }

  @override
  bool shouldRepaint(_WavePainter oldDelegate) => false;
}
