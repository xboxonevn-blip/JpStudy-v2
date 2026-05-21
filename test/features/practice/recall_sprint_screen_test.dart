import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:jpstudy/core/app_language.dart';
import 'package:jpstudy/core/language_provider.dart';
import 'package:jpstudy/data/db/app_database.dart';
import 'package:jpstudy/data/db/content_database.dart';
import 'package:jpstudy/data/db/app_database.dart' as app_db;
import 'package:jpstudy/data/repositories/lesson_repository.dart';
import 'package:jpstudy/features/practice/screens/recall_sprint_screen.dart';

// ── Fixtures ─────────────────────────────────────────────────

const _q1 = SprintQuestion(
  term: '水',
  correct: 'water',
  options: ['water', 'fire', 'tree', 'sky'],
);
const _q2 = SprintQuestion(
  term: '火',
  correct: 'fire',
  options: ['water', 'fire', 'tree', 'sky'],
);
const _q3 = SprintQuestion(
  term: '木',
  correct: 'tree',
  options: ['water', 'fire', 'tree', 'sky'],
);

Widget _buildScreen({List<SprintQuestion> questions = const [_q1, _q2, _q3]}) {
  return ProviderScope(
    overrides: [
      appLanguageProvider.overrideWith(
        (ref) => AppLanguageController.test(AppLanguage.en),
      ),
      recallSprintQuestionsProvider.overrideWith((ref) async => questions),
    ],
    child: const MaterialApp(home: RecallSprintScreen()),
  );
}

class _DueTermsRepository extends LessonRepository {
  _DueTermsRepository({
    required AppDatabase appDb,
    required ContentDatabase contentDb,
    required this.dueTerms,
  }) : super(appDb, contentDb);

  final List<app_db.UserLessonTermData> dueTerms;

  @override
  Future<List<app_db.UserLessonTermData>> fetchAllDueTerms() async => dueTerms;
}

app_db.UserLessonTermData _term(
  int id,
  String term,
  String definition,
  String definitionEn,
) => app_db.UserLessonTermData(
  id: id,
  lessonId: 1,
  term: term,
  reading: '',
  definition: definition,
  definitionEn: definitionEn,
  mnemonicVi: '',
  mnemonicEn: '',
  kanjiMeaning: '',
  exampleSentencesJson: '[]',
  isLearned: false,
  isStarred: false,
  orderIndex: id,
);

// ── Tests ────────────────────────────────────────────────────

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('RecallSprintScreen — empty state', () {
    testWidgets('shows not-enough-terms message when questions empty', (
      tester,
    ) async {
      await tester.pumpWidget(_buildScreen(questions: []));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      expect(
        find.text('Study at least 4 terms first to unlock Recall Sprint.'),
        findsOneWidget,
      );
    });
  });

  group('RecallSprintScreen — intro', () {
    testWidgets('shows title and start button on load', (tester) async {
      await tester.pumpWidget(_buildScreen());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.text(AppLanguage.en.practiceRecallSprintLabel), findsWidgets);
      expect(find.text('Start sprint'), findsOneWidget);
    });

    testWidgets('shows batch size label', (tester) async {
      await tester.pumpWidget(_buildScreen());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.text('3 questions from your review queue'), findsOneWidget);
    });
  });

  group('RecallSprintScreen — question flow', () {
    testWidgets('JA mode uses English fallback options, not Vietnamese', (
      tester,
    ) async {
      final appDb = AppDatabase(executor: NativeDatabase.memory());
      final contentDb = ContentDatabase(executor: NativeDatabase.memory());
      addTearDown(appDb.close);
      addTearDown(contentDb.close);
      final repo = _DueTermsRepository(
        appDb: appDb,
        contentDb: contentDb,
        dueTerms: [
          _term(1, '愛', 'yêu', 'love'),
          _term(2, '猫', 'mèo', 'cat'),
          _term(3, '海', 'biển', 'sea'),
          _term(4, '山', 'núi', 'mountain'),
        ],
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appLanguageProvider.overrideWith(
              (ref) => AppLanguageController.test(AppLanguage.ja),
            ),
            lessonRepositoryProvider.overrideWithValue(repo),
          ],
          child: const MaterialApp(home: RecallSprintScreen()),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      await tester.tap(find.text('スプリント開始'));
      await tester.pump();

      expect(find.text('love'), findsOneWidget);
      expect(find.text('cat'), findsOneWidget);
      expect(find.text('sea'), findsOneWidget);
      expect(find.text('mountain'), findsOneWidget);
      expect(find.text('yêu'), findsNothing);
      expect(find.text('mèo'), findsNothing);
      expect(find.text('biển'), findsNothing);
      expect(find.text('núi'), findsNothing);
    });

    testWidgets('tapping Start shows first question', (tester) async {
      await tester.pumpWidget(_buildScreen());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      await tester.tap(find.text('Start sprint'));
      await tester.pump();

      expect(find.text('Question 1 of 3'), findsOneWidget);
      expect(find.textContaining('水'), findsWidgets);
      // All 4 options shown
      expect(find.text('water'), findsOneWidget);
      expect(find.text('fire'), findsOneWidget);
      expect(find.text('tree'), findsOneWidget);
      expect(find.text('sky'), findsOneWidget);
    });

    testWidgets('selecting correct answer shows Nice feedback', (tester) async {
      await tester.pumpWidget(_buildScreen());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      await tester.tap(find.text('Start sprint'));
      await tester.pump();

      await tester.tap(find.text('water'));
      await tester.pump();

      expect(find.text('Nice'), findsOneWidget);
      expect(find.text('That is the right meaning.'), findsOneWidget);
      expect(find.text('Next'), findsOneWidget);
    });

    testWidgets('selecting wrong answer shows Not quite feedback', (
      tester,
    ) async {
      await tester.pumpWidget(_buildScreen());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      await tester.tap(find.text('Start sprint'));
      await tester.pump();

      await tester.tap(find.text('fire')); // wrong for 水
      await tester.pump();

      expect(find.text('Not quite'), findsOneWidget);
      expect(find.textContaining('水 means "water"'), findsOneWidget);
    });

    testWidgets('Next advances to second question', (tester) async {
      await tester.pumpWidget(_buildScreen());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      await tester.tap(find.text('Start sprint'));
      await tester.pump();

      // Answer q1
      await tester.tap(find.text('water'));
      await tester.pump();
      await tester.tap(find.text('Next'));
      await tester.pump();

      expect(find.text('Question 2 of 3'), findsOneWidget);
      expect(find.textContaining('火'), findsWidgets);
    });

    testWidgets('completing all correctly shows sprint complete', (
      tester,
    ) async {
      await tester.pumpWidget(_buildScreen());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      await tester.tap(find.text('Start sprint'));
      await tester.pump();

      // Q1
      await tester.tap(find.text('water'));
      await tester.pump();
      await tester.tap(find.text('Next'));
      await tester.pump();

      // Q2
      await tester.tap(find.text('fire'));
      await tester.pump();
      await tester.tap(find.text('Next'));
      await tester.pump();

      // Q3
      await tester.tap(find.text('tree'));
      await tester.pump();
      await tester.tap(find.text('Next'));
      await tester.pump();

      expect(find.text('Nice run.'), findsOneWidget);
      expect(find.text('Run again'), findsOneWidget);
    });
  });

  group('RecallSprintScreen — retry missed', () {
    testWidgets('enters retry mode when answers were wrong', (tester) async {
      await tester.pumpWidget(_buildScreen());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      await tester.tap(find.text('Start sprint'));
      await tester.pump();

      // Q1 - wrong
      await tester.tap(find.text('fire')); // wrong for 水
      await tester.pump();
      await tester.tap(find.text('Next'));
      await tester.pump();

      // Q2 - correct
      await tester.tap(find.text('fire'));
      await tester.pump();
      await tester.tap(find.text('Next'));
      await tester.pump();

      // Q3 - correct
      await tester.tap(find.text('tree'));
      await tester.pump();
      await tester.tap(find.text('Next'));
      await tester.pump();

      // Now in retry mode - should show the missed question (q1: 水)
      expect(find.text('Retry 1 of 1'), findsOneWidget);
      expect(find.textContaining('水'), findsWidgets);
    });

    testWidgets('completing retry shows completion screen', (tester) async {
      await tester.pumpWidget(_buildScreen());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      await tester.tap(find.text('Start sprint'));
      await tester.pump();

      // Q1 wrong, Q2 correct, Q3 correct
      await tester.tap(find.text('fire'));
      await tester.pump();
      await tester.tap(find.text('Next'));
      await tester.pump();
      await tester.tap(find.text('fire'));
      await tester.pump();
      await tester.tap(find.text('Next'));
      await tester.pump();
      await tester.tap(find.text('tree'));
      await tester.pump();
      await tester.tap(find.text('Next'));
      await tester.pump();

      // In retry - answer correctly this time
      await tester.tap(find.text('water'));
      await tester.pump();
      await tester.tap(find.text('Next'));
      await tester.pump();

      expect(find.text('Nice run.'), findsOneWidget);
    });
  });

  group('RecallSprintScreen — restart', () {
    testWidgets('Run again restarts at question 1', (tester) async {
      await tester.pumpWidget(_buildScreen());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      await tester.tap(find.text('Start sprint'));
      await tester.pump();

      // Answer all correctly
      await tester.tap(find.text('water'));
      await tester.pump();
      await tester.tap(find.text('Next'));
      await tester.pump();
      await tester.tap(find.text('fire'));
      await tester.pump();
      await tester.tap(find.text('Next'));
      await tester.pump();
      await tester.tap(find.text('tree'));
      await tester.pump();
      await tester.tap(find.text('Next'));
      await tester.pump();

      // Tap restart — goes back to question 1 (not intro, since _started stays true)
      await tester.tap(find.text('Run again'));
      await tester.pump();

      expect(find.text('Question 1 of 3'), findsOneWidget);
    });
  });
}
