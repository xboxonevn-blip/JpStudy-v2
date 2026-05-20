import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:jpstudy/app/navigation/app_route_constants.dart';
import 'package:jpstudy/core/app_language.dart';
import 'package:jpstudy/core/language_provider.dart';
import 'package:jpstudy/data/db/app_database.dart';
import 'package:jpstudy/data/repositories/grammar_repository.dart';
import 'package:jpstudy/features/conjugation/models/conjugation_practice_args.dart';
import 'package:jpstudy/features/grammar/screens/grammar_detail_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ---------------------------------------------------------------------------
// Fixtures
// ---------------------------------------------------------------------------

const _kGrammarId = 1;

const _stubPoint = GrammarPoint(
  id: _kGrammarId,
  grammarPoint: 'てもいい',
  meaning: 'được phép',
  meaningVi: 'được phép',
  meaningEn: 'is okay to do',
  connection: 'V-て + もいい',
  connectionEn: null,
  explanation: 'Expresses permission to do something.',
  explanationVi: 'Dùng để diễn đạt sự cho phép.',
  explanationEn: 'Use this pattern to express that something is allowed.',
  jlptLevel: 'N5',
  isLearned: false,
);

const _learnedPoint = GrammarPoint(
  id: _kGrammarId,
  grammarPoint: 'てもいい',
  meaning: 'được phép',
  meaningEn: 'is okay to do',
  connection: 'V-て + もいい',
  explanation: 'Expresses permission to do something.',
  jlptLevel: 'N5',
  isLearned: true,
);

const _verbNotationPoint = GrammarPoint(
  id: _kGrammarId,
  grammarPoint: 'てからでないと',
  meaning: 'phải sau khi',
  meaningVi: 'phải sau khi',
  meaningEn: 'not until after',
  connection: 'Verb-て + からでないと',
  connectionEn: 'Verb-て + からでないと',
  explanation: 'Dùng khi phải hoàn thành hành động trước.',
  explanationVi: 'Dùng khi phải hoàn thành hành động trước.',
  explanationEn: 'Use after the verb in て-form.',
  jlptLevel: 'N2',
  isLearned: false,
);

const _stubExample = GrammarExample(
  id: 10,
  grammarId: _kGrammarId,
  japanese: '食べてもいいですか？',
  translation: 'Có thể ăn không?',
  translationVi: 'Có thể ăn không?',
  translationEn: 'May I eat?',
);

typedef _GrammarDetailRecord = ({
  GrammarPoint point,
  List<GrammarExample> examples,
});

// ---------------------------------------------------------------------------
Widget _buildScreen({
  AppLanguage language = AppLanguage.en,
  _GrammarDetailRecord? detail,
  GrammarRepository? repo,
}) {
  final overrides = <Override>[
    appLanguageProvider.overrideWith(
      (ref) => AppLanguageController.test(language),
    ),
    grammarDetailProvider(_kGrammarId).overrideWith((_) async => detail),
    if (repo != null) grammarRepositoryProvider.overrideWithValue(repo),
  ];

  return ProviderScope(
    overrides: overrides,
    child: const MaterialApp(home: GrammarDetailScreen(grammarId: _kGrammarId)),
  );
}

Widget _buildRoutedScreen({
  AppLanguage language = AppLanguage.en,
  required _GrammarDetailRecord detail,
}) {
  final router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) =>
            const GrammarDetailScreen(grammarId: _kGrammarId),
      ),
      GoRoute(
        path: AppRoutePath.grammarConjugationPractice,
        name: AppRouteName.grammarConjugationPractice,
        builder: (context, state) {
          final args = state.extra as ConjugationPracticeArgs;
          return Scaffold(
            body: Text(
              'conjugation:${args.grammarId}:${args.formKeys?.join(',')}',
            ),
          );
        },
      ),
    ],
  );
  return ProviderScope(
    overrides: [
      appLanguageProvider.overrideWith(
        (ref) => AppLanguageController.test(language),
      ),
      grammarDetailProvider(_kGrammarId).overrideWith((_) async => detail),
    ],
    child: MaterialApp.router(routerConfig: router),
  );
}

Future<void> _pump(WidgetTester tester) async {
  await tester.pump();
  for (var i = 0; i < 6; i++) {
    await tester.pump(const Duration(milliseconds: 200));
  }
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('shows "not found" when provider returns null', (tester) async {
    await tester.pumpWidget(_buildScreen(detail: null));
    await _pump(tester);

    expect(find.text('Grammar point not found.'), findsOneWidget);
  });

  testWidgets('renders headline, JLPT badge, connection and explanation', (
    tester,
  ) async {
    await tester.pumpWidget(
      _buildScreen(detail: (point: _stubPoint, examples: const [])),
    );
    await _pump(tester);

    // AppBar title in EN
    expect(find.text('Grammar'), findsWidgets);
    // JLPT badge chip
    expect(find.text('N5'), findsWidgets);
    // EN headline via resolveEnglishGrammarConnection: falls back to connection
    expect(find.textContaining('V-て'), findsWidgets);
    // Explanation section header (uppercased via .toUpperCase())
    expect(find.textContaining('EXPLANATION'), findsOneWidget);
    // Explanation body
    expect(
      find.text('Use this pattern to express that something is allowed.'),
      findsOneWidget,
    );
  });

  testWidgets('renders examples when list is non-empty', (tester) async {
    await tester.pumpWidget(
      _buildScreen(detail: (point: _stubPoint, examples: const [_stubExample])),
    );
    await _pump(tester);

    expect(find.text('食べてもいいですか？'), findsWidgets);
  });

  testWidgets('unlearned point shows practice gate instead of manual mark', (
    tester,
  ) async {
    await tester.pumpWidget(
      _buildScreen(detail: (point: _stubPoint, examples: const [])),
    );
    await _pump(tester);

    expect(find.text('Mark done'), findsNothing);
    expect(find.text('In progress'), findsOneWidget);
    expect(find.text('Practice check'), findsOneWidget);
  });

  testWidgets('learned point shows understood badge and keeps practice entry', (
    tester,
  ) async {
    await tester.pumpWidget(
      _buildScreen(detail: (point: _learnedPoint, examples: const [])),
    );
    await _pump(tester);

    expect(find.text('Mark done'), findsNothing);
    expect(find.text('Understood ✓'), findsOneWidget);
    expect(find.text('Practice check'), findsOneWidget);
  });

  testWidgets('VI locale shows Vietnamese app bar title', (tester) async {
    await tester.pumpWidget(
      _buildScreen(
        language: AppLanguage.vi,
        detail: (point: _stubPoint, examples: const []),
      ),
    );
    await _pump(tester);

    expect(find.text('Điểm ngữ pháp'), findsOneWidget);
  });

  testWidgets('VI te-form point links to scoped conjugation practice', (
    tester,
  ) async {
    await tester.pumpWidget(
      _buildRoutedScreen(
        language: AppLanguage.vi,
        detail: (point: _stubPoint, examples: const [_stubExample]),
      ),
    );
    await _pump(tester);

    expect(find.text('Luyện chia thể liên quan'), findsOneWidget);
    await tester.tap(find.text('Luyện chia thể liên quan'));
    await tester.pumpAndSettle();

    expect(find.text('conjugation:1:te'), findsOneWidget);
  });

  testWidgets('VI Verb-て notation links to related conjugation practice', (
    tester,
  ) async {
    await tester.pumpWidget(
      _buildRoutedScreen(
        language: AppLanguage.vi,
        detail: (point: _verbNotationPoint, examples: const [_stubExample]),
      ),
    );
    await _pump(tester);

    expect(find.text('Luyện chia thể liên quan'), findsOneWidget);
    await tester.tap(find.text('Luyện chia thể liên quan'));
    await tester.pumpAndSettle();

    expect(find.text('conjugation:1:te'), findsOneWidget);
  });

  testWidgets('JA locale shows Japanese app bar title', (tester) async {
    await tester.pumpWidget(
      _buildScreen(
        language: AppLanguage.ja,
        detail: (point: _stubPoint, examples: const []),
      ),
    );
    await _pump(tester);

    expect(find.text('文法ポイント'), findsOneWidget);
  });
}
