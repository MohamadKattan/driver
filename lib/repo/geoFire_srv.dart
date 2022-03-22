// this class for update live current location driver to retrieve rider request if driver close to rider

import 'package:driver/config.dart';
import 'package:driver/repo/auth_srv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../my_provider/driver_currentPosition_provider.dart';

class GeoFireSrv {
  final currentUseId = AuthSev().auth.currentUser;
  String pathToReference = "availableDrivers";

// this method for make driver on line and display his currentPosition for in availableDrivers collection
  void makeDriverOnlineNow(BuildContext context) async {
    final position = Provider.of<DriverCurrentPosition>(context,listen: false).currentPosition;

    Geofire.initialize(pathToReference);
    await Geofire.setLocation(
        currentUseId!.uid, position.latitude, position.longitude);

    DatabaseReference rideRequestRef = FirebaseDatabase.instance
        .ref()
        .child("driver")
        .child(currentUseId!.uid)
        .child("newRide");
    rideRequestRef.onValue.listen((event) {});
  }

  //this method for updating driver currentPosition and listing as stream
   getLocationLiveUpdates(BuildContext context, bool valueSwitchBottom) {

    homeScreenStreamSubscription =
        Geolocator.getPositionStream().listen((Position position) async {
  if(valueSwitchBottom==true) {
    await Geofire.setLocation(
        currentUseId!.uid, position.latitude, position.longitude);
  }
      //for camera update
      LatLng latLng = LatLng(position.latitude, position.longitude);
      newGoogleMapController?.animateCamera(CameraUpdate.newLatLng(latLng));
    });
  }

  Future<void> makeDriverOffLine(BuildContext context) async {
    DatabaseReference? rideRequestRef = FirebaseDatabase.instance
        .ref()
        .child("driver")
        .child(currentUseId!.uid)
        .child("newRide");
    await Geofire.removeLocation(currentUseId!.uid);
    rideRequestRef.onDisconnect();
    await rideRequestRef.remove();
  }
}
