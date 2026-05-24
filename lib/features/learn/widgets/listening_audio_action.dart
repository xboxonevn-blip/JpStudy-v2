import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jpstudy/app/theme/app_theme_palette.dart';
import 'package:jpstudy/core/app_language.dart';
import 'package:jpstudy/core/audio/tts_service.dart';
import 'package:jpstudy/widgets/foundation/foundation.dart';

class ListeningAudioAction extends ConsumerWidget {
  const ListeningAudioAction({
    super.key,
    required this.audioText,
    required this.language,
  });

  final String audioText;
  final AppLanguage language;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final normalized = audioText.trim();
    if (normalized.isEmpty) return const SizedBox.shrink();
    final palette = context.appPalette;
    return Container(
      key: const ValueKey('listening_audio_action'),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: palette.info.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: palette.info.withValues(alpha: 0.22)),
      ),
      child: Row(
        children: [
          Icon(Icons.headphones_rounded, color: palette.info),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              _prompt(language),
              style: TextStyle(color: palette.ink, fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(width: 10),
          AppButton(
            key: const ValueKey('listening_play_audio'),
            label: _play(language),
            icon: Icons.volume_up_rounded,
            compact: true,
            onPressed: () => _speak(context, ref, normalized),
          ),
        ],
      ),
    );
  }

  Future<void> _speak(BuildContext context, WidgetRef ref, String text) async {
    final result = await ref.read(ttsServiceProvider).speak(text);
    if (!context.mounted) return;
    final message = switch (result.status) {
      TtsSpeakStatus.queued => _queued(language),
      TtsSpeakStatus.empty => _empty(language),
      TtsSpeakStatus.unavailable => 'Trình duyệt không có giọng tiếng Nhật.',
      TtsSpeakStatus.error => _error(language),
    };
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(result.message ?? message)));
  }

  String _prompt(AppLanguage language) => switch (language) {
    AppLanguage.en => 'Play the Japanese audio before answering.',
    AppLanguage.vi => 'Bấm phát âm tiếng Nhật trước khi trả lời.',
    AppLanguage.ja => '答える前に日本語音声を再生してください。',
  };

  String _play(AppLanguage language) => switch (language) {
    AppLanguage.en => 'Play',
    AppLanguage.vi => 'Phát âm',
    AppLanguage.ja => '再生',
  };

  String _queued(AppLanguage language) => switch (language) {
    AppLanguage.en => 'Audio queued.',
    AppLanguage.vi => 'Đã phát âm.',
    AppLanguage.ja => '音声を再生しました。',
  };

  String _empty(AppLanguage language) => switch (language) {
    AppLanguage.en => 'No Japanese text to read.',
    AppLanguage.vi => 'Chưa có tiếng Nhật để phát âm.',
    AppLanguage.ja => '読み上げる日本語がありません。',
  };

  String _error(AppLanguage language) => switch (language) {
    AppLanguage.en => 'Could not play Japanese audio.',
    AppLanguage.vi => 'Chưa phát được âm thanh tiếng Nhật.',
    AppLanguage.ja => '日本語音声を再生できませんでした。',
  };
}
