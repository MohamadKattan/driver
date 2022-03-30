// this class for inductor profile screen

import 'package:flutter/foundation.dart';

class InductorProfileProvider extends ChangeNotifier {
  bool isTrue = false;

  void updateState(bool state) {
    isTrue = state;
    notifyListeners();
  }
}
