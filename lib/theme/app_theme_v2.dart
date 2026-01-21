import 'package:flutter/material.dart';

class AppThemeV2 {
  // Vibrant Palette
  static const Color primary = Color(0xFF5B4DFF); // Indigo
  static const Color secondary = Color(0xFF58CC02); // Success Green
  static const Color tertiary = Color(0xFFFF9600); // Energetic Orange
  static const Color error = Color(0xFFFF4B4B); // Soft Red
  static const Color neutral = Color(0xFFE5E7EB); // Light Gray for borders/depth
  
  static const Color surface = Color(0xFFF5F7FB); // Cloud White
  static const Color textMain = Color(0xFF1F2937); // Navy specific
  static const Color textSub = Color(0xFF6B7280); // Gray

  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'M_PLUS_Rounded_1c', // Assuming a rounded font is available or fallback to system rounded
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        primary: primary,
        secondary: secondary,
        tertiary: tertiary,
        error: error,
        surface: surface,
        onSurface: textMain,
        surfaceContainerHighest: neutral,
      ),
      scaffoldBackgroundColor: surface,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: textMain,
          fontSize: 20,
          fontWeight: FontWeight.w800, // Extra Bold for headings
        ),
        iconTheme: IconThemeData(color: textMain),
      ),
      cardTheme: CardTheme(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: neutral, width: 2),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
  
  // Custom Depth Colors (Darker shades for bottom border)
  static Color getDepthColor(Color color) {
    // Return a darker shade manually
    final hsl = HSLColor.fromColor(color);
    return hsl.withLightness((hsl.lightness - 0.15).clamp(0.0, 1.0)).toColor();
  }
}
