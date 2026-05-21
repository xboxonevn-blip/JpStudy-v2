import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jpstudy/app/theme/app_theme_palette.dart';
import 'package:jpstudy/core/app_language.dart';
import 'package:jpstudy/core/language_provider.dart';
import 'package:jpstudy/core/level_provider.dart';
import 'package:jpstudy/core/study_level.dart';
import 'package:jpstudy/data/db/app_database.dart';
import 'package:jpstudy/data/repositories/lesson_repository.dart';
import 'package:jpstudy/features/grammar/grammar_providers.dart';
import 'package:jpstudy/features/lesson/lesson_detail_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

UserLessonTermData _term(
  int id,
  String term,
  String definition, {
  String reading = '',
  String? definitionEn,
}) => UserLessonTermData(
  id: id,
  lessonId: 1,
  term: term,
  reading: reading,
  definition: definition,
  definitionEn: definitionEn ?? definition,
  mnemonicVi: '',
  mnemonicEn: '',
  kanjiMeaning: '',
  isStarred: false,
  isLearned: false,
  orderIndex: id,
);

double _contrast(Color foreground, Color background) {
  final resolvedForeground = foreground.a < 1
      ? Color.alphaBlend(foreground, background)
      : foreground;
  final foregroundLuminance = resolvedForeground.computeLuminance() + 0.05;
  final backgroundLuminance = background.computeLuminance() + 0.05;
  return foregroundLuminance > backgroundLuminance
      ? foregroundLuminance / backgroundLuminance
      : backgroundLuminance / foregroundLuminance;
}

Widget buildScreen(
  List<UserLessonTermData> terms, {
  Future<List<UserLessonTermData>>? termsFuture,
  StudyLevel level = StudyLevel.n5,
  AppLanguage language = AppLanguage.en,
  int lessonId = 1,
  String? expectedFallbackTitle,
}) {
  final sourceLessonId = LessonRepository.curriculumSourceLessonId(
    level.shortLabel,
    lessonId,
  );
  final storageLessonId = LessonRepository.curriculumStorageLessonId(
    level.shortLabel,
    lessonId,
  );
  final fallbackTitle =
      expectedFallbackTitle ??
      language.curriculumLessonTitle(level.shortLabel, sourceLessonId);
  return ProviderScope(
    overrides: [
      appLanguageProvider.overrideWith(
        (ref) => AppLanguageController.test(language),
      ),
      studyLevelProvider.overrideWith((ref) => level),
      lessonTitleProvider(
        LessonTitleArgs(storageLessonId, fallbackTitle),
      ).overrideWith((ref) async => fallbackTitle),
      lessonTermsProvider(
        LessonTermsArgs(
          storageLessonId,
          level.shortLabel,
          fallbackTitle,
          sourceLessonId: sourceLessonId,
        ),
      ).overrideWith((ref) => termsFuture ?? Future.value(terms)),
      lessonGrammarProvider(
        LessonTermsArgs(sourceLessonId, level.shortLabel, ''),
      ).overrideWith((ref) async => const []),
      grammarDueCountProvider.overrideWith((ref) async => 0),
      grammarGhostCountProvider.overrideWith((ref) => Stream.value(0)),
      lessonKanjiProvider(1).overrideWith((ref) async => const []),
      lessonDueTermsProvider(
        storageLessonId,
      ).overrideWith((ref) async => const <UserLessonTermData>[]),
      srsStateProvider(1).overrideWith((ref) async => null),
    ],
    child: MaterialApp(
      home: LessonDetailScreen(lessonId: lessonId, levelCode: level.shortLabel),
    ),
  );
}

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  testWidgets('shows app bar back control and lesson tabs', (tester) async {
    await tester.pumpWidget(buildScreen([_term(1, '犬', 'dog')]));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.byIcon(Icons.chevron_left), findsOneWidget);
    expect(find.byType(TabBar), findsOneWidget);
  });

  testWidgets('upper JLPT lesson title uses Shin Kanzen source label', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildScreen(
        [_term(1, '相変わらず', 'as ever')],
        level: StudyLevel.n2,
        expectedFallbackTitle: 'Shin Kanzen N2 Lesson 1',
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.textContaining('N2 / Shin Kanzen N2 Lesson 1'), findsWidgets);
    expect(find.textContaining('N2 / Minna No Nihongo 1'), findsNothing);
  });

  testWidgets('lesson workspace renders breadcrumb and header actions', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildScreen([_term(1, '犬', 'dog')], expectedFallbackTitle: 'Unit One'),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.byKey(const ValueKey('lesson_breadcrumb_bar')), findsOneWidget);
    expect(find.byKey(const ValueKey('lesson_header')), findsOneWidget);
    expect(find.textContaining('N5 /'), findsWidgets);
    expect(find.byKey(const ValueKey('lesson_prev_button')), findsOneWidget);
    expect(find.byKey(const ValueKey('lesson_next_button')), findsOneWidget);
    expect(find.byKey(const ValueKey('lesson_report_button')), findsOneWidget);
    expect(find.byKey(const ValueKey('lesson_write_button')), findsOneWidget);
  });

  testWidgets('lesson navigation hides empty Kanji tab', (tester) async {
    await tester.pumpWidget(buildScreen([_term(1, '犬', 'dog')]));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text(AppLanguage.en.lessonVocabTabLabel), findsWidgets);
    expect(find.text(AppLanguage.en.flashcardsAction), findsWidgets);
    expect(find.text(AppLanguage.en.grammarLabel), findsWidgets);
    expect(
      find.descendant(
        of: find.byType(TabBar),
        matching: find.text(AppLanguage.en.kanjiLabel),
      ),
      findsNothing,
    );
  });

  testWidgets('JA lesson tabs use Japanese labels', (tester) async {
    await tester.pumpWidget(
      buildScreen([
        _term(1, '愛', 'yêu', reading: 'あい', definitionEn: 'love'),
      ], language: AppLanguage.ja),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text(AppLanguage.ja.lessonVocabTabLabel), findsWidgets);
    expect(find.text(AppLanguage.ja.grammarLabel), findsWidgets);
    expect(
      find.descendant(
        of: find.byType(TabBar),
        matching: find.text(AppLanguage.ja.kanjiLabel),
      ),
      findsNothing,
    );
    expect(find.text(AppLanguage.vi.lessonVocabTabLabel), findsNothing);
    expect(find.text(AppLanguage.vi.grammarLabel), findsNothing);
    expect(find.text(AppLanguage.vi.kanjiLabel), findsNothing);
  });

  testWidgets('JA lesson flashcard uses English fallback, not Vietnamese', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildScreen([
        _term(1, '愛', 'yêu', reading: 'あい', definitionEn: 'love'),
      ], language: AppLanguage.ja),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('love'), findsWidgets);
    expect(find.text('yêu'), findsNothing);
  });

  testWidgets('vocab flashcard does not expose manual learned toggle', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({'lesson.trackProgress': true});

    await tester.pumpWidget(buildScreen([_term(1, '犬', 'dog')]));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.byTooltip(AppLanguage.en.learnedLabel), findsNothing);
    expect(find.byTooltip(AppLanguage.en.starLabel), findsOneWidget);
  });

  testWidgets('lesson tabs switch to grammar panel only', (tester) async {
    await tester.pumpWidget(buildScreen([_term(1, '犬', 'dog')]));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    await tester.tap(find.text(AppLanguage.en.grammarLabel));
    await tester.pump(const Duration(milliseconds: 350));
    expect(
      DefaultTabController.of(tester.element(find.byType(TabBar))).index,
      1,
    );
    expect(
      find.descendant(
        of: find.byType(TabBar),
        matching: find.text(AppLanguage.en.kanjiLabel),
      ),
      findsNothing,
    );
  });

  testWidgets('lesson workspace shows mode picker and term list badges', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildScreen([_term(1, '学校', 'school', reading: 'がっこう')]),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.byKey(const ValueKey('lesson_mode_picker')), findsOneWidget);
    expect(find.byKey(const ValueKey('lesson_mode_flashcard')), findsOneWidget);
    expect(
      find.byKey(const ValueKey('lesson_mode_recognition')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('lesson_mode_sentence_sort')),
      findsOneWidget,
    );
    expect(find.byKey(const ValueKey('lesson_mode_typing')), findsOneWidget);
    expect(find.byKey(const ValueKey('lesson_mode_reading')), findsOneWidget);
    expect(find.byKey(const ValueKey('lesson_mode_listening')), findsOneWidget);
    expect(find.byKey(const ValueKey('lesson_term_list')), findsOneWidget);
    expect(find.byKey(const ValueKey('lesson_term_card_1')), findsOneWidget);
    expect(find.text('学校'), findsWidgets);
    expect(find.text('Kanji'), findsWidgets);
    expect(find.text('Practice'), findsWidgets);
  });

  testWidgets('lesson workspace constrains desktop content width', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1600, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(buildScreen([_term(1, '犬', 'dog')]));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    final box = tester.renderObject<RenderBox>(
      find.byKey(const ValueKey('lesson_responsive_container')),
    );
    expect(box.size.width, lessThanOrEqualTo(1040));
  });

  testWidgets('curriculum lesson menu hides user-set editing actions', (
    tester,
  ) async {
    await tester.pumpWidget(buildScreen([_term(1, '犬', 'dog')]));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    await tester.tap(find.byIcon(Icons.more_horiz));
    await tester.pumpAndSettle();

    expect(find.text(AppLanguage.en.copySetLabel), findsNothing);
    expect(find.text(AppLanguage.en.addTermLabel), findsNothing);
    expect(find.text(AppLanguage.en.combineSetLabel), findsNothing);
    expect(find.text(AppLanguage.en.resetProgressLabel), findsOneWidget);
    expect(find.text(AppLanguage.en.reportLabel), findsWidgets);
  });

  testWidgets('does not show zero totals while lesson terms are loading', (
    tester,
  ) async {
    final pending = Completer<List<UserLessonTermData>>().future;

    await tester.pumpWidget(buildScreen(const [], termsFuture: pending));
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsWidgets);
    expect(find.text(AppLanguage.en.statsTotalLabel), findsNothing);
    expect(find.text('0'), findsNothing);
  });

  testWidgets('flashcard helper labels meet light-surface AA contrast', (
    tester,
  ) async {
    await tester.pumpWidget(buildScreen([_term(1, '犬', 'dog', reading: 'いぬ')]));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    for (final label in [
      AppLanguage.en.termLabel,
      AppLanguage.en.readingLabel,
      AppLanguage.en.meaningLabel,
    ]) {
      final text = tester
          .widgetList<Text>(find.text(label))
          .firstWhere((text) => text.style?.color != null);
      final color = text.style?.color;
      expect(color, isNotNull, reason: label);
      expect(
        _contrast(color!, AppThemePalette.light.elevated),
        greaterThanOrEqualTo(4.5),
        reason: label,
      );
    }
  });
}
