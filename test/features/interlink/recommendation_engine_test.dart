import 'package:flutter_test/flutter_test.dart';
import 'package:jpstudy/features/interlink/models/interlink_graph.dart';
import 'package:jpstudy/features/interlink/services/recommendation_engine.dart';

void main() {
  test('lesson completion recommendations prioritize due related nodes', () {
    final graph = InterlinkGraph.fromJson({
      'nodes': [
        ['vocab:n5:mina:01:水', 'vocab', 'N5', '水', '/vocab/1'],
        ['kanji:n5:k001', 'kanji', 'N5', '水', '/kanji/%E6%B0%B4/graph'],
        ['reading:n5:001', 'reading', 'N5', '水の店', '/jlpt/reading'],
        ['conjugation:n5:飲む', 'conjugation', 'N5', '飲む', '/grammar/conjugation/1'],
      ],
      'edgeRelTypes': ['contains_kanji', 'reading_uses_kanji', 'has_conjugation'],
      'edgeEvidenceTypes': ['test'],
      'edges': [
        [0, 1, 0, 1.0, 0],
        [0, 2, 1, 0.6, 0],
        [0, 3, 2, 0.4, 0],
      ],
    });

    final recommendations = const RecommendationEngine().afterLessonComplete(
      graph: graph,
      learnedNodeIds: const ['vocab:n5:mina:01:水'],
      dueNodeIds: const {'kanji:n5:k001'},
      nextLessonLabel: 'Minna N5 Lesson 2',
      nextLessonRoute: '/lesson/2?level=N5',
    );

    expect(recommendations, hasLength(3));
    expect(recommendations[0].type, RecommendationType.srsDue);
    expect(recommendations[0].route, '/kanji/%E6%B0%B4/graph');
    expect(recommendations[1].type, RecommendationType.nextLesson);
    expect(recommendations[1].route, '/lesson/2?level=N5');
    expect(recommendations[2].type, RecommendationType.related);
  });

  test('lesson completion recommendations fill empty graph with actions', () {
    final graph = InterlinkGraph.fromJson({
      'nodes': <Object?>[],
      'edgeRelTypes': <Object?>[],
      'edgeEvidenceTypes': <Object?>[],
      'edges': <Object?>[],
    });

    final recommendations = const RecommendationEngine().afterLessonComplete(
      graph: graph,
      learnedNodeIds: const [],
      dueNodeIds: const {},
      nextLessonLabel: 'Next lesson',
      nextLessonRoute: '/lesson/2',
    );

    expect(recommendations.map((item) => item.route), [
      '/lesson/2',
      '/review',
      '/immersion',
    ]);
  });
}
