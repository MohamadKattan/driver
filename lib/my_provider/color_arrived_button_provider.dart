// this class for listing to change color button arrived connected with status

import 'package:flutter/material.dart';

class ColorButtonArrived extends ChangeNotifier{
  Color colorButton = Colors.greenAccent.shade700;

  void updateState(Color state){
    colorButton = state;
    notifyListeners();
  }
}