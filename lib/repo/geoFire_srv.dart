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
        .child(currentUseId!.uid)
        .child("newRide");
    //first set new value when driver switch bottom online and waiting for a new order rider
    await rideRequestRef.once().then((value) {
      if (value.snapshot.value != null) {
        final snap = value.snapshot.value.toString();
        if (snap == "timeOut" || snap == "canceled") {
          rideRequestRef.set("searching");
        } else if (snap != "timeOut" || snap != "canceled") {
          return;
        }
      } else if (value.snapshot.value == null) {
        rideRequestRef.set("searching");
      }
    });

    //second listing
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
        .child(currentUseId!.uid)
        .child("newRide");

    rideRequestRef.onDisconnect();
    await rideRequestRef.remove();
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
    await Geofire.setLocation(
        currentUseId!.uid, position.latitude, position.longitude);
  }
}
