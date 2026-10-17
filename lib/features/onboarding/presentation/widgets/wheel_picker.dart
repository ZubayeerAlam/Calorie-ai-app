import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Scroll-wheel picker over a list of integer [values], styled like the
/// mockup: the selected number is large and green between two thin lines,
/// and the numbers above and below get smaller, lighter and closer together.
///
/// Give it a new [Key] when [values] change (e.g. on a unit switch) so the
/// scroll position is rebuilt from [selected].
class WheelPicker extends StatefulWidget {
  const WheelPicker({
    super.key,
    required this.values,
    required this.selected,
    required this.onChanged,
    this.suffix = '',
    this.format,
    this.looping = false,
  });

  static const double height = 520;

  final List<int> values;
  final int selected;
  final ValueChanged<int> onChanged;

  /// Small label shown to the right of the selected number (e.g. `cm`, `PM`).
  final String suffix;
  final String Function(int value)? format;
  final bool looping;

  @override
  State<WheelPicker> createState() => _WheelPickerState();
}

class _WheelPickerState extends State<WheelPicker>
    with SingleTickerProviderStateMixin {
  // Distance from the center line, font size and color for a number that is
  // 0, 1, 2, 3 and 4 steps away from the selected one (measured from mockup).
  static const List<double> _offsets = [0, 93, 159, 215, 262];
  static const List<double> _fontSizes = [45, 37, 29, 22, 17];
  static const List<Color> _colors = [
    AppColors.primary,
    Color(0xFF555555),
    Color(0xFF666666),
    Color(0xFF8A8A8A),
    Color(0xFFBBBBBB),
  ];
  static const double _dragStep = 80;
  static const double _lineGap = 99;
  static const TextStyle _suffixStyle = TextStyle(
    fontSize: 16,
    color: AppColors.textDark,
  );

  late final AnimationController _position;

  @override
  void initState() {
    super.initState();
    final index = widget.values.indexOf(widget.selected);
    _position = AnimationController.unbounded(
      vsync: this,
      value: (index < 0 ? 0 : index).toDouble(),
    );
  }

  @override
  void dispose() {
    _position.dispose();
    super.dispose();
  }

  int get _count => widget.values.length;

  String _label(int index) {
    final value = widget.values[index % _count];
    return widget.format?.call(value) ?? '$value';
  }

  void _onDragUpdate(DragUpdateDetails details) {
    var next = _position.value - details.delta.dy / _dragStep;
    if (!widget.looping) next = next.clamp(0, _count - 1).toDouble();
    _position.value = next;
  }

  Future<void> _onDragEnd(DragEndDetails details) async {
    final velocity = details.velocity.pixelsPerSecond.dy / _dragStep;
    var target = (_position.value - velocity * 0.15).roundToDouble();
    if (!widget.looping) target = target.clamp(0, _count - 1).toDouble();
    await _position.animateTo(
      target,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
    );
    widget.onChanged(widget.values[target.toInt() % _count]);
  }

  /// Linear interpolation over one of the lookup tables above.
  double _lerpTable(List<double> table, double distance) {
    final i = distance.floor().clamp(0, table.length - 2);
    return table[i] + (table[i + 1] - table[i]) * (distance - i);
  }

  Color _colorAt(double distance) {
    final i = distance.floor().clamp(0, _colors.length - 2);
    return Color.lerp(_colors[i], _colors[i + 1], distance - i)!;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onVerticalDragUpdate: _onDragUpdate,
      onVerticalDragEnd: _onDragEnd,
      child: LayoutBuilder(
        builder: (context, constraints) => AnimatedBuilder(
          animation: _position,
          builder: (context, _) =>
              _buildWheel(constraints.maxWidth, constraints.maxHeight),
        ),
      ),
    );
  }

  Widget _buildWheel(double width, double height) {
    final centerY = height / 2;
    final position = _position.value;
    final first = position.floor() - 4;

    final numbers = <Widget>[];
    for (int k = first; k <= first + 9; k++) {
      if (!widget.looping && (k < 0 || k >= _count)) continue;
      final signed = k - position;
      final distance = signed.abs();
      if (distance > 3.6) continue;

      final fontSize = _lerpTable(_fontSizes, distance);
      final boxHeight = fontSize * 1.2;
      final y = centerY + _lerpTable(_offsets, distance) * signed.sign;
      final opacity = distance <= 3 ? 1.0 : 1 - (distance - 3) / 0.6;

      numbers.add(
        Positioned(
          left: 0,
          right: 0,
          top: y - boxHeight / 2,
          height: boxHeight,
          child: Opacity(
            opacity: opacity,
            child: Text(
              _label(k),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: fontSize,
                height: 1.2,
                fontWeight: FontWeight.w500,
                color: _colorAt(distance),
              ),
            ),
          ),
        ),
      );
    }

    // Place the suffix just right of the selected number.
    Widget? suffix;
    if (widget.suffix.isNotEmpty) {
      final numberWidth = (TextPainter(
        text: TextSpan(
          text: _label(position.round()),
          style: TextStyle(
            fontFamily: 'Outfit',
            fontSize: _fontSizes.first,
            fontWeight: FontWeight.w500,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout()).width;
      suffix = Positioned(
        left: width / 2 + numberWidth / 2 + 6,
        top: centerY - 4,
        child: IgnorePointer(child: Text(widget.suffix, style: _suffixStyle)),
      );
    }

    return Stack(
      clipBehavior: Clip.hardEdge,
      children: [
        ...numbers,
        for (final dy in [-_lineGap / 2, _lineGap / 2])
          Positioned(
            left: 0,
            right: 0,
            top: centerY + dy - 0.75,
            child: Container(height: 1.5, color: AppColors.primaryLight),
          ),
        ?suffix,
      ],
    );
  }
}
