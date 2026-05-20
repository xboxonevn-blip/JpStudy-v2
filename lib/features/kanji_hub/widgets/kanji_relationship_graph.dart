import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:jpstudy/app/theme/app_spacing.dart';
import 'package:jpstudy/core/app_language.dart';
import 'package:jpstudy/features/kanji_hub/models/kanji_relationship_graph.dart';

class KanjiRelationshipGraph extends StatefulWidget {
  const KanjiRelationshipGraph({
    super.key,
    required this.graphData,
    required this.onNodeSelected,
    required this.onPracticeCluster,
    this.language = AppLanguage.vi,
  });

  final KanjiRelationshipGraphData graphData;
  final ValueChanged<String> onNodeSelected;
  final VoidCallback onPracticeCluster;
  final AppLanguage language;

  @override
  State<KanjiRelationshipGraph> createState() => _KanjiRelationshipGraphState();
}

class _KanjiRelationshipGraphState extends State<KanjiRelationshipGraph> {
  final TransformationController _transformationController =
      TransformationController();
  int _layoutNonce = 0;

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final viewport = Size(
          constraints.maxWidth.isFinite ? constraints.maxWidth : 900,
          constraints.maxHeight.isFinite ? constraints.maxHeight : 560,
        );
        final canvasSize = Size(
          math.max(900, viewport.width),
          math.max(520, viewport.height),
        );
        final layout = _buildLayout(canvasSize);
        return ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Stack(
            key: const ValueKey('kanji_graph_canvas'),
            children: [
              Positioned.fill(
                child: CustomPaint(painter: _KanjiGraphGridPainter()),
              ),
              Positioned.fill(
                child: InteractiveViewer(
                  key: const ValueKey('kanji_graph_interactive_viewer'),
                  transformationController: _transformationController,
                  boundaryMargin: const EdgeInsets.all(180),
                  minScale: 0.55,
                  maxScale: 2.4,
                  child: SizedBox(
                    width: canvasSize.width,
                    height: canvasSize.height,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Positioned.fill(
                          child: CustomPaint(
                            painter: _KanjiGraphEdgePainter(layout: layout),
                          ),
                        ),
                        for (final node in widget.graphData.nodes)
                          _PositionedKanjiNode(
                            node: node,
                            language: widget.language,
                            center: layout.centerFor(node.character),
                            onTap: node.isNavigable
                                ? () => widget.onNodeSelected(node.character)
                                : null,
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: AppSpacing.sm,
                right: AppSpacing.sm,
                child: _KanjiGraphToolbar(
                  language: widget.language,
                  onFit: () => _fitToViewport(viewport, canvasSize),
                  onReset: () =>
                      _transformationController.value = Matrix4.identity(),
                  onRefresh: () => setState(() => _layoutNonce++),
                  onFullscreen: _openFullscreen,
                ),
              ),
              Positioned(
                left: AppSpacing.md,
                top: AppSpacing.md,
                child: FilledButton.icon(
                  key: const ValueKey('kanji_graph_practice_cluster'),
                  onPressed: widget.onPracticeCluster,
                  icon: const Icon(Icons.psychology_alt_rounded),
                  label: Text(_practiceLabel(widget.language)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  _KanjiGraphLayout _buildLayout(Size size) {
    final focus = widget.graphData.focus;
    final centers = <String, Offset>{focus.character: size.center(Offset.zero)};
    final firstHop = widget.graphData.nodes
        .where((node) => node.depth == 1)
        .toList(growable: false);
    final secondHop = widget.graphData.nodes
        .where((node) => node.depth >= 2)
        .toList(growable: false);

    _placeRing(
      centers: centers,
      nodes: firstHop,
      center: size.center(Offset.zero),
      radius: math.min(size.width, size.height) * 0.31,
      offset: _layoutNonce * 0.28,
    );
    _placeRing(
      centers: centers,
      nodes: secondHop,
      center: size.center(Offset.zero),
      radius: math.min(size.width, size.height) * 0.43,
      offset: math.pi / 8 + _layoutNonce * 0.22,
    );

    return _KanjiGraphLayout(centers: centers, edges: widget.graphData.edges);
  }

  void _placeRing({
    required Map<String, Offset> centers,
    required List<KanjiGraphNode> nodes,
    required Offset center,
    required double radius,
    required double offset,
  }) {
    if (nodes.isEmpty) return;
    for (var index = 0; index < nodes.length; index++) {
      final angle =
          -math.pi / 2 + offset + (2 * math.pi * index / nodes.length);
      centers[nodes[index].character] = Offset(
        center.dx + math.cos(angle) * radius,
        center.dy + math.sin(angle) * radius,
      );
    }
  }

  void _fitToViewport(Size viewport, Size canvasSize) {
    final scale = math.min(
      1.0,
      math.min(
        viewport.width / canvasSize.width,
        viewport.height / canvasSize.height,
      ),
    );
    final dx = (viewport.width - canvasSize.width * scale) / 2;
    final dy = (viewport.height - canvasSize.height * scale) / 2;
    _transformationController.value = Matrix4.identity()
      ..translateByDouble(dx, dy, 0, 1)
      ..scaleByDouble(scale, scale, 1, 1);
  }

  void _openFullscreen() {
    showDialog<void>(
      context: context,
      builder: (context) => Dialog.fullscreen(
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              _fullscreenTitle(
                widget.language,
                widget.graphData.focus.character,
              ),
            ),
            actions: [
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close_rounded),
              ),
            ],
          ),
          body: KanjiRelationshipGraph(
            graphData: widget.graphData,
            language: widget.language,
            onNodeSelected: (character) {
              Navigator.of(context).pop();
              widget.onNodeSelected(character);
            },
            onPracticeCluster: () {
              Navigator.of(context).pop();
              widget.onPracticeCluster();
            },
          ),
        ),
      ),
    );
  }
}

class _KanjiGraphLayout {
  const _KanjiGraphLayout({required this.centers, required this.edges});

  final Map<String, Offset> centers;
  final List<KanjiGraphEdge> edges;

  Offset centerFor(String character) => centers[character] ?? Offset.zero;
}

class _PositionedKanjiNode extends StatelessWidget {
  const _PositionedKanjiNode({
    required this.node,
    required this.language,
    required this.center,
    required this.onTap,
  });

  final KanjiGraphNode node;
  final AppLanguage language;
  final Offset center;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final size = node.type == KanjiGraphNodeType.focus ? 58.0 : 50.0;
    return Positioned(
      left: center.dx - size / 2,
      top: center.dy - size / 2,
      width: size,
      height: size,
      child: _KanjiGraphNodeBubble(
        node: node,
        language: language,
        onTap: onTap,
      ),
    );
  }
}

class _KanjiGraphToolbar extends StatelessWidget {
  const _KanjiGraphToolbar({
    required this.language,
    required this.onFit,
    required this.onReset,
    required this.onRefresh,
    required this.onFullscreen,
  });

  final AppLanguage language;
  final VoidCallback onFit;
  final VoidCallback onReset;
  final VoidCallback onRefresh;
  final VoidCallback onFullscreen;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.92),
      elevation: 2,
      borderRadius: BorderRadius.circular(8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            key: const ValueKey('kanji_graph_fit'),
            tooltip: _fitTooltip(language),
            onPressed: onFit,
            icon: const Icon(Icons.fit_screen_rounded),
          ),
          IconButton(
            key: const ValueKey('kanji_graph_reset'),
            tooltip: _refreshTooltip(language),
            onPressed: onRefresh,
            icon: const Icon(Icons.refresh_rounded),
          ),
          IconButton(
            tooltip: _resetTooltip(language),
            onPressed: onReset,
            icon: const Icon(Icons.center_focus_strong_rounded),
          ),
          IconButton(
            key: const ValueKey('kanji_graph_fullscreen'),
            tooltip: _fullscreenTooltip(language),
            onPressed: onFullscreen,
            icon: const Icon(Icons.fullscreen_rounded),
          ),
        ],
      ),
    );
  }
}

class _KanjiGraphNodeBubble extends StatelessWidget {
  const _KanjiGraphNodeBubble({
    required this.node,
    required this.language,
    required this.onTap,
  });

  final KanjiGraphNode node;
  final AppLanguage language;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final style = _styleFor(node.type);
    return Tooltip(
      message: _tooltipFor(node),
      child: InkWell(
        key: ValueKey(
          node.type == KanjiGraphNodeType.focus
              ? 'kanji_graph_focus_${node.character}'
              : 'kanji_graph_node_${node.character}',
        ),
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: style.fill,
            border: Border.all(color: style.border, width: 2.4),
            boxShadow: const [
              BoxShadow(
                color: Color(0x22000000),
                blurRadius: 8,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Text(
            node.character,
            style: TextStyle(
              color: style.text,
              fontSize: node.type == KanjiGraphNodeType.focus ? 25 : 21,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
    );
  }

  String _tooltipFor(KanjiGraphNode node) {
    final item = node.item;
    final meaning = item?.displayMeaning(language).trim();
    final level = item?.jlptLevel.trim();
    final label = language == AppLanguage.vi
        ? node.componentName?.trim()
        : null;
    return [
      node.character,
      if (label != null && label.isNotEmpty) label,
      if (meaning != null && meaning.isNotEmpty) meaning,
      if (level != null && level.isNotEmpty) level,
    ].join(' · ');
  }

  _KanjiNodeStyle _styleFor(KanjiGraphNodeType type) {
    return switch (type) {
      KanjiGraphNodeType.focus => const _KanjiNodeStyle(
        fill: Color(0xFF1E88E5),
        border: Color(0xFF43A047),
        text: Colors.white,
      ),
      KanjiGraphNodeType.component => const _KanjiNodeStyle(
        fill: Color(0xFF7E57C2),
        border: Color(0xFF9E9E9E),
        text: Colors.white,
      ),
      KanjiGraphNodeType.related => const _KanjiNodeStyle(
        fill: Color(0xFFFB8C00),
        border: Color(0xFF9E9E9E),
        text: Colors.white,
      ),
      KanjiGraphNodeType.outsideApp => const _KanjiNodeStyle(
        fill: Colors.white,
        border: Color(0xFF9E9E9E),
        text: Color(0xFF263238),
      ),
    };
  }
}

class _KanjiNodeStyle {
  const _KanjiNodeStyle({
    required this.fill,
    required this.border,
    required this.text,
  });

  final Color fill;
  final Color border;
  final Color text;
}

class _KanjiGraphEdgePainter extends CustomPainter {
  const _KanjiGraphEdgePainter({required this.layout});

  final _KanjiGraphLayout layout;

  @override
  void paint(Canvas canvas, Size size) {
    for (final edge in layout.edges) {
      final from = layout.centerFor(edge.source.character);
      final to = layout.centerFor(edge.target.character);
      if (from == Offset.zero || to == Offset.zero || from == to) continue;
      _drawArrow(canvas, from, to, edge.label);
    }
  }

  void _drawArrow(Canvas canvas, Offset from, Offset to, String label) {
    final vector = to - from;
    final distance = vector.distance;
    if (distance <= 1) return;
    final direction = vector / distance;
    final start = from + direction * 30;
    final end = to - direction * 30;
    final paint = Paint()
      ..color = const Color(0xFF616161)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(start, end, paint);

    const arrowSize = 9.0;
    final angle = math.atan2(direction.dy, direction.dx);
    final left =
        end -
        Offset(
          math.cos(angle - math.pi / 6) * arrowSize,
          math.sin(angle - math.pi / 6) * arrowSize,
        );
    final right =
        end -
        Offset(
          math.cos(angle + math.pi / 6) * arrowSize,
          math.sin(angle + math.pi / 6) * arrowSize,
        );
    final path = Path()
      ..moveTo(end.dx, end.dy)
      ..lineTo(left.dx, left.dy)
      ..lineTo(right.dx, right.dy)
      ..close();
    canvas.drawPath(
      path,
      Paint()
        ..color = const Color(0xFF616161)
        ..style = PaintingStyle.fill,
    );
    _drawLabel(canvas, start + (end - start) / 2, label);
  }

  void _drawLabel(Canvas canvas, Offset center, String label) {
    if (label.isEmpty) return;
    final painter = TextPainter(
      text: TextSpan(
        text: label,
        style: const TextStyle(
          color: Color(0xFF455A64),
          fontSize: 11,
          fontWeight: FontWeight.w800,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    final rect = Rect.fromCenter(
      center: center,
      width: math.max(34, painter.width + 12),
      height: painter.height + 6,
    );
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(999));
    canvas
      ..drawRRect(
        rrect,
        Paint()
          ..color = Colors.white.withValues(alpha: 0.9)
          ..style = PaintingStyle.fill,
      )
      ..drawRRect(
        rrect,
        Paint()
          ..color = const Color(0xFFB0BEC5)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1,
      );
    painter.paint(
      canvas,
      Offset(center.dx - painter.width / 2, center.dy - painter.height / 2),
    );
  }

  @override
  bool shouldRepaint(covariant _KanjiGraphEdgePainter oldDelegate) {
    return oldDelegate.layout != layout;
  }
}

class _KanjiGraphGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFE0E7EF)
      ..strokeWidth = 1;
    const step = 28.0;
    for (var x = 0.0; x < size.width; x += step) {
      for (var y = 0.0; y < size.height; y += step) {
        canvas.drawCircle(Offset(x, y), 0.8, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

String _practiceLabel(AppLanguage language) => switch (language) {
  AppLanguage.vi => 'Luyện cụm này',
  AppLanguage.en => 'Practice cluster',
  AppLanguage.ja => 'まとめて練習',
};

String _fullscreenTitle(AppLanguage language, String character) =>
    switch (language) {
      AppLanguage.vi => 'Mạng kanji $character',
      AppLanguage.en => '$character graph',
      AppLanguage.ja => '$character グラフ',
    };

String _fitTooltip(AppLanguage language) => switch (language) {
  AppLanguage.vi => 'Vừa màn hình',
  AppLanguage.en => 'Fit to screen',
  AppLanguage.ja => '画面に合わせる',
};

String _refreshTooltip(AppLanguage language) => switch (language) {
  AppLanguage.vi => 'Sắp xếp lại',
  AppLanguage.en => 'Refresh layout',
  AppLanguage.ja => '配置を更新',
};

String _resetTooltip(AppLanguage language) => switch (language) {
  AppLanguage.vi => 'Đặt lại zoom',
  AppLanguage.en => 'Reset zoom',
  AppLanguage.ja => 'ズームをリセット',
};

String _fullscreenTooltip(AppLanguage language) => switch (language) {
  AppLanguage.vi => 'Toàn màn hình',
  AppLanguage.en => 'Fullscreen',
  AppLanguage.ja => '全画面',
};
