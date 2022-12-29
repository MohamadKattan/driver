// this class for update live current location driver to retrieve rider request if driver close to rider

import 'dart:async';
import 'package:driver/config.dart';
import 'package:driver/repo/auth_srv.dart';
import 'package:driver/tools/tools.dart';
import 'package:driver/widget/location_stoped.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../notificatons/local_notifications.dart';

class GeoFireSrv {
  final currentUseId = AuthSev().auth.currentUser;
  late LocationSettings locationSettings;
// this method for stream check if gps service denied or has error
  void serviceStatusStream(BuildContext context) {
    if (serviceStatusStreamSubscription == null) {
      final serviceStatusStream = Geolocator.getServiceStatusStream();
      serviceStatusStreamSubscription =
          serviceStatusStream.handleError((error) {
        serviceStatusStreamSubscription?.cancel();
        serviceStatusStreamSubscription = null;
        showNotificationNoLocation(context);
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => locationStoped(context));
      }).listen((serviceStatus) async {
        if (serviceStatus == ServiceStatus.enabled) {
          Tools().toastMsg('...................................',
              Colors.orangeAccent.shade100);
          Tools().toastMsg('..................................',
              Colors.orangeAccent.shade700);
          await getLocationLiveUpdates(context);
        } else {
          if (homeScreenStreamSubscription != null) {
            homeScreenStreamSubscription?.cancel();
            homeScreenStreamSubscription = null;
          }
          showNotificationNoLocation(context);
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => locationStoped(context));
        }
      });
    }
  }

// this method for stream update location
  Future<void> getLocationLiveUpdates(BuildContext context) async {
    Geofire.initialize("availableDrivers");
    if (defaultTargetPlatform == TargetPlatform.android) {
      locationSettings = AndroidSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 10,
          forceLocationManager: false,
          // intervalDuration: const Duration(seconds: 10),
          foregroundNotificationConfig: ForegroundNotificationConfig(
            notificationText: AppLocalizations.of(context)!.locationBackground,
            notificationTitle: "Garanti taxi",
            enableWakeLock: true,
          ));
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      locationSettings = AppleSettings(
        accuracy: LocationAccuracy.high,
        activityType: ActivityType.automotiveNavigation,
        distanceFilter: 10,
        pauseLocationUpdatesAutomatically: false,
        showBackgroundLocationIndicator: true,
      );
    } else {
      locationSettings = const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      );
    }
    homeScreenStreamSubscription =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position position) async {
      await Geofire.setLocation(
          currentUseId!.uid, position.latitude, position.longitude);
      LatLng latLng = LatLng(position.latitude, position.longitude);
      CameraPosition cameraPosition = CameraPosition(
          target: latLng, zoom: 13.50, tilt: 80.0, bearing: 35.0);
      newGoogleMapController
          ?.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
      // newGoogleMapController?.animateCamera(CameraUpdate.newLatLng(latLng));
    });
    Tools().toastMsg(AppLocalizations.of(context)!.locationUpdate,
        Colors.greenAccent.shade700);
    DatabaseReference rideRequestRef = FirebaseDatabase.instance
        .ref()
        .child("driver")
        .child(currentUseId!.uid)
        .child("newRide");
    rideRequestRef.set("searching");
  }

  // this method for delete driver from live location if switch offLine bottom
  Future<void> makeDriverOffLine() async {
    cancelStreamLocation();
    DatabaseReference? rideRequestRef = FirebaseDatabase.instance
        .ref()
        .child("driver")
        .child(currentUseId!.uid);
    rideRequestRef.child("newRide").onDisconnect();
    await rideRequestRef.child("newRide").remove();
    Geofire.stopListener();
    await Geofire.removeLocation(currentUseId!.uid);
  }

  // this method for cancel stream on location if error or disabled
  void cancelStreamLocation() {
    if (homeScreenStreamSubscription != null) {
      homeScreenStreamSubscription?.cancel();
      homeScreenStreamSubscription = null;
    }
  }
}
