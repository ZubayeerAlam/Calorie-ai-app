import '../../../../core/utils/number_format.dart';

/// Shows weights in the unit the user picked in onboarding.
class WeightUnits {
  const WeightUnits({required this.metric});

  static const double _lbPerKg = 2.20462;

  final bool metric;

  String get unit => metric ? 'kg' : 'lb';

  double fromKg(double kg) => metric ? kg : kg * _lbPerKg;

  double toKg(double value) => metric ? value : value / _lbPerKg;

  /// "70.4 kg".
  String format(double kg) => '${AppNumbers.oneDecimal(fromKg(kg))} $unit';

  /// "+0.8 kg" / "−1.2 kg".
  String formatChange(double kg) {
    final value = fromKg(kg);
    final sign = value > 0
        ? '+'
        : value < 0
        ? '−'
        : '±';
    return '$sign${AppNumbers.oneDecimal(value.abs())} $unit';
  }
}
