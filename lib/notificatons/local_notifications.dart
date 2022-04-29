import 'dart:async';
import 'package:driver/notificatons/push_notifications_srv.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/subjects.dart';
import '../config.dart';


final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
    BehaviorSubject<ReceivedNotification>();

final BehaviorSubject<String?> selectNotificationSubject =
    BehaviorSubject<String?>();

const MethodChannel platform =
    MethodChannel('dexterx.dev/flutter_local_notifications_example');

class ReceivedNotification {
  ReceivedNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
  });

  final int id;
  final String? title;
  final String? body;
  final String? payload;
}

String? selectedNotificationPayload;

Future<void> initializationLocal(BuildContext context) async {
  
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('app_icon');

  final IOSInitializationSettings initializationSettingsIOS =
      IOSInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
          onDidReceiveLocalNotification: (
            int id,
            String? title,
            String? body,
            String? payload,
          ) async {
            didReceiveLocalNotificationSubject.add(
              ReceivedNotification(
                id: id,
                title: title,
                body: body,
                payload: payload,
              ),
            );
          });

  final InitializationSettings initializationSettings=
  InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String? payload) async {
    final ref = FirebaseDatabase.instance
        .ref()
        .child("driver")
        .child(currentUser!.uid)
        .child("newRide");
    await ref.once().then((value) {
      if (value.snapshot.value != null) {
        final snap = value.snapshot.value;
        // Map<String, dynamic> map = Map<String, dynamic>.from(snap as Map);
        // String _id = map["newRide"];
        String id = snap.toString();
       const _duration= Duration(seconds: 1);
        int count = 1;
        Timer.periodic(_duration, (timer) {
          count =count - 1;
          if(count==0){
            timer.cancel();
            count = 1;
            PushNotificationsSrv().retrieveRideRequestInfo(id, context);
          }
        });
      }
    });
    selectedNotificationPayload = payload;
    selectNotificationSubject.add(payload);
  });
}

void requestPermissions() {
  flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>()
      ?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
  flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          MacOSFlutterLocalNotificationsPlugin>()
      ?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
}

Future<void> showNotification() async {

   var bigImage =const BigPictureStyleInformation(
     DrawableResourceAndroidBitmap("map1"),
     contentTitle: "New Ride Request",
     htmlFormatContent: true,
     htmlFormatContentTitle: true,
     summaryText: "click here to accepted",
     // largeIcon: DrawableResourceAndroidBitmap("app_icon"),
   ) ;
   AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    'your channel id5',
    'your channel name',
    channelDescription: 'your channel description',
    importance: Importance.max,
    priority: Priority.high,
    ticker: 'ticker',
    styleInformation: bigImage,
    largeIcon:const DrawableResourceAndroidBitmap("app_icon"),
    enableLights: true,
    enableVibration: true,
    playSound: true,
        sound:  const RawResourceAndroidNotificationSound("new_order1"),
  );
  const IOSNotificationDetails iOSPlatformChannelSpecifics =
      IOSNotificationDetails(
          presentBadge: true,
          sound: 'new_order.mp3',
          presentAlert: true,
        presentSound: true,
        subtitle: "subtitle",
          );

  final NotificationDetails platform = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
    0,
    'New ride request ',
    'click here for more info',
    platform,
    payload: 'item x',
  );
}
