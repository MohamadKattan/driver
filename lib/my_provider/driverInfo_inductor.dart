// this class for listing true/false for _inductor in driverInfo screen

import 'package:flutter/cupertino.dart';

class DriverInfoInductor extends ChangeNotifier {
  bool isTrue = false;
  void updateState(bool state) {
    isTrue = state;
    notifyListeners();
  }
}
