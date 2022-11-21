// this class for booling internt week value

import 'package:flutter/cupertino.dart';

class IsNetWeek extends ChangeNotifier{
  bool netWeek = false;
  void updateState(bool state){
    netWeek=state;
    notifyListeners();
  }
}