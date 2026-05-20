import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:jpstudy/app/navigation/app_route_constants.dart';
import 'package:jpstudy/core/app_language.dart';
import 'package:jpstudy/core/language_provider.dart';
import 'package:jpstudy/data/db/content_database.dart';
import 'package:jpstudy/features/vocab/providers/vocab_detail_provider.dart';
import 'package:jpstudy/features/vocab/screens/vocab_detail_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ---------------------------------------------------------------------------
// Fixtures
// ---------------------------------------------------------------------------

const _kVocabId = 42;
const _kKanjiId = 7;

const _stubVocab = VocabData(
  id: _kVocabId,
  term: '食べる',
  reading: 'たべる',
  meaning: 'ăn',
  meaningEn: 'to eat',
  series: 'minna',
  level: 'N5',
);

const _godanRuVocab = VocabData(
  id: _kVocabId,
  term: '帰る',
  reading: 'かえる',
  meaning: 'về',
  meaningEn: 'to return',
  series: 'hajimete',
  level: 'N5',
);

const _godanRuLemma = ConjugationLemmaData(
  id: 9001,
  contentVocabId: _kVocabId,
  contentEntryId: 'entry_42',
  term: '帰る',
  reading: 'かえる',
  dictionaryForm: '帰る',
  dictionaryReading: 'かえる',
  kind: 'verb',
  conjugationClass: 'godanRu',
  posTagsJson: '[]',
  jmdictEntrySeq: '9001',
  sourceVocabId: 'src_42',
  sourceSenseId: 'sense_42',
  level: 'N5',
  series: 'hajimete',
  lessonId: 1,
  matchMethod: 'test',
);

const _stubKanji = KanjiData(
  id: _kKanjiId,
  lessonId: 1,
  character: '食',
  strokeCount: 9,
  onyomi: 'ショク',
  kunyomi: 'た.べる',
  meaning: 'ăn',
  examplesJson: '[]',
  jlptLevel: 'N5',
);

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

Widget _buildRouterScreen({
  required VocabDetail? detail,
  AppLanguage language = AppLanguage.en,
}) {
  final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) =>
            const VocabDetailScreen(vocabId: _kVocabId),
      ),
      GoRoute(
        path: '/kanji',
        builder: (context, state) => Scaffold(
          body: Center(
            child: Text('KANJI_ID=${state.uri.queryParameters['kanjiId']}'),
          ),
        ),
      ),
      GoRoute(
        path: AppRoutePath.grammarConjugationWord,
        name: AppRouteName.grammarConjugationWord,
        builder: (context, state) => Scaffold(
          body: Center(
            child: Text(
              'CONJ=${state.pathParameters['contentVocabId']}',
            ),
          ),
        ),
      ),
    ],
  );

  return ProviderScope(
    overrides: [
      appLanguageProvider.overrideWith(
        (ref) => AppLanguageController.test(language),
      ),
      vocabDetailProvider(_kVocabId).overrideWith((_) async => detail),
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

  testWidgets('shows "Word not found" when provider returns null', (
    tester,
  ) async {
    await tester.pumpWidget(_buildRouterScreen(detail: null));
    await _pump(tester);

    expect(find.text('Word not found'), findsOneWidget);
  });

  testWidgets('renders word term and reading when vocab has no kanji', (
    tester,
  ) async {
    const detail = VocabDetail(
      vocab: _stubVocab,
      kanjiList: [],
      relatedVocab: [],
    );
    await tester.pumpWidget(_buildRouterScreen(detail: detail));
    await _pump(tester);

    expect(find.text('食べる'), findsWidgets); // term appears in title + body
    expect(find.byType(VocabDetailScreen), findsOneWidget);
  });

  testWidgets('kanji row is rendered when kanjiList is non-empty', (
    tester,
  ) async {
    const detail = VocabDetail(
      vocab: _stubVocab,
      kanjiList: [_stubKanji],
      relatedVocab: [],
    );
    await tester.pumpWidget(_buildRouterScreen(detail: detail));
    await _pump(tester);

    // The kanji character should appear in the kanji row
    expect(find.text('食'), findsWidgets);
  });

  testWidgets('tapping kanji row navigates to /kanji/:id', (tester) async {
    // Large viewport so all content renders without scrolling past limits.
    tester.view.physicalSize = const Size(1440, 1400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    const detail = VocabDetail(
      vocab: _stubVocab,
      kanjiList: [_stubKanji],
      relatedVocab: [],
    );
    await tester.pumpWidget(_buildRouterScreen(detail: detail));
    await tester.pumpAndSettle();

    // Scroll until the isolated kanji character is visible
    await tester.ensureVisible(find.text('食'));
    await tester.pumpAndSettle();

    expect(find.text('食'), findsOneWidget);

    await tester.tap(find.text('食'), warnIfMissed: false);
    await tester.pumpAndSettle();

    // Navigation pushes /kanji/7; the destination scaffold renders on top
    expect(find.text('KANJI_ID=$_kKanjiId'), findsOneWidget);
  });

  testWidgets('renders study pack examples and collocations', (
    tester,
  ) async {
    const detail = VocabDetail(
      vocab: _stubVocab,
      kanjiList: [_stubKanji],
      relatedVocab: [],
    );
    await tester.pumpWidget(
      _buildRouterScreen(detail: detail, language: AppLanguage.vi),
    );
    await _pump(tester);

    expect(find.text('Gói học nhanh'), findsOneWidget);
    expect(find.text('Ví dụ'), findsOneWidget);
    expect(find.text('Cụm đi với từ'), findsOneWidget);
    expect(find.text('ご飯を食べる'), findsOneWidget);
  });

  testWidgets('hides conjugation forms without a sourced lemma', (
    tester,
  ) async {
    const detail = VocabDetail(
      vocab: _stubVocab,
      kanjiList: [_stubKanji],
      relatedVocab: [],
    );
    await tester.pumpWidget(
      _buildRouterScreen(detail: detail, language: AppLanguage.vi),
    );
    await _pump(tester);

    expect(find.text('Chia động từ'), findsNothing);
    expect(find.textContaining('食べます'), findsNothing);
    expect(find.text('Ngữ pháp 〜ます'), findsNothing);
  });

  testWidgets('renders sourced godan forms and opens scoped practice', (
    tester,
  ) async {
    const detail = VocabDetail(
      vocab: _godanRuVocab,
      kanjiList: [],
      relatedVocab: [],
      conjugationLemma: _godanRuLemma,
    );
    await tester.pumpWidget(
      _buildRouterScreen(detail: detail, language: AppLanguage.vi),
    );
    await _pump(tester);

    expect(find.text('Chia động từ'), findsOneWidget);
    expect(find.textContaining('帰って'), findsOneWidget);
    expect(find.textContaining('帰て'), findsNothing);
    expect(find.text('Luyện chia thể'), findsOneWidget);

    await tester.tap(find.text('Luyện chia thể'));
    await tester.pumpAndSettle();

    expect(find.text('CONJ=$_kVocabId'), findsOneWidget);
  });

  testWidgets('VI locale shows Vietnamese app bar title', (tester) async {
    const detail = VocabDetail(
      vocab: _stubVocab,
      kanjiList: [],
      relatedVocab: [],
    );
    await tester.pumpWidget(
      _buildRouterScreen(detail: detail, language: AppLanguage.vi),
    );
    await _pump(tester);

    expect(find.text('Chi tiết từ'), findsOneWidget);
  });
}
