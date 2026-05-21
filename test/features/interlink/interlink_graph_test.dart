import 'package:flutter_test/flutter_test.dart';
import 'package:jpstudy/features/interlink/models/interlink_graph.dart';

void main() {
  test(
    'InterlinkGraph decodes compact indexed graph and returns related rows',
    () {
      final graph = InterlinkGraph.fromJson(const {
        'nodeFields': ['id', 'type', 'level', 'label', 'route'],
        'edgeRelTypes': ['contains_kanji', 'contained_in_vocab'],
        'edgeEvidenceTypes': ['test'],
        'nodes': [
          ['vocab:n5:v1', 'vocab', 'N5', '私', '/vocab'],
          ['kanji:n5:k1', 'kanji', 'N5', '私', '/kanji/%E7%A7%81/graph'],
        ],
        'edges': [
          [0, 1, 0, 1.0, 0],
          [1, 0, 1, 1.0, 0],
        ],
      });

      expect(graph.nodes, hasLength(2));
      expect(graph.related('vocab:n5:v1'), hasLength(1));
      expect(graph.related('vocab:n5:v1').single.rel, 'contains_kanji');
      expect(
        graph.findNode(type: 'kanji', level: 'N5', label: '私')?.id,
        'kanji:n5:k1',
      );
    },
  );

  test('InterlinkGraph groups related rows by learner-facing section', () {
    final graph = InterlinkGraph.fromJson(const {
      'nodeFields': ['id', 'type', 'level', 'label', 'route'],
      'edgeRelTypes': ['contains_kanji', 'has_conjugation'],
      'edgeEvidenceTypes': ['test'],
      'nodes': [
        ['vocab:n5:v1', 'vocab', 'N5', '食べる', '/vocab'],
        ['kanji:n5:k1', 'kanji', 'N5', '食', '/kanji/%E9%A3%9F/graph'],
        [
          'conjugation:n5:c1',
          'conjugation',
          'N5',
          '食べる',
          '/grammar/conjugation',
        ],
      ],
      'edges': [
        [0, 1, 0, 1.0, 0],
        [0, 2, 1, 0.9, 0],
      ],
    });

    final sections = graph.relatedSections('vocab:n5:v1');

    expect(sections.map((section) => section.kind), [
      RelatedSectionKind.kanji,
      RelatedSectionKind.conjugation,
    ]);
  });
}
