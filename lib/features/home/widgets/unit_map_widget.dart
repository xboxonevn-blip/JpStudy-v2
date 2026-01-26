import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/unit.dart';
import '../models/lesson_node.dart';
import 'lesson_node_widget.dart';
import 'path_painter.dart';
import 'mascot_rive.dart';
import '../../../../core/language_provider.dart';
import '../../../../core/app_language.dart';

class UnitMapWidget extends ConsumerWidget {
  final Unit unit;
  final Function(LessonNode) onNodeTap;

  const UnitMapWidget({super.key, required this.unit, required this.onNodeTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final positions = _generatePositions(context, unit.nodes.length);
    final totalHeight =
        (unit.nodes.length + 1) * 120.0; // Space for mascot at bottom if needed
    final language = ref.watch(appLanguageProvider);

    // Find active node (First unlocked and not completed)
    // Or if all completed, maybe the last one?
    // If all locked, the first one.
    int activeIndex = unit.nodes.indexWhere(
      (n) => !n.isCompleted && !n.isLocked,
    );
    if (activeIndex == -1) {
      if (unit.nodes.isNotEmpty && unit.nodes.first.isLocked) {
        activeIndex = 0;
      } else if (unit.nodes.isNotEmpty && unit.nodes.last.isCompleted) {
        activeIndex = unit.nodes.length - 1;
      }
    }

    return SizedBox(
      width: double.infinity,
      height: totalHeight,
      child: Stack(
        children: [
          // 1. Draw the connected path
          CustomPaint(
            painter: PathPainter(points: positions, color: unit.color),
            size: Size.infinite,
          ),

          // 2. Place nodes at calculated positions
          ...List.generate(unit.nodes.length, (index) {
            final node = unit.nodes[index];
            final pos = positions[index];
            const nodeSize = 80.0;

            return Positioned(
              left: pos.dx - nodeSize / 2,
              top: pos.dy - nodeSize / 2,
              child: LessonNodeWidget(
                node: node,
                size: nodeSize,
                onTap: () => onNodeTap(node),
              ),
            );
          }),

          // 3. Mascot (Floating near Active Node)
          if (activeIndex != -1 && activeIndex < positions.length)
            MascotRive(nodePos: positions[activeIndex]),

          // 4. Unit Header
          Positioned(
            top: 20,
            left: 20,
            right: 20,
            child: _buildUnitHeader(context, language),
          ),
        ],
      ),
    );
  }

  Widget _buildUnitHeader(BuildContext context, AppLanguage language) {
    // Localize Title if it matches "Level X"
    String title = unit.title;
    if (title.startsWith('Level ')) {
      final level = title.replaceAll('Level ', '');
      title = '${language.levelLabel} $level';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            unit.color.withValues(alpha: 0.9),
            unit.color.withValues(alpha: 0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: unit.color.withValues(alpha: 0.4),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.flag_rounded, color: Colors.white),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  List<Offset> _generatePositions(BuildContext context, int count) {
    final width = MediaQuery.of(context).size.width;
    final centerX = width / 2;
    const spacing = 120.0;
    const amplitude = 90.0;
    // Start drawing a bit down to accommodate header
    const startY = 180.0;

    return List.generate(count, (index) {
      // Sine wave pattern
      // index * 0.8 controls the frequency of the wave
      final x = centerX + amplitude * sin(index * 0.8);
      final y = startY + index * spacing;
      return Offset(x, y);
    });
  }
}
