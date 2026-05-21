import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jpstudy/core/app_language.dart';
import 'package:jpstudy/theme/app_theme.dart';

void main() {
  group('design tokens', () {
    test('spacing scale follows the 4px grid required by Phase H.2', () {
      expect(AppSpacingTokens.scale, <double>[
        4,
        8,
        12,
        16,
        20,
        24,
        32,
        40,
        48,
        64,
      ]);
    });

    test('radius tokens expose the Phase H.2 scale', () {
      expect(AppRadiusTokens.scale, <double>[4, 8, 12, 16, 24]);
      expect(AppRadiusTokens.pill, 999);
    });

    test(
      'typography tokens expose display, heading, body, and caption sizes',
      () {
        expect(AppTypographyTokens.display, <double>[32, 40, 48]);
        expect(AppTypographyTokens.heading, <double>[20, 24, 28]);
        expect(AppTypographyTokens.body, <double>[14, 16, 18]);
        expect(AppTypographyTokens.caption, <double>[12, 13]);
        expect(AppTypographyTokens.vietnameseFontFamily, 'Be Vietnam Pro');
      },
    );

    test(
      'semantic colors include brand, state, surface, text, and JLPT levels',
      () {
        expect(AppColorTokens.light.primary, const Color(0xFF20675B));
        expect(AppColorTokens.light.surface, AppThemePalette.light.surface);
        expect(AppColorTokens.light.textHigh, AppThemePalette.light.ink);
        expect(AppColorTokens.level('N5'), AppColorTokens.jlptN5);
        expect(AppColorTokens.level('N4'), AppColorTokens.jlptN4);
        expect(AppColorTokens.level('N3'), AppColorTokens.jlptN3);
        expect(AppColorTokens.level('N2'), AppColorTokens.jlptN2);
        expect(AppColorTokens.level('N1'), AppColorTokens.jlptN1);
      },
    );

    test('elevation and motion scales are centralized', () {
      expect(AppElevationTokens.dp, <double>[0, 1, 2, 4, 8]);
      expect(AppElevationTokens.shadowDp0, isEmpty);
      expect(AppElevationTokens.shadowDp8.single.blurRadius, 28);
      expect(AppMotionTokens.snap, const Duration(milliseconds: 120));
      expect(AppMotionTokens.smoothCurve, Curves.easeInOutCubic);
    });
  });

  group('ThemeData token wiring', () {
    test(
      'light theme consumes Phase H.2 color, radius, type, spacing, and motion tokens',
      () {
        final theme = AppTheme.light(AppLanguage.vi);
        final cardShape = theme.cardTheme.shape as RoundedRectangleBorder;
        final elevatedStyle = theme.elevatedButtonTheme.style!;

        expect(theme.colorScheme.primary, AppColorTokens.light.primary);
        expect(
          cardShape.borderRadius,
          BorderRadius.circular(AppRadiusTokens.xxl),
        );
        expect(
          theme.textTheme.displayLarge?.fontSize,
          AppTypographyTokens.displayLg,
        );
        expect(
          theme.textTheme.bodyMedium?.fontSize,
          AppTypographyTokens.bodyMd,
        );
        expect(
          elevatedStyle.padding?.resolve({}),
          const EdgeInsets.symmetric(
            horizontal: AppSpacingTokens.xxl,
            vertical: AppSpacingTokens.lg,
          ),
        );
        expect(elevatedStyle.animationDuration, AppMotionTokens.smooth);
        expect(elevatedStyle.elevation?.resolve({}), AppElevationTokens.dp0);
      },
    );
  });
}
