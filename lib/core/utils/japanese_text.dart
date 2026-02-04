final RegExp _kanaOnlyPattern = RegExp(
  r'^[\u3040-\u309F\u30A0-\u30FF\uFF66-\uFF9Fー・･\s]+$',
);

bool isKanaOnly(String value) {
  final text = value.trim();
  if (text.isEmpty) {
    return false;
  }
  return _kanaOnlyPattern.hasMatch(text);
}

bool shouldShowReading({required String term, String? reading}) {
  final normalizedTerm = term.trim();
  final normalizedReading = (reading ?? '').trim();
  if (normalizedReading.isEmpty) {
    return false;
  }
  if (normalizedTerm == normalizedReading) {
    return false;
  }
  if (isKanaOnly(normalizedTerm)) {
    return false;
  }
  return true;
}
