/// Number formatting without an intl dependency.
class AppNumbers {
  AppNumbers._();

  /// 12345 → "12,345".
  static String thousands(int n) => n.toString().replaceAllMapped(
    RegExp(r'\B(?=(\d{3})+(?!\d))'),
    (_) => ',',
  );

  /// 70.0 → "70", 70.25 → "70.3".
  static String oneDecimal(double n) {
    final rounded = (n * 10).round() / 10;
    return rounded == rounded.roundToDouble()
        ? rounded.toStringAsFixed(0)
        : rounded.toStringAsFixed(1);
  }
}
