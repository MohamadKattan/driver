/// this class for localNoitifction we will use with ios just
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/subjects.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


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
      onSelectNotification: (String? payload){
    /// stop for now
    // final ref = FirebaseDatabase.instance
    //     .ref()
    //     .child("driver")
    //     .child(currentUser!.uid)
    //     .child("newRide");
    // await ref.once().then((value) {
    //   if (value.snapshot.value != null) {
    //     final snap = value.snapshot.value;
    //     String id = snap.toString();
    //    const _duration= Duration(milliseconds: 600);
    //     int count = 1;
    //     Timer.periodic(_duration, (timer) {
    //       count =count - 1;
    //       if(count==0){
    //         timer.cancel();
    //         count = 1;
    //         PushNotificationsSrv().retrieveRideRequestInfo(id, context);
    //       }
    //     });
    //   }
    // });
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

Future<void> showNotification(BuildContext context) async {

   var bigImage =const BigPictureStyleInformation(
     DrawableResourceAndroidBitmap("map1"),
     contentTitle: "Garanti Taxi",
     htmlFormatContent: true,
     htmlFormatContentTitle: true,
     summaryText: "isteğinizi kabul etti",
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
   IOSNotificationDetails iOSPlatformChannelSpecifics =
      const IOSNotificationDetails(
          presentBadge: true,
          sound: 'new_order.mp3',
          presentAlert: true,
        presentSound: true,
        subtitle: "  ",
          );

  final NotificationDetails platform = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
    0,
    AppLocalizations.of(context)!.rideRequest,
    AppLocalizations.of(context)!.clickHere,
    platform,
    payload: 'item x',
  );
}
