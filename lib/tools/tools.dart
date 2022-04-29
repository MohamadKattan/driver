// this class include tools will use many times in our app

import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


class Tools {

  void toastMsg(String msg,Color colors,) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: colors,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  Widget timerAuth(BuildContext context,int timer) {
    final CountDownController downController = CountDownController();
    return CircularCountDownTimer(
      duration: timer,
      initialDuration: 0,
      controller: downController,
      width: MediaQuery.of(context).size.width / 9,
      height: MediaQuery.of(context).size.height / 9,
      ringColor: Colors.white,
      fillColor: Colors.black12,
      backgroundColor: const Color(0xFFFFD54F),
      strokeWidth: 8.0,
      strokeCap: StrokeCap.round,
      textStyle: const TextStyle(
          fontSize: 20.0, color: Colors.white, fontWeight: FontWeight.bold),
      textFormat: CountdownTextFormat.S,
      isReverse: true,
      isReverseAnimation: true,
      isTimerTextShown: true,
      autoStart: true,
      onStart: () {
        print('Countdown Started');
      },
      onComplete: () {
      },
    );
  }
}
