import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../models/swipe_action.dart';
import '../../../data/models/vocab_item.dart';

class EnhancedFlashcard extends StatefulWidget {
  final VocabItem item;
  final VoidCallback? onFlip;
  final Function(SwipeAction)? onSwipe;
  final bool enableSwipeGestures;
  final bool showTermFirst;

  const EnhancedFlashcard({
    super.key,
    required this.item,
    this.onFlip,
    this.onSwipe,
    this.enableSwipeGestures = true,
    this.showTermFirst = true,
  });

  @override
  State<EnhancedFlashcard> createState() => _EnhancedFlashcardState();
}

class _EnhancedFlashcardState extends State<EnhancedFlashcard>
    with SingleTickerProviderStateMixin {
  late AnimationController _swipeController;
  Offset _swipeOffset = Offset.zero;
  SwipeDirection? _currentSwipeDirection;
  bool _isFlipped = false;

  @override
  void initState() {
    super.initState();
    _swipeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _swipeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: _handleTap,
      onHorizontalDragUpdate: widget.enableSwipeGestures ? _handleHorizontalDrag : null,
      onHorizontalDragEnd: widget.enableSwipeGestures ? _handleHorizontalDragEnd : null,
      onVerticalDragUpdate: widget.enableSwipeGestures ? _handleVerticalDrag : null,
      onVerticalDragEnd: widget.enableSwipeGestures ? _handleVerticalDragEnd : null,
      child: Stack(
        children: [
          // Swipe indicators
          if (widget.enableSwipeGestures) _buildSwipeIndicators(),

          // Card
          AnimatedBuilder(
            animation: _swipeController,
            builder: (context, child) {
              return Transform.translate(
                offset: _swipeOffset,
                child: Transform.rotate(
                  angle: _swipeOffset.dx / screenSize.width * 0.4,
                  child: child,
                ),
              );
            },
            child: _buildCard(context),
          ),
        ],
      ),
    );
  }

  void _handleTap() {
    setState(() {
      _isFlipped = !_isFlipped;
    });
    widget.onFlip?.call();
  }

  void _handleHorizontalDrag(DragUpdateDetails details) {
    setState(() {
      _swipeOffset += details.delta;

      // Determine direction
      if (_swipeOffset.dx > 50) {
        _currentSwipeDirection = SwipeDirection.right;
      } else if (_swipeOffset.dx < -50) {
        _currentSwipeDirection = SwipeDirection.left;
      }
    });
  }

  void _handleHorizontalDragEnd(DragEndDetails details) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    if (_swipeOffset.dx.abs() > screenWidth * 0.4) {
      // Threshold reached - trigger swipe action
      _triggerSwipe(_currentSwipeDirection == SwipeDirection.right
          ? SwipeAction.know
          : SwipeAction.needPractice);
    } else {
      // Return to center
      _resetPosition();
    }
  }

  void _handleVerticalDrag(DragUpdateDetails details) {
    setState(() {
      _swipeOffset += details.delta;

      if (_swipeOffset.dy < -50) {
        _currentSwipeDirection = SwipeDirection.up;
      } else if (_swipeOffset.dy > 50) {
        _currentSwipeDirection = SwipeDirection.down;
      }
    });
  }

  void _handleVerticalDragEnd(DragEndDetails details) {
    final screenHeight = MediaQuery.of(context).size.height;

    if (_swipeOffset.dy.abs() > screenHeight * 0.2) {
      _triggerSwipe(_currentSwipeDirection == SwipeDirection.up
          ? SwipeAction.star
          : SwipeAction.skip);
    } else {
      _resetPosition();
    }
  }

  void _triggerSwipe(SwipeAction action) async {
    // Animate card out
    await _swipeController.forward();
    
    // Notify parent
    widget.onSwipe?.call(action);
    
    // Reset for next card
    setState(() {
      _swipeOffset = Offset.zero;
      _currentSwipeDirection = null;
      _isFlipped = false;
    });
    _swipeController.reset();
  }

  void _resetPosition() {
    setState(() {
      _swipeOffset = Offset.zero;
      _currentSwipeDirection = null;
    });
  }

  Widget _buildCard(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 480, // Slightly taller for emphasis
      margin: const EdgeInsets.symmetric(horizontal: 20),
      // Mimic ClayCard decoration
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFFE5E7EB), // Neutral 200
          width: 3,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE5E7EB),
            offset: const Offset(0, 8), // Deeper shadow for main card
            blurRadius: 0, // Sharp clay style
          ),
        ],
      ),
      child: _isFlipped ? _buildBack() : _buildFront(),
    ).animate(target: _isFlipped ? 1 : 0).flipH(duration: 300.ms);
  }

  Widget _buildFront() {
    final displayTerm = widget.showTermFirst 
        ? widget.item.term 
        : widget.item.meaning;
    final secondaryText = widget.showTermFirst && widget.item.reading != null
        ? widget.item.reading
        : null;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            displayTerm,
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 48,
                ),
            textAlign: TextAlign.center,
          ),
          if (secondaryText != null) ...[
            const SizedBox(height: 16),
            Text(
              secondaryText,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.grey[600],
                  ),
              textAlign: TextAlign.center,
            ),
          ],
          const SizedBox(height: 32),
          Text(
            'Tap to flip',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[500],
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildBack() {
    final displayMeaning = widget.showTermFirst 
        ? widget.item.meaning 
        : widget.item.term;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              displayMeaning,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
              textAlign: TextAlign.center,
            ),
            if (widget.item.kanjiMeaning != null &&
                widget.item.kanjiMeaning!.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                widget.item.kanjiMeaning!,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.grey[700],
                      fontStyle: FontStyle.italic,
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSwipeIndicators() {
    return Stack(
      children: [
        // Left - Need Practice (Orange)
        Positioned(
          left: 20,
          top: 0,
          bottom: 0,
          child: AnimatedOpacity(
            opacity: _swipeOffset.dx < -50 ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 150),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.replay_rounded,
                    size: 64,
                    color: Colors.orange[400],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    SwipeAction.needPractice.label,
                    style: TextStyle(
                      color: Colors.orange[400],
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Right - Know (Green)
        Positioned(
          right: 20,
          top: 0,
          bottom: 0,
          child: AnimatedOpacity(
            opacity: _swipeOffset.dx > 50 ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 150),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.check_circle_rounded,
                    size: 64,
                    color: Colors.green[400],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    SwipeAction.know.label,
                    style: TextStyle(
                      color: Colors.green[400],
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Up - Star (Amber)
        Positioned(
          top: 20,
          left: 0,
          right: 0,
          child: AnimatedOpacity(
            opacity: _swipeOffset.dy < -50 ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 150),
            child: Center(
              child: Icon(
                Icons.star_rounded,
                size: 64,
                color: Colors.amber[400],
              ),
            ),
          ),
        ),

        // Down - Skip (Grey)
        Positioned(
          bottom: 20,
          left: 0,
          right: 0,
          child: AnimatedOpacity(
            opacity: _swipeOffset.dy > 50 ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 150),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.skip_next_rounded,
                    size: 48,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    SwipeAction.skip.label,
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
