import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jpstudy/data/models/kanji_item.dart';
import 'package:jpstudy/features/kanji_hub/models/kanji_relationship_graph.dart';
import 'package:jpstudy/features/kanji_hub/widgets/kanji_relationship_graph.dart';

void main() {
  testWidgets('renders focus, related nodes, and toolbar actions', (
    tester,
  ) async {
    final graph = KanjiRelationshipGraphBuilder.build(
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
    final tapped = <String>[];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: KanjiRelationshipGraph(
            graphData: graph,
            srsTiers: const {
              '木': KanjiGraphSrsTier.due,
              '学': KanjiGraphSrsTier.stable,
            },
            onNodeSelected: tapped.add,
            onPracticeCluster: () {},
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('kanji_graph_canvas')), findsOneWidget);
    expect(find.byKey(const ValueKey('kanji_graph_focus_校')), findsOneWidget);
    expect(
      find.byKey(const ValueKey('kanji_graph_node_木_due')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('kanji_graph_node_学_stable')),
      findsOneWidget,
    );
    expect(find.byKey(const ValueKey('kanji_graph_fit')), findsOneWidget);
    expect(find.byKey(const ValueKey('kanji_graph_reset')), findsOneWidget);
    expect(
      find.byKey(const ValueKey('kanji_graph_fullscreen')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('kanji_graph_practice_cluster')),
      findsOneWidget,
    );

    tester
        .widget<FilledButton>(
          find.byKey(const ValueKey('kanji_graph_practice_cluster')),
        )
        .onPressed!();
    expect(tester.getTopLeft(practiceButtonFinder).dy, lessThan(40));

    final node = tester.widget<InkWell>(
      find.byKey(const ValueKey('kanji_graph_node_学_stable')),
    );
    node.onTap!();

    expect(tapped, ['学']);
  });
}

Finder get practiceButtonFinder =>
    find.byKey(const ValueKey('kanji_graph_practice_cluster'));

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
