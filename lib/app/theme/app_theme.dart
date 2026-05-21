import 'package:flutter/material.dart';
import 'package:jpstudy/app/theme/app_theme_palette.dart';
import 'package:jpstudy/core/app_language.dart';
import 'package:jpstudy/theme/tokens/color_tokens.dart';
import 'package:jpstudy/theme/tokens/elevation_tokens.dart';
import 'package:jpstudy/theme/tokens/motion_tokens.dart';
import 'package:jpstudy/theme/tokens/radius_tokens.dart';
import 'package:jpstudy/theme/tokens/spacing_tokens.dart';
import 'package:jpstudy/theme/tokens/typography_tokens.dart';

class AppTheme {
  // Component palette (used by ClayButton, ClayCard, grammar widgets, etc.)
  static const Color primary = AppColorTokens.lightPrimary;
  static const Color secondary = AppColorTokens.lightSecondary;
  static const Color tertiary = AppColorTokens.lightAccent;
  static const Color error = AppColorTokens.lightDanger;
  static const Color neutral = AppColorTokens.lightOutline;
  static const Color surface = AppColorTokens.lightBase;
  static const Color textMain = AppColorTokens.lightTextHigh;
  static const Color textSub = AppColorTokens.lightTextMedium;
  static const String latinFontFamily =
      AppTypographyTokens.vietnameseFontFamily;
  static const String bundledLatinFontFamily =
      AppTypographyTokens.bundledLatinFontFamily;
  static const String japanesePrimaryFontFamily =
      AppTypographyTokens.japanesePrimaryFontFamily;
  static const String vietnameseFallbackFontFamily =
      AppTypographyTokens.vietnameseFallbackFontFamily;
  static const String japaneseFallbackFontFamily =
      AppTypographyTokens.japaneseFallbackFontFamily;
  static const String emojiFallbackFontFamily =
      AppTypographyTokens.emojiFallbackFontFamily;
  static const List<String> vietnameseFontFallbacks = <String>[
    vietnameseFallbackFontFamily,
    japaneseFallbackFontFamily,
    emojiFallbackFontFamily,
  ];
  static const List<String> japaneseFontFallbacks = <String>[
    japanesePrimaryFontFamily,
    japaneseFallbackFontFamily,
    vietnameseFallbackFontFamily,
    bundledLatinFontFamily,
    emojiFallbackFontFamily,
  ];

  static Color getDepthColor(Color color) {
    final hsl = HSLColor.fromColor(color);
    return hsl.withLightness((hsl.lightness - 0.15).clamp(0.0, 1.0)).toColor();
  }

  static ThemeData light([AppLanguage language = AppLanguage.en]) {
    const colors = AppColorTokens.light;
    final palette = AppThemePalette.light;
    final typography = _typographyFor(language);

    final colorScheme = ColorScheme.light(
      primary: colors.primary,
      secondary: colors.secondary,
      surface: colors.surface,
      onPrimary: const Color(0xFFFFFFFF),
      onSurface: colors.textHigh,
      error: colors.danger,
      tertiary: colors.accent,
    );

    return ThemeData(
      colorScheme: colorScheme,
      extensions: const [AppThemePalette.light],
      useMaterial3: true,
      fontFamily: typography.bodyFontFamily,
      scaffoldBackgroundColor: palette.bg,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        foregroundColor: colorScheme.onSurface,
        titleTextStyle: _textStyle(
          typography,
          display: true,
          fontSize: AppTypographyTokens.headingMd,
          fontWeight: FontWeight.w800,
          color: palette.ink,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.transparent,
        indicatorColor: palette.primary.withValues(alpha: 0.14),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          return _textStyle(
            typography,
            fontWeight: states.contains(WidgetState.selected)
                ? FontWeight.w800
                : FontWeight.w700,
            color: states.contains(WidgetState.selected)
                ? palette.primary
                : palette.ink.withValues(alpha: 0.64),
          );
        }),
      ),
      cardTheme: CardThemeData(
        color: colorScheme.surface,
        elevation: AppElevationTokens.dp0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadiusTokens.xxl),
          side: BorderSide(color: palette.outline, width: 1.1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          animationDuration: AppMotionTokens.smooth,
          elevation: AppElevationTokens.dp0,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacingTokens.xxl,
            vertical: AppSpacingTokens.lg,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadiusTokens.lg),
          ),
          backgroundColor: palette.primary,
          foregroundColor: Colors.white,
          textStyle: _textStyle(
            typography,
            fontWeight: FontWeight.w800,
            fontSize: AppTypographyTokens.bodyMd,
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          animationDuration: AppMotionTokens.smooth,
          elevation: AppElevationTokens.dp0,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacingTokens.xl,
            vertical: AppSpacingTokens.lg,
          ),
          backgroundColor: palette.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadiusTokens.lg),
          ),
          textStyle: _textStyle(
            typography,
            fontWeight: FontWeight.w800,
            fontSize: AppTypographyTokens.bodyMd,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          animationDuration: AppMotionTokens.smooth,
          foregroundColor: palette.ink,
          side: BorderSide(color: palette.outline),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacingTokens.xl,
            vertical: AppSpacingTokens.lg,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadiusTokens.lg),
          ),
          textStyle: _textStyle(
            typography,
            fontWeight: FontWeight.w700,
            fontSize: AppTypographyTokens.bodyMd,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: palette.elevated,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadiusTokens.xxl),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadiusTokens.xxl),
          borderSide: BorderSide(color: palette.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadiusTokens.xxl),
          borderSide: BorderSide(color: palette.primary, width: 2),
        ),
        hintStyle: _textStyle(
          typography,
          color: palette.ink.withValues(alpha: 0.68),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacingTokens.xl,
          vertical: AppSpacingTokens.lg,
        ),
      ),
      textTheme: TextTheme(
        displayLarge: _textStyle(
          typography,
          display: true,
          fontSize: AppTypographyTokens.displayLg,
          fontWeight: FontWeight.w900,
          color: palette.ink,
        ),
        titleLarge: _textStyle(
          typography,
          display: true,
          fontSize: AppTypographyTokens.headingLg,
          fontWeight: FontWeight.w800,
          color: palette.ink,
        ),
        titleMedium: _textStyle(
          typography,
          fontSize: AppTypographyTokens.headingMd,
          fontWeight: FontWeight.w800,
          color: palette.ink,
        ),
        bodyLarge: _textStyle(
          typography,
          fontSize: AppTypographyTokens.bodyLg,
          color: palette.ink.withValues(alpha: 0.88),
        ),
        bodyMedium: _textStyle(
          typography,
          fontSize: AppTypographyTokens.bodyMd,
          color: palette.ink.withValues(alpha: 0.74),
        ),
      ),
      iconTheme: IconThemeData(color: palette.ink.withValues(alpha: 0.68)),
    );
  }

  static ThemeData dark([AppLanguage language = AppLanguage.en]) {
    const colors = AppColorTokens.dark;
    final typography = _typographyFor(language);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      extensions: const [AppThemePalette.dark],
      fontFamily: typography.bodyFontFamily,
      colorScheme: const ColorScheme.dark(
        primary: AppColorTokens.darkPrimary,
        secondary: AppColorTokens.darkSecondary,
        tertiary: AppColorTokens.darkAccent,
        surface: AppColorTokens.darkSurface,
        onPrimary: Colors.white,
      ),
      scaffoldBackgroundColor: colors.background,
      appBarTheme: AppBarTheme(
        backgroundColor: colors.background,
        elevation: AppElevationTokens.dp0,
        centerTitle: false,
        titleTextStyle: _textStyle(
          typography,
          display: true,
          fontSize: AppTypographyTokens.headingMd,
          fontWeight: FontWeight.w800,
          color: Colors.white,
        ),
      ),
      cardTheme: CardThemeData(
        color: colors.surface,
        elevation: AppElevationTokens.dp0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadiusTokens.xxl),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          animationDuration: AppMotionTokens.smooth,
          elevation: AppElevationTokens.dp0,
          backgroundColor: colors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacingTokens.xxl,
            vertical: AppSpacingTokens.lg,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadiusTokens.xxl),
          ),
          textStyle: _textStyle(
            typography,
            fontWeight: FontWeight.w800,
            fontSize: AppTypographyTokens.bodyMd,
          ),
        ),
      ),
      textTheme: TextTheme(
        displayLarge: _textStyle(
          typography,
          display: true,
          fontSize: AppTypographyTokens.displayLg,
          fontWeight: FontWeight.w900,
          color: Colors.white,
        ),
        titleLarge: _textStyle(
          typography,
          display: true,
          fontSize: AppTypographyTokens.headingLg,
          fontWeight: FontWeight.w800,
          color: Colors.white,
        ),
        titleMedium: _textStyle(
          typography,
          fontSize: AppTypographyTokens.headingMd,
          fontWeight: FontWeight.w800,
          color: Colors.white,
        ),
        bodyLarge: _textStyle(
          typography,
          fontSize: AppTypographyTokens.bodyLg,
          color: colors.textMedium,
        ),
        bodyMedium: _textStyle(
          typography,
          fontSize: AppTypographyTokens.bodyMd,
          color: colors.textLow,
        ),
      ),
    );
  }

  static _AppTypography _typographyFor(AppLanguage language) {
    if (language.usesJapaneseTypography) {
      return const _AppTypography(
        bodyFontFamily: japanesePrimaryFontFamily,
        displayFontFamily: japanesePrimaryFontFamily,
        fontFamilyFallback: <String>[
          japaneseFallbackFontFamily,
          vietnameseFallbackFontFamily,
          emojiFallbackFontFamily,
          bundledLatinFontFamily,
          latinFontFamily,
        ],
      );
    }

    return const _AppTypography(
      bodyFontFamily: latinFontFamily,
      displayFontFamily: latinFontFamily,
      fontFamilyFallback: <String>[
        ...vietnameseFontFallbacks,
        ...japaneseFontFallbacks,
      ],
    );
  }

  static TextStyle _textStyle(
    _AppTypography typography, {
    bool display = false,
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
  }) {
    return TextStyle(
      fontFamily: display
          ? typography.displayFontFamily
          : typography.bodyFontFamily,
      fontFamilyFallback: typography.fontFamilyFallback,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }
}

class _AppTypography {
  const _AppTypography({
    required this.bodyFontFamily,
    required this.displayFontFamily,
    required this.fontFamilyFallback,
  });

  final String bodyFontFamily;
  final String displayFontFamily;
  final List<String> fontFamilyFallback;
}
