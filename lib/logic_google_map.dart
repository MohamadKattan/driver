//this class for google map methods
import 'dart:async';
import 'package:driver/config.dart';
import 'package:driver/tools/tools.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'my_provider/driver_currentPosition_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LogicGoogleMap {
  Completer<GoogleMapController> controllerGoogleMap = Completer();

  final CameraPosition kGooglePlex = const CameraPosition(
    target: LatLng(41.084253576036936,28.89201922194848),
    zoom: 14.4746,
  );


  Future<dynamic> locationPosition(BuildContext context) async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Tools().toastMsg(AppLocalizations.of(context)!.locationServNot,Colors.red);
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Tools().toastMsg(AppLocalizations.of(context)!.locationPrevNot,Colors.red);
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      Tools().toastMsg(AppLocalizations.of(context)!.locationPrevNotAlwayes,Colors.red);
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    Provider.of<DriverCurrentPosition>(context, listen: false)
        .updateSate(position);
    LatLng latLngPosition = LatLng(position.latitude, position.longitude);
    CameraPosition cameraPosition = CameraPosition(
        target: latLngPosition, zoom: 16.50, tilt: 80.0, bearing: 35.0);
    newGoogleMapController
        ?.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    return position;
  }


  Future<void> darkOrwhite(GoogleMapController controller) async {
    final _controller = controller;
    if (hourForDarkMode > 6 && hourForDarkMode < 18) {
      _controller.setMapStyle(lightMapStyle);
    } else {
      _controller.setMapStyle(darkMapStyle);
    }
  }
}
