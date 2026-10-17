import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/progress_ring.dart';

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
              icon: const Icon(Icons.close, color: AppColors.textDark),
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
              color: AppColors.textDark,
            ),
          ),
        ),
        Expanded(
          child: Center(
            child: AnimatedBuilder(
              animation: _progress,
              builder: (context, _) => ProgressRing(
                value: _progress.value,
                size: 220,
                trackColor: AppColors.track,
                child: Text(
                  '${(_progress.value * 100).round()}%',
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textDark,
                  ),
                ),
              ),
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
