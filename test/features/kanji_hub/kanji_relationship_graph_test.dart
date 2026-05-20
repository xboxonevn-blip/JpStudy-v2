import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jpstudy/data/models/kanji_item.dart';
import 'package:jpstudy/features/kanji_hub/models/kanji_relationship_graph.dart';
import 'package:jpstudy/features/kanji_hub/providers/kanji_relationship_graph_provider.dart';

void main() {
  test('builds focus, component, related, and outside-app nodes', () {
    final graph = KanjiRelationshipGraphBuilder.build(
      focusCharacter: '校',
      allKanji: [
        _kanji(
          id: 1,
          character: '校',
          hanViet: 'Giáo',
          components: ['木', '交'],
          componentNames: ['Mộc', 'Giao'],
          relatedKanji: ['木', '学'],
        ),
        _kanji(id: 2, character: '木', hanViet: 'Mộc'),
        _kanji(id: 3, character: '学', hanViet: 'Học'),
      ],
    );

    expect(graph.focus.character, '校');
    expect(
      graph.nodes.map((node) => node.character),
      containsAll(['校', '木', '交', '学']),
    );
    expect(graph.nodes.where((node) => node.character == '木'), hasLength(1));
    expect(graph.nodeFor('校')!.type, KanjiGraphNodeType.focus);
    expect(graph.nodeFor('木')!.type, KanjiGraphNodeType.component);
    expect(graph.nodeFor('交')!.type, KanjiGraphNodeType.outsideApp);
    expect(graph.nodeFor('学')!.type, KanjiGraphNodeType.related);

    expect(
      graph.edges,
      contains(
        isA<KanjiGraphEdge>()
            .having((edge) => edge.source.character, 'source', '木')
            .having((edge) => edge.target.character, 'target', '校')
            .having(
              (edge) => edge.type,
              'type',
              KanjiGraphEdgeType.componentOf,
            ),
      ),
    );
    expect(
      graph.edges,
      contains(
        isA<KanjiGraphEdge>()
            .having((edge) => edge.source.character, 'source', '校')
            .having((edge) => edge.target.character, 'target', '学')
            .having((edge) => edge.type, 'type', KanjiGraphEdgeType.related),
      ),
    );
  });

  test('caps depth-two graph size while keeping focus first', () {
    final related = List.generate(20, (index) => '関$index');
    final graph = KanjiRelationshipGraphBuilder.build(
      focusCharacter: '親',
      maxNodes: 6,
      allKanji: [
        _kanji(id: 1, character: '親', hanViet: 'Thân', relatedKanji: related),
        for (var i = 0; i < related.length; i++)
          _kanji(id: i + 2, character: related[i], hanViet: 'Quan'),
      ],
    );

    expect(graph.nodes, hasLength(6));
    expect(graph.nodes.first.character, '親');
    expect(
      graph.nodes
          .skip(1)
          .every((node) => node.type == KanjiGraphNodeType.related),
      isTrue,
    );
  });

  test(
    'asset loader builds graph-ready kanji without opening the DB',
    () async {
      final loader = KanjiRelationshipGraphAssetLoader(
        bundle: _FakeKanjiAssetBundle({
          'assets/data/content/kanji/n5/lesson_01.json': _lessonJson(
            level: 'N5',
            lessonId: 1,
            character: '校',
            hanViet: 'Giáo',
            meaning: 'trường học',
            components: ['木', '交'],
            relatedKanji: ['学'],
          ),
          'assets/data/content/kanji/n5/lesson_02.json': _lessonJson(
            level: 'N5',
            lessonId: 2,
            character: '学',
            hanViet: 'Học',
            meaning: 'học tập',
          ),
        }),
        levels: const ['n5'],
        lessonCount: 2,
      );

      final items = await loader.loadAllKanji();
      final graph = KanjiRelationshipGraphBuilder.build(
        focusCharacter: '校',
        allKanji: items,
      );

      expect(items.map((item) => item.character), ['校', '学']);
      expect(graph.nodeFor('校')!.item!.meaning, 'Giáo (trường học)');
      expect(graph.nodeFor('木')!.type, KanjiGraphNodeType.outsideApp);
      expect(graph.nodeFor('学')!.type, KanjiGraphNodeType.related);
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

class _FakeKanjiAssetBundle extends CachingAssetBundle {
  _FakeKanjiAssetBundle(this.files);

  final Map<String, String> files;

  @override
  Future<String> loadString(String key, {bool cache = true}) async {
    final value = files[key];
    if (value == null) {
      throw Exception('Missing test asset $key');
    }
    return value;
  }

  @override
  Future<ByteData> load(String key) async {
    throw UnimplementedError('load is not used by this test');
  }
}

String _lessonJson({
  required String level,
  required int lessonId,
  required String character,
  required String hanViet,
  required String meaning,
  List<String> components = const [],
  List<String> relatedKanji = const [],
}) {
  final componentsJson = components.map((item) => '"$item"').join(',');
  final relatedJson = relatedKanji.map((item) => '"$item"').join(',');
  return '''
{
  "level": "$level",
  "lessonId": $lessonId,
  "entries": [
    {
      "lessonId": $lessonId,
      "level": "$level",
      "character": "$character",
      "strokeCount": 1,
      "labels": {
        "hanViet": "$hanViet",
        "meaningVi": "$meaning",
        "meaningViDisplay": "$hanViet ($meaning)",
        "meaningEn": "$meaning"
      },
      "readings": {
        "onyomi": ["コウ"],
        "kunyomi": []
      },
      "decomposition": {
        "hanViet": "$hanViet",
        "components": [$componentsJson],
        "relatedKanji": [$relatedJson]
      },
      "examples": []
    }
  ]
}
''';
}
