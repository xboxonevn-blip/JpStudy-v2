import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ClozeTestWidget extends StatefulWidget {
  final String sentenceTemplate; // e.g., "私は {blank} です。"
  final List<String> options;
  final String correctOption;
  final Function(bool isCorrect, String selected) onCheck;

  const ClozeTestWidget({
    super.key,
    required this.sentenceTemplate,
    required this.options,
    required this.correctOption,
    required this.onCheck,
  });

  @override
  State<ClozeTestWidget> createState() => _ClozeTestWidgetState();
}

class _ClozeTestWidgetState extends State<ClozeTestWidget> {
  String? _selectedOption;
  bool? _isCorrect;

  void _onOptionSelected(String option) {
    if (_isCorrect != null) return;
    setState(() {
      _selectedOption = option;
    });
  }

  void _check() {
    if (_selectedOption == null) return;
    setState(() {
      _isCorrect = _selectedOption == widget.correctOption;
      widget.onCheck(_isCorrect!, _selectedOption!);
    });
  }

  @override
  Widget build(BuildContext context) {
    final parts = widget.sentenceTemplate.split('{blank}');
    
    return Column(
      children: [
        // Sentence Display
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(16),
          ),
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(height: 1.5),
              children: [
                TextSpan(text: parts[0]),
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: _isCorrect == null 
                              ? Theme.of(context).colorScheme.primary 
                              : (_isCorrect! ? Colors.green : Colors.red),
                          width: 2,
                        ),
                      ),
                    ),
                    child: Text(
                      _selectedOption ?? " ",
                      style: TextStyle(
                        color: _isCorrect == null 
                            ? Theme.of(context).colorScheme.primary 
                            : (_isCorrect! ? Colors.green : Colors.red),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                if (parts.length > 1) TextSpan(text: parts[1]),
              ],
            ),
          ),
        ),
        const SizedBox(height: 48),
        // Options List
        Column(
          children: widget.options.asMap().entries.map((entry) {
            final option = entry.value;
            final isSelected = _selectedOption == option;
            
            Color? tileColor;
            if (isSelected) {
              if (_isCorrect == null) {
                tileColor = Theme.of(context).colorScheme.primaryContainer;
              } else {
                tileColor = _isCorrect! ? Colors.green[100] : Colors.red[100];
              }
            }

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: InkWell(
                onTap: () => _onOptionSelected(option),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  decoration: BoxDecoration(
                    color: tileColor ?? Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected 
                          ? (_isCorrect == null ? Theme.of(context).colorScheme.primary : (_isCorrect! ? Colors.green : Colors.red))
                          : Theme.of(context).colorScheme.outlineVariant,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Theme.of(context).colorScheme.outline),
                        ),
                        child: Center(child: Text("${entry.key + 1}")),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        option,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      const Spacer(),
                      if (isSelected && _isCorrect != null)
                        Icon(
                          _isCorrect! ? Icons.check_circle : Icons.cancel,
                          color: _isCorrect! ? Colors.green : Colors.red,
                        ),
                    ],
                  ),
                ),
              ).animate().slideX(begin: 0.1, duration: 300.ms, delay: 50.ms * entry.key).fadeIn(),
            );
          }).toList(),
        ),
        const Spacer(),
        // Actions
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: _selectedOption == null || _isCorrect != null ? null : _check,
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 20),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('CHECK ANSWER', style: TextStyle(letterSpacing: 1.2, fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }
}
