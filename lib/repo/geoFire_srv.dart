// this class for update live current location driver to retrieve rider request if driver close to rider

import 'dart:async';

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

  getLocationLiveUpdates(bool valueSwitchBottom) async {
    Geofire.initialize("availableDrivers");
    homeScreenStreamSubscription =
        Geolocator.getPositionStream().listen((Position position) async {
      if (position.latitude == 37.42796133580664 &&
          position.longitude == 122.085749655962) {
        return;
      } else {
        if (valueSwitchBottom == true) {
          await Geofire.setLocation(
              currentUseId!.uid, position.latitude, position.longitude);
        }
      }

      //for camera update
      LatLng latLng = LatLng(position.latitude, position.longitude);
      newGoogleMapController?.animateCamera(CameraUpdate.newLatLng(latLng));
    });
    DatabaseReference rideRequestRef = FirebaseDatabase.instance
        .ref()
        .child("driver")
        .child(currentUseId!.uid).child("newRide");
        rideRequestRef.set("searching");
    rideRequestRef.onValue.listen((event) {});
  }

// this method for delete driver from live location if switch offLine bottom
  Future<void> makeDriverOffLine() async {
    homeScreenStreamSubscription?.pause();
    Geofire.stopListener();
    Geofire.removeLocation(currentUseId!.uid);

    DatabaseReference? rideRequestRef = FirebaseDatabase.instance
        .ref()
        .child("driver")
        .child(currentUseId!.uid);

    rideRequestRef .child("newRide").onDisconnect();
    await rideRequestRef .child("newRide").remove();
  }

  // this method for display driver from live location when he accepted on order
  Future<void> displayLocationLiveUpdates() async {
    homeScreenStreamSubscription?.pause();
    Geofire.stopListener();
    Geofire.removeLocation(currentUseId!.uid);
  }

// this method for enable driver in live location when he finished his order
  void enableLocationLiveUpdates(BuildContext context) async {
    final position = Provider.of<DriverCurrentPosition>(context, listen: false)
        .currentPosition;
    homeScreenStreamSubscription?.resume();
    subscriptionNot1.resume();
    await Geofire.setLocation(
        currentUseId!.uid, position.latitude, position.longitude);
  }
}
