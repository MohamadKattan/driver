import 'dart:async';
import 'package:driver/repo/auth_srv.dart';
import 'package:driver/repo/dataBaseReal_sev.dart';
import 'package:driver/user_screen/HomeScreen.dart';
import 'package:driver/user_screen/check_in_Screen.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import '../my_provider/driver_model_provider.dart';
import '../payment/couut_plan_days.dart';
import '../tools/tools.dart';
import '../tools/turn_GBS.dart';
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
    TurnOnGBS().turnOnGBSifNot();
    _animationController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 500),
        lowerBound: 0.6,
        upperBound: 0.7);
    _animationController.forward();
    _animationController.addStatusListener((status) async {
      if (AuthSev().auth.currentUser?.uid != null) {
        await DataBaseReal().getDriverInfoFromDataBase(context);
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
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const AuthScreen()));
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
}
