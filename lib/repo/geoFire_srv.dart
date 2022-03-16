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
    final _position = Provider.of<DriverCurrentPosition>(context, listen: false)
        .currentPosition;
    // 1-first create new collection availableDrivers
    Geofire.initialize(pathToReference);
    await Geofire.setLocation(
        currentUseId!.uid, _position.latitude, _position.longitude);
    print("this isssssss" + _position.latitude.toString());
    print("this isssssss" + currentUseId!.uid.toString());

    DatabaseReference rideRequestRef = FirebaseDatabase.instance
        .ref()
        .child("driver")
        .child(currentUseId!.uid)
        .child("newRide");

    rideRequestRef.onValue.listen((event) {});
  }

  //this method for updating driver currentPosition and listing as stream
  void getLocationLiveUpdates(BuildContext context) {
    var currentPosition =
        Provider.of<DriverCurrentPosition>(context, listen: false)
            .currentPosition;
    homeScreenStreamSubscription =
        Geolocator.getPositionStream().listen((Position position) async {
      currentPosition = position;
      await Geofire.setLocation(
          currentUseId!.uid, position.latitude, position.longitude);
      //for camera update
      LatLng latLng = LatLng(position.latitude, position.longitude);
      newGoogleMapController?.animateCamera(CameraUpdate.newLatLng(latLng));
    });
  }
}
