// this class for update live current location driver to retrieve rider request if driver close to rider

import 'dart:async';
import 'package:driver/config.dart';
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

  Future<void> getLocationLiveUpdates(BuildContext context) async {
    Geofire.initialize("availableDrivers");
    if (defaultTargetPlatform == TargetPlatform.android) {
      locationSettings = AndroidSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 20,
          forceLocationManager: false,
          intervalDuration: const Duration(seconds: 2),
          foregroundNotificationConfig: ForegroundNotificationConfig(
            notificationText: AppLocalizations.of(context)!.locationBackground,
            notificationTitle: "Garanti taxi",
            enableWakeLock: true,
          ));
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      locationSettings = AppleSettings(
        accuracy: LocationAccuracy.high,
        activityType: ActivityType.fitness,
        distanceFilter: 20,
        pauseLocationUpdatesAutomatically: false,
        showBackgroundLocationIndicator: true,
      );
    } else {
      locationSettings = const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 20,
      );
    }
    // if (Platform.isAndroid) {
    //   var androidInfo = await DeviceInfoPlugin().androidInfo;
    //   var sdkInt = androidInfo.version.sdkInt;
    //   if (sdkInt! <= 27) {
    //     homeScreenStreamSubscription =
    //         Geolocator.getPositionStream().listen((Position position) async {
    //       if (position.latitude == 37.42796133580664 &&
    //           position.longitude == 122.085749655962) {
    //         return;
    //       } else {
    //         await Geofire.setLocation(
    //             currentUseId!.uid, position.latitude, position.longitude);
    //         // Provider.of<DriverCurrentPosition>(context, listen: false)
    //         //     .updateSate(position);
    //       }
    //
    //       LatLng latLng = LatLng(position.latitude, position.longitude);
    //       newGoogleMapController?.animateCamera(CameraUpdate.newLatLng(latLng));
    //     });
    //     DatabaseReference rideRequestRef = FirebaseDatabase.instance
    //         .ref()
    //         .child("driver")
    //         .child(currentUseId!.uid)
    //         .child("newRide");
    //     rideRequestRef.set("searching");
    //     rideRequestRef.onValue.listen((event) {});
    //   } else {
    //     homeScreenStreamSubscription =
    //         Geolocator.getPositionStream(locationSettings: locationSettings)
    //             .listen((Position position) async {
    //       await Geofire.setLocation(
    //           currentUseId!.uid, position.latitude, position.longitude);
    //       Provider.of<DriverCurrentPosition>(context, listen: false)
    //           .updateSate(position);
    //       LatLng latLng = LatLng(position.latitude, position.longitude);
    //       newGoogleMapController?.animateCamera(CameraUpdate.newLatLng(latLng));
    //     });
    //     DatabaseReference rideRequestRef = FirebaseDatabase.instance
    //         .ref()
    //         .child("driver")
    //         .child(currentUseId!.uid)
    //         .child("newRide");
    //     rideRequestRef.set("searching");
    //     rideRequestRef.onValue.listen((event) {});
    //   }
    // }
    // else {
    //   homeScreenStreamSubscription =
    //       Geolocator.getPositionStream(locationSettings: locationSettings)
    //           .listen((Position position) async {
    //     await Geofire.setLocation(
    //         currentUseId!.uid, position.latitude, position.longitude);
    //     Provider.of<DriverCurrentPosition>(context, listen: false)
    //         .updateSate(position);
    //     LatLng latLng = LatLng(position.latitude, position.longitude);
    //     newGoogleMapController?.animateCamera(CameraUpdate.newLatLng(latLng));
    //   });
    //   DatabaseReference rideRequestRef = FirebaseDatabase.instance
    //       .ref()
    //       .child("driver")
    //       .child(currentUseId!.uid)
    //       .child("newRide");
    //   rideRequestRef.set("searching");
    //   rideRequestRef.onValue.listen((event) {});
    // }
    homeScreenStreamSubscription =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position position) async {
          await Geofire.setLocation(
              currentUseId!.uid, position.latitude, position.longitude);
          LatLng latLng = LatLng(position.latitude, position.longitude);
          newGoogleMapController?.animateCamera(CameraUpdate.newLatLng(latLng));
        });
    DatabaseReference rideRequestRef = FirebaseDatabase.instance
        .ref()
        .child("driver")
        .child(currentUseId!.uid)
        .child("newRide");
    rideRequestRef.set("searching");
    rideRequestRef.onValue.listen((event) {});
  }

// this method for delete driver from live location if switch offLine bottom
  Future<void> makeDriverOffLine() async {
    homeScreenStreamSubscription.pause();
    DatabaseReference? rideRequestRef = FirebaseDatabase.instance
        .ref()
        .child("driver")
        .child(currentUseId!.uid);
    rideRequestRef.child("newRide").onDisconnect();
    await rideRequestRef.child("newRide").remove();
    Geofire.stopListener();
    await Geofire.removeLocation(currentUseId!.uid);
  }

  // this method for display driver from live location when he accepted on order
  Future<void> displayLocationLiveUpdates() async {
    homeScreenStreamSubscription.pause();
    Geofire.stopListener();
   await Geofire.removeLocation(currentUseId!.uid);
  }
}
