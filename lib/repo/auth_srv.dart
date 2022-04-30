import 'package:driver/user_screen/driverInfo_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../my_provider/auth__inductor_provider.dart';
import '../my_provider/user_id_provider.dart';
import '../tools/tools.dart';
import '../user_screen/splash_screen.dart';
import 'dataBaseReal_sev.dart';

// this class for Auth by firebase-phone method
class AuthSev {
  final Tools _tools = Tools();
 late FirebaseAuth auth = FirebaseAuth.instance;
  late UserCredential userCredential;
  late User? currentUser;
  final TextEditingController code = TextEditingController();
  DatabaseReference driverRef = FirebaseDatabase.instance.ref().child("driver");
  //this method for got user id
  Future<User?> createOrLoginWithEmail(
      TextEditingController email, String result, BuildContext context) async {
    try {
      userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email.text.trim(), password: "123456789!");
      await getCurrentUserId(context).whenComplete(() async {
        if (userCredential.user!.uid.isNotEmpty) {
          currentUser = userCredential.user!;
          await DataBaseReal()
              .getDriverInfoFromDataBase(context)
              .whenComplete(() {
               Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const SplashScreen()));
            Provider.of<TrueFalse>(context, listen: false).updateState(false);
          });
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
              "status": "",
              "firstName": "",
              "country":"",
              "lastName": "",
              "idNo": "",
              "driverLis": "",
              "carLis": "",
              "earning":"0.0",
              "personImage":"",
            }).whenComplete(() {
              Provider.of<TrueFalse>(context, listen: false).updateState(false);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const DriverInfoScreen()));
            });
          }
        } on FirebaseAuthException catch (e) {
          e.toString();
          _tools.toastMsg("Some Thing went Wrong",Colors.redAccent.shade700);
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
    if (kDebugMode) {
      print("this is current user from AuthSrv:::${currentUser!.uid}");
    }
    return currentUser!;
  }
}
