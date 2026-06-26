import 'dart:js_interop';

import 'package:web/web.dart' as web;

import 'tts_types.dart';

TtsService createTtsService() => const WebSpeechTtsService();

class WebSpeechTtsService implements TtsService {
  const WebSpeechTtsService();

  @override
  bool get isSupported => true;

  @override
  Future<TtsSpeakResult> speak(
    String text, {
    String lang = 'ja-JP',
    double rate = 0.9,
  }) async {
    final normalized = text.trim();
    if (normalized.isEmpty) {
      return const TtsSpeakResult(status: TtsSpeakStatus.empty);
    }

    try {
      final synth = web.window.speechSynthesis;
      final voice = _selectVoice(synth, lang);
      if (voice is _UnavailableVoice) {
        return TtsSpeakResult(
          status: TtsSpeakStatus.unavailable,
          spokenText: normalized,
        );
      }

      synth.cancel();
      final utterance = web.SpeechSynthesisUtterance(normalized)
        ..lang = lang
        ..rate = rate
        ..pitch = 1
        ..volume = 1;
      if (voice is _SelectedVoice) {
        utterance.voice = voice.voice;
      }
      synth.speak(utterance);
      return TtsSpeakResult(
        status: TtsSpeakStatus.queued,
        spokenText: normalized,
      );
    } catch (error) {
      return TtsSpeakResult(
        status: TtsSpeakStatus.error,
        spokenText: normalized,
        message: error.toString(),
      );
    }
  }

  _VoiceSelection _selectVoice(web.SpeechSynthesis synth, String lang) {
    final voices = synth.getVoices().toDart;
    if (voices.isEmpty) return const _VoiceSelection.pending();
    final normalizedLang = lang.toLowerCase();
    web.SpeechSynthesisVoice? firstJapanese;
    for (final voice in voices) {
      final voiceLang = voice.lang.toLowerCase();
      if (voiceLang == normalizedLang) return _SelectedVoice(voice);
      if (firstJapanese == null && voiceLang.startsWith('ja')) {
        firstJapanese = voice;
      }
    }
    if (firstJapanese != null) return _SelectedVoice(firstJapanese);
    return const _VoiceSelection.unavailable();
  }
}

sealed class _VoiceSelection {
  const _VoiceSelection();

  const factory _VoiceSelection.pending() = _PendingVoiceList;
  const factory _VoiceSelection.unavailable() = _UnavailableVoice;
}

final class _PendingVoiceList extends _VoiceSelection {
  const _PendingVoiceList();
}

final class _UnavailableVoice extends _VoiceSelection {
  const _UnavailableVoice();
}

final class _SelectedVoice extends _VoiceSelection {
  const _SelectedVoice(this.voice);

  final web.SpeechSynthesisVoice voice;
}
