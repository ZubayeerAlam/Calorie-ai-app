import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/l10n.dart';
import '../../data/catalog/exercise_demos.dart';
import '../../data/catalog/exercise_texts.dart';
import '../../data/models/exercise_demo.dart';
import 'exercise_figure_painter.dart';

/// The app palette's colours for demo drawings.
FigureColors figureColors() => FigureColors(
  body: AppColors.textDark,
  equipment: AppColors.textGrey,
  equipmentFill: AppColors.tick,
  floor: AppColors.tick,
  mat: AppColors.primaryLight,
);

/// An exercise's animated demonstration, with a pause / play button.
///
/// [onStep] reports which instruction step (0–2) the animation is showing.
/// With "reduce motion" on, the key poses are shown side by side instead.
class ExerciseDemoView extends StatefulWidget {
  const ExerciseDemoView({super.key, required this.exerciseId, this.onStep});

  final String exerciseId;
  final ValueChanged<int>? onStep;

  @override
  State<ExerciseDemoView> createState() => _ExerciseDemoViewState();
}

class _ExerciseDemoViewState extends State<ExerciseDemoView>
    with SingleTickerProviderStateMixin {
  late final ExerciseDemo? _demo = ExerciseDemos.of(widget.exerciseId);
  late final DemoLayout? _layout = _demo == null ? null : DemoLayout(_demo);
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: Duration(milliseconds: ((_demo?.seconds ?? 2.4) * 1000).round()),
  )..addListener(_onTick);

  bool _playing = true;
  int _step = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _sync();
  }

  bool get _reduceMotion => MediaQuery.disableAnimationsOf(context);

  void _sync() {
    if (_demo != null && _playing && !_reduceMotion) {
      if (!_controller.isAnimating) _controller.repeat();
    } else {
      _controller.stop();
    }
  }

  void _onTick() {
    final step = _demo!.stepAt(_controller.value);
    if (step != _step) {
      setState(() => _step = step);
      widget.onStep?.call(step);
    }
  }

  void _toggle() {
    setState(() => _playing = !_playing);
    _sync();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final demo = _demo;
    final layout = _layout;
    final colors = figureColors();
    final name = ExerciseTexts.nameOf(widget.exerciseId);
    if (demo == null || layout == null) {
      return const SizedBox.shrink();
    }
    final Widget drawing;
    if (_reduceMotion) {
      // Still poses, numbered like the steps.
      drawing = Row(
        children: [
          for (final (i, pose) in demo.poses.indexed)
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: CustomPaint(
                      size: Size.infinite,
                      painter: ExerciseFigurePainter(
                        layout: layout,
                        pose: pose,
                        colors: colors,
                      ),
                    ),
                  ),
                  Text(
                    '${i + 1}',
                    style: TextStyle(fontSize: 13, color: AppColors.textGrey),
                  ),
                ],
              ),
            ),
        ],
      );
    } else {
      drawing = AnimatedBuilder(
        animation: _controller,
        builder: (context, _) => CustomPaint(
          size: Size.infinite,
          painter: ExerciseFigurePainter(
            layout: layout,
            pose: demo.poseAt(_controller.value),
            colors: colors,
          ),
        ),
      );
    }
    return Container(
      height: 240,
      decoration: BoxDecoration(
        color: AppColors.primaryLight.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(8),
      child: Stack(
        children: [
          Positioned.fill(
            child: Semantics(
              image: true,
              label: l10n.demoLabel(name),
              child: ExcludeSemantics(child: drawing),
            ),
          ),
          if (!_reduceMotion)
            Positioned(
              right: 0,
              bottom: 0,
              child: IconButton(
                key: const ValueKey('demo-play-pause'),
                tooltip: _playing ? l10n.demoPause : l10n.demoPlay,
                onPressed: _toggle,
                icon: Icon(
                  _playing
                      ? Icons.pause_circle_filled_rounded
                      : Icons.play_circle_fill_rounded,
                  size: 32,
                  color: AppColors.accent,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
