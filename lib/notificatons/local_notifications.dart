/// this class for local Notification
import 'dart:async';
import 'package:flutter/foundation.dart';
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
// this method for initializationLocalNotifications in home Screen
Future<void> initializationLocalNotifications(BuildContext context) async {
  try {
    if (kDebugMode) {
      print('intLocal start');
    }
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

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String? payload) async {
      selectedNotificationPayload = payload;
      selectNotificationSubject.add(payload);
    });
  } catch (ex) {
    if (kDebugMode) {
      print('intLocal${ex.toString()}');
    }
  }
}

// this method requestPermissionsLocalNotifications
void requestPermissionsLocalNotifications() {
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

  ///todo stop for now till update plugin
  // flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
  //     AndroidFlutterLocalNotificationsPlugin>()?.requestPermission();
}

// this method for display locale Notification on ios just new order in backGround
Future<void> showNotificationNewOrder(BuildContext context) async {
  var bigImage = const BigPictureStyleInformation(
    DrawableResourceAndroidBitmap("map1"),
    contentTitle: "Garanti Taxi",
    htmlFormatContent: true,
    htmlFormatContentTitle: true,
    summaryText: "isteğinizi kabul etti",
    // largeIcon: DrawableResourceAndroidBitmap("app_icon"),
  );
  AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    'your channel id5',
    'your channel name',
    channelDescription: 'your channel description',
    importance: Importance.max,
    priority: Priority.high,
    ticker: 'ticker',
    styleInformation: bigImage,
    largeIcon: const DrawableResourceAndroidBitmap("app_icon"),
    enableLights: true,
    enableVibration: true,
    playSound: true,
    sound: const RawResourceAndroidNotificationSound("new_order1"),
  );
  IOSNotificationDetails iOSPlatformChannelSpecifics =
      const IOSNotificationDetails(
    presentBadge: true,
    sound: 'new_order.mp3',
    presentAlert: true,
    presentSound: true,
    subtitle: "",
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

// this method for display locale Notification on GPS has error or disable
Future<void> showNotificationNoLocation(BuildContext context) async {
  try {
    if (kDebugMode) {
      print('start showNotificationNoLocation');
    }
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        const AndroidNotificationDetails(
      'your channel id6',
      'no GPS',
      channelDescription: 'No Gps service',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      enableLights: true,
      enableVibration: true,
      playSound: true,
      sound: RawResourceAndroidNotificationSound("no_gps"),
    );
    IOSNotificationDetails iOSPlatformChannelSpecifics =
        const IOSNotificationDetails(
      presentBadge: true,
      sound: 'no_gps.mp3',
      presentAlert: true,
      presentSound: true,
    );

    final NotificationDetails platform = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      AppLocalizations.of(context)!.locationServNot,
      'Garanti taxi',
      platform,
      payload: 'item x',
    );
  } catch (ex) {
    if (kDebugMode) {
      print('loc:::${ex.toString()}');
    }
  }
}
