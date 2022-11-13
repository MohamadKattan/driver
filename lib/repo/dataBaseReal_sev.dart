// this class will include method dataBase Real time

import 'package:driver/model/driverInfo.dart';
import 'package:driver/notificatons/push_notifications_srv.dart';
import 'package:driver/repo/auth_srv.dart';
import 'package:driver/tools/tools.dart';
import 'package:driver/user_screen/splash_screen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config.dart';
import '../my_provider/driver_model_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DataBaseReal {
  final currentUser = AuthSev().auth.currentUser;
  late final DataSnapshot snapshot;
  // this method for got Driver info and save in model then Provider
  Future<void> getDriverInfoFromDataBase(BuildContext context) async {
    try {
      final ref = FirebaseDatabase.instance.ref();
      snapshot = await ref.child("driver").child(currentUser!.uid).get();
      if (snapshot.exists) {
        Map<String, dynamic> map =
            Map<String, dynamic>.from(snapshot.value as Map);
        DriverInfo driverInfo = DriverInfo.fromMap(map);
        Provider.of<DriverInfoModelProvider>(context, listen: false)
            .updateDriverInfo(driverInfo);
        return;
      } else {
        Tools().toastMsg(
            AppLocalizations.of(context)!.welcome, Colors.green.shade700);
      }
    } catch (ex) {
      Tools().toastMsg(
          AppLocalizations.of(context)!.welcome, Colors.green.shade700);
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
        }
        else{return;}
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
        }
        else{return;}
      });
    } catch (ex) {
      if (kDebugMode) {
        print(ex.toString());
      }
    }
  }

  // this method for listing to status if changed in payTime homeScreen
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
        }
        else{return;}
      });
    } catch (ex) {
      if (kDebugMode) {
        print(ex.toString());
      }
    }
  }
}
