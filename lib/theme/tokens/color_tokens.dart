import 'package:flutter/material.dart';

@immutable
class AppColorTokenSet {
  const AppColorTokenSet({
    required this.background,
    required this.base,
    required this.surface,
    required this.elevated,
    required this.primary,
    required this.secondary,
    required this.accent,
    required this.textHigh,
    required this.textMedium,
    required this.textLow,
    required this.success,
    required this.warning,
    required this.danger,
    required this.info,
    required this.outline,
    required this.outlineSoft,
    required this.heroStart,
    required this.heroEnd,
  });

  final Color background;
  final Color base;
  final Color surface;
  final Color elevated;
  final Color primary;
  final Color secondary;
  final Color accent;
  final Color textHigh;
  final Color textMedium;
  final Color textLow;
  final Color success;
  final Color warning;
  final Color danger;
  final Color info;
  final Color outline;
  final Color outlineSoft;
  final Color heroStart;
  final Color heroEnd;
}

abstract final class AppColorTokens {
  static const Color lightBackground = Color(0xFFF5EEE3);
  static const Color lightBase = Color(0xFFFCF7F0);
  static const Color lightSurface = Color(0xFFF7F0E3);
  static const Color lightElevated = Color(0xFFFFFCF7);
  static const Color lightPrimary = Color(0xFF20675B);
  static const Color lightSecondary = Color(0xFF17324D);
  static const Color lightAccent = Color(0xFFA64926);
  static const Color lightTextHigh = Color(0xFF15202B);
  static const Color lightTextMedium = Color(0xFF61707F);
  static const Color lightTextLow = Color(0xFF8A97A5);
  static const Color lightSuccess = Color(0xFF176C4A);
  static const Color lightWarning = Color(0xFF7A4D00);
  static const Color lightDanger = Color(0xFF9B3440);
  static const Color lightInfo = Color(0xFF315F9A);
  static const Color lightOutline = Color(0xFFE5D7C4);
  static const Color lightOutlineSoft = Color(0xFFF1E7D8);
  static const Color lightHeroStart = Color(0xFF102A43);
  static const Color lightHeroEnd = Color(0xFF1F6F67);

  static const Color darkBackground = Color(0xFF0E1620);
  static const Color darkBase = Color(0xFF162230);
  static const Color darkSurface = Color(0xFF1B2938);
  static const Color darkElevated = Color(0xFF223446);
  static const Color darkPrimary = Color(0xFF7EC2B0);
  static const Color darkSecondary = Color(0xFF93B3D3);
  static const Color darkAccent = Color(0xFFF08A55);
  static const Color darkTextHigh = Color(0xFFF8F1E7);
  static const Color darkTextMedium = Color(0xFFCBD5E1);
  static const Color darkTextLow = Color(0xFF94A3B8);
  static const Color darkSuccess = Color(0xFF7CCB9B);
  static const Color darkWarning = Color(0xFFF1BE6B);
  static const Color darkDanger = Color(0xFFFF8390);
  static const Color darkInfo = Color(0xFF8CB8F0);
  static const Color darkOutline = Color(0xFF314557);
  static const Color darkOutlineSoft = Color(0xFF27384A);
  static const Color darkHeroStart = Color(0xFF16304B);
  static const Color darkHeroEnd = Color(0xFF255E58);

  static const Color jlptN5 = Color(0xFFDC2626);
  static const Color jlptN4 = Color(0xFFF97316);
  static const Color jlptN3 = Color(0xFFEAB308);
  static const Color jlptN2 = Color(0xFF16A34A);
  static const Color jlptN1 = Color(0xFF2563EB);

  static const AppColorTokenSet light = AppColorTokenSet(
    background: lightBackground,
    base: lightBase,
    surface: lightSurface,
    elevated: lightElevated,
    primary: lightPrimary,
    secondary: lightSecondary,
    accent: lightAccent,
    textHigh: lightTextHigh,
    textMedium: lightTextMedium,
    textLow: lightTextLow,
    success: lightSuccess,
    warning: lightWarning,
    danger: lightDanger,
    info: lightInfo,
    outline: lightOutline,
    outlineSoft: lightOutlineSoft,
    heroStart: lightHeroStart,
    heroEnd: lightHeroEnd,
  );

  static const AppColorTokenSet dark = AppColorTokenSet(
    background: darkBackground,
    base: darkBase,
    surface: darkSurface,
    elevated: darkElevated,
    primary: darkPrimary,
    secondary: darkSecondary,
    accent: darkAccent,
    textHigh: darkTextHigh,
    textMedium: darkTextMedium,
    textLow: darkTextLow,
    success: darkSuccess,
    warning: darkWarning,
    danger: darkDanger,
    info: darkInfo,
    outline: darkOutline,
    outlineSoft: darkOutlineSoft,
    heroStart: darkHeroStart,
    heroEnd: darkHeroEnd,
  );

  static Color level(String level) {
    switch (level.toUpperCase()) {
      case 'N5':
        return jlptN5;
      case 'N4':
        return jlptN4;
      case 'N3':
        return jlptN3;
      case 'N2':
        return jlptN2;
      case 'N1':
        return jlptN1;
      default:
        return light.textMedium;
    }
  }
}
