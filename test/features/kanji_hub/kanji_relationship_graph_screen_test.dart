import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:jpstudy/app/navigation/app_route_constants.dart';
import 'package:jpstudy/core/app_language.dart';
import 'package:jpstudy/core/language_provider.dart';
import 'package:jpstudy/data/models/kanji_item.dart';
import 'package:jpstudy/features/kanji_hub/models/kanji_graph_practice.dart';
import 'package:jpstudy/features/kanji_hub/models/kanji_relationship_graph.dart';
import 'package:jpstudy/features/kanji_hub/providers/kanji_relationship_graph_provider.dart';
import 'package:jpstudy/features/kanji_hub/screens/kanji_relationship_graph_screen.dart';

class _FakeGraphAssetLoader extends KanjiRelationshipGraphAssetLoader {
  _FakeGraphAssetLoader();

  @override
  Future<List<KanjiItem>> loadAllKanji() async {
    return [
      _kanji(
        id: 1,
        character: '校',
        hanViet: 'Giáo',
        components: ['木', '交'],
        componentNames: ['Mộc', 'Giao'],
        relatedKanji: ['学'],
      ),
      _kanji(id: 2, character: '木', hanViet: 'Mộc'),
      _kanji(id: 3, character: '学', hanViet: 'Học', relatedKanji: ['校']),
    ];
  }
}

void main() {
  testWidgets(
    'graph route navigates between nodes and starts cluster practice',
    (tester) async {
      KanjiGraphPracticeOutcome? recordedOutcome;
      final router = GoRouter(
        initialLocation: '/kanji/校/graph',
        routes: [
          GoRoute(
            path: AppRoutePath.kanjiGraph,
            name: AppRouteName.kanjiGraph,
            builder: (context, state) => KanjiRelationshipGraphScreen(
              character: state.pathParameters['character']!,
            ),
          ),
        ],
      );

      await tester.pumpWidget(
        ProviderScope(
          retry: (retryCount, error) => null,
          overrides: [
            appLanguageProvider.overrideWith(
              (ref) => AppLanguageController.test(AppLanguage.vi),
            ),
            kanjiRelationshipGraphAssetLoaderProvider.overrideWithValue(
              _FakeGraphAssetLoader(),
            ),
            kanjiGraphPracticeRecorderProvider.overrideWithValue(
              KanjiGraphPracticeRecorder.forTesting(
                onRecord: (graphData, outcome) async {
                  recordedOutcome = outcome;
                },
              ),
            ),
          ],
          child: MaterialApp.router(routerConfig: router),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byKey(const ValueKey('kanji_graph_focus_校')), findsOneWidget);
      expect(
        find.byKey(const ValueKey('kanji_graph_node_木_unseen')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey('kanji_graph_node_学_unseen')),
        findsOneWidget,
      );

      tester
          .widget<InkWell>(
            find.byKey(const ValueKey('kanji_graph_node_学_unseen')),
          )
          .onTap!();
      await tester.pumpAndSettle();

      expect(find.byKey(const ValueKey('kanji_graph_focus_学')), findsOneWidget);

      await tester.tap(
        find.byKey(const ValueKey('kanji_graph_practice_cluster')),
      );
      await tester.pumpAndSettle();

      expect(
        find.byKey(const ValueKey('kanji_graph_practice_panel')),
        findsOneWidget,
      );

      final session = KanjiGraphPracticeSession.generate(
        graphData: KanjiRelationshipGraphBuilder.build(
          focusCharacter: '学',
          allKanji: await _FakeGraphAssetLoader().loadAllKanji(),
        ),
        language: AppLanguage.vi,
      );
      for (final question in session.questions) {
        await tester.tap(
          find
              .byKey(
                ValueKey(
                  'kanji_graph_practice_option_${question.correctCharacter}',
                ),
              )
              .first,
        );
        await tester.pump();
        await tester.tap(
          find.byKey(const ValueKey('kanji_graph_practice_next')),
        );
        await tester.pumpAndSettle();
      }

      expect(recordedOutcome, isNotNull);
      expect(recordedOutcome!.passed, isTrue);
    },
  );
}

KanjiItem _kanji({
  required int id,
  required String character,
  required String hanViet,
  List<String> components = const [],
  List<String> componentNames = const [],
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
      componentNames: componentNames,
      relatedKanji: relatedKanji,
    ),
  );
}
