import 'package:just_audio/just_audio.dart';

class SfxService {
  SfxService._privateConstructor();
  static final SfxService instance = SfxService._privateConstructor();

  final _tap = AudioPlayer();
  final _error = AudioPlayer();
  final _complete = AudioPlayer();
  final _fail = AudioPlayer();

  Future<void> init() async {
    await _tap.setAsset('assets/audio/sfx/tap.ogg');
    await _error.setAsset('assets/audio/sfx/error.ogg');
    await _complete.setAsset('assets/audio/sfx/complete.ogg');
    await _fail.setAsset('assets/audio/sfx/fail.ogg');

    _tap.setLoopMode(LoopMode.off);
    _error.setLoopMode(LoopMode.off);
    _complete.setLoopMode(LoopMode.off);
    _fail.setLoopMode(LoopMode.off);
  }

  void tap() async {
    await _tap.seek(Duration.zero);
    _tap.play();
  }

  void error() async {
    await _error.seek(Duration.zero);
    _error.play();
  }

  void complete() async {
    await _complete.seek(Duration.zero);
    _complete.play();
  }

  void fail() async {
    await _fail.seek(Duration.zero);
    _fail.play();
  }

  Future<void> dispose() async {
    await _tap.dispose();
    await _error.dispose();
    await _complete.dispose();
    await _fail.dispose();
  }
}
