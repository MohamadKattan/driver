// this class for for play sounds methods

import 'package:assets_audio_player/assets_audio_player.dart';
import '../config.dart';

class PlaySoundTool {


  // this method for display sounds
  void openPlaySound(String path) {
    assetsAudioPlayer.open(
      Audio(path),
    );
  }

  // this method for Stop sounds
  void stopSound() {
    assetsAudioPlayer.stop();
    assetsAudioPlayer.open(
      Audio("")
    );
    return;
  }
}
