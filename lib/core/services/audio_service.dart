import 'package:flutter/foundation.dart';

/// Stub AudioService - audio functionality disabled
class AudioService {
  static final AudioService instance = AudioService._();
  AudioService._();

  Future<void> initialize() async {
    // Audio disabled
  }

  Future<void> play(String soundName) async {
    // Audio disabled - no-op
    debugPrint('AudioService: play($soundName) - disabled');
  }

  void setEnabled(bool enabled) {
    // Audio disabled
  }

  void dispose() {
    // Audio disabled
  }
}
