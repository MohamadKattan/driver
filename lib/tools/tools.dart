// this class include tools will use many times in our app
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Tools {


  void toastMsg(
    String msg,
    Color colors,
  ) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: colors,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  Widget timerAuth(BuildContext context, int timer) {
    final CountDownController downController = CountDownController();
    return CircularCountDownTimer(
      duration: timer,
      initialDuration: 0,
      controller: downController,
      width: 60,
      height: 60,
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
      onStart: () {},
      onComplete: () {},
    );
  }

  Route createRoute(BuildContext context, Widget screen) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => screen,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var curve = Curves.ease;
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}
