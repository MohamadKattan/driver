//this class for google map methods
import 'dart:async';
import 'package:driver/config.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

import 'my_provider/driver_currentPosition_provider.dart';


class LogicGoogleMap {
  // final ApiSrvGeo _apiMethods = ApiSrvGeo();
  late Position currentPosition;
  var geolocator = Geolocator();

  //instant current location on map before any request on map
  Completer<GoogleMapController> controllerGoogleMap = Completer();

// when driver arrived we need to change location to trip location on map

// set location
  final CameraPosition kGooglePlex = const CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  // this method for user got his current location

  Future<dynamic> locationPosition(BuildContext context) async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;
    // to fitch LatLng in google map
    LatLng latLngPosition = LatLng(position.latitude, position.longitude);
    Provider.of<DriverCurrentPosition>(context,listen: false).updateSate(currentPosition);
    // update on google map
    CameraPosition cameraPosition =
    CameraPosition(target: latLngPosition, zoom: 14);
    newGoogleMapController
        ?.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    ///Not for chacking
    // final address =
    // await _apiMethods.searchCoordinatesAddress(position, context);
    // print("My Address:::" + address);

    return currentPosition;
  }
}
