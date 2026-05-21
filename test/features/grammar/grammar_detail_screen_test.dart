import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:jpstudy/app/navigation/app_route_constants.dart';
import 'package:jpstudy/core/app_language.dart';
import 'package:jpstudy/core/language_provider.dart';
import 'package:jpstudy/data/db/app_database.dart';
import 'package:jpstudy/data/models/grammar_directive_e_content.dart';
import 'package:jpstudy/data/repositories/grammar_repository.dart';
import 'package:jpstudy/features/conjugation/models/conjugation_practice_args.dart';
import 'package:jpstudy/features/grammar/screens/grammar_detail_screen.dart';
import 'package:jpstudy/features/interlink/models/interlink_graph.dart';
import 'package:jpstudy/features/interlink/providers/interlink_graph_provider.dart';
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

const _stubDirectiveE = GrammarDirectiveEContent(
  form: 'Hình thức: V-て + もいい',
  meaning: 'Ý nghĩa: được phép làm hành động V.',
  usage: 'Sử dụng: hỏi hoặc nói về sự cho phép trong tình huống cụ thể.',
  etymology: 'てもいい ghép thể て với もいい để mở cửa cho hành động phía trước.',
  hanVietBridge: 'Cầu Hán-Việt: nhớ bằng ý cho phép, không phải dịch từng chữ.',
  humanMoment: 'Dr. Linh lưu ý: với てもいい, cánh cửa hành động đang được mở ra.',
  crossLinks: [
    GrammarDirectiveECrossLink(
      pattern: 'てはいけない',
      contrast: 'てもいい cho phép; てはいけない cấm hành động đó.',
    ),
  ],
  fallbackReference: GrammarDirectiveEFallbackReference(
    sourceCredit: "Tae Kim's Guide to Japanese Grammar",
    license: 'CC-BY-NC-SA 3.0',
    sourceUrl: 'https://guidetojapanese.org/learn/grammar',
  ),
);

List<GrammarExample> _manyExamples() {
  return List<GrammarExample>.generate(
    10,
    (index) => GrammarExample(
      id: 100 + index,
      grammarId: _kGrammarId,
      japanese: '例文${index + 1}です。',
      translation: 'Câu ví dụ ${index + 1}.',
      translationVi: 'Câu ví dụ ${index + 1}.',
      translationEn: 'Example sentence ${index + 1}.',
    ),
  );
}

typedef _GrammarDetailRecord = ({
  GrammarPoint point,
  List<GrammarExample> examples,
  GrammarDirectiveEContent? directiveE,
});

_GrammarDetailRecord _detail({
  GrammarPoint point = _stubPoint,
  List<GrammarExample> examples = const [],
  GrammarDirectiveEContent? directiveE,
}) {
  return (point: point, examples: examples, directiveE: directiveE);
}

// ---------------------------------------------------------------------------
Widget _buildScreen({
  AppLanguage language = AppLanguage.en,
  _GrammarDetailRecord? detail,
  GrammarRepository? repo,
  InterlinkGraph? interlinkGraph,
}) {
  final overrides = <Override>[
    appLanguageProvider.overrideWith(
      (ref) => AppLanguageController.test(language),
    ),
    grammarDetailProvider(_kGrammarId).overrideWith((_) async => detail),
    if (repo != null) grammarRepositoryProvider.overrideWithValue(repo),
    if (interlinkGraph != null)
      interlinkGraphProvider.overrideWith((_) async => interlinkGraph),
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
    await tester.pumpWidget(_buildScreen(detail: _detail()));
    await _pump(tester);

    // AppBar title in EN
    expect(find.text('Grammar'), findsWidgets);
    // JLPT badge chip
    expect(find.text('N5'), findsWidgets);
    // EN headline via resolveEnglishGrammarConnection: falls back to connection
    expect(find.textContaining('V-て'), findsWidgets);
    expect(find.text('Core pattern'), findsOneWidget);
    expect(find.text('Structure'), findsOneWidget);
    expect(find.text('Meaning'), findsOneWidget);
    expect(find.text('Usage'), findsOneWidget);
    expect(
      find.text('Use this pattern to express that something is allowed.'),
      findsOneWidget,
    );
  });

  testWidgets('renders examples when list is non-empty', (tester) async {
    await tester.pumpWidget(
      _buildScreen(detail: _detail(examples: const [_stubExample])),
    );
    await _pump(tester);

    expect(find.text('食べてもいいですか？'), findsWidgets);
  });

  testWidgets('VI detail progressively discloses Directive E depth', (
    tester,
  ) async {
    await tester.pumpWidget(
      _buildScreen(
        language: AppLanguage.vi,
        detail: _detail(
          examples: const [_stubExample],
          directiveE: _stubDirectiveE,
        ),
      ),
    );
    await _pump(tester);

    expect(find.text('Cấu trúc'), findsOneWidget);
    expect(find.text('Ý nghĩa'), findsOneWidget);
    expect(find.text('Cách dùng'), findsOneWidget);
    expect(find.textContaining('Gốc rễ'), findsNothing);
    expect(find.textContaining('Lưu ý từ Dr. Linh'), findsNothing);
    expect(find.text('KẾT NỐI'), findsNothing);

    await tester.ensureVisible(find.text('Tìm hiểu sâu hơn'));
    await tester.tap(find.text('Tìm hiểu sâu hơn'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Gốc rễ'), findsWidgets);
    expect(find.textContaining('cánh cửa hành động'), findsOneWidget);
    expect(find.textContaining('Lưu ý từ Dr. Linh'), findsWidgets);
    expect(find.text('Mẫu liên quan'), findsOneWidget);
    expect(find.textContaining('てもいい cho phép'), findsOneWidget);
    expect(
      find.textContaining("Tae Kim's Guide to Japanese Grammar"),
      findsOneWidget,
    );
  });

  testWidgets('long example lists are collapsed until requested', (
    tester,
  ) async {
    final examples = _manyExamples();
    await tester.pumpWidget(_buildScreen(detail: _detail(examples: examples)));
    await _pump(tester);

    expect(find.text('Show examples'), findsOneWidget);
    expect(find.text('例文1です。'), findsNothing);

    await tester.ensureVisible(find.text('Show examples'));
    await tester.tap(find.text('Show examples'));
    await tester.pumpAndSettle();

    expect(find.text('例文1です。'), findsOneWidget);
    expect(find.text('例文10です。'), findsOneWidget);
  });

  testWidgets('unlearned point shows practice gate instead of manual mark', (
    tester,
  ) async {
    await tester.pumpWidget(_buildScreen(detail: _detail()));
    await _pump(tester);

    expect(find.text('Mark done'), findsNothing);
    expect(find.text('In progress'), findsOneWidget);
    expect(find.text('Practice check'), findsOneWidget);
  });

  testWidgets('learned point shows understood badge and keeps practice entry', (
    tester,
  ) async {
    await tester.pumpWidget(
      _buildScreen(detail: _detail(point: _learnedPoint)),
    );
    await _pump(tester);

    expect(find.text('Mark done'), findsNothing);
    expect(find.text('Understood ✓'), findsOneWidget);
    expect(find.text('Practice check'), findsOneWidget);
  });

  testWidgets('VI locale shows Vietnamese app bar title', (tester) async {
    await tester.pumpWidget(
      _buildScreen(language: AppLanguage.vi, detail: _detail()),
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
        detail: _detail(examples: const [_stubExample]),
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
        detail: _detail(
          point: _verbNotationPoint,
          examples: const [_stubExample],
        ),
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
      _buildScreen(language: AppLanguage.ja, detail: _detail()),
    );
    await _pump(tester);

    expect(find.text('文法ポイント'), findsOneWidget);
  });

  testWidgets('renders interlink related section for grammar detail', (
    tester,
  ) async {
    final graph = InterlinkGraph.fromJson(const {
      'nodeFields': ['id', 'type', 'level', 'label', 'route'],
      'edgeRelTypes': ['uses_vocab'],
      'edgeEvidenceTypes': ['test'],
      'nodes': [
        ['grammar:n5:minna_1_1', 'grammar', 'N5', 'てもいい', '/grammar'],
        ['vocab:n5:taberu', 'vocab', 'N5', '食べる', '/vocab'],
      ],
      'edges': [
        [0, 1, 0, 1.0, 0],
      ],
    });

    await tester.pumpWidget(
      _buildScreen(
        language: AppLanguage.vi,
        detail: _detail(examples: const [_stubExample]),
        interlinkGraph: graph,
      ),
    );
    await _pump(tester);

    expect(find.text('Liên quan'), findsOneWidget);
    expect(find.text('Từ vựng chứa mục này'), findsOneWidget);
    expect(find.text('食べる'), findsOneWidget);
  });
}
