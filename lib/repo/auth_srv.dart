import 'dart:async';
import 'package:driver/user_screen/driverInfo_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config.dart';
import '../model/driverInfo.dart';
import '../my_provider/auth__inductor_provider.dart';
import '../my_provider/driver_model_provider.dart';
import '../my_provider/user_id_provider.dart';
import '../notificatons/push_notifications_srv.dart';
import '../tools/tools.dart';
import '../user_screen/splash_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AuthSev {
  final Tools _tools = Tools();
  late FirebaseAuth auth = FirebaseAuth.instance;
  late UserCredential userCredential;
  late User? currentUser;
  final TextEditingController codeText = TextEditingController();
  DatabaseReference driverRef = FirebaseDatabase.instance.ref().child("driver");
  late final DataSnapshot snapshot;

  //this method for got user id
  Future<void> createOrLoginWithEmail(TextEditingController email,
      BuildContext context, TextEditingController passWord) async {
    try {
      userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email.text.trim(), password: passWord.text.trim());
      if (userCredential.user!.uid.isNotEmpty) {
        tokenPhone = await firebaseMessaging.getToken();
        currentUser = userCredential.user!;
        snapshot = await driverRef.child(currentUser!.uid).get();
        if (snapshot.exists) {
          Map<String, dynamic> map =
              Map<String, dynamic>.from(snapshot.value as Map);
          DriverInfo driverInfo = DriverInfo.fromMap(map);
          if (driverInfo.status == "info" && driverInfo.tok == "") {
            Provider.of<TrueFalse>(context, listen: false).updateState(false);
            Navigator.of(context)
                .push(Tools().createRoute(context, const DriverInfoScreen()));
          } else {
            Provider.of<DriverInfoModelProvider>(context, listen: false)
                .updateDriverInfo(driverInfo);
            Provider.of<TrueFalse>(context, listen: false).updateState(false);
            Navigator.of(context)
                .push(Tools().createRoute(context, const SplashScreen()));
          }
        } else if (!snapshot.exists || snapshot.key!.isEmpty) {
          driverRef.child(currentUser!.uid).set({
            "userId": currentUser!.uid,
            "phoneNumber": "",
            "email": email.text.trim(),
            "pass": passWord.text.trim(),
            "backbool": false,
            "update": false,
            "status": "info",
            "firstName": "",
            "country": "",
            "city": "",
            "exPlan": 0,
            "lastName": "",
            "idNo": "",
            "token": "",
            "driverLis": "",
            "carLis": "",
            "earning": "0.0",
            "personImage": "",
            "plandate": DateTime.now().toString(),
            "lastseen": DateTime.now().toString(),
            "active": "active",
            "map": "googleMap",
            "imei": ""
          }).whenComplete(() async {
            await driverRef.child(currentUser!.uid).child("carInfo").set({
              "carBrand": "",
              "carColor": "",
              "carModel": "",
              "carType": "",
              "carImage": "",
            });
          });
          Provider.of<TrueFalse>(context, listen: false).updateState(false);
          Navigator.of(context)
              .push(Tools().createRoute(context, const DriverInfoScreen()));
        }
      }
      getCurrentUserId(context);
    } on FirebaseAuthException catch (e) {
      if (e.code == "wrong-password") {
        _tools.toastMsg(
            AppLocalizations.of(context)!.wrongPass, Colors.redAccent.shade700);
        Provider.of<TrueFalse>(context, listen: false).updateState(false);
      } else if (e.code == 'user-not-found') {
        try {
          userCredential = await FirebaseAuth.instance
              .createUserWithEmailAndPassword(
                  email: email.text.trim(), password: passWord.text.trim());
          currentUser = userCredential.user!;
          if (currentUser!.uid.isNotEmpty) {
            driverRef.child(currentUser!.uid).set({
              "userId": currentUser!.uid,
              "phoneNumber": "",
              "email": email.text.trim(),
              "pass": passWord.text.trim(),
              "backbool": false,
              "update": false,
              "status": "info",
              "firstName": "",
              "country": "",
              "city": "",
              "exPlan": 0,
              "lastName": "",
              "token": "",
              "idNo": "",
              "driverLis": "",
              "carLis": "",
              "earning": "0.0",
              "personImage": "",
              "plandate": DateTime.now().toString(),
              "lastseen": DateTime.now().toString(),
              "active": "active",
              "map": "googleMap",
              "imei": ""
            }).whenComplete(() async {
              await driverRef.child(currentUser!.uid).child("carInfo").set({
                "carBrand": "",
                "carColor": "",
                "carModel": "",
                "carType": "",
                "carImage": "",
              });
            });
            Provider.of<TrueFalse>(context, listen: false).updateState(false);
            Navigator.of(context)
                .push(Tools().createRoute(context, const DriverInfoScreen()));
            getCurrentUserId(context);
          }
        } on FirebaseAuthException catch (e) {
          e.toString();
          _tools.toastMsg(
              AppLocalizations.of(context)!.error, Colors.redAccent.shade700);
        } catch (e) {
          e.toString();
        }
      }
    }
  }

  Future<User> getCurrentUserId(BuildContext context) async {
    currentUser = auth.currentUser!;
    if (currentUser!.uid.isNotEmpty) {
      Provider.of<UserIdProvider>(context, listen: false)
          .getUserIdProvider(currentUser!);
    }
    return currentUser!;
  }
}
