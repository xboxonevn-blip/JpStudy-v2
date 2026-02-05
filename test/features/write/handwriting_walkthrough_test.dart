import 'dart:math';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jpstudy/core/app_language.dart';
import 'package:jpstudy/data/db/app_database.dart';
import 'package:jpstudy/data/db/content_database.dart';
import 'package:jpstudy/data/db/database_provider.dart';
import 'package:jpstudy/data/models/kanji_item.dart';
import 'package:jpstudy/data/models/vocab_item.dart';
import 'package:jpstudy/data/repositories/lesson_repository.dart';
import 'package:jpstudy/features/write/screens/handwriting_practice_screen.dart';
import 'package:jpstudy/features/write/screens/write_mode_screen.dart';
import 'package:jpstudy/features/write/services/kanji_stroke_template_service.dart';
import 'package:jpstudy/features/write/widgets/handwriting_canvas.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  Finder animationControlFinder() => find.byWidgetPredicate(
    (widget) =>
        widget is Text &&
        ((widget.data ?? '') == AppLanguage.en.handwritingAnimateLabel ||
            (widget.data ?? '') == AppLanguage.en.handwritingPauseLabel),
  );

  setUp(() {
    SharedPreferences.setMockInitialValues({
      'write.handwriting.strokeGuide.defaultExpanded': true,
    });
  });

  Map<String, KanjiStrokeTemplate> oneStrokeTemplate() => {
    '\u4E00': const KanjiStrokeTemplate(
      character: '\u4E00',
      quality: 'manual',
      strokes: [StrokeTemplate(start: Point(0.1, 0.5), end: Point(0.9, 0.5))],
    ),
  };

  testWidgets('Write Mode opens Handwriting screen', (tester) async {
    KanjiStrokeTemplateService.setDebugTemplateOverrides(oneStrokeTemplate());
    addTearDown(() {
      KanjiStrokeTemplateService.setDebugTemplateOverrides(null);
    });

    final vocabItems = [
      const VocabItem(
        id: 1,
        term: '\u4E00',
        reading: 'ichi',
        meaning: 'mot',
        meaningEn: 'one',
        level: 'N5',
      ),
    ];
    final kanjiItems = [
      const KanjiItem(
        id: 1,
        lessonId: 1,
        character: '\u4E00',
        strokeCount: 1,
        meaning: 'mot',
        meaningEn: 'one',
        examples: [],
        jlptLevel: 'N5',
      ),
    ];

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: WriteModeScreen(
            lessonId: 1,
            lessonTitle: 'Lesson 1',
            vocabItems: vocabItems,
            kanjiItems: kanjiItems,
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();
    await tester.tap(find.text(AppLanguage.en.writeModeHandwritingLabel));
    await tester.pumpAndSettle();

    expect(find.byType(HandwritingPracticeScreen), findsOneWidget);
  });

  testWidgets(
    'Handwriting walkthrough updates SRS and creates mistake on wrong answer',
    (tester) async {
      KanjiStrokeTemplateService.setDebugTemplateOverrides(oneStrokeTemplate());
      addTearDown(() {
        KanjiStrokeTemplateService.setDebugTemplateOverrides(null);
      });

      final db = AppDatabase(executor: NativeDatabase.memory());
      final contentDb = ContentDatabase(executor: NativeDatabase.memory());
      final repo = LessonRepository(db, contentDb);
      addTearDown(() async {
        await contentDb.close();
        await db.close();
      });

      const kanjiId = 99901;
      const item = KanjiItem(
        id: kanjiId,
        lessonId: 1,
        character: '\u4E00',
        strokeCount: 1,
        meaning: 'mot',
        meaningEn: 'one',
        examples: [],
        jlptLevel: 'N5',
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            databaseProvider.overrideWithValue(db),
            lessonRepositoryProvider.overrideWithValue(repo),
          ],
          child: const MaterialApp(
            home: HandwritingPracticeScreen(
              lessonTitle: 'Lesson 1',
              items: [item],
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final canvas = find.byType(HandwritingCanvas);
      expect(canvas, findsOneWidget);
      await tester.ensureVisible(canvas);
      await tester.pumpAndSettle();
      final rect = tester.getRect(canvas);

      Future<void> drawStroke(Offset start, Offset end) async {
        final gesture = await tester.startGesture(start);
        await tester.pump(const Duration(milliseconds: 16));
        await gesture.moveTo(end);
        await tester.pump(const Duration(milliseconds: 16));
        await gesture.up();
        await tester.pump(const Duration(milliseconds: 50));
      }

      // Draw 2 strokes while expected is 1 -> deterministic wrong case.
      await drawStroke(
        rect.topLeft + const Offset(16, 16),
        rect.bottomRight - const Offset(16, 16),
      );
      await drawStroke(
        rect.bottomLeft + const Offset(16, -16),
        rect.topRight - const Offset(16, -16),
      );

      await tester.ensureVisible(
        find.text(AppLanguage.en.handwritingCheckLabel),
      );
      await tester.tap(find.text(AppLanguage.en.handwritingCheckLabel));
      await tester.pumpAndSettle();
      expect(
        find.text(AppLanguage.en.handwritingPracticeWrongFirstLabel),
        findsOneWidget,
      );
      expect(
        find.text(AppLanguage.en.handwritingRetryWrongCharactersLabel),
        findsOneWidget,
      );

      await tester.ensureVisible(
        find.text(AppLanguage.en.handwritingPracticeWrongFirstLabel),
      );
      await tester.tap(find.text(AppLanguage.en.handwritingPracticeWrongFirstLabel));
      await tester.pumpAndSettle();

      final srs = await db.kanjiSrsDao.getSrsState(kanjiId);
      expect(srs, isNotNull);
      expect(srs!.lastConfidence, equals(1));

      final mistakes = await db.mistakeDao.getMistakesByType('kanji');
      final targetMistake = mistakes.where((m) => m.itemId == kanjiId).toList();
      expect(targetMistake, hasLength(1));
      expect(targetMistake.first.source, equals('handwriting'));
    },
  );

  testWidgets('Handwriting builds compound target from kanji examples', (
    tester,
  ) async {
    KanjiStrokeTemplateService.setDebugTemplateOverrides({
      ...oneStrokeTemplate(),
      '\u4E8C': const KanjiStrokeTemplate(
        character: '\u4E8C',
        quality: 'manual',
        strokes: [StrokeTemplate(start: Point(0.1, 0.4), end: Point(0.9, 0.4))],
      ),
    });
    addTearDown(() {
      KanjiStrokeTemplateService.setDebugTemplateOverrides(null);
    });

    final db = AppDatabase(executor: NativeDatabase.memory());
    final contentDb = ContentDatabase(executor: NativeDatabase.memory());
    final repo = LessonRepository(db, contentDb);
    addTearDown(() async {
      await contentDb.close();
      await db.close();
    });

    const items = [
      KanjiItem(
        id: 1,
        lessonId: 1,
        character: '\u4E00',
        strokeCount: 1,
        meaning: 'mot',
        meaningEn: 'one',
        examples: [
          KanjiExample(
            word: '\u4E00\u4E8C',
            reading: 'ichini',
            meaning: 'mot hai',
            meaningEn: 'one two',
          ),
        ],
        jlptLevel: 'N5',
      ),
      KanjiItem(
        id: 2,
        lessonId: 1,
        character: '\u4E8C',
        strokeCount: 1,
        meaning: 'hai',
        meaningEn: 'two',
        examples: [],
        jlptLevel: 'N5',
      ),
    ];

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
          lessonRepositoryProvider.overrideWithValue(repo),
        ],
        child: MaterialApp(
          home: HandwritingPracticeScreen(
            lessonTitle: 'Lesson 1',
            items: items,
            maxCompoundsPerKanji: 1,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.text(AppLanguage.en.practiceProgressLabel(1, 3)),
      findsOneWidget,
    );
    expect(find.text('一二'), findsNothing);

    await tester.tap(find.text(AppLanguage.en.handwritingModeCompoundLabel));
    await tester.pumpAndSettle();

    expect(
      find.text(AppLanguage.en.practiceProgressLabel(1, 1)),
      findsOneWidget,
    );
    expect(find.text('一二'), findsOneWidget);
  });

  testWidgets(
    'Handwriting keeps compound example even when other kanji is outside lesson list',
    (tester) async {
      KanjiStrokeTemplateService.setDebugTemplateOverrides({
        ...oneStrokeTemplate(),
        '\u4E8C': const KanjiStrokeTemplate(
          character: '\u4E8C',
          quality: 'manual',
          strokes: [
            StrokeTemplate(start: Point(0.1, 0.4), end: Point(0.9, 0.4)),
          ],
        ),
      });
      addTearDown(() {
        KanjiStrokeTemplateService.setDebugTemplateOverrides(null);
      });

      const items = [
        KanjiItem(
          id: 1,
          lessonId: 1,
          character: '\u4E00',
          strokeCount: 1,
          meaning: 'mot',
          meaningEn: 'one',
          examples: [
            KanjiExample(
              word: '\u4E00\u4E8C',
              reading: 'ichini',
              meaning: 'mot hai',
              meaningEn: 'one two',
            ),
          ],
          jlptLevel: 'N5',
        ),
      ];

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: HandwritingPracticeScreen(
              lessonTitle: 'Lesson 1',
              items: items,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.text(AppLanguage.en.practiceProgressLabel(1, 2)),
        findsOneWidget,
      );

      await tester.tap(find.text(AppLanguage.en.handwritingModeCompoundLabel));
      await tester.pumpAndSettle();

      expect(
        find.text(AppLanguage.en.practiceProgressLabel(1, 1)),
        findsOneWidget,
      );
      expect(find.text('一二'), findsOneWidget);
    },
  );

  testWidgets('Handwriting supports single/compound/mixed mode selection', (
    tester,
  ) async {
    KanjiStrokeTemplateService.setDebugTemplateOverrides({
      ...oneStrokeTemplate(),
      '\u4E8C': const KanjiStrokeTemplate(
        character: '\u4E8C',
        quality: 'manual',
        strokes: [StrokeTemplate(start: Point(0.1, 0.4), end: Point(0.9, 0.4))],
      ),
    });
    addTearDown(() {
      KanjiStrokeTemplateService.setDebugTemplateOverrides(null);
    });

    const items = [
      KanjiItem(
        id: 1,
        lessonId: 1,
        character: '\u4E00',
        strokeCount: 1,
        meaning: 'mot',
        meaningEn: 'one',
        examples: [
          KanjiExample(
            word: '\u4E00\u4E8C',
            reading: 'ichini',
            meaning: 'mot hai',
            meaningEn: 'one two',
          ),
        ],
        jlptLevel: 'N5',
      ),
      KanjiItem(
        id: 2,
        lessonId: 1,
        character: '\u4E8C',
        strokeCount: 1,
        meaning: 'hai',
        meaningEn: 'two',
        examples: [],
        jlptLevel: 'N5',
      ),
    ];

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: HandwritingPracticeScreen(
            lessonTitle: 'Lesson 1',
            items: items,
            maxCompoundsPerKanji: 1,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text(AppLanguage.en.handwritingModeLabel), findsOneWidget);
    expect(
      find.text(AppLanguage.en.handwritingStrokeGuideTitle),
      findsOneWidget,
    );
    expect(
      find.text(AppLanguage.en.practiceProgressLabel(1, 3)),
      findsOneWidget,
    );

    await tester.tap(find.text(AppLanguage.en.handwritingModeCompoundLabel));
    await tester.pumpAndSettle();

    expect(
      find.text(AppLanguage.en.practiceProgressLabel(1, 1)),
      findsOneWidget,
    );
    expect(
      find.text(AppLanguage.en.handwritingWriteOrderByCharacterLabel),
      findsOneWidget,
    );
    expect(find.text('1. 一'), findsOneWidget);
    expect(find.text('2. 二'), findsOneWidget);
    expect(animationControlFinder(), findsWidgets);
  });

  testWidgets(
    'Handwriting uses default stroke guide setting from preferences',
    (tester) async {
      SharedPreferences.setMockInitialValues({
        'write.handwriting.strokeGuide.defaultExpanded': false,
      });

      KanjiStrokeTemplateService.setDebugTemplateOverrides(oneStrokeTemplate());
      addTearDown(() {
        KanjiStrokeTemplateService.setDebugTemplateOverrides(null);
      });

      const items = [
        KanjiItem(
          id: 1,
          lessonId: 1,
          character: '\u4E00',
          strokeCount: 1,
          meaning: 'mot',
          meaningEn: 'one',
          examples: [],
          jlptLevel: 'N5',
        ),
      ];

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: HandwritingPracticeScreen(
              lessonTitle: 'Lesson 1',
              items: items,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.text(AppLanguage.en.handwritingStrokeGuideTitle),
        findsOneWidget,
      );
      expect(animationControlFinder(), findsNothing);

      await tester.tap(find.text(AppLanguage.en.handwritingStrokeGuideTitle));
      await tester.pumpAndSettle();

      expect(animationControlFinder(), findsWidgets);
    },
  );
}
