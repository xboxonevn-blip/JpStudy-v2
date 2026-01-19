import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class GrammarExampleWidget extends StatelessWidget {
  final String japanese;
  final String translation;
  final String? translationVi;
  final bool showVietnamese;
  final FlutterTts tts;

  const GrammarExampleWidget({
    super.key,
    required this.japanese,
    required this.translation,
    this.translationVi,
    this.showVietnamese = true,
    required this.tts,
  });

  Future<void> _speak() async {
    await tts.speak(japanese);
  }

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
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.volume_up_rounded),
              onPressed: _speak,
              color: Theme.of(context).colorScheme.primary,
              tooltip: 'Listen',
            ),
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
