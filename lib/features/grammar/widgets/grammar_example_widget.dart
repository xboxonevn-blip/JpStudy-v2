import 'package:flutter/material.dart';

class GrammarExampleWidget extends StatelessWidget {
  final String japanese;
  final String translation;
  final String? translationVi;
  final bool showVietnamese;

  const GrammarExampleWidget({
    super.key,
    required this.japanese,
    required this.translation,
    this.translationVi,
    this.showVietnamese = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                japanese,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  height: 1.4,
                ),
              ),
            ),
            // Audio button removed - TTS disabled
          ],
        ),
        const SizedBox(height: 4),
        Text(
          showVietnamese ? (translationVi ?? translation) : translation,
          style: TextStyle(
            fontSize: 16,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }
}
