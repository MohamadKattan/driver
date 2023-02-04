import 'dart:async';
import 'package:driver/config.dart';
import 'package:driver/notificatons/push_notifications_srv.dart';
import 'package:driver/repo/auth_srv.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GeoFireSrv {
  final currentUseId = AuthSev().auth.currentUser;
  late LocationSettings locationSettings;

// this method for stream update location
  Future<void> getLocationLiveUpdates(BuildContext context) async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      locationSettings = AndroidSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 100,
          intervalDuration: const Duration(seconds: 10),
          foregroundNotificationConfig: ForegroundNotificationConfig(
              notificationText:
                  AppLocalizations.of(context)!.locationBackground,
              notificationTitle: "Garanti taxi",
              enableWakeLock: true));
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      locationSettings = AppleSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 100,
        activityType: ActivityType.automotiveNavigation,
        pauseLocationUpdatesAutomatically: false,
        showBackgroundLocationIndicator: true,
      );
    } else {
      locationSettings = const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 100,
      );
    }
    homeScreenStreamSubscription =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position position) async {
      await Geofire.setLocation(
          currentUseId!.uid, position.latitude, position.longitude);
      LatLng latLng = LatLng(position.latitude, position.longitude);
      CameraPosition cameraPosition = CameraPosition(
          target: latLng, zoom: 16.50, tilt: 10.0, bearing: position.heading);
      newGoogleMapController
          ?.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
      driverRef.child(currentUseId!.uid).child("heading").set(position.heading);
      // newGoogleMapController?.animateCamera(CameraUpdate.newLatLng(latLng));
    });
  }

/*this method it will work just in backGround because stream in backGround
 it will disconnect after 30 min on ios 4 hour on android*/
  // Future<void> updateLocationIfGpsSleepy(BuildContext context) async {
  //   Timer.periodic(const Duration(seconds: 50), (timer) async {
  //     if (runLocale) {
  //       if (showGpsDailog) {
  //         Position position = await Geolocator.getCurrentPosition(
  //             desiredAccuracy: LocationAccuracy.high);
  //         await Geofire.setLocation(
  //             currentUseId!.uid, position.latitude, position.longitude);
  //         driverRef
  //             .child(currentUseId!.uid)
  //             .child("heading")
  //             .set(position.heading);
  //       }
  //     } else {
  //       timer.cancel();
  //     }
  //   });
  // }

  // this method for delete driver from live location if switch offLine bottom

  Future<void> makeDriverOffLine() async {
    homeScreenStreamSubscription.cancel();
    DatabaseReference? rideRequestRef = FirebaseDatabase.instance
        .ref()
        .child("driver")
        .child(currentUseId!.uid);
    rideRequestRef.child("newRide").onDisconnect();
    await rideRequestRef.child("newRide").remove();
    Geofire.stopListener();
    await Geofire.removeLocation(currentUseId!.uid);
  }
}
