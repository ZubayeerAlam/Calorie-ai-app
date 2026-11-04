import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/number_format.dart';
import 'weight_units.dart';
import '../../../../l10n/l10n.dart';

/// Bottom sheet for today's weigh-in. Resolves to the weight in kg, or
/// null if dismissed.
class LogWeightSheet extends StatefulWidget {
  const LogWeightSheet({
    super.key,
    required this.units,
    required this.initialKg,
  });

  final WeightUnits units;
  final double initialKg;

  static Future<double?> show(
    BuildContext context, {
    required WeightUnits units,
    required double initialKg,
  }) {
    return showModalBottomSheet<double>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => LogWeightSheet(units: units, initialKg: initialKg),
    );
  }

  @override
  State<LogWeightSheet> createState() => _LogWeightSheetState();
}

class _LogWeightSheetState extends State<LogWeightSheet> {
  // Sensible human range, in kg.
  static const double _minKg = 20;
  static const double _maxKg = 400;

  late final TextEditingController _controller = TextEditingController(
    text: AppNumbers.oneDecimal(widget.units.fromKg(widget.initialKg)),
  );

  double? get _kg {
    final value = double.tryParse(_controller.text.replaceAll(',', '.'));
    if (value == null) return null;
    final kg = widget.units.toKg(value);
    return kg >= _minKg && kg <= _maxKg ? kg : null;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _save() {
    final kg = _kg;
    if (kg != null) context.pop(kg);
  }

  @override
  Widget build(BuildContext context) {
    final valid = _kg != null;
    return Padding(
      padding: EdgeInsets.fromLTRB(
        24,
        24,
        24,
        24 + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.logWeight,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.logWeightSubtitle,
            style: TextStyle(fontSize: 14, color: AppColors.textGrey),
          ),
          const SizedBox(height: 20),
          TextField(
            key: const ValueKey('weight-input'),
            controller: _controller,
            autofocus: true,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
            ],
            onChanged: (_) => setState(() {}),
            onSubmitted: (_) => _save(),
            decoration: InputDecoration(
              suffixText: widget.units.unit,
              errorText: valid || _controller.text.isEmpty
                  ? null
                  : l10n.realisticWeight,
              filled: true,
              fillColor: AppColors.card,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 52,
            child: ElevatedButton(
              key: const ValueKey('save-weight'),
              onPressed: valid ? _save : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.onPrimary,
                elevation: 0,
                shape: const StadiumBorder(),
              ),
              child: Text(
                l10n.save,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
