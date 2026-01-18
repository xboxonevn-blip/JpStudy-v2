// import 'package:just_audio/just_audio.dart';

class TtsService {
  static final TtsService _instance = TtsService._internal();
  static TtsService get instance => _instance;

  // late AudioPlayer _player;
  bool _isInitialized = false;

  TtsService._internal() {
    // _player = AudioPlayer();
  }

  Future<void> initialize() async {
    if (_isInitialized) return;
    _isInitialized = true;
  }

  Future<void> speak(String text) async {
     // print("TTS Disabled: Would speak '$text'");
  }

  Future<void> stop() async {
    // await _player.stop();
  }
}
