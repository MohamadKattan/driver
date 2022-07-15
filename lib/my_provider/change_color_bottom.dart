// this class for change color bottom drawer

import 'package:flutter/cupertino.dart';

class ChangeColorBottomDrawer extends ChangeNotifier {
  bool isTrue = false;
  void updateColorBottom(bool update) {
    isTrue = update;
    notifyListeners();
  }
}
