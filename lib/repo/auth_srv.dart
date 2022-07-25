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
import '../user_screen/active_account.dart';
import '../user_screen/splash_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// this class for Auth by firebase-phone method

class AuthSev {
  final Tools _tools = Tools();
  late FirebaseAuth auth = FirebaseAuth.instance;
  late UserCredential userCredential;
  late User? currentUser;
  final TextEditingController codeText = TextEditingController();
  DatabaseReference driverRef = FirebaseDatabase.instance.ref().child("driver");
  late final DataSnapshot snapshot;
  //this method for got user id
  Future<User?> createOrLoginWithEmail(TextEditingController email,
      BuildContext context, TextEditingController passWord) async {
    try {
      userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email.text.trim(), password: passWord.text.trim());
      await getCurrentUserId(context).whenComplete(() async {
        if (userCredential.user!.uid.isNotEmpty) {
          tokenPhone = await firebaseMessaging.getToken();
          currentUser = userCredential.user!;
          snapshot = await driverRef.child(currentUser!.uid).get();
          if (snapshot.exists) {
            Map<String, dynamic> map =
                Map<String, dynamic>.from(snapshot.value as Map);
            DriverInfo driverInfo = DriverInfo.fromMap(map);
            if (driverInfo.tok.substring(0,5) != tokenPhone?.substring(0,5)) {
              _tools.toastMsg(
                  AppLocalizations.of(context)!.tokenUesd,Colors.red);
              Navigator.push(context, MaterialPageRoute(builder:(_)=>const ActiveAccount()));
            } else {
              Provider.of<DriverInfoModelProvider>(context, listen: false)
                  .updateDriverInfo(driverInfo);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SplashScreen()));
              Provider.of<TrueFalse>(context, listen: false).updateState(false);
            }
            return;
          } else if (!snapshot.exists || snapshot.key!.isEmpty) {
            driverRef.child(currentUser!.uid).set({
              "userId": currentUser!.uid,
              "phoneNumber": "",
              "email": email.text.trim(),
              "pass":passWord.text.trim(),
              "backbool": false,
              "update": false,
              "status": "info",
              "firstName": "",
              "country": "",
              "exPlan": 0,
              "lastName": "",
              "idNo": "",
              "token": "",
              "driverLis": "",
              "carLis": "",
              "earning": "0.0",
              "personImage": "",
              "plandate":DateTime.now().toString(),
              "active":"active"
            }).whenComplete(() async {
              await driverRef.child(currentUser!.uid).child("carInfo").set({
                "carBrand": "",
                "carColor": "",
                "carModel": "",
                "carType": "",
                "carImage": "",
              });
            }).whenComplete(() async {
              Provider.of<TrueFalse>(context, listen: false).updateState(false);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const DriverInfoScreen()));
              Provider.of<TrueFalse>(context, listen: false).updateState(false);
            });
          }
        }
        Provider.of<TrueFalse>(context, listen: false).updateState(false);
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == "wrong-password") {
        _tools.toastMsg(
            AppLocalizations.of(context)!.wrongPass, Colors.redAccent.shade700);
        Provider.of<TrueFalse>(context, listen: false).updateState(false);
      }
      else if (e.code == 'user-not-found') {
        try {
          userCredential = await FirebaseAuth.instance
              .createUserWithEmailAndPassword(
                  email: email.text.trim(), password: passWord.text.trim());
          await getCurrentUserId(context);
          currentUser = userCredential.user!;
          if (currentUser!.uid.isNotEmpty) {
            driverRef.child(currentUser!.uid).set({
              "userId": currentUser!.uid,
              "phoneNumber": "",
              "email": email.text.trim(),
              "pass":passWord.text.trim(),
              "backbool": false,
              "update": false,
              "status": "info",
              "firstName": "",
              "country": "",
              "exPlan": 0,
              "lastName": "",
              "token": "",
              "idNo": "",
              "driverLis": "",
              "carLis": "",
              "earning": "0.0",
              "personImage": "",
              "plandate":DateTime.now().toString(),
              "active":"active"
            }).whenComplete(() async {
              await driverRef.child(currentUser!.uid).child("carInfo").set({
                "carBrand": "",
                "carColor": "",
                "carModel": "",
                "carType": "",
                "carImage": "",
              });
            }).whenComplete(() async {
              Provider.of<TrueFalse>(context, listen: false).updateState(false);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const DriverInfoScreen()));
              Provider.of<TrueFalse>(context, listen: false).updateState(false);
            });
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
    return null;
    // return userCredential.user!;
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
