import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SentenceBuilderWidget extends StatefulWidget {
  final List<String> correctWords;
  final List<String> shuffledWords;
  final Function(bool isCorrect) onCheck;
  final VoidCallback onReset;

  const SentenceBuilderWidget({
    super.key,
    required this.correctWords,
    required this.shuffledWords,
    required this.onCheck,
    required this.onReset,
  });

  @override
  State<SentenceBuilderWidget> createState() => _SentenceBuilderWidgetState();
}

class _SentenceBuilderWidgetState extends State<SentenceBuilderWidget> {
  final List<String> _selectedWords = [];
  late List<String> _remainingWords;
  bool? _isLastCorrect;

  @override
  void initState() {
    super.initState();
    _remainingWords = List.from(widget.shuffledWords);
  }

  void _selectWord(int index) {
    if (_isLastCorrect != null) return;
    setState(() {
      final word = _remainingWords.removeAt(index);
      _selectedWords.add(word);
    });
  }

  void _deselectWord(int index) {
    if (_isLastCorrect != null) return;
    setState(() {
      final word = _selectedWords.removeAt(index);
      _remainingWords.add(word);
    });
  }

  void _check() {
    setState(() {
      final userSentence = _selectedWords.join('').trim();
      final correctSentence = widget.correctWords.join('').trim();
      _isLastCorrect = userSentence == correctSentence;
      widget.onCheck(_isLastCorrect!);
    });
  }

  void _reset() {
    setState(() {
      _selectedWords.clear();
      _remainingWords = List.from(widget.shuffledWords);
      _isLastCorrect = null;
      widget.onReset();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Target Area
        Container(
          constraints: const BoxConstraints(minHeight: 120),
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _isLastCorrect == null
                  ? Theme.of(context).colorScheme.outlineVariant
                  : (_isLastCorrect! ? Colors.green : Colors.red),
              width: 2,
            ),
          ),
          child: Wrap(
            spacing: 8,
            runSpacing: 12,
            children: _selectedWords.asMap().entries.map((entry) {
              return _WordTile(
                word: entry.value,
                onTap: () => _deselectWord(entry.key),
                isSelected: true,
              ).animate().scale(duration: 200.ms).fadeIn();
            }).toList(),
          ),
        ),
        const SizedBox(height: 32),
        // Source Area
        Wrap(
          spacing: 10,
          runSpacing: 15,
          alignment: WrapAlignment.center,
          children: _remainingWords.asMap().entries.map((entry) {
            return _WordTile(
              word: entry.value,
              onTap: () => _selectWord(entry.key),
              isSelected: false,
            ).animate().fadeIn(delay: 50.ms * entry.key);
          }).toList(),
        ),
        const Spacer(),
        // Actions
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _reset,
                icon: const Icon(Icons.refresh),
                label: const Text('Reset'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: FilledButton.icon(
                onPressed: _selectedWords.isEmpty ? null : _check,
                icon: const Icon(Icons.check_circle_outline),
                label: const Text('Check Answer'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: _isLastCorrect == true ? Colors.green : null,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _WordTile extends StatelessWidget {
  final String word;
  final VoidCallback onTap;
  final bool isSelected;

  const _WordTile({
    required this.word,
    required this.onTap,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected 
              ? Theme.of(context).colorScheme.primaryContainer 
              : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected 
                ? Theme.of(context).colorScheme.primary 
                : Theme.of(context).colorScheme.outline,
          ),
          boxShadow: isSelected ? null : [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          word,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: isSelected 
                ? Theme.of(context).colorScheme.onPrimaryContainer 
                : Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}
