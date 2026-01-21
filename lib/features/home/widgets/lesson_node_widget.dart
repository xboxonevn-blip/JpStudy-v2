import 'package:flutter/material.dart';
import '../../../theme/app_theme_v2.dart';
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
          child: _buildClayNode(context),
        ),
        const SizedBox(height: 8),
        _buildStars(context),
        const SizedBox(height: 4),
        Text(
          node.lesson.title, // "Lesson X"
          style: TextStyle(
            color: node.isLocked ? AppThemeV2.textSub : AppThemeV2.textMain,
            fontWeight: FontWeight.bold, 
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildClayNode(BuildContext context) {
    final baseColor = _getNodeColor();
    // Depth color is crucial for the 3D effect
    final depthColor = AppThemeV2.getDepthColor(baseColor);
    // Locked nodes are flat, Active nodes have depth
    final double depth = node.isLocked ? 0 : 6.0;

    return SizedBox(
      width: size,
      height: size + depth, // Add space for the 3D bottom part
      child: Stack(
        children: [
          // Bottom layer (Depth/Shadow)
          if (!node.isLocked)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              top: depth, // Push down
              child: Container(
                decoration: BoxDecoration(
                  color: depthColor,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            
          // Top layer (Face)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: depth, // Keep above the depth
            child: Container(
              decoration: BoxDecoration(
                color: baseColor,
                shape: BoxShape.circle,
                // Inner highlight for plastic look
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white.withValues(alpha: 0.2), // Highlight top
                    Colors.white.withValues(alpha: 0.0),
                  ],
                  stops: const [0.0, 0.5],
                ),
                border: Border.all(
                  // Slightly lighter border usually looks good, or just rely on color
                  color: Colors.white.withValues(alpha: 0.1),
                  width: 1,
                ),
              ),
              child: Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Icon
                    Icon(
                      _getNodeIcon(),
                      color: Colors.white,
                      size: size * 0.4,
                    ),
                    // Unlock animation or status could go here
                  ],
                ),
              ),
            ),
          ),
          
          // Completion Crow/Check
          if (node.isCompleted)
            Positioned(
              right: 0,
              bottom: depth, // Float above
              child: _buildStatusBadge(Icons.check, AppThemeV2.secondary),
            ),
        ],
      ),
    );
  }
  
  Widget _buildStatusBadge(IconData icon, Color color) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Center(
        child: Icon(icon, size: 14, color: Colors.white),
      ),
    );
  }

  Color _getNodeColor() {
    if (node.isLocked) return const Color(0xFFE5E7EB); // Gray 200
    if (node.isCompleted) return const Color(0xFFFFC800); // Gold
    // Current/Active
    return AppThemeV2.primary; 
  }

  IconData _getNodeIcon() {
    if (node.isLocked) return Icons.lock;
    if (node.isCompleted) return Icons.star_rounded;
    return Icons.play_arrow_rounded;
  }

  Widget _buildStars(BuildContext context) {
    if (node.isLocked) return const SizedBox(height: 16); 
    
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        final isEarned = index < node.stars;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 1.0),
          child: Icon(
            Icons.star_rounded,
            size: 14,
            color: isEarned ? const Color(0xFFFFC800) : Colors.grey[300],
          ),
        );
      }),
    );
  }
}
