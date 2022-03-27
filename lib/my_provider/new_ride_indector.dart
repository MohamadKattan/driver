// this class for inductor true or false in newRideScreen

import 'package:flutter/cupertino.dart';

class NewRideScreenIndector extends ChangeNotifier {
  bool isInductor = false;

  void updateState(bool state) {
    isInductor = state;
    notifyListeners();
  }
}
