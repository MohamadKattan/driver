import 'package:driver/user_screen/driverInfo_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../my_provider/auth__inductor_provider.dart';
import '../tools/tools.dart';

// this class for Auth by firebase-phone method
class AuthSev {
  final Tools _tools = Tools();
  FirebaseAuth auth = FirebaseAuth.instance;
  late UserCredential userCredential;
  late User currentUser;
  final TextEditingController code = TextEditingController();
// this method for register by phone number
  Future<void> signUpWithPhone(String result, BuildContext context) async {
    try {
      await auth.verifyPhoneNumber(
          phoneNumber: result,
          timeout: const Duration(seconds: 120),
          verificationCompleted: (PhoneAuthCredential credential) async {
            Navigator.pop(context);
            userCredential = await auth.signInWithCredential(credential);
            await getCurrentUserId();
            Provider.of<TrueFalse>(context, listen: false).updateState(false);
            if (userCredential.user != null) {
              Provider.of<TrueFalse>(context, listen: false).updateState(false);

              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const DriverInfoScreen()));
            } else {
              _tools.toastMsg("Some Thing went wrong");
              _tools.toastMsg("check you net work or phone Number");
              Provider.of<TrueFalse>(context, listen: false).updateState(false);
            }
          },
          verificationFailed: (FirebaseAuthException e) {
            Provider.of<TrueFalse>(context, listen: false).updateState(false);
            _tools.toastMsg("Error${e.toString()}");
          },
          codeSent: (String verificationId, int? resendToken) {
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
                          const Text("type a code"),
                          Expanded(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: TextField(
                                controller: code,
                                maxLength: 15,
                                showCursor: true,
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600),
                                cursorColor: const Color(0xFFFFD54F),
                                decoration: const InputDecoration(
                                  icon: Padding(
                                    padding: EdgeInsets.only(top: 15.0),
                                    child: Icon(
                                      Icons.vpn_key,
                                      color: Color(0xFFFFD54F),
                                    ),
                                  ),
                                  fillColor: Color(0xFFFFD54F),
                                  hintText: "Your Code",
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
                            if (code.text.isNotEmpty) {
                              PhoneAuthCredential credential =
                                  PhoneAuthProvider.credential(
                                      verificationId: verificationId,
                                      smsCode: code.text.trim());
                              userCredential =
                                  await auth.signInWithCredential(credential);
                              await getCurrentUserId();
                              if (userCredential.user != null) {
                                DatabaseReference driverRef = FirebaseDatabase.instance
                                    .ref()
                                    .child("driver")
                                    .child(currentUser.uid);
                                await driverRef.set({
                                  "userId":currentUser.uid,
                                  "status":"",
                                  "firstName":"",
                                  "lastName":"",
                                  "idNo":"",
                                  "phoneNumber":"",
                                  "email":"",
                                  "driverLis":"",
                                  "carLis":"",

                                });
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const DriverInfoScreen()));
                              } else {
                                Provider.of<TrueFalse>(context, listen: false)
                                    .updateState(false);
                                _tools.toastMsg("Some thing went wrong");
                                Navigator.pop(context);
                              }
                            } else {
                              Provider.of<TrueFalse>(context, listen: false)
                                  .updateState(false);
                              _tools.toastMsg("Code field can't be empty");
                            }
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _tools.timerAuth(context),
                              Container(
                                  height: 60,
                                  width: 140,
                                  decoration: BoxDecoration(
                                      color: const Color(0xFFFFD54F),
                                      borderRadius: BorderRadius.circular(8)),
                                  child: const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Center(
                                        child: Text(
                                      "verify",
                                      style: TextStyle(
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
          },
          codeAutoRetrievalTimeout: (String verificationId) {
            Provider.of<TrueFalse>(context, listen: false).updateState(false);
            // _tools.toastMsg(verificationId);
            _tools.toastMsg("try again");
          });
    } catch (ex) {
      Provider.of<TrueFalse>(context, listen: false).updateState(false);
      _tools.toastMsg(ex.toString());
    }
  }

  //this method for got user id
  Future<User> getCurrentUserId() async {
    currentUser = auth.currentUser!;
    if (kDebugMode) {
      print("::::${currentUser.uid}");
    }
    return currentUser;
  }
}
