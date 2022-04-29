// this class for true /false payment indector

import 'package:flutter/cupertino.dart';

class PaymentIndector extends ChangeNotifier {
  bool isTrue = false;
  void updateState(bool state){
    isTrue = state;
    notifyListeners();
  }
}