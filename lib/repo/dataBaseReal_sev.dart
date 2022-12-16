// this class will include method dataBase Real time

import 'package:driver/model/driverInfo.dart';
import 'package:driver/notificatons/push_notifications_srv.dart';
import 'package:driver/repo/auth_srv.dart';
import 'package:driver/repo/geoFire_srv.dart';
import 'package:driver/tools/tools.dart';
import 'package:driver/user_screen/auth_screen.dart';
import 'package:driver/user_screen/splash_screen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config.dart';
import '../my_provider/circle_indectorWeek.dart';
import '../my_provider/driver_model_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../tools/url_lunched.dart';
import '../user_screen/HomeScreen.dart';
import '../user_screen/check_in_Screen.dart';
import '../user_screen/driverInfo_screen.dart';
import '../user_screen/if_you_wanttopay.dart';
import '../user_screen/intrentet_week.dart';
import '../user_screen/refresh_after_active.dart';

class DataBaseReal {
  final currentUser = AuthSev().auth.currentUser;
  late final DataSnapshot snapshot;

  // this method for got Driver info and save in model/Provider
  Future<void> getDriverInfoFromDataBase(BuildContext context) async {
    try {
      final ref = FirebaseDatabase.instance.ref();
      snapshot = await ref.child("driver").child(currentUser!.uid).get();
      if (snapshot.value != null) {
        Map<String, dynamic> map =
            Map<String, dynamic>.from(snapshot.value as Map);
        DriverInfo driverInfo = DriverInfo.fromMap(map);
        Provider.of<DriverInfoModelProvider>(context, listen: false)
            .updateDriverInfo(driverInfo);
      } else {
        return;
      }
    } catch (ex) {
      Tools().toastMsg('!!!Data one!!!', Colors.red.shade700);
    }
  }

  // this method for got Driver info and save in model just in net Screen
  Future<void> getDriverInfoIfNetWeek(BuildContext context) async {
    try {
      final ref = FirebaseDatabase.instance.ref();
      snapshot = await ref.child("driver").child(currentUser!.uid).get();
      if (snapshot.value != null) {
        Map<String, dynamic> map =
            Map<String, dynamic>.from(snapshot.value as Map);
        DriverInfo driverInfo = DriverInfo.fromMap(map);
        Provider.of<DriverInfoModelProvider>(context, listen: false)
            .updateDriverInfo(driverInfo);
        await Future.delayed(const Duration(seconds: 2));
        await checkStatusUser(context);
      } else {
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => const AuthScreen()));
      }
    } catch (ex) {
      Tools().toastMsg('!!!no net!!!', Colors.red.shade700);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const SplashScreen()),
          (route) => false);
    }
  }

  // this method for delete account user
  Future<void> deleteAccount(BuildContext context) async {
    try {
      driverRef.child(userId).onDisconnect();
      driverRef.child(userId).remove();
      // await FirebaseAuth.instance.currentUser!.delete();
      Tools().toastMsg(AppLocalizations.of(context)!.delDon, Colors.redAccent);
      Tools().toastMsg(AppLocalizations.of(context)!.youCanExit, Colors.green);
    } catch (ex) {
      ex.toString();
    }
  }

  // this method for listing to status if changed in checkIn/payTime
  Future<void> listingForChangeInStatus(BuildContext context) async {
    if (kDebugMode) {
      print("listingForChangeInStatus Start");
    }
    try {
      final _ref = FirebaseDatabase.instance.ref();
      listingForChangeStatus = _ref
          .child('driver')
          .child(currentUser!.uid)
          .child('status')
          .onValue
          .listen((event) {
        final _snap = event.snapshot.value;
        if (_snap != null) {
          if (_snap == 'payed') {
            listingForChangeStatus.cancel();
            if (kDebugMode) {
              print("listingForChangeInStatus canceled");
            }
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const SplashScreen()),
                (route) => false);
          } else {
            if (kDebugMode) {
              print("listingForChangeInStatus null");
            }
            return;
          }
        } else {
          return;
        }
      });
    } catch (ex) {
      if (kDebugMode) {
        print(ex.toString());
      }
    }
  }

  // this method for listing to status if changed in payTime homeScreen
  Future<void> listingForChangeInStatusPay(BuildContext context) async {
    if (kDebugMode) {
      print("listingForChangeInStatusPay Start");
    }
    try {
      final _ref = FirebaseDatabase.instance.ref();
      listingForChangeStatusPay = _ref
          .child('driver')
          .child(currentUser!.uid)
          .child('status')
          .onValue
          .listen((event) {
        final _snap = event.snapshot.value;
        if (_snap != null) {
          if (_snap == 'payTime') {
            listingForChangeStatusPay.cancel();
            subscriptionNot1.cancel();
            serviceStatusStreamSubscription?.cancel();
            GeoFireSrv().cancelStreamLocation();
            if (kDebugMode) {
              print("listingForChangeInStatusPay canceled");
            }
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const SplashScreen()),
                (route) => false);
          } else {
            if (kDebugMode) {
              print("listingForChangeInStatusPay null");
            }
            return;
          }
        } else {
          return;
        }
      });
    } catch (ex) {
      if (kDebugMode) {
        print(ex.toString());
      }
    }
  }

  // this method for listing to status if changed in NotActive
  Future<void> listingForChangeInStatusActive(BuildContext context) async {
    if (kDebugMode) {
      print("listingForChangeInStatusActive Start");
    }
    try {
      final _ref = FirebaseDatabase.instance.ref();
      listingForChangeStatusActive = _ref
          .child('driver')
          .child(currentUser!.uid)
          .child('token')
          .onValue
          .listen((event) {
        final _snap = event.snapshot.value;
        if (_snap != null) {
          if (_snap == 'r') {
            listingForChangeStatusActive.cancel();
            if (kDebugMode) {
              print("listingForChangeInStatusActive canceled");
            }
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const SplashScreen()),
                (route) => false);
          } else {
            if (kDebugMode) {
              print("listingForChangeInStatusActive null");
            }
            return;
          }
        } else {
          return;
        }
      });
    } catch (ex) {
      if (kDebugMode) {
        print(ex.toString());
      }
    }
  }

  // this method for check Status user after got info form real if normal or net week
  Future<void> checkStatusUser(BuildContext context) async {
    final driverInfo =
        Provider.of<DriverInfoModelProvider>(context, listen: false).driverInfo;
    tokenPhone = await firebaseMessaging.getToken();
    if (driverInfo.update == true) {
      await ToUrlLunch().toPlayStore();
      await driverRef.child(userId).child("update").set(false);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const SplashScreen()),
          (route) => false);
    }
    else if (driverInfo.tok == "r") {
      Tools()
          .toastMsg(AppLocalizations.of(context)!.active, Colors.greenAccent);
      await getToken();
      tokenPhone = await firebaseMessaging.getToken();
      await driverRef.child(userId).child("active").set("active");
      Navigator.push(context,
          MaterialPageRoute(builder: (_) => const RefreshAfterActived()));
    }
    else if (driverInfo.tok == "" && driverInfo.status == "") {
      Provider.of<IsNetWeek>(context, listen: false).updateState(true);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => const InterNetWeak(
                    timeNet: 1,
                  )));
    }
    else {
      switch (driverInfo.status) {
        case 'info':
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const DriverInfoScreen()));
          break;
        case 'checkIn':
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const CheckInScreen()));
          break;
        case 'payTime':
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const IfYouWantPay()));
          break;
        case 'payed':
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const HomeScreen()));
          break;
        default:
          break;
      }
    }
    // else if (driverInfo.status == "info") {
    //   Navigator.push(
    //       context,
    //       MaterialPageRoute(
    //           builder: (context) => const DriverInfoScreen()));
    // }
    // else if (driverInfo.status == "checkIn") {
    //   Navigator.push(
    //       context,
    //       MaterialPageRoute(
    //           builder: (context) => const CheckInScreen()));
    // }
    // else if (driverInfo.status == "payTime") {
    //   Navigator.push(
    //       context,
    //       MaterialPageRoute(
    //           builder: (context) => const IfYouWantPay()));
    // }
    // else if (driverInfo.status == "payed") {
    //   Navigator.push(context,
    //       MaterialPageRoute(builder: (context) => const HomeScreen()));
    // }
  }
}
