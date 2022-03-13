// auth screen
import 'package:country_list_pick/country_list_pick.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../my_provider/auth__inductor_provider.dart';
import '../repo/auth_sev.dart';
import '../widget/custom_circuler.dart';

GlobalKey globalKey = GlobalKey();

class AuthScreen extends StatelessWidget {
  const AuthScreen({Key? key}) : super(key: key);
  static String result = "";
  static String? resultCodeCon = "+90";
  static final TextEditingController phoneNumber = TextEditingController();
  static AuthSev authSev = AuthSev();
  static final CircularInductorCostem _inductorCostem =
      CircularInductorCostem();

  @override
  Widget build(BuildContext context) {
    bool circulerProvider = Provider.of<TrueFalse>(context).isTrue;
    MediaQuery.of(context).size;
    return GestureDetector(
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
                    const Text(
                      "Log in to Garanti driver taxi",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                          overflow: TextOverflow.fade),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Enter your number to be able to log in or create a new account",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black26,
                          overflow: TextOverflow.fade),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    const Text(
                      "Enter your phone number",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          overflow: TextOverflow.fade),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: CountryListPick(
                                appBar: AppBar(
                                  backgroundColor: Colors.amber[200],
                                  title: const Text('Pick your country'),
                                ),
                                theme: CountryTheme(
                                  isShowFlag: true,
                                  isShowTitle: false,
                                  isShowCode: true,
                                  isDownIcon: true,
                                  showEnglishName: false,
                                  labelColor: Colors.black54,
                                  alphabetSelectedBackgroundColor:
                                      const Color(0xFFFFD54F),
                                  alphabetTextColor: Colors.deepOrange,
                                  alphabetSelectedTextColor: Colors.deepPurple,
                                ),
                                initialSelection: resultCodeCon,
                                onChanged: (CountryCode? code) {
                                  resultCodeCon = code?.dialCode;
                                },
                                useUiOverlay: true,
                                useSafeArea: false),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            flex: 1,
                            child: TextField(
                              controller: phoneNumber,
                              maxLength: 15,
                              showCursor: true,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                              cursorColor: const Color(0xFFFFD54F),
                              decoration: const InputDecoration(
                                icon: Padding(
                                  padding: EdgeInsets.only(top: 15.0),
                                  child: Icon(
                                    Icons.phone,
                                    color: Color(0xFFFFD54F),
                                  ),
                                ),
                                fillColor: Color(0xFFFFD54F),
                                label: Text("Phone number"),
                              ),
                              keyboardType: TextInputType.phone,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                      child: Text("Verification code will send by a massage"),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 40),
                      child: GestureDetector(
                        onTap: () async {
                          if (phoneNumber.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                behavior: SnackBarBehavior.fixed,
                                backgroundColor: Colors.red,
                                duration: Duration(seconds: 3),
                                content: Text('phone number can\'t be empty'),
                              ),
                            );
                          } else {
                            result = "$resultCodeCon${phoneNumber.text}";
                            await authSev.signUpWithPhone(result, context);
                            FocusScope.of(context).requestFocus(FocusNode());
                            Provider.of<TrueFalse>(context, listen: false)
                                .updateState(true);
                          }
                        },
                        child: Container(
                          child: const Center(
                              child: Text(
                            "SignUp",
                            style: TextStyle(
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
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15.0),
                      child: Center(
                          child: Lottie.asset(
                              'images/91310-mobile-device-tech.json',
                              height: 250,
                              width: 250)),
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
                        child: _inductorCostem.circularInductorCostem(context),
                      ),
                    )
                  : const Text("")
            ],
          ),
        ),
      ),
    );
  }
}
