import 'package:just_audio/just_audio.dart';

class AudioService {
  static final AudioService instance = AudioService._();
  AudioService._();

  final Map<String, AudioPlayer> _players = {};
  bool _isEnabled = true;

  Future<void> initialize() async {
    // Preload common sounds
    await _preloadSound('success');
    await _preloadSound('error');
    await _preloadSound('combo');
    await _preloadSound('levelup');
  }

  Future<void> _preloadSound(String name) async {
    try {
      final player = AudioPlayer();
      // Note: These asset paths assume you'll add audio files to assets/sounds/
      // For now, this won't play anything but structure is ready
      // await player.setAsset('assets/sounds/$name.mp3');
      _players[name] = player;
    } catch (e) {
      // Silently fail if audio not available
      // print('Failed to load sound $name: $e');
    }
  }

  Future<void> play(String soundName) async {
    if (!_isEnabled) return;
    
    final player = _players[soundName];
    if (player != null) {
      try {
        await player.seek(Duration.zero);
        await player.play();
      } catch (e) {
        // Silently fail
      }
    }
  }

  void setEnabled(bool enabled) {
    _isEnabled = enabled;
  }

  void dispose() {
    for (final player in _players.values) {
      player.dispose();
    }
    _players.clear();
  }
}
