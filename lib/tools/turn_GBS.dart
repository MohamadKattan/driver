//this class for let user turn his GBS
import 'package:location/location.dart';
import 'package:provider/provider.dart';

import '../my_provider/driver_currentPosition_provider.dart';

class TurnOnGBS {
  Location location = Location();
  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  late LocationData _locationData;

  Future<LocationData?> turnOnGBSifNot() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return null;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }

    _locationData = await location.getLocation();
    // Provider.of<DriverCurrentPosition>(context,listen: false).updateSate(_locationData);
    location.enableBackgroundMode(enable: false);
    return _locationData;
  }
}
