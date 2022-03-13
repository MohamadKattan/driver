// this class for listing to change value bottom sheet in driver info screen

import 'package:flutter/cupertino.dart';

class BottomSheetValue extends ChangeNotifier {
  double bottomSheetValue = -600.0;

  void updateValue(double val) {
    bottomSheetValue = val;
    notifyListeners();
  }
}
