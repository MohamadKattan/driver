
// this class for listing to drop bottom value type of car in driver info screen

import 'package:flutter/cupertino.dart';

class DropBottomValue extends ChangeNotifier{
  String valDrop = "Select a car class";

  void updateValue(String value){
    valDrop=value;
    notifyListeners();
  }
}