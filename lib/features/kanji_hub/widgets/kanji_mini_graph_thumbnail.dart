import 'package:flutter/material.dart';
import 'package:jpstudy/app/theme/app_spacing.dart';
import 'package:jpstudy/features/kanji_hub/models/kanji_relationship_graph.dart';

class KanjiMiniGraphThumbnail extends StatelessWidget {
  const KanjiMiniGraphThumbnail({
    super.key,
    required this.graphData,
    required this.onTap,
  });

  final KanjiRelationshipGraphData graphData;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final nodes = graphData.nodes.take(6).toList(growable: false);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        key: const ValueKey('kanji_mini_graph_thumbnail'),
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        child: Container(
          height: 72,
          padding: const EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Row(
            children: [
              for (var index = 0; index < nodes.length; index++) ...[
                _MiniNode(node: nodes[index]),
                if (index != nodes.length - 1)
                  const Expanded(
                    child: Divider(color: Color(0xFFCBD5E1), thickness: 1.2),
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _MiniNode extends StatelessWidget {
  const _MiniNode({required this.node});

  final KanjiGraphNode node;

  @override
  Widget build(BuildContext context) {
    final isFocus = node.type == KanjiGraphNodeType.focus;
    return Container(
      width: isFocus ? 42 : 34,
      height: isFocus ? 42 : 34,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isFocus ? const Color(0xFF1E88E5) : const Color(0xFFFB8C00),
        border: Border.all(
          color: isFocus ? const Color(0xFF43A047) : const Color(0xFF9E9E9E),
          width: 2,
        ),
      ),
      child: Text(
        node.character,
        style: TextStyle(
          color: Colors.white,
          fontSize: isFocus ? 20 : 16,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}
