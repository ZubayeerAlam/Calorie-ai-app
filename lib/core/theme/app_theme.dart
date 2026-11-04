import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static const String fontFamily = 'Outfit';

  /// The theme for the palette [AppColors] is using (light or dark).
  static ThemeData current() {
    final dark = AppColors.isDark;
    return ThemeData(
      useMaterial3: true,
      brightness: dark ? Brightness.dark : Brightness.light,
      fontFamily: fontFamily,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: dark ? Brightness.dark : Brightness.light,
        primary: dark ? AppColors.primary : AppColors.accent,
        onPrimary: dark ? AppColors.onPrimary : Colors.white,
        surface: AppColors.surface,
        onSurface: AppColors.textDark,
        error: AppColors.badge,
      ),
      scaffoldBackgroundColor: AppColors.background,
      dividerColor: AppColors.line,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textDark,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      // Links and text buttons in the readable green.
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: AppColors.accent),
      ),
      dialogTheme: DialogThemeData(backgroundColor: AppColors.surface),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: AppColors.surface,
      ),
      listTileTheme: ListTileThemeData(
        textColor: AppColors.textDark,
        iconColor: AppColors.textGrey,
      ),
    );
  }
}
