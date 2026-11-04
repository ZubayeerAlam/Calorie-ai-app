import 'package:flutter/material.dart';

/// Brand colors from the design mockups, shared by every screen, in a light
/// and a dark version. The app picks one with [useDark] before it builds
/// (see `CalAiApp`), so widgets read these like constants.
///
/// The names describe the light design: [textDark] is the main text colour
/// (near-black in light mode, near-white in dark mode).
class AppColors {
  AppColors._();

  static bool _dark = false;

  static bool get isDark => _dark;

  /// Switches every colour below to the dark (or light) palette.
  static void useDark(bool dark) => _dark = dark;

  static Color _pick(int light, int dark) => Color(_dark ? dark : light);

  // Brand
  static Color get primary => const Color(0xFFA3CE50);
  static Color get primaryLight => _pick(0xFFCFE5A8, 0xFF4C6128);

  /// Text and icons placed on [primary] (buttons, selected chips): always
  /// dark, in both modes.
  static Color get onPrimary => const Color(0xFF1E1E1E);

  /// Green for text and icons on [surface] or [background] (text buttons,
  /// links). Darker than [primary] in light mode so it is readable.
  static Color get accent => _pick(0xFF4A7311, 0xFFA3CE50);

  // Text
  static Color get textDark => _pick(0xFF1E1E1E, 0xFFEDEDED);
  static Color get textGrey => _pick(0xFF555555, 0xFFB8B8B8);
  static Color get textLight => _pick(0xFF757575, 0xFF9A9A9A);

  // Lines and fills
  static Color get tick => _pick(0xFFCCCCCC, 0xFF4A4A4A);
  static Color get tickLabel => _pick(0xFFC4C4C4, 0xFF6E6E6E);
  static Color get card => _pick(0xFFFAFAFA, 0xFF262626);
  static Color get track => _pick(0xFFEEEEEE, 0xFF333333);
  static Color get chipBorder => _pick(0xFFE6E6E6, 0xFF3A3A3A);
  static Color get divider => _pick(0xFFF2F2F2, 0xFF2A2A2A);

  // Home / dashboard
  static Color get background => _pick(0xFFF6F6F6, 0xFF121212);
  static Color get surface => _pick(0xFFFFFFFF, 0xFF1E1E1E);
  static Color get line => _pick(0xFFE8E8E8, 0xFF333333);
  static Color get ringTrack => _pick(0xFFEDEDED, 0xFF2E2E2E);
  static Color get badge => _pick(0xFFD93A42, 0xFFF2727A);
}
