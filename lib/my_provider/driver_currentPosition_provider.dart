// this class for listing to first current location to driver

import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

class DriverCurrentPosition extends ChangeNotifier{
   Position currentPosition = Position(latitude:40.0205268 ,longitude:28.6953056 , timestamp: DateTime.now(), accuracy: 0.0, altitude: 0.0, heading: 0.0, speed: 0.0, speedAccuracy: 0);
  void updateSate(Position state){
    currentPosition = state;
    notifyListeners();
  }
}