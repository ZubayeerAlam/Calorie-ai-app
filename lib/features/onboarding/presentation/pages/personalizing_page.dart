import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../onboarding_colors.dart';

/// Full-screen loader shown after the last setup step: a ring fills from
/// 0% to 100%, then [onCompleted] fires. [onClose] backs out of it.
class PersonalizingPage extends StatefulWidget {
  const PersonalizingPage({
    super.key,
    required this.onCompleted,
    required this.onClose,
    this.duration = const Duration(seconds: 4),
  });

  final VoidCallback onCompleted;
  final VoidCallback onClose;
  final Duration duration;

  @override
  State<PersonalizingPage> createState() => _PersonalizingPageState();
}

class _PersonalizingPageState extends State<PersonalizingPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.duration,
  );
  late final Animation<double> _progress = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeInOut,
  );
  Timer? _finishTimer;

  @override
  void initState() {
    super.initState();
    _controller
      ..addStatusListener((status) {
        if (status != AnimationStatus.completed) return;
        // Let "100%" show for a moment before moving on.
        _finishTimer = Timer(const Duration(milliseconds: 400), () {
          if (mounted) widget.onCompleted();
        });
      })
      ..forward();
  }

  @override
  void dispose() {
    _finishTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 4, 0, 0),
            child: IconButton(
              onPressed: widget.onClose,
              icon: const Icon(Icons.close, color: OnboardingColors.textDark),
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(32, 24, 32, 0),
          child: Text(
            'Personalizing your ${AppConstants.appName}\nexperience...',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              height: 1.4,
              color: OnboardingColors.textDark,
            ),
          ),
        ),
        Expanded(
          child: Center(
            child: AnimatedBuilder(
              animation: _progress,
              builder: (context, _) => _ProgressRing(value: _progress.value),
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(48, 0, 48, 48),
          child: Text(
            "Hang tight! We're crafting a personalized plan just for you.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              height: 1.5,
              color: Color(0xFFA0A0A0),
            ),
          ),
        ),
      ],
    );
  }
}

class _ProgressRing extends StatelessWidget {
  const _ProgressRing({required this.value});

  static const double _size = 220;

  final double value;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: _size,
      child: CustomPaint(
        painter: _RingPainter(value),
        child: Center(
          child: Text(
            '${(value * 100).round()}%',
            style: const TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.w500,
              color: OnboardingColors.textDark,
            ),
          ),
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter(this.value);

  static const double _stroke = 12;

  final double value;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(
      _stroke / 2,
      _stroke / 2,
      size.width - _stroke,
      size.height - _stroke,
    );
    final track = Paint()
      ..color = OnboardingColors.track
      ..style = PaintingStyle.stroke
      ..strokeWidth = _stroke;
    canvas.drawArc(rect, 0, math.pi * 2, false, track);

    if (value <= 0) return;
    final arc = Paint()
      ..color = OnboardingColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = _stroke
      ..strokeCap = StrokeCap.round;
    // Starts at 12 o'clock and fills clockwise.
    canvas.drawArc(rect, -math.pi / 2, math.pi * 2 * value, false, arc);
  }

  @override
  bool shouldRepaint(_RingPainter oldDelegate) => oldDelegate.value != value;
}
