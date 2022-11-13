import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../my_provider/auth__inductor_provider.dart';
import '../widget/custom_circuler.dart';
import '../widget/send_passDon.dart';

class ForgotPass extends StatefulWidget {
  const ForgotPass({Key? key}) : super(key: key);
  static final CircularInductorCostem _inductorCostem =
      CircularInductorCostem();

  @override
  State<ForgotPass> createState() => _ForgotPassState();
}

class _ForgotPassState extends State<ForgotPass> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _email = TextEditingController();

  @override
  Widget build(BuildContext context) {
    bool myTimerProvider = Provider.of<TrueFalse>(context).isTrue;
    return SafeArea(
        child: Scaffold(
      backgroundColor: const Color(0xFF00A3E0),
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.forgetPassWord,
          textAlign: TextAlign.start,
          style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.normal,
              color: Colors.white,
              overflow: TextOverflow.fade),
        ),
        backgroundColor: const Color(0xFF00A3E0),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    "images/logIn.png",
                    width: 125,
                    height: 125,
                    fit: BoxFit.contain,
                  ),
                ),
                Text(
                  AppLocalizations.of(context)!.forgetPassWord,
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      overflow: TextOverflow.fade),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    AppLocalizations.of(context)!.exForgotPass,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white70,
                        overflow: TextOverflow.fade),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                  child: Container(
                    height: 55,
                    margin: const EdgeInsets.only(left: 4.0, right: 4.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: TextField(
                      controller: _email,
                      showCursor: true,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600),
                      cursorColor: const Color(0xFFFFD54F),
                      decoration: InputDecoration(
                        fillColor: const Color(0xFFFFD54F),
                        hintText: AppLocalizations.of(context)!.email,
                        icon: const Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Icon(
                            Icons.mail,
                            color: Colors.grey,
                            size: 25,
                          ),
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: GestureDetector(
                    onTap: () async {
                      if (_email.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            behavior: SnackBarBehavior.fixed,
                            backgroundColor: Colors.red,
                            duration: const Duration(seconds: 3),
                            content:
                                Text(AppLocalizations.of(context)!.emailempty),
                          ),
                        );
                      } else {
                        Provider.of<TrueFalse>(context, listen: false)
                            .updateState(true);
                        try {
                          setLan().whenComplete(() async {
                            await _auth
                                .sendPasswordResetEmail(
                                    email: _email.text.trim())
                                .whenComplete(() {
                              Provider.of<TrueFalse>(context, listen: false)
                                  .updateState(false);
                              showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (_) => sendPassDon(context));
                              _email.clear();
                            });
                          });
                        } catch (ex) {
                          if (kDebugMode) {
                            print(ex.toString());
                          }
                        }
                        FocusScope.of(context).requestFocus(FocusNode());
                      }
                    },
                    child: Container(
                      child: Center(
                          child: Text(
                        AppLocalizations.of(context)!.send,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      )),
                      width: 200,
                      height: 60,
                      decoration: BoxDecoration(
                          color: const Color(0xFFFBC408),
                          borderRadius: BorderRadius.circular(12.0),
                          boxShadow: const [
                            BoxShadow(
                                color: Colors.black45,
                                offset: Offset(0.10, 0.7),
                                spreadRadius: 0.9)
                          ]),
                    ),
                  ),
                ),
              ],
            ),
          ),
          myTimerProvider == true
              ? Opacity(
                  opacity: 0.9,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: (const BoxDecoration(
                      color: Colors.black,
                    )),
                    child: ForgotPass._inductorCostem
                        .circularInductorCostem(context),
                  ),
                )
              : const Text("")
        ],
      ),
    ));
  }

  Future<void> setLan() async {
    String val = AppLocalizations.of(context)!.forgetPassWord;
    switch (val) {
      case 'Şifremi Unuttum?':
        await FirebaseAuth.instance.setLanguageCode("tr");
        break;
      case 'هل نسيت كلمة السر؟':
        await FirebaseAuth.instance.setLanguageCode("ar");
        break;
      default:
        await FirebaseAuth.instance.setLanguageCode("en");
        break;
    }
  }
}
