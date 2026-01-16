import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData light() {
    return ThemeData(
      colorSchemeSeed: const Color(0xFF2B5B3F),
      useMaterial3: true,
      scaffoldBackgroundColor: const Color(0xFFF7F5F1),
      textTheme: const TextTheme(
        titleLarge: TextStyle(fontWeight: FontWeight.w700),
      ),
    );
  }
}
