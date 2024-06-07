import 'dart:math';
import 'package:audioplayers/audioplayers.dart';

class SoundManager {
  static final AudioPlayer _audioPlayer = AudioPlayer();
  static final Random _random = Random();
  static final Map<String, List<String>> _audioPaths = {
    'Positive': ['assets/music/positive1.mp3', 'assets/music/positive2.mp3', 'assets/music/positive3.mp3'],
    'Negative': ['assets/music/negative1.mp3', 'assets/music/negative2.mp3', 'assets/music/negative3.mp3'],
    'Neutral': ['assets/music/neutral1.mp3', 'assets/music/neutral2.mp3']
  };

  static Future<void> playSound(String sentiment) async {
    var audioPaths = _audioPaths[sentiment];
    if (audioPaths != null && audioPaths.isNotEmpty) {
      var audioPath = audioPaths[_random.nextInt(audioPaths.length)];
      await _audioPlayer.setReleaseMode(ReleaseMode.loop);
      await _audioPlayer.play(DeviceFileSource(audioPath));
      await _audioPlayer.setVolume(0.5);
    }
  }

  static Future<void> stopSound() async {
    await _audioPlayer.stop();
  }
}
