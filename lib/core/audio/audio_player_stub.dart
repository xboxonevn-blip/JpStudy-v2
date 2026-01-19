/// Stub AudioPlayer to replace just_audio dependency
/// Audio functionality is disabled
library;

import 'dart:async';

class PlayerState {
  final bool playing;
  final ProcessingState processingState;
  
  const PlayerState(this.playing, this.processingState);
}

enum ProcessingState {
  idle,
  loading,
  buffering,
  ready,
  completed,
}

class AudioPlayer {
  final _stateController = StreamController<PlayerState>.broadcast();
  
  Stream<PlayerState> get playerStateStream => _stateController.stream;
  
  Future<void> setAsset(String assetPath) async {
    // No-op - audio disabled
  }
  
  Future<void> setFilePath(String path) async {
    // No-op - audio disabled
  }
  
  Future<void> play() async {
    // No-op - audio disabled
  }
  
  Future<void> stop() async {
    // No-op - audio disabled
  }
  
  Future<void> seek(Duration position) async {
    // No-op - audio disabled
  }
  
  void dispose() {
    _stateController.close();
  }
}
