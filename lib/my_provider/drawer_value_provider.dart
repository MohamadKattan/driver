// this class for change double value for drawer

import 'package:flutter/cupertino.dart';

class DrawerValueChange extends ChangeNotifier {
  double value = 0;

  updateValue(double val) {
    value = val;
    notifyListeners();
  }
}
