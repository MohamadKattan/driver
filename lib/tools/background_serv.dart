
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
 const channel = MethodChannel("com.garanti.driver/channel");

 openDailog()async{
  try{
    await channel.invokeMethod("openDailog");
  }on PlatformException catch(ex){
    debugPrint( ex.message);
  }
}

closeDailog()async{
  try{
    await channel.invokeMethod("closeDailog");
  }on PlatformException catch(ex){
    debugPrint( ex.message);
  }
}