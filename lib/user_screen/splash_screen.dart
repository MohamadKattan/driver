import 'dart:async';
import 'dart:io';
import 'package:driver/logic_google_map.dart';
import 'package:driver/repo/auth_srv.dart';
import 'package:driver/repo/dataBaseReal_sev.dart';
import 'package:driver/user_screen/page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import '../my_provider/circle_indectorWeek.dart';
import '../widget/custom_divider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'intrentet_week.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool result = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _asyncMethod();
    });
    _animationController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 3000),
        lowerBound: 0.4,
        upperBound: 0.5);
    _animationController.forward();
  }

  Future<void> _asyncMethod() async {
   await  checkInternet();
   await DataBaseReal().setImeiDevice();
  }

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ScaleTransition(
          scale: _animationController,
          child: SizedBox(
            height: _height,
            width: _width,
            child: Container(
                color: Colors.white, child: Image.asset("images/splash.png")),
          ),
        ),
      ),
    );
  }

  Future<void> checkInternet() async {
    result = await InternetConnectionChecker().hasConnection;
    if (result == false) {
      Provider.of<IsNetWeek>(context, listen: false).updateState(true);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const InterNetWeak(timeNet: 8)));
    } else {
      if (AuthSev().auth.currentUser?.uid == null) {
        if (Platform.isAndroid) {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => showDialogPolicy(context));
        } else {
          LogicGoogleMap().locationPosition(context);
          // TurnOnGBS().turnOnGBSifNot();
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const MyPageView()));
        }
      } else {
        if (AuthSev().auth.currentUser?.uid != null) {
          await DataBaseReal()
              .getDriverInfoFromDataBase(context)
              .whenComplete(() async {
            await Future.delayed(const Duration(seconds: 1));
            await DataBaseReal().checkStatusUser(context);
            LogicGoogleMap().locationPosition(context);
          });
        }
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  showDialogPolicy(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: Colors.black.withOpacity(0.7),
      child: Dialog(
        elevation: 1.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        backgroundColor: Colors.transparent,
        child: Container(
          height: MediaQuery.of(context).size.height * 55 / 100,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            color: const Color(0xFF00A3E0),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 10.0,
                ),
                Container(
                  decoration: const BoxDecoration(
                      color: Color(0xFFFBC408),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12.0),
                          topRight: Radius.circular(12.0))),
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    AppLocalizations.of(context)!.declaration,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                CustomDivider().customDivider(),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    AppLocalizations.of(context)!.background,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                ),
                CustomDivider().customDivider(),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () => SystemNavigator.pop(),
                        child: Container(
                          height: 40,
                          width: 120,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4.0),
                              color: Colors.redAccent.shade700),
                          child: Center(
                            child: Text(
                                AppLocalizations.of(context)!.noApproval,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                       LogicGoogleMap().locationPosition(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const MyPageView()));
                        },
                        child: Container(
                          height: 40,
                          width: 120,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4.0),
                              color: const Color(0xFFFBC408)),
                          child: Center(
                            child: Text(AppLocalizations.of(context)!.approval,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
