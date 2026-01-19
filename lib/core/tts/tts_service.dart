import 'dart:io';

import 'package:flutter/foundation.dart';

/// Exception thrown when TTS is not configured (stub - TTS disabled)
class TtsNotConfiguredException implements Exception {
  const TtsNotConfiguredException();
}

/// Exception thrown when TTS request fails (stub - TTS disabled)
class TtsRequestException implements Exception {
  const TtsRequestException(this.statusCode, this.body);

  final int statusCode;
  final String body;
}

/// Stub TtsService - TTS functionality disabled
class TtsService {
  TtsService();

  /// No-op synthesize - throws exception as TTS is disabled
  Future<File> synthesize({
    required String text,
    required String locale,
    String? voice,
  }) async {
    debugPrint('TtsService: synthesize($text) - disabled');
    throw const TtsNotConfiguredException();
  }

  void dispose() {
    // TTS disabled
  }

  Future<int> cacheSizeBytes() async {
    return 0;
  }

  Future<void> clearCache() async {
    // No cache to clear
  }
}
