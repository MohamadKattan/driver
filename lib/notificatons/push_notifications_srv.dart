// this class for firebase push notifications
import 'dart:async';
import 'dart:io';
import 'package:driver/repo/auth_srv.dart';
import 'package:driver/tools/background_serv.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../config.dart';
import '../model/rideDetails.dart';
import '../my_provider/ride_request_info.dart';
import '../tools/tools.dart';
import '../widget/notification_dialog.dart';

FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

final userId = AuthSev().auth.currentUser!.uid;
DatabaseReference driverRef = FirebaseDatabase.instance.ref().child("driver");
Future<String?> getToken() async {
  String? token = await firebaseMessaging.getToken();
  if (kDebugMode) {
    print("this is token::$token");
  }
  tokenPhone = token!;
  await driverRef.child(userId).child("token").set(token);
  firebaseMessaging.subscribeToTopic("allDrivers");
  firebaseMessaging.subscribeToTopic("allUsers");
  return token;
}

void iosPermission() async {
  NotificationSettings settings = await firebaseMessaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
}

class PushNotificationsSrv {
  // this method for push notification if app foreground
  ///Stoped for now
  // setForegroundNotifications(BuildContext context) {
  //   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //     if (message.data.isNotEmpty && message.notification != null) {
  //       //method in method for string ride id
  //       retrieveRideRequestInfo(getRideRequestId(message), context);
  //       playSound();
  //     }
  //   });
  // }

  // this method for push notification if app BackGround
  ///Stoped for now
  // setBackgroundNotifications(BuildContext context) {
  //   FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
  //     // if (message.data.isNotEmpty && message.notification != null) {
  //     //   retrieveRideRequestInfo(getRideRequestId(message), context);
  //     //   openDailog();
  //     //   playSound();
  //     //   openDailogOld();
  //     // }
  //   });
  // }

  // this method for push notification if app torment
  ///StopForNow
  // setTerminateNotifications(BuildContext context) async {
  //   RemoteMessage? initialMessage =
  //       await FirebaseMessaging.instance.getInitialMessage();
  //   if (initialMessage != null) {
  //     //method in method for string ride id
  //     await FirebaseMessaging.instance
  //         .setForegroundNotificationPresentationOptions(
  //       alert: true,
  //       badge: true,
  //       sound: true,
  //     );
  //     // retrieveRideRequestInfo(getRideRequestId(initialMessage), context);
  //   }
  // }
  ///
  ///Stoped for now
  // void startSendNotifications(BuildContext context) async {
  //   FirebaseMessaging.onBackgroundMessage(onBackgroundMessage);
  //   if (Platform.isIOS) {
  //     iosPermission();
  //   }
  //   setForegroundNotifications(context);
  //   setBackgroundNotifications(context);
  // }

  // this method will use in home screen in instant for auto starting
  ///Stoped for now
  // getCurrentInfoDriverForNotification(BuildContext context) {
  //   getToken();
  //   startSendNotifications(context);
  // }

  // this method for got Notification in back ground

  // String getRideRequestId(RemoteMessage message) {
  //   String rideId = "";
  //   if (Platform.isAndroid) {
  //     rideId = message.data["ride_id"];
  //     if (kDebugMode) {
  //       print("this is notRideId$rideId");
  //     }
  //   } else {
  //     rideId = message.data["ride_id"];
  //     if (kDebugMode) {
  //       print("this is notRideId$rideId");
  //     }
  //   }
  //   return rideId;
  // }

  //this method for retrieve rider info from Ride Request collection when rider do order

  Future<void> retrieveRideRequestInfo(
      String rideId, BuildContext context) async {
    late final DataSnapshot snapshot;
    try {
      final ref = FirebaseDatabase.instance.ref();
      snapshot = await ref.child("Ride Request").child(rideId).get();
      if (snapshot.exists) {
        Map<String, dynamic> map =
            Map<String, dynamic>.from(snapshot.value as Map);
        double pickUpLinlatitude =
            double.parse(map["pickup"]["latitude"].toString());
        double pickUpLontude =
            double.parse(map["pickup"]["longitude"].toString());
        double dropOffLinlatitude =
            double.parse(map["dropoff"]["latitude"].toString());
        double dropOffLontitude =
            double.parse(map["dropoff"]["longitude"].toString());
        String userId = map["userId"];
        String riderName = map["riderName"];
        String riderPhone = map["riderPhone"];
        String paymentMethod = map["paymentMethod"];
        String vehicleTypeId = map["vehicleType_id"];
        String pickupAddress = map["pickupAddress"];
        String dropoffAddress = map["dropoffAddress"];
        String km = map["km"];
        String amount = map["amount"];
        String tourismCityName = map["tourismCityName"];

        RideDetails rideDetails = RideDetails(
          userId: userId,
          riderName: riderName,
          riderPhone: riderPhone,
          paymentMethod: paymentMethod,
          vehicleTypeId: vehicleTypeId,
          pickupAddress: pickupAddress,
          pickup: LatLng(pickUpLinlatitude, pickUpLontude),
          dropoffAddress: dropoffAddress,
          dropoff: LatLng(dropOffLinlatitude, dropOffLontitude),
          km: km,
          amount: amount,
          tourismCityName: tourismCityName,
        );
        Provider.of<RideRequestInfoProvider>(context, listen: false)
            .updateState(rideDetails);

        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) => NotificationDialog(context));
        return;
      } else {
        driverRef.child(userId).child("newRide").set("searching");
        Tools().toastMsg("Not.exists", Colors.redAccent.shade700);
        stopSound();
      }
    } catch (ex) {
      Tools().toastMsg("push.Loading catch...", Colors.redAccent.shade700);
      driverRef.child(userId).child("newRide").set("searching");
      stopSound();
    }
  }

  Future<void> gotNotificationInBackground(BuildContext context) async {
    subscriptionNot1 =
        driverRef.child(userId).child("newRide").onValue.listen((event) async {
      if (event.snapshot.value != null) {
        String _riderId = event.snapshot.value.toString();
        if (_riderId == "searching") {
          return;
        } else if (_riderId == "canceled") {
          Future.delayed(const Duration(seconds: 1)).whenComplete(() {
            driverRef.child(userId).child("newRide").set("searching");
            driverRef.child(userId).child("offLine").set("Available");
          });
        } else if (_riderId == "timeOut") {
          Future.delayed(const Duration(seconds: 1)).whenComplete(() {
            driverRef.child(userId).child("newRide").set("searching");
            driverRef.child(userId).child("offLine").set("Available");
          });
        } else if (_riderId == "accepted") {
          Future.delayed(const Duration(seconds: 2)).whenComplete(() {
            driverRef.child(userId).child("newRide").set("searching");
          });
        } else {
          if (Platform.isAndroid) {
            openDailog();
            playSound();
            openDailogOld();
            retrieveRideRequestInfo(_riderId, context);
          } else {
            retrieveRideRequestInfo(_riderId, context);

            /// stop locale notification on ios
            // if (runLocale) {
            //   showNotificationNewOrder(context);
            // }
          }
        }
      } else {
        driverRef.child(userId).child("newRide").set("searching");
      }
    });
  }
}
