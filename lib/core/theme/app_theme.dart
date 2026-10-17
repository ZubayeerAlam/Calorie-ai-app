import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static const Color _seed = Color(0xFF2E7D32);

  static ThemeData get light => ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: _seed),
    useMaterial3: true,
  );

  static ThemeData get dark => ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: _seed,
      brightness: Brightness.dark,
    ),
    useMaterial3: true,
  );
}
