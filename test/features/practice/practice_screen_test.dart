import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jpstudy/app/theme/app_spacing.dart';
import 'package:jpstudy/core/app_language.dart';
import 'package:jpstudy/core/language_provider.dart';
import 'package:jpstudy/core/level_provider.dart';
import 'package:jpstudy/core/study_level.dart';
import 'package:jpstudy/features/grammar/grammar_providers.dart';
import 'package:jpstudy/features/home/providers/dashboard_provider.dart';
import 'package:jpstudy/features/home/providers/continue_provider.dart';
import 'package:jpstudy/features/home/providers/weakness_radar_provider.dart';
import 'package:jpstudy/data/models/kanji_item.dart';
import 'package:jpstudy/features/kanji_hub/models/kanji_relationship_graph.dart';
import 'package:jpstudy/features/kanji_hub/providers/kanji_relationship_graph_provider.dart';
import 'package:jpstudy/features/practice/practice_screen.dart';

const _kDashboard = DashboardState(
  streak: 3,
  todayXp: 10,
  vocabDue: 5,
  grammarDue: 2,
  kanjiDue: 1,
  vocabMistakeCount: 1,
  grammarMistakeCount: 0,
  kanjiMistakeCount: 0,
  totalMistakeCount: 1,
);

Widget _buildScreen({
  AppLanguage language = AppLanguage.en,
  DashboardState dashboard = _kDashboard,
  ContinueAction? continueAction,
  List<WeaknessRadarItem> weaknessItems = const [],
  int grammarGhostCount = 0,
}) {
  return ProviderScope(
    overrides: [
      appLanguageProvider.overrideWith(
        (ref) => AppLanguageController.test(language),
      ),
      studyLevelProvider.overrideWith((ref) => StudyLevel.n5),
      dashboardProvider.overrideWith((ref) => Stream.value(dashboard)),
      continueActionProvider.overrideWith(
        (ref) async =>
            continueAction ??
            const ContinueAction(
              type: ContinueActionType.grammarReview,
              label: 'Review grammar',
              count: 2,
              data: [11, 12],
            ),
      ),
      weaknessRadarProvider.overrideWith((ref) async => weaknessItems),
      grammarGhostCountProvider.overrideWith((ref) async* {
        yield grammarGhostCount;
      }),
      dueKanjiMiniGraphProvider.overrideWith((ref) async => _dueKanjiGraph()),
    ],
    child: const MaterialApp(home: PracticeScreen()),
  );
}

void main() {
  group('PracticeScreen — rendering', () {
    testWidgets('shows app bar with Review title', (tester) async {
      await tester.pumpWidget(_buildScreen());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.text('Review'), findsOneWidget);
    });

    testWidgets('shows search icon button', (tester) async {
      await tester.pumpWidget(_buildScreen());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byIcon(Icons.search_rounded), findsOneWidget);
    });

    testWidgets('renders practice destination tiles', (tester) async {
      tester.view.physicalSize = const Size(1440, 2560);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(_buildScreen());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Should show standard practice destinations
      expect(find.text(AppLanguage.en.practiceMatchLabel), findsWidgets);
    });

    testWidgets('shows a session plan instead of a generic goals grid', (
      tester,
    ) async {
      await tester.pumpWidget(_buildScreen());
      await tester.pumpAndSettle();

      expect(find.text('Today plan'), findsOneWidget);
      expect(find.text('Run Recall Sprint first'), findsWidgets);
      expect(find.text('Clear due grammar'), findsAtLeastNWidgets(1));
      expect(find.text('Focus tools'), findsOneWidget);
    });

    testWidgets('Vietnamese plan caption uses natural learner copy', (
      tester,
    ) async {
      await tester.pumpWidget(_buildScreen(language: AppLanguage.vi));
      await tester.pumpAndSettle();

      expect(find.textContaining('giữ trí nhớ'), findsOneWidget);
      expect(find.textContaining('chặn rơi'), findsNothing);
      expect(find.textContaining('vá điểm yếu'), findsNothing);
    });

    testWidgets('surfaces grammar ghost repair when no due queue is waiting', (
      tester,
    ) async {
      await tester.pumpWidget(
        _buildScreen(
          dashboard: const DashboardState(
            streak: 0,
            todayXp: 0,
            vocabDue: 0,
            grammarDue: 0,
            kanjiDue: 0,
            vocabMistakeCount: 0,
            grammarMistakeCount: 0,
            kanjiMistakeCount: 0,
            totalMistakeCount: 0,
          ),
          continueAction: const ContinueAction(
            type: ContinueActionType.practiceMixed,
            label: 'Practice',
          ),
          grammarGhostCount: 3,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Repair grammar ghosts'), findsWidgets);
      expect(find.text('Queue and repair'), findsOneWidget);
    });

    testWidgets('renders with zero-due dashboard', (tester) async {
      await tester.pumpWidget(
        _buildScreen(
          dashboard: const DashboardState(
            streak: 0,
            todayXp: 0,
            vocabDue: 0,
            grammarDue: 0,
            kanjiDue: 0,
            vocabMistakeCount: 0,
            grammarMistakeCount: 0,
            kanjiMistakeCount: 0,
            totalMistakeCount: 0,
          ),
          continueAction: const ContinueAction(
            type: ContinueActionType.nextLesson,
            label: 'Lesson 12',
            data: 12,
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      // Screen renders without error
      expect(find.byType(PracticeScreen), findsOneWidget);
    });

    testWidgets('session step CTA keeps a 44px touch target', (tester) async {
      await tester.pumpWidget(_buildScreen());
      await tester.pumpAndSettle();

      final cta = find.byKey(
        const ValueKey('practice_session_step_cta_grammar_due'),
      );
      await tester.ensureVisible(cta);
      final size = tester.getSize(cta);
      expect(size.width, greaterThanOrEqualTo(AppTouchTargets.min));
      expect(size.height, greaterThanOrEqualTo(AppTouchTargets.min));
    });

    testWidgets('shows a due-kanji mini graph on the review plan', (
      tester,
    ) async {
      await tester.pumpWidget(
        _buildScreen(
          dashboard: const DashboardState(
            streak: 0,
            todayXp: 0,
            vocabDue: 0,
            grammarDue: 0,
            kanjiDue: 3,
            vocabMistakeCount: 0,
            grammarMistakeCount: 0,
            kanjiMistakeCount: 0,
            totalMistakeCount: 0,
          ),
          continueAction: const ContinueAction(
            type: ContinueActionType.kanjiReview,
            label: 'Review kanji',
            count: 3,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.byKey(const ValueKey('kanji_mini_graph_thumbnail')),
        findsOneWidget,
      );
      expect(find.text('校'), findsWidgets);
      expect(find.text('学'), findsWidgets);
    });
  });
}

KanjiRelationshipGraphData _dueKanjiGraph() {
  return KanjiRelationshipGraphBuilder.build(
    focusCharacter: '校',
    allKanji: [
      _kanji(
        id: 1,
        character: '校',
        hanViet: 'Giáo',
        components: ['木', '交'],
        relatedKanji: ['学'],
      ),
      _kanji(id: 2, character: '木', hanViet: 'Mộc'),
      _kanji(id: 3, character: '学', hanViet: 'Học'),
    ],
  );
}

KanjiItem _kanji({
  required int id,
  required String character,
  required String hanViet,
  List<String> components = const [],
  List<String> relatedKanji = const [],
}) {
  return KanjiItem(
    id: id,
    lessonId: 1,
    character: character,
    strokeCount: 1,
    meaning: hanViet,
    examples: const [],
    jlptLevel: 'N5',
    decomposition: KanjiDecomposition(
      hanViet: hanViet,
      components: components,
      relatedKanji: relatedKanji,
    ),
  );
}
