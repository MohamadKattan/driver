import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

const channel = MethodChannel("com.garanti.driver/channel");
const channelSound = MethodChannel("com.garanti.driverSound/channel");
const channelOpenDailogOld = MethodChannel("com.garanti.driverOld/channel");
const channelClearCash = MethodChannel("com.garanti.driverClearCash/channel");

openDailog() async {
  try {
    await channel.invokeMethod("openDailog");
  } on PlatformException catch (ex) {
    debugPrint(ex.message);
  }
}

openDailogOld() async {
  try {
    await channelOpenDailogOld.invokeMethod("openDailogOld");
  } on PlatformException catch (ex) {
    debugPrint(ex.message);
  }
}

playSound() async {
  try {
    await channelSound.invokeMethod("playSound");
  } on PlatformException catch (ex) {
    debugPrint(ex.message);
  }
}

stopSound() async {
  try {
    await channelSound.invokeMethod("stopSound");
  } on PlatformException catch (ex) {
    debugPrint(ex.message);
  }
}

clearCash() async {
  try {
    await channelClearCash.invokeMethod("clearCash");
  } on PlatformException catch (ex) {
    debugPrint(ex.message);
  }
}
