import 'dart:async';
import 'dart:io';
import 'package:driver/repo/auth_srv.dart';
import 'package:driver/repo/dataBaseReal_sev.dart';
import 'package:driver/user_screen/HomeScreen.dart';
import 'package:driver/user_screen/check_in_Screen.dart';
import 'package:driver/user_screen/refresh_after_active.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import '../config.dart';
import '../my_provider/driver_model_provider.dart';
import '../notificatons/push_notifications_srv.dart';
import '../payment/couut_plan_days.dart';
import '../tools/tools.dart';
import '../tools/turn_GBS.dart';
import '../tools/url_lunched.dart';
import '../widget/custom_divider.dart';
import 'active_account.dart';
import 'auth_screen.dart';
import 'driverInfo_screen.dart';
import 'if_you_wanttopay.dart';
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
    checkInternet();
    if (AuthSev().auth.currentUser?.uid != null) {
      DataBaseReal().getDriverInfoFromDataBase(context);
      PlanDays().getBackGroundBoolValue();
    }
    _animationController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 800),
        lowerBound: 0.6,
        upperBound: 0.7);
    _animationController.forward();
    _animationController.addStatusListener((status) async {
      if (AuthSev().auth.currentUser?.uid != null) {
        await DataBaseReal().getDriverInfoFromDataBase(context);
        tokenPhone = await firebaseMessaging.getToken();
      }
      if (status == AnimationStatus.completed) {
        if (result == false) {
          Tools()
              .toastMsg(AppLocalizations.of(context)!.noNet, Colors.redAccent);
          Tools().toastMsg(
              AppLocalizations.of(context)!.checkNet, Colors.redAccent);
        } else {
          final driverInfo =
              Provider.of<DriverInfoModelProvider>(context, listen: false)
                  .driverInfo;
          if (AuthSev().auth.currentUser?.uid == null) {
            if(Platform.isAndroid){
              showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) => showDialogPolicy(context));
            }else{
              TurnOnGBS().turnOnGBSifNot();
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const AuthScreen()));
            }
          }
          else if (AuthSev().auth.currentUser?.uid != null &&
              driverInfo.update == true) {
            await ToUrlLunch().toPlayStore();
           await driverRef.child(userId).child("update").set(false);
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                builder:(_)=>const SplashScreen()), (route) => false);
          } else if (AuthSev().auth.currentUser?.uid != null &&
              driverInfo.tok == "r") {
            Tools().toastMsg(
                AppLocalizations.of(context)!.active, Colors.greenAccent);
            await getToken();
            tokenPhone = await firebaseMessaging.getToken();
           await driverRef.child(userId).child("active").set("active");
            Navigator.push(context, MaterialPageRoute(builder:(_)=>const RefreshAfterActived()));
          } else if (AuthSev().auth.currentUser?.uid != null &&
              driverInfo.tok == "") {
            Navigator.push(context, MaterialPageRoute(builder:(_)=>const DriverInfoScreen()));
          }
          else if (AuthSev().auth.currentUser?.uid != null &&
              driverInfo.tok.substring(0,5) != tokenPhone?.substring(0,5)) {
            Tools().toastMsg(
                AppLocalizations.of(context)!.tokenUesd, Colors.redAccent);
            Navigator.push(context, MaterialPageRoute(builder:(_)=>const ActiveAccount()));
          } else if (AuthSev().auth.currentUser?.uid != null &&
              driverInfo.status == "info") {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const DriverInfoScreen()));
          } else if (AuthSev().auth.currentUser?.uid != null &&
              driverInfo.status == "checkIn") {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const CheckInScreen()));
          } else if (AuthSev().auth.currentUser?.uid != null &&
              driverInfo.status == "payTime") {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const IfYouWantPay()));
          } else if (AuthSev().auth.currentUser?.uid != null &&
              driverInfo.status == "payed") {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const HomeScreen()));
          } else if (AuthSev().auth.currentUser?.uid != null &&
              driverInfo.status.isEmpty) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const InterNetWeak()));
          } else {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const AuthScreen()));
          }
        }
      }
    });
    super.initState();
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
          height: MediaQuery.of(context).size.height * 50 / 100,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6.0),
            color: Colors.white,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 10.0,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    AppLocalizations.of(context)!.declaration,
                    style: TextStyle(
                        color: Colors.redAccent.shade700,
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
                        color: Colors.black,
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
                           TurnOnGBS().turnOnGBSifNot().whenComplete(() =>
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const AuthScreen())));
                        },
                        child: Container(
                          height: 40,
                          width: 120,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4.0),
                              color: Colors.greenAccent.shade700),
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
