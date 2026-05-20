import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:jpstudy/app/navigation/app_route_constants.dart';
import 'package:jpstudy/core/app_language.dart';
import 'package:jpstudy/core/language_provider.dart';
import 'package:jpstudy/data/models/kanji_item.dart';
import 'package:jpstudy/features/kanji_hub/models/kanji_practice_args.dart';
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
      late KanjiPracticeArgs practiceArgs;
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
          GoRoute(
            path: AppRoutePath.kanjiPractice,
            name: AppRouteName.kanjiPractice,
            builder: (context, state) {
              practiceArgs = state.extra! as KanjiPracticeArgs;
              return const Scaffold(body: Text('practice route'));
            },
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
          ],
          child: MaterialApp.router(routerConfig: router),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byKey(const ValueKey('kanji_graph_focus_校')), findsOneWidget);
      expect(find.byKey(const ValueKey('kanji_graph_node_木')), findsOneWidget);
      expect(find.byKey(const ValueKey('kanji_graph_node_学')), findsOneWidget);

      tester
          .widget<InkWell>(find.byKey(const ValueKey('kanji_graph_node_学')))
          .onTap!();
      await tester.pumpAndSettle();

      expect(find.byKey(const ValueKey('kanji_graph_focus_学')), findsOneWidget);

      final practiceButton = find.byKey(
        const ValueKey('kanji_graph_practice_cluster'),
      );
      tester.widget<FilledButton>(practiceButton).onPressed!();
      await tester.pumpAndSettle();

      expect(find.text('practice route'), findsOneWidget);
      expect(practiceArgs.source, 'graph_cluster');
      expect(practiceArgs.kanjiIds, containsAll([1, 2, 3]));
      expect(practiceArgs.kanjiCharacters, containsAll(['校', '木', '学']));
      expect(practiceArgs.preferredKanjiId, 3);
      expect(practiceArgs.preferredKanjiCharacter, '学');
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
