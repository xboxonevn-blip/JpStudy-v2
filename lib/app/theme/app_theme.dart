import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData light() {
    const appBackground = Color(0xFFF8FAFC); // Soft off-white
    const primaryColor = Color(0xFF6366F1); // Indigo
    const secondaryColor = Color(0xFF8B5CF6); // Violet

    final colorScheme = const ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
      surface: Color(0xFFFFFFFF),
      onPrimary: Color(0xFFFFFFFF),
      onSurface: Color(0xFF1E293B), // Slate 800
      error: Color(0xFFEF4444),
      tertiary: Color(0xFF10B981), // Emerald (Success)
    );

    final fontName = GoogleFonts.nunito().fontFamily;

    return ThemeData(
      colorScheme: colorScheme,
      useMaterial3: true,
      fontFamily: fontName,
      scaffoldBackgroundColor: appBackground,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent, // For gradient backgrounds
        elevation: 0,
        centerTitle: true,
        foregroundColor: colorScheme.onSurface,
        titleTextStyle: TextStyle(
          fontFamily: fontName,
          fontSize: 20,
          fontWeight: FontWeight.w800, // Extra bold for "Juicy" feel
          color: const Color(0xFF1E293B),
        ),
      ),
      cardTheme: CardThemeData(
        color: colorScheme.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24), // Increased radius
          side: const BorderSide(color: Color(0xFFE2E8F0), width: 1.5),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFF1F5F9), // Slate 100
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        hintStyle: const TextStyle(color: Color(0xFF94A3B8)), // Slate 400
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      ),
      textTheme: TextTheme(
        displayLarge: TextStyle(fontFamily: fontName, fontWeight: FontWeight.w900, color: const Color(0xFF1E293B)),
        titleLarge: TextStyle(fontFamily: fontName, fontWeight: FontWeight.w800, color: const Color(0xFF1E293B)),
        titleMedium: TextStyle(fontFamily: fontName, fontWeight: FontWeight.w700, color: const Color(0xFF1E293B)),
        bodyLarge: TextStyle(fontFamily: fontName, color: const Color(0xFF334155)),
        bodyMedium: TextStyle(fontFamily: fontName, color: const Color(0xFF475569)),
      ),
      iconTheme: const IconThemeData(color: Color(0xFF64748B)),
    );
  }

  static ThemeData dark() {
    const primaryColor = Color(0xFF8B8FF1);
    const secondaryColor = Color(0xFFA78BFE);
    const scaffoldBg = Color(0xFF0F172A);
    const cardBg = Color(0xFF1E293B);
    final fontName = GoogleFonts.nunito().fontFamily;

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: fontName,
      colorScheme: const ColorScheme.dark(
        primary: primaryColor,
        secondary: secondaryColor,
        tertiary: Color(0xFF34D399),
        surface: cardBg,
        onPrimary: Colors.white,
      ),
      scaffoldBackgroundColor: scaffoldBg,
      appBarTheme: AppBarTheme(
        backgroundColor: scaffoldBg,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: fontName,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
      cardTheme: CardThemeData(
        color: cardBg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
      ),
    );
  }
}
