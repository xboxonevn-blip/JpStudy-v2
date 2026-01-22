import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../common/widgets/clay_button.dart';
import '../../common/widgets/clay_card.dart';
import '../../../theme/app_theme_v2.dart';

class SentenceBuilderWidget extends StatefulWidget {
  final String prompt;
  final List<String> correctWords;
  final List<String> shuffledWords;
  final Function(bool isCorrect) onCheck;
  final VoidCallback onReset;

  const SentenceBuilderWidget({
    super.key,
    required this.prompt,
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
    Color targetColor = Colors.white;
    if (_isLastCorrect == true) targetColor = AppThemeV2.secondary.withValues(alpha: 0.2);
    if (_isLastCorrect == false) targetColor = AppThemeV2.error.withValues(alpha: 0.1);

    return Column(
      children: [
        // Prompt
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 24),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppThemeV2.primary.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppThemeV2.primary.withValues(alpha: 0.1)),
          ),
          child: Column(
            children: [
               Text(
                 'Arrange the sentence:',
                 style: TextStyle(
                   color: AppThemeV2.textSub,
                   fontSize: 12,
                   fontWeight: FontWeight.bold,
                   letterSpacing: 0.5,
                 ),
               ),
               const SizedBox(height: 8),
               Text(
                 widget.prompt,
                 textAlign: TextAlign.center,
                 style: TextStyle(
                    color: AppThemeV2.textMain,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                 ),
               ),
            ],
          ),
        ),

        // Target Area
        ClayCard(
          color: targetColor,
          child: Container(
            constraints: const BoxConstraints(minHeight: 120),
            width: double.infinity,
            alignment: Alignment.centerLeft,
            child: Wrap(
              spacing: 8,
              runSpacing: 12,
              children: _selectedWords.asMap().entries.map((entry) {
                return _ClayWordTile(
                  word: entry.value,
                  onTap: () => _deselectWord(entry.key),
                  isSelected: true,
                ).animate().scale(duration: 200.ms).fadeIn();
              }).toList(),
            ),
          ),
        ),
        const SizedBox(height: 32),
        // Source Area
        Wrap(
          spacing: 12,
          runSpacing: 16,
          alignment: WrapAlignment.center,
          children: _remainingWords.asMap().entries.map((entry) {
            return _ClayWordTile(
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
              child: ClayButton(
                label: 'Reset',
                icon: Icons.refresh,
                style: ClayButtonStyle.neutral,
                onPressed: _reset,
                isExpanded: true,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ClayButton(
                label: 'Check',
                icon: Icons.check_circle,
                style: _isLastCorrect == true ? ClayButtonStyle.secondary : ClayButtonStyle.primary,
                onPressed: _selectedWords.isEmpty ? null : _check,
                isExpanded: true,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ClayWordTile extends StatelessWidget {
  final String word;
  final VoidCallback onTap;
  final bool isSelected;

  const _ClayWordTile({
    required this.word,
    required this.onTap,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClayButton(
        label: word,
        onPressed: onTap,
        style: isSelected ? ClayButtonStyle.primary : ClayButtonStyle.neutral,
      ),
    );
  }
}


