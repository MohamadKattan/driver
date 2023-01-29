/// this class for local Notification

import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();
//
// final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
//     BehaviorSubject<ReceivedNotification>();
//
// final BehaviorSubject<String?> selectNotificationSubject =
//     BehaviorSubject<String?>();
//
// const MethodChannel platform =
//     MethodChannel('dexterx.dev/flutter_local_notifications_example');
//
// class ReceivedNotification {
//   ReceivedNotification({
//     required this.id,
//     required this.title,
//     required this.body,
//     required this.payload,
//   });
//
//   final int id;
//   final String? title;
//   final String? body;
//   final String? payload;
// }
//
// String? selectedNotificationPayload;
// // this method for initializationLocalNotifications in home Screen
// Future<void> initializationLocalNotifications(BuildContext context) async {
//   try {
//     if (kDebugMode) {
//       print('intLocal start');
//     }
//     const AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings('app_icon');
//
//     final IOSInitializationSettings initializationSettingsIOS =
//         IOSInitializationSettings(
//             requestAlertPermission: false,
//             requestBadgePermission: false,
//             requestSoundPermission: false,
//             onDidReceiveLocalNotification: (
//               int id,
//               String? title,
//               String? body,
//               String? payload,
//             ) async {
//               didReceiveLocalNotificationSubject.add(
//                 ReceivedNotification(
//                   id: id,
//                   title: title,
//                   body: body,
//                   payload: payload,
//                 ),
//               );
//             });
//
//     final InitializationSettings initializationSettings =
//         InitializationSettings(
//       android: initializationSettingsAndroid,
//       iOS: initializationSettingsIOS,
//     );
//
//     await flutterLocalNotificationsPlugin.initialize(initializationSettings,
//         onSelectNotification: (String? payload) async {
//       selectedNotificationPayload = payload;
//       selectNotificationSubject.add(payload);
//     });
//   } catch (ex) {
//     if (kDebugMode) {
//       print('intLocal${ex.toString()}');
//     }
//   }
// }

// this method requestPermissionsLocalNotifications
// // this method for display locale Notification on ios just new order in backGround
// Future<void> showNotificationNewOrder(BuildContext context) async {
//   var bigImage = const BigPictureStyleInformation(
//     DrawableResourceAndroidBitmap("map1"),
//     contentTitle: "Garanti Taxi",
//     htmlFormatContent: true,
//     htmlFormatContentTitle: true,
//     summaryText: "isteğinizi kabul etti",
//     // largeIcon: DrawableResourceAndroidBitmap("app_icon"),
//   );
//   AndroidNotificationDetails androidPlatformChannelSpecifics =
//       AndroidNotificationDetails(
//     'your channel id5',
//     'your channel name',
//     channelDescription: 'your channel description',
//     importance: Importance.max,
//     priority: Priority.high,
//     ticker: 'ticker',
//     styleInformation: bigImage,
//     largeIcon: const DrawableResourceAndroidBitmap("app_icon"),
//     enableLights: true,
//     enableVibration: true,
//     playSound: true,
//     sound: const RawResourceAndroidNotificationSound("new_order1"),
//   );
//   IOSNotificationDetails iOSPlatformChannelSpecifics =
//       const IOSNotificationDetails(
//     presentBadge: true,
//     sound: 'new_order.mp3',
//     presentAlert: true,
//     presentSound: true,
//     subtitle: "",
//   );
//
//   final NotificationDetails platform = NotificationDetails(
//       android: androidPlatformChannelSpecifics,
//       iOS: iOSPlatformChannelSpecifics);
//   await flutterLocalNotificationsPlugin.show(
//     0,
//     AppLocalizations.of(context)!.rideRequest,
//     AppLocalizations.of(context)!.clickHere,
//     platform,
//     payload: 'item x',
//   );
// }
//
// // this method for display locale Notification on GPS has error or disable
// Future<void> showNotificationNoLocation(BuildContext context) async {
//   try {
//     if (kDebugMode) {
//       print('start showNotificationNoLocation');
//     }
//     AndroidNotificationDetails androidPlatformChannelSpecifics =
//         const AndroidNotificationDetails(
//       'your channel id6',
//       'no GPS',
//       channelDescription: 'No Gps service',
//       importance: Importance.max,
//       priority: Priority.high,
//       ticker: 'ticker',
//       enableLights: true,
//       enableVibration: true,
//       playSound: true,
//       sound: RawResourceAndroidNotificationSound("no_gps"),
//     );
//     IOSNotificationDetails iOSPlatformChannelSpecifics =
//         const IOSNotificationDetails(
//       presentBadge: true,
//       sound: 'no_gps.mp3',
//       presentAlert: true,
//       presentSound: true,
//     );
//
//     final NotificationDetails platform = NotificationDetails(
//         android: androidPlatformChannelSpecifics,
//         iOS: iOSPlatformChannelSpecifics);
//
//     await flutterLocalNotificationsPlugin.show(
//       0,
//       AppLocalizations.of(context)!.locationServNot,
//       'Garanti taxi',
//       platform,
//       payload: 'item x',
//     );
//   } catch (ex) {
//     if (kDebugMode) {
//       print('loc:::${ex.toString()}');
//     }
//   }
// }
int id = 0;

String? selectedNotificationPayload;
const String navigationActionId = 'id_3';
const String darwinNotificationCategoryText = 'textCategory';
const String darwinNotificationCategoryPlain = 'plainCategory';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

final StreamController<ReceivedNotification> didReceiveLocalNotificationStream =
    StreamController<ReceivedNotification>.broadcast();

final StreamController<String?> selectNotificationStream =
    StreamController<String?>.broadcast();

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

// this method for initialization LocalNotifications
Future<void> initializationLocalNotifications(BuildContext context) async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('app_icon');

  final List<DarwinNotificationCategory> darwinNotificationCategories =
      <DarwinNotificationCategory>[
    DarwinNotificationCategory(
      darwinNotificationCategoryText,
      actions: <DarwinNotificationAction>[
        DarwinNotificationAction.text(
          'text_1',
          'Action 1',
          buttonTitle: 'Send',
          placeholder: 'Placeholder',
        ),
      ],
    ),
    DarwinNotificationCategory(
      darwinNotificationCategoryPlain,
      actions: <DarwinNotificationAction>[
        DarwinNotificationAction.plain('id_1', 'Action 1'),
        DarwinNotificationAction.plain(
          'id_2',
          'Action 2 (destructive)',
          options: <DarwinNotificationActionOption>{
            DarwinNotificationActionOption.destructive,
          },
        ),
        DarwinNotificationAction.plain(
          navigationActionId,
          'Action 3 (foreground)',
          options: <DarwinNotificationActionOption>{
            DarwinNotificationActionOption.foreground,
          },
        ),
        DarwinNotificationAction.plain(
          'id_4',
          'Action 4 (auth required)',
          options: <DarwinNotificationActionOption>{
            DarwinNotificationActionOption.authenticationRequired,
          },
        ),
      ],
      options: <DarwinNotificationCategoryOption>{
        DarwinNotificationCategoryOption.hiddenPreviewShowTitle,
      },
    )
  ];

  final DarwinInitializationSettings initializationSettingsDarwin =
      DarwinInitializationSettings(
    requestAlertPermission: false,
    requestBadgePermission: false,
    requestSoundPermission: false,
    onDidReceiveLocalNotification:
        (int id, String? title, String? body, String? payload) async {
      didReceiveLocalNotificationStream.add(
        ReceivedNotification(
          id: id,
          title: title,
          body: body,
          payload: payload,
        ),
      );
    },
    notificationCategories: darwinNotificationCategories,
  );

  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsDarwin,
  );

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse:
        (NotificationResponse notificationResponse) {
      switch (notificationResponse.notificationResponseType) {
        case NotificationResponseType.selectedNotification:
          selectNotificationStream.add(notificationResponse.payload);
          break;
        case NotificationResponseType.selectedNotificationAction:
          if (notificationResponse.actionId == navigationActionId) {
            selectNotificationStream.add(notificationResponse.payload);
          }
          break;
      }
    },
  );
}

// this method for request Permissions LocalNotifications
Future<void> requestPermissionsLocalNotifications() async {
  if (Platform.isIOS) {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  } else if (Platform.isAndroid) {
    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    await androidImplementation?.requestPermission();
  }
}

// this method for notify driver after one hour for location active
Future<void> showNotificationNoLocation(BuildContext context) async {
  const AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails(
    '2',
    'no gps',
    channelDescription: 'Gps stopped working',
    importance: Importance.defaultImportance,
    priority: Priority.high,
    ticker: 'ticker',
    enableLights: true,
    enableVibration: true,
    playSound: true,
    sound: RawResourceAndroidNotificationSound("no_gps"),
  );
  const DarwinNotificationDetails iosNotificationDetails =
      DarwinNotificationDetails(
    categoryIdentifier: darwinNotificationCategoryPlain,
    presentBadge: true,
    sound: 'no_gps.mp3',
    presentAlert: true,
    presentSound: true,
  );
  const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails, iOS: iosNotificationDetails);
  await flutterLocalNotificationsPlugin.show(id++, 'Garanti taxi',
      AppLocalizations.of(context)!.locationServNot, notificationDetails,
      payload: 'item x');
}

// this method for notify driver if new order connect with firebase only android
Future<void> showNewOrderNotification() async {
  const AndroidNotificationChannel androidNotificationDetails =
      AndroidNotificationChannel(
          'high_importance_channel', 'notification_order',
          description: 'notification',
          importance: Importance.defaultImportance,
          enableLights: true,
          enableVibration: true,
          playSound: true,
          sound: RawResourceAndroidNotificationSound("notify"),
        );
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(androidNotificationDetails);
}
