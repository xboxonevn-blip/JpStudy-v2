import 'dart:math';
import 'package:flutter/material.dart';
import 'package:jpstudy/core/app_language.dart';
import 'package:jpstudy/data/models/vocab_item.dart';

class FlashcardWidget extends StatefulWidget {
  final VocabItem item;
  final VoidCallback? onFlip;
  final AppLanguage language;

  const FlashcardWidget({
    super.key,
    required this.item,
    this.onFlip,
    required this.language,
  });

  @override
  State<FlashcardWidget> createState() => _FlashcardWidgetState();
}

class _FlashcardWidgetState extends State<FlashcardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isFront = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutBack),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _flipCard() {
    if (_isFront) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    _isFront = !_isFront;
    widget.onFlip?.call();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _flipCard,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          final angle = _animation.value * pi;
          final transform = Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(angle);

          return Transform(
            transform: transform,
            alignment: Alignment.center,
            child: _animation.value < 0.5
                ? _buildFront()
                : Transform(
                    transform: Matrix4.identity()..rotateY(pi),
                    alignment: Alignment.center,
                    child: _buildBack(),
                  ),
          );
        },
      ),
    );
  }

  Widget _buildCardBase({required Widget child, required Color color}) {
    return Container(
      width: double.infinity,
      height: 480, // Match EnhancedFlashcard height
      decoration: BoxDecoration(
        color:
            Colors.white, // Always white for Clay style usually, or color param
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFFE5E7EB), // Neutral 200
          width: 3,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE5E7EB),
            offset: const Offset(0, 8),
            blurRadius: 0,
          ),
        ],
      ),
      alignment: Alignment.center,
      padding: const EdgeInsets.all(24),
      child: child,
    );
  }

  Widget _buildFront() {
    return _buildCardBase(
      color: Theme.of(context).colorScheme.surface,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.item.term,
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              // Only show Kanji Meaning for Vietnamese and Japanese users
              if (widget.language != AppLanguage.en &&
                  widget.item.kanjiMeaning != null &&
                  widget.item.kanjiMeaning!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  widget.item.kanjiMeaning!,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.grey[700],
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
              const SizedBox(height: 16),
              Text(
                'Tap to flip',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBack() {
    return _buildCardBase(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (widget.item.reading != null &&
              widget.item.reading!.isNotEmpty) ...[
            Text(
              widget.item.reading!,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontStyle: FontStyle.italic),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
          ],
          Text(
            widget.language == AppLanguage.en
                ? (widget.item.meaningEn ?? widget.item.meaning)
                : widget.item.meaning,
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
