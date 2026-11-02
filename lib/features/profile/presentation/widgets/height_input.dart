import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_colors.dart';

/// Height in cm, or in feet and inches. Reports the height in cm, or null
/// while it isn't a sensible height (100–250 cm).
class HeightInput extends StatefulWidget {
  const HeightInput({
    super.key,
    required this.initialCm,
    required this.metric,
    required this.onChanged,
  });

  static const int minCm = 100;
  static const int maxCm = 250;
  static const double _cmPerInch = 2.54;

  final int initialCm;
  final bool metric;
  final ValueChanged<int?> onChanged;

  @override
  State<HeightInput> createState() => _HeightInputState();
}

class _HeightInputState extends State<HeightInput> {
  final _cm = TextEditingController();
  final _ft = TextEditingController();
  final _in = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fill(widget.initialCm);
  }

  // Switching units keeps the same height, shown the other way.
  @override
  void didUpdateWidget(HeightInput old) {
    super.didUpdateWidget(old);
    if (old.metric != widget.metric) {
      final cm = _currentCm();
      if (cm != null) _fill(cm);
    }
  }

  void _fill(int cm) {
    final inches = (cm / HeightInput._cmPerInch).round();
    _cm.text = '$cm';
    _ft.text = '${inches ~/ 12}';
    _in.text = '${inches % 12}';
  }

  int? _currentCm() {
    int? cm;
    if (widget.metric) {
      cm = int.tryParse(_cm.text);
    } else {
      final ft = int.tryParse(_ft.text);
      final inch = int.tryParse(_in.text.isEmpty ? '0' : _in.text);
      if (ft != null && inch != null && inch < 12) {
        cm = ((ft * 12 + inch) * HeightInput._cmPerInch).round();
      }
    }
    if (cm == null || cm < HeightInput.minCm || cm > HeightInput.maxCm) {
      return null;
    }
    return cm;
  }

  void _changed(String _) {
    setState(() {});
    widget.onChanged(_currentCm());
  }

  @override
  void dispose() {
    _cm.dispose();
    _ft.dispose();
    _in.dispose();
    super.dispose();
  }

  Widget _field(TextEditingController controller, String suffix, {Key? key}) =>
      Expanded(
        child: TextField(
          key: key,
          controller: controller,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          onChanged: _changed,
          decoration: InputDecoration(
            suffixText: suffix,
            filled: true,
            fillColor: AppColors.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final valid = _currentCm() != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: widget.metric
              ? [_field(_cm, 'cm', key: const ValueKey('height-cm-input'))]
              : [
                  _field(_ft, 'ft', key: const ValueKey('height-ft-input')),
                  const SizedBox(width: 10),
                  _field(_in, 'in', key: const ValueKey('height-in-input')),
                ],
        ),
        if (!valid) ...[
          const SizedBox(height: 6),
          const Text(
            'Enter a height between 100 and 250 cm (3′4″–8′2″)',
            style: TextStyle(fontSize: 13, color: AppColors.badge),
          ),
        ],
      ],
    );
  }
}
