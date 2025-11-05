import 'package:just_audio/just_audio.dart';

class BgmService {
  BgmService._privateConstructor();
  static final BgmService instance = BgmService._privateConstructor();

  final AudioPlayer _player = AudioPlayer();

  Future<void> init() async {
    await _player.setAsset('assets/audio/bgm/background0.ogg');
    _player.setLoopMode(LoopMode.one);
    _player.setVolume(0.4);
  }

  void play() {
    _player.play();
  }

  void stop() {
    _player.stop();
  }

  void setVolume(double volume) {
    _player.setVolume(volume);
  }

  Future<void> dispose() async {
    await _player.dispose();
  }
}
