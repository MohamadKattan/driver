// this class for listing to first current location to driver

import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';

class DriverCurrentPosition extends ChangeNotifier{
  late Position currentPosition;

  void updateSate(Position state){
    currentPosition = state;
    notifyListeners();
  }
}