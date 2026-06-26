import 'tts_types.dart';

TtsService createTtsService() => const StubTtsService();

class StubTtsService implements TtsService {
  const StubTtsService();

  @override
  bool get isSupported => false;

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
    return TtsSpeakResult(
      status: TtsSpeakStatus.unavailable,
      spokenText: normalized,
    );
  }
}
