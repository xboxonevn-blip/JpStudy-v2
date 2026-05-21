enum RelatedSectionKind { grammar, vocab, kanji, conjugation, reading }

class InterlinkNode {
  const InterlinkNode({
    required this.id,
    required this.type,
    required this.level,
    required this.label,
    required this.route,
  });

  final String id;
  final String type;
  final String level;
  final String label;
  final String route;
}

class InterlinkRelatedItem {
  const InterlinkRelatedItem({
    required this.node,
    required this.rel,
    required this.weight,
    required this.evidence,
  });

  final InterlinkNode node;
  final String rel;
  final double weight;
  final String evidence;
}

class InterlinkRelatedSection {
  const InterlinkRelatedSection({required this.kind, required this.items});

  final RelatedSectionKind kind;
  final List<InterlinkRelatedItem> items;
}

class InterlinkGraph {
  InterlinkGraph._({
    required this.nodes,
    required this.edgesBySource,
    required this.nodeById,
  });

  final List<InterlinkNode> nodes;
  final Map<String, List<InterlinkRelatedItem>> edgesBySource;
  final Map<String, InterlinkNode> nodeById;

  factory InterlinkGraph.fromJson(Map<String, Object?> json) {
    final rawNodes = (json['nodes'] as List? ?? const []);
    final relTypes = (json['edgeRelTypes'] as List? ?? const [])
        .map((value) => '$value')
        .toList(growable: false);
    final evidenceTypes = (json['edgeEvidenceTypes'] as List? ?? const [])
        .map((value) => '$value')
        .toList(growable: false);

    final nodes = <InterlinkNode>[
      for (final raw in rawNodes)
        if (raw is List && raw.length >= 5)
          InterlinkNode(
            id: '${raw[0]}',
            type: '${raw[1]}',
            level: '${raw[2]}',
            label: '${raw[3]}',
            route: '${raw[4]}',
          ),
    ];
    final nodeById = {for (final node in nodes) node.id: node};
    final edgesBySource = <String, List<InterlinkRelatedItem>>{};
    for (final raw in json['edges'] as List? ?? const []) {
      if (raw is! List || raw.length < 5) continue;
      final from = _readInt(raw[0]);
      final to = _readInt(raw[1]);
      if (from == null ||
          to == null ||
          from >= nodes.length ||
          to >= nodes.length) {
        continue;
      }
      final rel = _readIndexed(raw[2], relTypes);
      final evidence = _readIndexed(raw[4], evidenceTypes);
      final item = InterlinkRelatedItem(
        node: nodes[to],
        rel: rel,
        weight: _readDouble(raw[3]) ?? 1,
        evidence: evidence,
      );
      edgesBySource.putIfAbsent(nodes[from].id, () => []).add(item);
    }
    for (final items in edgesBySource.values) {
      items.sort((a, b) {
        final weight = b.weight.compareTo(a.weight);
        if (weight != 0) return weight;
        return a.node.label.compareTo(b.node.label);
      });
    }
    return InterlinkGraph._(
      nodes: List.unmodifiable(nodes),
      edgesBySource: {
        for (final entry in edgesBySource.entries)
          entry.key: List.unmodifiable(entry.value),
      },
      nodeById: nodeById,
    );
  }

  List<InterlinkRelatedItem> related(String nodeId, {int limit = 20}) {
    final items = edgesBySource[nodeId] ?? const <InterlinkRelatedItem>[];
    if (items.length <= limit) return items;
    return items.take(limit).toList(growable: false);
  }

  InterlinkNode? findNode({
    required String type,
    required String level,
    String? id,
    String? label,
  }) {
    if (id != null && nodeById[id] != null) return nodeById[id];
    final normalizedLevel = level.trim().toUpperCase();
    final normalizedLabel = label?.trim();
    for (final node in nodes) {
      if (node.type != type) continue;
      if (node.level.toUpperCase() != normalizedLevel) continue;
      if (normalizedLabel != null && node.label == normalizedLabel) return node;
    }
    return null;
  }

  List<InterlinkRelatedSection> relatedSections(
    String nodeId, {
    int limit = 5,
  }) {
    final byKind = <RelatedSectionKind, List<InterlinkRelatedItem>>{};
    for (final item in related(nodeId, limit: 80)) {
      final kind = _kindForNodeType(item.node.type);
      if (kind == null) continue;
      byKind.putIfAbsent(kind, () => []).add(item);
    }
    return [
      for (final kind in RelatedSectionKind.values)
        if (byKind[kind]?.isNotEmpty ?? false)
          InterlinkRelatedSection(
            kind: kind,
            items: List.unmodifiable(byKind[kind]!.take(limit)),
          ),
    ];
  }

  static RelatedSectionKind? _kindForNodeType(String type) {
    return switch (type) {
      'grammar' => RelatedSectionKind.grammar,
      'vocab' => RelatedSectionKind.vocab,
      'kanji' => RelatedSectionKind.kanji,
      'conjugation' => RelatedSectionKind.conjugation,
      'reading' => RelatedSectionKind.reading,
      _ => null,
    };
  }
}

int? _readInt(Object? value) {
  if (value is int) return value;
  return int.tryParse('$value');
}

double? _readDouble(Object? value) {
  if (value is num) return value.toDouble();
  return double.tryParse('$value');
}

String _readIndexed(Object? value, List<String> values) {
  final index = _readInt(value);
  if (index != null && index >= 0 && index < values.length) {
    return values[index];
  }
  return '$value';
}
