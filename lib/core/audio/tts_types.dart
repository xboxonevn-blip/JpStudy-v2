enum TtsSpeakStatus { queued, empty, unavailable, error }

class TtsSpeakResult {
  const TtsSpeakResult({required this.status, this.message, this.spokenText});

  final TtsSpeakStatus status;
  final String? message;
  final String? spokenText;

  bool get didQueue => status == TtsSpeakStatus.queued;
}

abstract class TtsService {
  Future<TtsSpeakResult> speak(
    String text, {
    String lang = 'ja-JP',
    double rate = 0.9,
  });

  bool get isSupported;
}

String japaneseTtsText({
  required String term,
  String? reading,
  String? fallback,
}) {
  final normalizedReading = (reading ?? '').trim();
  if (normalizedReading.isNotEmpty) return normalizedReading;
  final normalizedTerm = term.trim();
  if (normalizedTerm.isNotEmpty) return normalizedTerm;
  return (fallback ?? '').trim();
}
