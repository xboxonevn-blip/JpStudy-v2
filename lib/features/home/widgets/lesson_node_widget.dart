import 'package:flutter/material.dart';
import '../models/lesson_node.dart';

class LessonNodeWidget extends StatelessWidget {
  final LessonNode node;
  final VoidCallback? onTap;
  final double size;

  const LessonNodeWidget({
    super.key,
    required this.node,
    this.onTap,
    this.size = 80.0,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: node.isLocked ? null : onTap,
          child: _buildNodeCircle(context),
        ),
        const SizedBox(height: 8),
        _buildStars(context),
      ],
    );
  }

  Widget _buildNodeCircle(BuildContext context) {
    final theme = Theme.of(context);
    final color = _getNodeColor(theme);
    
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: node.isLocked ? Colors.grey[300] : color,
        boxShadow: node.isLocked
            ? []
            : [
                BoxShadow(
                  color: color.withValues(alpha: 0.4),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
                BoxShadow(
                  color: color.withValues(alpha: 0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 8), // 3D effect depth
                ),
              ],
        border: node.isCompleted
            ? Border.all(color: Colors.amber, width: 3)
            : null,
      ),
      child: Center(
        child: Icon(
          node.isLocked ? Icons.lock : Icons.menu_book_rounded,
          color: node.isLocked ? Colors.grey[500] : Colors.white,
          size: size * 0.4,
        ),
      ),
    );
  }

  Color _getNodeColor(ThemeData theme) {
    if (node.isCompleted) return Colors.green;
    if (node.isLocked) return Colors.grey;
    return theme.primaryColor;
  }

  Widget _buildStars(BuildContext context) {
    if (node.isLocked) return const SizedBox(height: 20); // Placeholder spacing
    
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        final isEarned = index < node.stars;
        return Icon(
          Icons.star_rounded,
          size: 16,
          color: isEarned ? Colors.amber : Colors.grey[300],
        );
      }),
    );
  }
}
