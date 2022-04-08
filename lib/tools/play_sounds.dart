// this class for for play sounds methods

import 'package:assets_audio_player/assets_audio_player.dart';
import '../config.dart';

class PlaySoundTool {

  // FlutterSoundPlayer? _soundPlayer;
  //
  // Future init()async{
  //   _soundPlayer =  FlutterSoundPlayer();
  //   await _soundPlayer!.openAudioSession();
  // }
  //
  // Future dispose()async{
  //   await _soundPlayer!.closeAudioSession();
  //   _soundPlayer =null;
  // }
  //
  // Future play()async{
  //   await _soundPlayer!.startPlayer(
  //     fromURI:"sounds/new_order.mp3",
  //   );
  // }
  //
  // Future stop()async{
  //   await _soundPlayer!.stopPlayer();
  // }
  //
  // Future togglePlaying()async{
  //   if(_soundPlayer!.isStopped){
  //     await play();
  //   }else{
  //     await stop();
  //   }
  // }



  // this method for display sounds
  void openPlaySound(String path) {
    AssetsAudioPlayer.newPlayer().open(
      Audio(path),
      autoStart: true
    );
  }
}
