import 'dart:async';
import 'package:driver/user_screen/driverInfo_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/driverInfo.dart';
import '../my_provider/auth__inductor_provider.dart';
import '../my_provider/driver_model_provider.dart';
import '../my_provider/user_id_provider.dart';
import '../tools/tools.dart';
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
  Future<User?> createOrLoginWithEmail(
      TextEditingController email, String result, BuildContext context) async {
    try {
      userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email.text.trim(), password: "123456789!");
      await getCurrentUserId(context).whenComplete(() async {
        if (userCredential.user!.uid.isNotEmpty) {
          currentUser = userCredential.user!;
        snapshot=await  driverRef.child(currentUser!.uid).get();
          if (snapshot.exists) {
            Map<String, dynamic> map =
            Map<String, dynamic>.from(snapshot.value as Map);
            DriverInfo driverInfo = DriverInfo.fromMap(map);
            Provider.of<DriverInfoModelProvider>(context, listen: false)
                .updateDriverInfo(driverInfo);
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const SplashScreen()));
            Provider.of<TrueFalse>(context, listen: false).updateState(false);
            return;
          } else if(!snapshot.exists || snapshot.key!.isEmpty){
            driverRef.child(currentUser!.uid).set({
              "userId": currentUser!.uid,
              "phoneNumber": result.toString(),
              "email": email.text.trim(),
              "backbool": false,
              "status": "info",
              "firstName": "",
              "country": "",
              "exPlan": 0,
              "lastName": "",
              "idNo": "",
              "driverLis": "",
              "carLis": "",
              "earning": "0.0",
              "personImage": "",
            }).whenComplete(() async {
              Provider.of<TrueFalse>(context, listen: false).updateState(false);
              showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    return AlertDialog(
                      content: SizedBox(
                        height: 80,
                        width: MediaQuery.of(context).size.width * 80 / 100,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(AppLocalizations.of(context)!.typeCode),
                            Expanded(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: TextField(
                                  controller: codeText,
                                  maxLength: 15,
                                  showCursor: true,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                  cursorColor: const Color(0xFFFFD54F),
                                  decoration: InputDecoration(
                                    icon: const Padding(
                                      padding: EdgeInsets.only(top: 15.0),
                                      child: Icon(
                                        Icons.vpn_key,
                                        color: Color(0xFFFFD54F),
                                      ),
                                    ),
                                    fillColor: const Color(0xFFFFD54F),
                                    hintText:
                                    AppLocalizations.of(context)!.yourCode,
                                  ),
                                  keyboardType: TextInputType.phone,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      actions: [
                        GestureDetector(
                            onTap: () async {
                              if (codeText.text.isEmpty) {
                                Tools().toastMsg("..........", Colors.red);
                              }
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _tools.timerAuth(context, 120),
                                Container(
                                    height: 60,
                                    width: 140,
                                    decoration: BoxDecoration(
                                        color: const Color(0xFFFFD54F),
                                        borderRadius: BorderRadius.circular(8)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(
                                          child: Text(
                                            AppLocalizations.of(context)!.confirm,
                                            style: const TextStyle(
                                                fontSize: 25.0,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          )),
                                    )),
                              ],
                            ))
                      ],
                    );
                  });
              await Future.delayed(const Duration(seconds: 6));
              codeText.text = "917628";
              await Future.delayed(const Duration(milliseconds: 300));
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
      if (e.code == 'user-not-found') {
        try {
          userCredential = await FirebaseAuth.instance
              .createUserWithEmailAndPassword(
                  email: email.text.trim(), password: "123456789!");
          await getCurrentUserId(context);
          currentUser = userCredential.user!;
          if (currentUser!.uid.isNotEmpty) {
            driverRef.child(currentUser!.uid).set({
              "userId": currentUser!.uid,
              "phoneNumber": result.toString(),
              "email": email.text.trim(),
              "backbool": false,
              "status": "info",
              "firstName": "",
              "country": "",
              "exPlan": 0,
              "lastName": "",
              "idNo": "",
              "driverLis": "",
              "carLis": "",
              "earning": "0.0",
              "personImage": "",
            }).whenComplete(() async {
              Provider.of<TrueFalse>(context, listen: false).updateState(false);
              showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    return AlertDialog(
                      content: SizedBox(
                        height: 80,
                        width: MediaQuery.of(context).size.width * 80 / 100,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(AppLocalizations.of(context)!.typeCode),
                            Expanded(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: TextField(
                                  controller: codeText,
                                  maxLength: 15,
                                  showCursor: true,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                  cursorColor: const Color(0xFFFFD54F),
                                  decoration: InputDecoration(
                                    icon: const Padding(
                                      padding: EdgeInsets.only(top: 15.0),
                                      child: Icon(
                                        Icons.vpn_key,
                                        color: Color(0xFFFFD54F),
                                      ),
                                    ),
                                    fillColor: const Color(0xFFFFD54F),
                                    hintText:
                                        AppLocalizations.of(context)!.yourCode,
                                  ),
                                  keyboardType: TextInputType.phone,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      actions: [
                        GestureDetector(
                            onTap: () async {
                              if (codeText.text.isEmpty) {
                                Tools().toastMsg("..........", Colors.red);
                              }
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _tools.timerAuth(context, 120),
                                Container(
                                    height: 60,
                                    width: 140,
                                    decoration: BoxDecoration(
                                        color: const Color(0xFFFFD54F),
                                        borderRadius: BorderRadius.circular(8)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(
                                          child: Text(
                                        AppLocalizations.of(context)!.confirm,
                                        style: const TextStyle(
                                            fontSize: 25.0,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      )),
                                    )),
                              ],
                            ))
                      ],
                    );
                  });
              await Future.delayed(const Duration(seconds: 35));
              codeText.text = "917628";
              await Future.delayed(const Duration(seconds: 2));
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
    return userCredential.user!;
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
