import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jpstudy/core/app_language.dart';
import 'package:jpstudy/features/interlink/models/interlink_graph.dart';
import 'package:jpstudy/features/interlink/providers/interlink_graph_provider.dart';
import 'package:jpstudy/features/interlink/widgets/related_section.dart';

void main() {
  testWidgets('RelatedSection renders localized linked rows', (tester) async {
    final graph = InterlinkGraph.fromJson(const {
      'nodeFields': ['id', 'type', 'level', 'label', 'route'],
      'edgeRelTypes': ['contains_kanji'],
      'edgeEvidenceTypes': ['test'],
      'nodes': [
        ['vocab:n5:v1', 'vocab', 'N5', '食べる', '/vocab'],
        ['kanji:n5:k1', 'kanji', 'N5', '食', '/kanji/%E9%A3%9F/graph'],
      ],
      'edges': [
        [0, 1, 0, 1.0, 0],
      ],
    });

    await tester.pumpWidget(
      ProviderScope(
        overrides: [interlinkGraphProvider.overrideWith((ref) async => graph)],
        child: const MaterialApp(
          home: Scaffold(
            body: RelatedSection(
              nodeId: 'vocab:n5:v1',
              language: AppLanguage.vi,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Liên quan'), findsOneWidget);
    expect(find.text('Kanji trong mục này'), findsOneWidget);
    expect(find.text('食'), findsOneWidget);
  });

  testWidgets('RelatedSection hides itself when no links exist', (
    tester,
  ) async {
    final graph = InterlinkGraph.fromJson(const {
      'nodeFields': ['id', 'type', 'level', 'label', 'route'],
      'edgeRelTypes': [],
      'edgeEvidenceTypes': [],
      'nodes': [
        ['vocab:n5:v1', 'vocab', 'N5', '食べる', '/vocab'],
      ],
      'edges': [],
    });

    await tester.pumpWidget(
      ProviderScope(
        overrides: [interlinkGraphProvider.overrideWith((ref) async => graph)],
        child: const MaterialApp(
          home: Scaffold(
            body: RelatedSection(
              nodeId: 'vocab:n5:v1',
              language: AppLanguage.vi,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Liên quan'), findsNothing);
  });

  testWidgets('RelatedSection can resolve semantic item labels', (
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
      ProviderScope(
        overrides: [interlinkGraphProvider.overrideWith((ref) async => graph)],
        child: const MaterialApp(
          home: Scaffold(
            body: RelatedSection.lookup(
              type: 'grammar',
              level: 'N5',
              label: 'てもいい',
              language: AppLanguage.vi,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Liên quan'), findsOneWidget);
    expect(find.text('Từ vựng chứa mục này'), findsOneWidget);
    expect(find.text('食べる'), findsOneWidget);
  });
}
