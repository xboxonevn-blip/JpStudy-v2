import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../data/models/vocab_item.dart';

class EnhancedFlashcard extends StatefulWidget {
  final VocabItem item;
  final VoidCallback? onFlip;
  final bool showTermFirst;

  const EnhancedFlashcard({
    super.key,
    required this.item,
    this.onFlip,
    this.showTermFirst = true,
  });

  @override
  State<EnhancedFlashcard> createState() => _EnhancedFlashcardState();
}

class _EnhancedFlashcardState extends State<EnhancedFlashcard> {
  bool _isFlipped = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: Container(
        // Ensure hit testing works for the whole area
        color: Colors.transparent,
        child: _buildCard(context),
      ),
    );
  }

  void _handleTap() {
    setState(() {
      _isFlipped = !_isFlipped;
    });
    widget.onFlip?.call();
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
        boxShadow: const [
          BoxShadow(
            color: Color(0xFFE5E7EB),
            offset: Offset(0, 8), // Deeper shadow for main card
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
}
