import 'package:jpstudy/data/models/kanji_item.dart';

enum KanjiGraphNodeType { focus, component, related, outsideApp }

enum KanjiGraphEdgeType { componentOf, related }

enum KanjiGraphSrsTier { unseen, learning, due, stable }

KanjiGraphSrsTier kanjiGraphSrsTierFromState({
  required DateTime? nextReviewAt,
  required double stability,
  required DateTime now,
}) {
  if (nextReviewAt == null) return KanjiGraphSrsTier.unseen;
  if (!nextReviewAt.isAfter(now)) return KanjiGraphSrsTier.due;
  return stability >= 21.0
      ? KanjiGraphSrsTier.stable
      : KanjiGraphSrsTier.learning;
}

class KanjiGraphNode {
  const KanjiGraphNode({
    required this.character,
    required this.type,
    required this.depth,
    this.item,
    this.componentName,
  });

  final String character;
  final KanjiGraphNodeType type;
  final int depth;
  final KanjiItem? item;
  final String? componentName;

  bool get isNavigable => item != null;
}

class KanjiGraphEdge {
  const KanjiGraphEdge({
    required this.source,
    required this.target,
    required this.type,
  });

  final KanjiGraphNode source;
  final KanjiGraphNode target;
  final KanjiGraphEdgeType type;

  String get label => switch (type) {
    KanjiGraphEdgeType.componentOf => '成分',
    KanjiGraphEdgeType.related => '関連',
  };
}

class KanjiRelationshipGraphData {
  const KanjiRelationshipGraphData({
    required this.focus,
    required this.nodes,
    required this.edges,
  });

  final KanjiGraphNode focus;
  final List<KanjiGraphNode> nodes;
  final List<KanjiGraphEdge> edges;

  bool get hasRelations => edges.isNotEmpty;

  KanjiGraphNode? nodeFor(String character) {
    for (final node in nodes) {
      if (node.character == character) return node;
    }
    return null;
  }
}

class KanjiRelationshipGraphBuilder {
  const KanjiRelationshipGraphBuilder._();

  static KanjiRelationshipGraphData build({
    required String focusCharacter,
    required List<KanjiItem> allKanji,
    int depthLimit = 2,
    int maxNodes = 15,
  }) {
    final index = {for (final item in allKanji) item.character: item};
    final focusItem = index[focusCharacter];
    final focus = KanjiGraphNode(
      character: focusCharacter,
      type: KanjiGraphNodeType.focus,
      depth: 0,
      item: focusItem,
    );
    final nodes = <KanjiGraphNode>[focus];
    final nodeByCharacter = <String, KanjiGraphNode>{focusCharacter: focus};
    final pendingEdges = <_PendingKanjiGraphEdge>[];

    if (focusItem != null) {
      _addOneHop(
        source: focusItem,
        focus: focus,
        index: index,
        nodes: nodes,
        nodeByCharacter: nodeByCharacter,
        pendingEdges: pendingEdges,
        maxNodes: maxNodes,
      );
    }

    if (depthLimit > 1 && nodes.length < maxNodes) {
      final firstHop = nodes
          .where((node) => node.depth == 1 && node.item != null)
          .toList(growable: false);
      for (final node in firstHop) {
        if (nodes.length >= maxNodes) break;
        _addDepthTwo(
          sourceNode: node,
          index: index,
          nodes: nodes,
          nodeByCharacter: nodeByCharacter,
          pendingEdges: pendingEdges,
          maxNodes: maxNodes,
        );
      }
    }

    final edges = <KanjiGraphEdge>[];
    final seenEdges = <String>{};
    for (final edge in pendingEdges) {
      final source = nodeByCharacter[edge.sourceCharacter];
      final target = nodeByCharacter[edge.targetCharacter];
      if (source == null || target == null) continue;
      final key =
          '${edge.sourceCharacter}->${edge.targetCharacter}:${edge.type.name}';
      if (!seenEdges.add(key)) continue;
      edges.add(
        KanjiGraphEdge(source: source, target: target, type: edge.type),
      );
    }

    return KanjiRelationshipGraphData(
      focus: focus,
      nodes: List.unmodifiable(nodes),
      edges: List.unmodifiable(edges),
    );
  }

  static void _addOneHop({
    required KanjiItem source,
    required KanjiGraphNode focus,
    required Map<String, KanjiItem> index,
    required List<KanjiGraphNode> nodes,
    required Map<String, KanjiGraphNode> nodeByCharacter,
    required List<_PendingKanjiGraphEdge> pendingEdges,
    required int maxNodes,
  }) {
    final decomposition = source.decomposition;
    if (decomposition == null) return;
    for (var i = 0; i < decomposition.components.length; i++) {
      final character = decomposition.components[i];
      final componentName = i < decomposition.componentNames.length
          ? decomposition.componentNames[i]
          : null;
      _addNode(
        character: character,
        type: index.containsKey(character)
            ? KanjiGraphNodeType.component
            : KanjiGraphNodeType.outsideApp,
        depth: 1,
        index: index,
        nodes: nodes,
        nodeByCharacter: nodeByCharacter,
        maxNodes: maxNodes,
        componentName: componentName,
      );
      pendingEdges.add(
        _PendingKanjiGraphEdge(
          sourceCharacter: character,
          targetCharacter: focus.character,
          type: KanjiGraphEdgeType.componentOf,
        ),
      );
    }

    for (final character in decomposition.relatedKanji) {
      _addNode(
        character: character,
        type: index.containsKey(character)
            ? KanjiGraphNodeType.related
            : KanjiGraphNodeType.outsideApp,
        depth: 1,
        index: index,
        nodes: nodes,
        nodeByCharacter: nodeByCharacter,
        maxNodes: maxNodes,
      );
      pendingEdges.add(
        _PendingKanjiGraphEdge(
          sourceCharacter: focus.character,
          targetCharacter: character,
          type: KanjiGraphEdgeType.related,
        ),
      );
    }
  }

  static void _addDepthTwo({
    required KanjiGraphNode sourceNode,
    required Map<String, KanjiItem> index,
    required List<KanjiGraphNode> nodes,
    required Map<String, KanjiGraphNode> nodeByCharacter,
    required List<_PendingKanjiGraphEdge> pendingEdges,
    required int maxNodes,
  }) {
    final item = sourceNode.item;
    final decomposition = item?.decomposition;
    if (item == null || decomposition == null) return;

    for (final character in decomposition.components) {
      if (nodes.length >= maxNodes) break;
      _addNode(
        character: character,
        type: index.containsKey(character)
            ? KanjiGraphNodeType.component
            : KanjiGraphNodeType.outsideApp,
        depth: 2,
        index: index,
        nodes: nodes,
        nodeByCharacter: nodeByCharacter,
        maxNodes: maxNodes,
      );
      pendingEdges.add(
        _PendingKanjiGraphEdge(
          sourceCharacter: character,
          targetCharacter: sourceNode.character,
          type: KanjiGraphEdgeType.componentOf,
        ),
      );
    }

    for (final character in decomposition.relatedKanji) {
      if (nodes.length >= maxNodes) break;
      _addNode(
        character: character,
        type: index.containsKey(character)
            ? KanjiGraphNodeType.related
            : KanjiGraphNodeType.outsideApp,
        depth: 2,
        index: index,
        nodes: nodes,
        nodeByCharacter: nodeByCharacter,
        maxNodes: maxNodes,
      );
      pendingEdges.add(
        _PendingKanjiGraphEdge(
          sourceCharacter: sourceNode.character,
          targetCharacter: character,
          type: KanjiGraphEdgeType.related,
        ),
      );
    }
  }

  static void _addNode({
    required String character,
    required KanjiGraphNodeType type,
    required int depth,
    required Map<String, KanjiItem> index,
    required List<KanjiGraphNode> nodes,
    required Map<String, KanjiGraphNode> nodeByCharacter,
    required int maxNodes,
    String? componentName,
  }) {
    if (nodeByCharacter.containsKey(character)) return;
    if (nodes.length >= maxNodes) return;
    final item = index[character];
    final node = KanjiGraphNode(
      character: character,
      type: item == null ? KanjiGraphNodeType.outsideApp : type,
      depth: depth,
      item: item,
      componentName: componentName,
    );
    nodes.add(node);
    nodeByCharacter[character] = node;
  }
}

class _PendingKanjiGraphEdge {
  const _PendingKanjiGraphEdge({
    required this.sourceCharacter,
    required this.targetCharacter,
    required this.type,
  });

  final String sourceCharacter;
  final String targetCharacter;
  final KanjiGraphEdgeType type;
}
