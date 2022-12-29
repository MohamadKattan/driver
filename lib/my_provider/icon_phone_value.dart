// this class for listing to change value icon phone in checkIn screen

import 'package:flutter/cupertino.dart';

class PhoneIconValue extends ChangeNotifier {
  double IconValue = -100.0;

  void updateValue(double val) {
    IconValue = val;
    notifyListeners();
  }
}
