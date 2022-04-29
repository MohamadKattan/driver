// this class for listing to name country from geolocator for using in plan and currency typ

import 'package:flutter/foundation.dart';

class PlaceName extends ChangeNotifier{
  String placeName = "";

  void updateState(String name){
    placeName = name;
    notifyListeners();
  }
}