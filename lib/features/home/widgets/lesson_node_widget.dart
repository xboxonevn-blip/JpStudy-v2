import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../theme/app_theme_v2.dart';
import '../models/lesson_node.dart';
import '../../../../core/language_provider.dart';
import '../../../../core/app_language.dart';

class LessonNodeWidget extends ConsumerStatefulWidget {
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
  ConsumerState<LessonNodeWidget> createState() => _LessonNodeWidgetState();
}

class _LessonNodeWidgetState extends ConsumerState<LessonNodeWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  bool get _isActive => !widget.node.isLocked && !widget.node.isCompleted;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    if (_isActive) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(LessonNodeWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_isActive && !_controller.isAnimating) {
      _controller.repeat(reverse: true);
    } else if (!_isActive && _controller.isAnimating) {
      _controller.stop();
      _controller.reset();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final language = ref.watch(appLanguageProvider);
    
    // Localize "Lesson X" -> "Bai X"
    String title = widget.node.lesson.title;
    if (title.startsWith('Lesson ')) {
      final number = title.replaceAll('Lesson ', '');
      title = '${language.lessonLabel} $number';
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: widget.node.isLocked ? null : widget.onTap,
          child: AnimatedBuilder(
            animation: _scaleAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _isActive ? _scaleAnimation.value : 1.0,
                child: child,
              );
            },
            child: _buildProClayNode(context),
          ),
        ),
        const SizedBox(height: 8),
        _buildStars(context),
        const SizedBox(height: 4),
        Text(
          title,
          style: TextStyle(
            color: widget.node.isLocked ? AppThemeV2.textSub : AppThemeV2.textMain,
            fontWeight: widget.isActive ? FontWeight.w900 : FontWeight.bold,
            fontSize: 12,
            fontFamily: 'M_PLUS_Rounded_1c', 
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildProClayNode(BuildContext context) {
    final colors = _getNodeColors();
    final depth = widget.node.isLocked ? 2.0 : 8.0;
    
    return Container(
      width: widget.size,
      height: widget.size, // Aspect ratio 1:1, depth handled by shadow
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        // Main sphere gradient
        gradient: RadialGradient(
          center: const Alignment(-0.4, -0.4), // Light source top-left
          radius: 1.2,
          colors: [
            colors.light,
            colors.main,
            colors.dark,
          ],
          stops: const [0.0, 0.4, 0.9],
        ),
        boxShadow: [
           // Drop Shadow (Depth)
           BoxShadow(
             color: colors.shadow.withValues(alpha: 0.4),
             offset: Offset(0, depth),
             blurRadius: 10,
             spreadRadius: 1,
           ),
           // Inner Highlight (Top Left - "Glassy")
           BoxShadow(
             color: Colors.white.withValues(alpha: 0.4),
             offset: const Offset(-4, -4),
             blurRadius: 8,
             spreadRadius: -2,
             blurStyle: BlurStyle.inner, // IMPORTANT: Inner shadow
           ),
           // Inner Shadow (Bottom Right)
           BoxShadow(
             color: Colors.black.withValues(alpha: 0.1),
             offset: const Offset(4, 4),
             blurRadius: 8,
             spreadRadius: -2,
             blurStyle: BlurStyle.inner,
           ),
           // Glow for Active
           if (_isActive)
             BoxShadow(
               color: colors.main.withValues(alpha: 0.6),
               blurRadius: 20,
               spreadRadius: 4,
             ),
        ],
      ),
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
             if (widget.node.isCompleted)
              Icon(Icons.check_rounded, color: Colors.white, size: widget.size * 0.5)
             else if (widget.node.isLocked)
              Icon(Icons.lock_rounded, color: Colors.white.withValues(alpha: 0.5), size: widget.size * 0.4)
             else
              Icon(Icons.play_arrow_rounded, color: Colors.white, size: widget.size * 0.5),
             
             // Shine reflection (Gloss)
             Positioned(
               top: widget.size * 0.15,
               left: widget.size * 0.2,
               child: Container(
                 width: widget.size * 0.25,
                 height: widget.size * 0.12,
                 decoration: BoxDecoration(
                   color: Colors.white.withValues(alpha: 0.3),
                   borderRadius: BorderRadius.all(Radius.elliptical(widget.size, widget.size)),
                 ),
               ),
             ),
          ],
        ),
      ),
    );
  }

  _NodeColors _getNodeColors() {
    if (widget.node.isLocked) {
      return _NodeColors(
        light: const Color(0xFFE5E7EB),
        main: const Color(0xFFD1D5DB), // Slate 300
        dark: const Color(0xFF9CA3AF),
        shadow: Colors.black,
      );
    }
    if (widget.node.isCompleted) {
      // Amber/Gold
      return _NodeColors(
        light: AppThemeV2.amber400,
        main: Colors.orange, // Standard orange for middle
        dark: AppThemeV2.orange500,
        shadow: AppThemeV2.orange500,
      );
    }
    // Active (Violet)
    return _NodeColors(
      light: const Color(0xFFA78BFA), // Violet 400
      main: AppThemeV2.violet500,
      dark: AppThemeV2.indigo600,
      shadow: AppThemeV2.indigo600,
    );
  }

  Widget _buildStars(BuildContext context) {
    if (widget.node.isLocked) return const SizedBox(height: 16); 
    
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        final isEarned = index < widget.node.stars;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 1.0),
          child: Icon(
            Icons.star_rounded,
            size: 14,
            color: isEarned ? const Color(0xFFFFC800) : Colors.grey[300],
             shadows: isEarned ? [
               Shadow(color: Colors.orange.withValues(alpha: 0.5), blurRadius: 4),
             ] : null,
          ),
        );
      }),
    );
  }
}

class _NodeColors {
  final Color light;
  final Color main;
  final Color dark;
  final Color shadow;

  _NodeColors({
    required this.light,
    required this.main,
    required this.dark,
    required this.shadow,
  });
}

extension on LessonNodeWidget {
  bool get isActive => !node.isLocked && !node.isCompleted;
}
