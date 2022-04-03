import 'package:driver/repo/auth_srv.dart';
import 'package:driver/repo/dataBaseReal_sev.dart';
import 'package:driver/user_screen/HomeScreen.dart';
import 'package:driver/user_screen/check_in_Screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../my_provider/driver_model_provider.dart';
import '../tools/turn_GBS.dart';
import 'auth_screen.dart';
import 'driverInfo_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    if (AuthSev().auth.currentUser?.uid != null) {
       DataBaseReal().getDriverInfoFromDataBase(context);
    }
    TurnOnGBS().turnOnGBSifNot();
    _animationController = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 4),
        lowerBound: 0.5,
        upperBound: 0.7);
    _animationController.forward();
    _animationController.addStatusListener((status) async {
      if (AuthSev().auth.currentUser?.uid != null) {
        await DataBaseReal().getDriverInfoFromDataBase(context);
      }
      if (status == AnimationStatus.completed) {
        final driverInfo =
            Provider.of<DriverInfoModelProvider>(context, listen: false)
                .driverInfo;
        print("this is driverInfo" + driverInfo.userId);
        if (AuthSev().auth.currentUser?.uid == null ) {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AuthScreen()));
        }
        else if (AuthSev().auth.currentUser?.uid != null &&
                           driverInfo.status == "" ||
            driverInfo.status.isEmpty) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const DriverInfoScreen()));
        }
        else if (AuthSev().auth.currentUser?.uid != null &&
            driverInfo.status == "checkIn") {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const CheckInScreen()));
        }
        else if (AuthSev().auth.currentUser?.uid != null &&
            driverInfo.status == "ok") {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const HomeScreen()));
        } else {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AuthScreen()));
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

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }
}
