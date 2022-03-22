// this class for firebase push notifications

import 'package:driver/repo/auth_srv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

 Future<void>onBackgroundMessage(RemoteMessage message)async{
   await Firebase.initializeApp();
   if (message.data.isNotEmpty && message.notification != null) {
     ///Todo
     print('Message also contained a notification: ${message.notification}');
   }

 }

class PushNotificationsSrv {
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  final userId = AuthSev().auth.currentUser!.uid;
  DatabaseReference driverRef = FirebaseDatabase.instance.ref().child("driver");

  // this method for permission after that start methods
  void startSendNotifications() async {
    FirebaseMessaging.onBackgroundMessage(onBackgroundMessage);

    // NotificationSettings settings = await firebaseMessaging.requestPermission(
    //   alert: true,
    //   announcement: false,
    //   badge: true,
    //   carPlay: false,
    //   criticalAlert: false,
    //   provisional: false,
    //   sound: true,
    // );
    setForegroundNotifications();
    setBackgroundNotifications();
    setTerminateNotifications();
  }

  // this method for got token driver and set to database
  Future<String?> getToken() async {
    String? token = await firebaseMessaging.getToken();
    print("this is token::$token");
    await driverRef.child(userId).child("token").set(token);
    firebaseMessaging.subscribeToTopic("allDrivers");
    firebaseMessaging.subscribeToTopic("allUsers");
    return token;
  }

   setForegroundNotifications() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.data.isNotEmpty&&message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });
  }

   setBackgroundNotifications() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.data.isNotEmpty&&message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });
  }

   setTerminateNotifications()async {
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if(initialMessage != null){

    }
   }

  // this method will use in home screen in instant for auto starting
  getCurrentInfoDriverForNotification() {
    // final userId = AuthSev().auth.currentUser?.uid;
    getToken();
  startSendNotifications();
  }
}
