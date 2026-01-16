import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData light() {
    const appBackground = Color(0xFFF5F7FB);
    final colorScheme = const ColorScheme.light(
      primary: Color(0xFF4255FF),
      secondary: Color(0xFF6C7CFF),
      surface: Color(0xFFFFFFFF),
      onPrimary: Color(0xFFFFFFFF),
      onSurface: Color(0xFF1C2440),
    );

    return ThemeData(
      colorScheme: colorScheme,
      useMaterial3: true,
      fontFamily: 'Manrope',
      scaffoldBackgroundColor: appBackground,
      appBarTheme: AppBarTheme(
        backgroundColor: appBackground,
        elevation: 0,
        foregroundColor: colorScheme.onSurface,
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: Color(0xFF1C2440),
        ),
      ),
      cardTheme: CardThemeData(
        color: colorScheme.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFF1F3F7),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        hintStyle: const TextStyle(color: Color(0xFF8F9BB3)),
      ),
      textTheme: const TextTheme(
        titleLarge: TextStyle(fontWeight: FontWeight.w700),
        titleMedium: TextStyle(fontWeight: FontWeight.w600),
        bodyMedium: TextStyle(color: Color(0xFF4D5877)),
      ),
      iconTheme: const IconThemeData(color: Color(0xFF4D5877)),
    );
  }
}
