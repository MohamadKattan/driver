import 'dart:async';
import 'package:driver/user_screen/page_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../config.dart';
import '../my_provider/circle_indectorWeek.dart';
import '../repo/dataBaseReal_sev.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../widget/custom_circuler.dart';

class InterNetWeak extends StatefulWidget {
  final int timeNet;
  const InterNetWeak({Key? key, required this.timeNet}) : super(key: key);

  @override
  State<InterNetWeak> createState() => _InterNetWeakState();
}

class _InterNetWeakState extends State<InterNetWeak> {
  bool result = false;
  final String? _id = FirebaseAuth.instance.currentUser?.uid;

  @override
  void initState() {
    checkInternet();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool valNetWeek = Provider.of<IsNetWeek>(context).netWeek;
    return SafeArea(
        child: Scaffold(
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                  child: Lottie.asset('images/12907-no-connection.json',
                      height: 250, width: 250)),
              Text(
                AppLocalizations.of(context)!.interNetWeak,
                style: TextStyle(
                    color: Colors.red.shade700,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16.0),
            ],
          ),
          valNetWeek == true
              ? CircularInductorCostem().circularInductorCostem(context)
              : const Text(''),
        ],
      ),
    ));
  }

  Future<void> checkInternet() async {
    listener =
        InternetConnectionChecker().onStatusChange.listen((status) async {
      switch (status) {
        case InternetConnectionStatus.connected:
          await Future.delayed(Duration(seconds: widget.timeNet));
          if (_id != null) {
            listener.cancel();
            await DataBaseReal().getDriverInfoIfNetWeek(context);
            Provider.of<IsNetWeek>(context, listen: false).updateState(false);
          } else if (_id == null) {
            listener.cancel();
            Provider.of<IsNetWeek>(context, listen: false).updateState(false);
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => const MyPageView()));
          }
          break;
        case InternetConnectionStatus.disconnected:
          break;
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    listener.cancel();
  }
}
