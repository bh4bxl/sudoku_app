import 'package:flutter/cupertino.dart';
import 'package:just_audio/just_audio.dart';

class BgmService {
  BgmService._privateConstructor();
  static final BgmService instance = BgmService._privateConstructor();

  final AudioPlayer _player = AudioPlayer();
  final List<String> tracks = [
    'assets/audio/bgm/background0.ogg',
    'assets/audio/bgm/background1.ogg',
    'assets/audio/bgm/background2.ogg',
    'assets/audio/bgm/background3.ogg',
  ];

  final ValueNotifier<int?> selectedIndex = ValueNotifier<int?>(null);
  final ValueNotifier<bool> isPlaying = ValueNotifier<bool>(false);

  Future<void> init() async {
    _player.setLoopMode(LoopMode.one);
    _player.playerStateStream.listen((state) {
      isPlaying.value = state.playing;
    });
    _player.setVolume(0.4);
  }

  Future<void> selectAndPlay(int index) async {
    if (index < 0 || index >= tracks.length) return;
    if (selectedIndex.value == index && isPlaying.value) {
      return;
    }

    selectedIndex.value = index;

    final src = tracks[index];
    try {
      await _player.setAsset(src);
      _player.setLoopMode(LoopMode.one);
      await _player.play();
      isPlaying.value = true;
    } catch (e) {
      isPlaying.value = false;
      debugPrint('BGM load/play error: $e');
    }
  }

  Future<void> togglePlayPause() async {
    if (_player.playing) {
      await _player.pause();
      isPlaying.value = false;
    } else {
      if (selectedIndex.value == null) {
        await selectAndPlay(0);
      } else {
        await _player.play();
        isPlaying.value = true;
      }
    }
  }

  Future<void> stop() async {
    await _player.stop();
    isPlaying.value = false;
  }

  Future<void> setVolume(double volume) async {
    await _player.setVolume(volume.clamp(0.0, 1.0));
  }

  Future<void> dispose() async {
    await _player.dispose();
  }
}
