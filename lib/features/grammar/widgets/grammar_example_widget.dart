import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jpstudy/app/theme/app_theme_palette.dart';
import 'package:jpstudy/core/app_language.dart';
import 'package:jpstudy/core/audio/tts_service.dart';
import 'package:jpstudy/data/utils/grammar_english_notation.dart';

class GrammarExampleWidget extends ConsumerWidget {
  final AppLanguage language;
  final String japanese;
  final String translation;
  final String? translationVi;
  final String? translationEn;
  final bool showVietnamese;

  const GrammarExampleWidget({
    super.key,
    required this.language,
    required this.japanese,
    required this.translation,
    this.translationVi,
    this.translationEn,
    this.showVietnamese = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioText = japanese.trim();
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
            if (audioText.isNotEmpty)
              IconButton(
                tooltip: 'Play Japanese audio',
                icon: const Icon(Icons.volume_up_rounded),
                onPressed: () => _speak(context, ref, audioText),
              ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          _resolveTranslation(),
          style: TextStyle(
            fontSize: 16,
            color: context.appPalette.ink.withValues(alpha: 0.55),
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  Future<void> _speak(BuildContext context, WidgetRef ref, String text) async {
    final result = await ref.read(ttsServiceProvider).speak(text);
    if (!context.mounted) return;
    final message = switch (result.status) {
      TtsSpeakStatus.queued => 'Audio queued',
      TtsSpeakStatus.empty => 'No Japanese text to read',
      TtsSpeakStatus.unavailable => 'Trình duyệt không có giọng tiếng Nhật.',
      TtsSpeakStatus.error => 'Could not play Japanese audio.',
    };
    ScaffoldMessenger.maybeOf(
      context,
    )?.showSnackBar(SnackBar(content: Text(result.message ?? message)));
  }

  String _resolveTranslation() {
    if (!showVietnamese) {
      return translation;
    }
    switch (language) {
      case AppLanguage.en:
        return resolveEnglishGrammarExampleTranslation(
          japanese: japanese,
          translationEn: translationEn,
          translation: translation,
        );
      case AppLanguage.vi:
        return (translationVi ?? translation).trim();
      case AppLanguage.ja:
        return resolveEnglishGrammarExampleTranslation(
          japanese: japanese,
          translationEn: translationEn,
          translation: translation,
        );
    }
  }
}
