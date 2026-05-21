import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jpstudy/app/theme/app_spacing.dart';
import 'package:jpstudy/core/app_language.dart';
import 'package:jpstudy/core/level_provider.dart';
import 'package:jpstudy/core/language_provider.dart';
import 'package:jpstudy/core/study_level.dart';
import 'package:jpstudy/features/jlpt/screens/jlpt_reading_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('mobile reading CTA clears the bottom navigation area', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    const navOverlayKey = Key('mobile-nav-overlay');
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appLanguageProvider.overrideWith(
            (ref) => AppLanguageController.test(AppLanguage.en),
          ),
          studyLevelProvider.overrideWith((ref) => StudyLevel.n3),
        ],
        child: const MaterialApp(
          home: Stack(
            children: [
              Positioned.fill(child: JlptReadingScreen()),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: SizedBox(key: navOverlayKey, height: 102),
              ),
            ],
          ),
        ),
      ),
    );

    await tester.pump();
    await tester.runAsync(() async {
      await Future<void>.delayed(const Duration(milliseconds: 100));
    });
    for (var i = 0; i < 20; i++) {
      await tester.pump(const Duration(milliseconds: 200));
      if (find.byIcon(Icons.play_arrow_rounded).evaluate().isNotEmpty) {
        break;
      }
    }
    await tester.pump(const Duration(seconds: 2));

    final scrollable = find.byType(CustomScrollView).first;
    for (var i = 0; i < 6; i++) {
      if (find.byIcon(Icons.play_arrow_rounded).evaluate().isNotEmpty) {
        break;
      }
      await tester.drag(scrollable, const Offset(0, -260));
      await tester.pump(const Duration(milliseconds: 200));
    }

    expect(
      find.byIcon(Icons.play_arrow_rounded),
      findsAtLeastNWidgets(1),
      reason: 'First reading CTA should be available before the bottom nav.',
    );

    final firstCta = find
        .ancestor(
          of: find.byIcon(Icons.play_arrow_rounded).first,
          matching: find.byType(FilledButton),
        )
        .first;
    final ctaRect = tester.getRect(firstCta);
    final navTop = tester.getTopLeft(find.byKey(navOverlayKey)).dy;

    expect(
      ctaRect.bottom,
      lessThanOrEqualTo(navTop - AppSpacing.sm),
      reason:
          'CTA bottom ${ctaRect.bottom} must clear nav top $navTop by ${AppSpacing.sm}px.',
    );

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
    await tester.pump(const Duration(seconds: 2));
  });
}
