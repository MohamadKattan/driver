// auth screen
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
  // static String result = "";
  // static String? resultCodeCon = "+90";
  // static final TextEditingController phoneNumber = TextEditingController();
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
            key: globalKey,
            body: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        AppLocalizations.of(context)!.logIn,
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                            overflow: TextOverflow.fade),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        AppLocalizations.of(context)!.enteryournumber,
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black26,
                            overflow: TextOverflow.fade),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Text(
                        AppLocalizations.of(context)!.email,
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            overflow: TextOverflow.fade),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      ///stop for now
                      // Padding(
                      //   padding: const EdgeInsets.all(15.0),
                      //   child: Row(
                      //     crossAxisAlignment: CrossAxisAlignment.center,
                      //     mainAxisAlignment: MainAxisAlignment.center,
                      //     children: [
                      //       Padding(
                      //         padding: const EdgeInsets.only(top: 8.0),
                      //         child: CountryListPick(
                      //             appBar: AppBar(
                      //               backgroundColor: Colors.amber[200],
                      //               title: Text(
                      //                   AppLocalizations.of(context)!.country),
                      //             ),
                      //             theme: CountryTheme(
                      //               isShowFlag: true,
                      //               isShowTitle: false,
                      //               isShowCode: true,
                      //               isDownIcon: true,
                      //               showEnglishName: false,
                      //               labelColor: Colors.black54,
                      //               alphabetSelectedBackgroundColor:
                      //                   const Color(0xFFFFD54F),
                      //               alphabetTextColor: Colors.deepOrange,
                      //               alphabetSelectedTextColor:
                      //                   Colors.deepPurple,
                      //             ),
                      //             initialSelection: resultCodeCon,
                      //             onChanged: (CountryCode? code) {
                      //               resultCodeCon = code?.dialCode;
                      //             },
                      //             useUiOverlay: true,
                      //             useSafeArea: false),
                      //       ),
                      //       const SizedBox(
                      //         width: 10,
                      //       ),
                      //       Expanded(
                      //         flex: 1,
                      //         child: TextField(
                      //           controller: phoneNumber,
                      //           maxLength: 15,
                      //           showCursor: true,
                      //           style: const TextStyle(
                      //               fontSize: 16, fontWeight: FontWeight.w600),
                      //           cursorColor: const Color(0xFFFFD54F),
                      //           decoration: InputDecoration(
                      //             icon: const Padding(
                      //               padding: EdgeInsets.only(top: 15.0),
                      //               child: Icon(
                      //                 Icons.phone,
                      //                 color: Color(0xFFFFD54F),
                      //               ),
                      //             ),
                      //             fillColor: const Color(0xFFFFD54F),
                      //             label: Text(AppLocalizations.of(context)!
                      //                 .phonenumber),
                      //           ),
                      //           keyboardType: TextInputType.phone,
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Expanded(
                              flex: 0,
                              child: Padding(
                                  padding:
                                      EdgeInsets.only(top: 15.0, left: 15.0),
                                  child: Icon(
                                    Icons.email,
                                    color: Color(0xFFFFD54F),
                                    size: 35.0,
                                  )),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              flex: 1,
                              child: TextField(
                                controller: email,
                                maxLength: 30,
                                showCursor: true,
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600),
                                cursorColor: const Color(0xFFFFD54F),
                                decoration: InputDecoration(
                                  fillColor: const Color(0xFFFFD54F),
                                  label: Text(
                                      AppLocalizations.of(context)!.email1),
                                ),
                                keyboardType: TextInputType.emailAddress,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Expanded(
                              flex: 0,
                              child: Padding(
                                  padding:
                                      EdgeInsets.only(top: 15.0, left: 15.0),
                                  child: Icon(
                                    Icons.vpn_key,
                                    color: Color(0xFFFFD54F),
                                    size: 35.0,
                                  )),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              flex: 1,
                              child: TextField(
                                controller: passWord,
                                maxLength: 30,
                                showCursor: true,
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600),
                                cursorColor: const Color(0xFFFFD54F),
                                decoration: InputDecoration(
                                  fillColor: const Color(0xFFFFD54F),
                                  label:
                                      Text(AppLocalizations.of(context)!.pass),
                                ),
                                keyboardType: TextInputType.text,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                        child: Text(AppLocalizations.of(context)!.verification),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 40),
                        child: GestureDetector(
                          onTap: () async {
                            ///stop for now
                            // if (phoneNumber.text.isEmpty) {
                            //   ScaffoldMessenger.of(context).showSnackBar(
                            //     SnackBar(
                            //       behavior: SnackBarBehavior.fixed,
                            //       backgroundColor: Colors.red,
                            //       duration: const Duration(seconds: 3),
                            //       content: Text(
                            //           AppLocalizations.of(context)!.phoneempty),
                            //     ),
                            //   );
                            // }
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
                            child: Center(
                                child: Text(
                              AppLocalizations.of(context)!.signUp,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            )),
                            width: 180,
                            height: 60,
                            decoration: BoxDecoration(
                                color: const Color(0xFFFFD54F),
                                borderRadius: BorderRadius.circular(4.0),
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
