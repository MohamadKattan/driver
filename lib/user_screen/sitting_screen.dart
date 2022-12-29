import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wakelock/wakelock.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: const Color(0xFFFBC408),
              title: Text(AppLocalizations.of(context)!.appSetting,
                  style: const TextStyle(color: Colors.white, fontSize: 16.0)),
            ),
            body: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                color: const Color(0xFF00A3E0),
                child: SingleChildScrollView(
                    child: Column(children: [
                  Lottie.asset(
                    'images/setting app.json',
                    fit: BoxFit.fill,
                    height: MediaQuery.of(context).size.height * 40 / 100,
                    width: MediaQuery.of(context).size.width * 40 / 100,
                  ),
                  Text(
                    AppLocalizations.of(context)!.appSettingDs,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  GestureDetector(
                    onTap: () async {
                      Map<Permission, PermissionStatus> statuses = await [
                        Permission.locationWhenInUse,
                        Permission.locationAlways,
                      ].request();
                      await Wakelock.enable();
                      openAppSettings();
                    },
                    child: Container(
                      height: 60,
                      width: 160,
                      padding: const EdgeInsets.all(8.0),
                      margin: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                          color: const Color(0xFFFBC408),
                          borderRadius: BorderRadius.circular(12.0)),
                      child: Center(
                        child: Text(
                          AppLocalizations.of(context)!.checkSetting,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  )
                ])))));
  }
}
