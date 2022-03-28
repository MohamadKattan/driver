// this class for listing to change title button arrived connected to status a trip

import 'package:flutter/cupertino.dart';

class TitleArrived extends ChangeNotifier {
  String titleButton = "Arrived";

  void updateState(String state){
    titleButton = state;
    notifyListeners();
  }
}