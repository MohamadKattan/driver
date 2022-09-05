
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../my_provider/auth__inductor_provider.dart';
import '../repo/auth_srv.dart';
import '../tools/tools.dart';
import '../widget/custom_circuler.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

GlobalKey globalKey = GlobalKey();

class AuthScreen extends StatelessWidget {
  const AuthScreen({Key? key}) : super(key: key);
  static final TextEditingController email = TextEditingController();
  static final TextEditingController passWord = TextEditingController();
  static AuthSev authSev = AuthSev();
  static final CircularInductorCostem _inductorCostem =
      CircularInductorCostem();



  @override
  Widget build(BuildContext context) {
    bool circulerProvider = Provider.of<TrueFalse>(context).isTrue;
    MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: SafeArea(
          child: Scaffold(
            backgroundColor: const Color(0xFF00A3E0),
            key: globalKey,
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
                        child: Center(
                          child: Image.asset("images/logIn.png",
                            width: 150,
                            height: 150,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      Text(
                        AppLocalizations.of(context)!.logIn,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            overflow: TextOverflow.fade),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          AppLocalizations.of(context)!.enteryournumber,
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white70,
                              overflow: TextOverflow.fade),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 12.0,right: 12.0),
                        padding: const EdgeInsets.only(left: 12.0,right: 12.0),
                        decoration: BoxDecoration(
                          color: Colors.white70,
                          borderRadius: BorderRadius.circular(12.0)
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Expanded(
                              flex: 0,
                              child: Icon(
                                Icons.email,
                                color: Color(0xFFFBC408),
                                size: 35.0,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              flex: 1,
                              child: TextField(
                                controller: email,
                                showCursor: true,
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w600),
                                cursorColor: const Color(0xFFFFD54F),
                                decoration: InputDecoration(
                                  fillColor: const Color(0xFFFFD54F),
                                  hintText:  AppLocalizations.of(context)!.email1,
                                  hintStyle: const TextStyle(
                                    color: Colors.black87
                                  )
                                ),
                                keyboardType: TextInputType.emailAddress,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 12.0,right: 12.0),
                        padding: const EdgeInsets.only(left: 12.0,right: 12.0),
                        decoration: BoxDecoration(
                            color: Colors.white70,
                            borderRadius: BorderRadius.circular(12.0)
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Expanded(
                              flex: 0,
                              child: Icon(
                                Icons.vpn_key,
                                color: Color(0xFFFFD54F),
                                size: 35.0,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              flex: 1,
                              child: TextField(
                                controller: passWord,
                                showCursor: true,
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w600),
                                cursorColor: const Color(0xFFFFD54F),
                                decoration: InputDecoration(
                                  fillColor: const Color(0xFFFFD54F),
                                  hintText: AppLocalizations.of(context)!.pass,
                                 hintStyle: TextStyle(color: Colors.black87)
                                ),
                                keyboardType: TextInputType.text,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () async {
                          if (email.text.isEmpty) {
                            Tools().toastMsg(
                                AppLocalizations.of(context)!.emailempty,
                                Colors.redAccent.shade700);
                          }
                          else if (!email.text.contains("@")) {
                            Tools().toastMsg(
                                AppLocalizations.of(context)!.checkemail,
                                Colors.redAccent.shade700);
                          }
                          else if (!email.text.contains(".com")) {
                            Tools().toastMsg(
                                AppLocalizations.of(context)!.checkcom,
                                Colors.redAccent.shade700);
                          }
                          else if (passWord.text.isEmpty) {
                            Tools().toastMsg(
                                AppLocalizations.of(context)!.passRequired,
                                Colors.redAccent.shade700);
                          }else if(passWord.text.length<8){
                            Tools().toastMsg(
                                AppLocalizations.of(context)!.passLength,
                                Colors.redAccent.shade700);
                          }
                          else {
                            Provider.of<TrueFalse>(context, listen: false)
                                .updateState(true);
                            // result = "$resultCodeCon${phoneNumber.text}";
                            FocusScope.of(context).requestFocus(FocusNode());
                            await authSev.createOrLoginWithEmail(
                                email, context, passWord);
                            // await authSev.signUpWithPhone(result, context);
                            FocusScope.of(context).requestFocus(FocusNode());
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.only(top: 40),
                          padding:  const EdgeInsets.all(8.0),
                          child: Center(
                              child: Text(
                            AppLocalizations.of(context)!.signUp,
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
                    ],
                  ),
                ),
                circulerProvider == true
                    ? Opacity(
                        opacity: 0.9,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: (const BoxDecoration(
                            color: Colors.black,
                          )),
                          child:
                              _inductorCostem.circularInductorCostem(context),
                        ),
                      )
                    : const Text(""),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
