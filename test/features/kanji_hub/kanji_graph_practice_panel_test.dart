import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jpstudy/core/app_language.dart';
import 'package:jpstudy/data/models/kanji_item.dart';
import 'package:jpstudy/features/kanji_hub/models/kanji_graph_practice.dart';
import 'package:jpstudy/features/kanji_hub/models/kanji_relationship_graph.dart';
import 'package:jpstudy/features/kanji_hub/widgets/kanji_graph_practice_panel.dart';

void main() {
  test('generates five deterministic graph-cluster questions', () {
    final graph = _graph();
    final session = KanjiGraphPracticeSession.generate(
      graphData: graph,
      language: AppLanguage.vi,
    );

    expect(session.questions, hasLength(5));
    expect(session.questions.first.prompt, contains('Giáo'));
    expect(session.questions.first.correctCharacter, '校');
    expect(session.questions.first.options, hasLength(4));
    expect(session.questions.first.options, contains('校'));
  });

  testWidgets('passes after four correct answers and emits outcome', (
    tester,
  ) async {
    final graph = _graph();
    KanjiGraphPracticeOutcome? outcome;
    final session = KanjiGraphPracticeSession.generate(
      graphData: graph,
      language: AppLanguage.vi,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: KanjiGraphPracticePanel(
            graphData: graph,
            language: AppLanguage.vi,
            onCompleted: (next) => outcome = next,
          ),
        ),
      ),
    );

    for (var index = 0; index < session.questions.length; index++) {
      final question = session.questions[index];
      final answer = index == 4
          ? question.options.firstWhere(
              (option) => option != question.correctCharacter,
            )
          : question.correctCharacter;
      await tester.tap(
        find.byKey(ValueKey('kanji_graph_practice_option_$answer')).first,
      );
      await tester.pump();
      await tester.tap(find.byKey(const ValueKey('kanji_graph_practice_next')));
      await tester.pump();
    }

    expect(outcome, isNotNull);
    expect(outcome!.passed, isTrue);
    expect(outcome!.correctCount, 4);
    expect(
      outcome!.missedCharacters,
      contains(session.questions.last.target.character),
    );
  });
}

KanjiRelationshipGraphData _graph() {
  return KanjiRelationshipGraphBuilder.build(
    focusCharacter: '校',
    allKanji: [
      _kanji(
        id: 1,
        character: '校',
        hanViet: 'Giáo',
        meaning: 'trường học',
        components: ['木', '交'],
        componentNames: ['Mộc', 'Giao'],
        relatedKanji: ['学'],
      ),
      _kanji(id: 2, character: '木', hanViet: 'Mộc', meaning: 'cây'),
      _kanji(id: 3, character: '学', hanViet: 'Học', meaning: 'học'),
    ],
  );
}

KanjiItem _kanji({
  required int id,
  required String character,
  required String hanViet,
  required String meaning,
  List<String> components = const [],
  List<String> componentNames = const [],
  List<String> relatedKanji = const [],
}) {
  return KanjiItem(
    id: id,
    lessonId: 1,
    character: character,
    strokeCount: 1,
    meaning: '$hanViet ($meaning)',
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
