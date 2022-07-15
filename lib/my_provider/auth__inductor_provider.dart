// this class for listing true/false for _inductor in auth screen

import 'package:flutter/cupertino.dart';

class TrueFalse extends ChangeNotifier {
  bool isTrue = false;
  void updateState(bool state) {
    isTrue = state;
    notifyListeners();
  }
}
