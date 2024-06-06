import 'dart:math';
import 'package:audioplayers/audioplayers.dart';

class SoundManager {
  static final AudioPlayer _audioPlayer = AudioPlayer();
  static final Random _random = Random();
  static final Map<String, List<String>> _audioPaths = {
    'Positive': ['assets/music/positive1.mp3', 'assets/music/positive2.mp3'],
    'Negative': ['assets/music/negative1.mp3', 'assets/music/negative2.mp3'],
    'Neutral': ['assets/music/neutral.mp3']
  };

  static Future<void> playSound(String sentiment) async {
    var audioPaths = _audioPaths[sentiment];
    if (audioPaths != null && audioPaths.isNotEmpty) {
      var audioPath = audioPaths[_random.nextInt(audioPaths.length)];
      await _audioPlayer.setReleaseMode(ReleaseMode.LOOP);
      await _audioPlayer.play(audioPath, isLocal: true);
    }
  }

  static Future<void> stopSound() async {
    await _audioPlayer.stop();
  }
}
