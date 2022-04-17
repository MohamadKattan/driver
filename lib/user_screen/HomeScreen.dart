
import 'dart:math';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:driver/repo/geoFire_srv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../config.dart';
import '../logic_google_map.dart';
import '../my_provider/change_color_bottom.dart';
import '../my_provider/drawer_value_provider.dart';
import '../notificatons/local_notifications.dart';
import '../notificatons/push_notifications_srv.dart';
import '../tools/background_serv.dart';
import '../widget/custom_container_ofLine.dart';
import '../widget/custom_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late bool valueSwitchBottom = true;

  @override
  void initState() {
    super.initState();
    /// connect with Push Notifications service
    initializationLocal(context);
    requestPermissions();
    PushNotificationsSrv().getCurrentInfoDriverForNotification(context);

  }

  @override
  Widget build(BuildContext context) {
    final drawerValue = Provider.of<DrawerValueChange>(context).value;
    final changeColorBottom =
        Provider.of<ChangeColorBottomDrawer>(context).isTrue;
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: SafeArea(
        child: Scaffold(
          body: Stack(
            children: [
              //widget
              valueSwitchBottom == false
                  ? timerOffLineDriver()
                  : const Text(""),
              customDrawer(context),
              GestureDetector(
                onTap: () async {
                  Provider.of<DrawerValueChange>(context, listen: false)
                      .updateValue(0);
                  Provider.of<ChangeColorBottomDrawer>(context, listen: false)
                      .updateColorBottom(false);
                },
                child: TweenAnimationBuilder(
                  tween: Tween<double>(begin: 0.0, end: drawerValue),
                  duration: const Duration(milliseconds: 150),
                  builder: (_, double val, __) {
                    return Transform(
                        transform: Matrix4.identity()
                          ..setEntry(3, 2, 0.001)
                          ..setEntry(0, 3, 300 * val)
                          ..rotateY((pi / 3) * val),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          color: Colors.white,
                          child: Stack(
                            children: [
                              SizedBox(height: MediaQuery.of(context).size.height,
                                child: GoogleMap(
                                  padding: const EdgeInsets.only(top: 25.0),
                                  mapType: MapType.normal,
                                  initialCameraPosition:LogicGoogleMap().kGooglePlex,
                                  myLocationButtonEnabled: true,
                                  myLocationEnabled: true,
                                  liteModeEnabled: true,
                                  onMapCreated:
                                      (GoogleMapController controller) async {
                                    LogicGoogleMap()
                                        .controllerGoogleMap
                                        .complete(controller);
                                    newGoogleMapController = controller;
                                    LogicGoogleMap().locationPosition(context).whenComplete((){
                                      GeoFireSrv().getLocationLiveUpdates(context, valueSwitchBottom);
                                    });
                                  },
                                ),
                              ),
                              //widget
                              valueSwitchBottom == false
                                  ? customContainerOffLineDriver(context)
                                  : const Text(""),
                              //widget
                              Positioned(
                                  left: 25.0,
                                  bottom: 10.0,
                                  child: customSwitchBottom())
                            ],
                          ),
                        ));
                  },
                ),
              ),
              changeColorBottom == false
                  ? Padding(
                      padding: const EdgeInsets.only(top: 30.0, left: 15.0),
                      child: CircleAvatar(
                        radius: 30,
                        backgroundColor: const Color(0xFFFFD54F),
                        child: IconButton(
                            onPressed: () {
                              Provider.of<DrawerValueChange>(context,
                                      listen: false)
                                  .updateValue(1);
                              Provider.of<ChangeColorBottomDrawer>(context,
                                      listen: false)
                                  .updateColorBottom(true);
                            },
                            icon: const Icon(
                              Icons.format_list_numbered_rtl_rounded,
                              color: Colors.black54,
                              size: 25,
                            )),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(top: 30.0, left: 15.0),
                      child: CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.white,
                        child: IconButton(
                            onPressed: ()async {
                              Provider.of<DrawerValueChange>(context,
                                      listen: false)
                                  .updateValue(0);
                              Provider.of<ChangeColorBottomDrawer>(context,
                                      listen: false)
                                  .updateColorBottom(false);
                              closeDailog();
                            },
                            icon: const Icon(
                              Icons.arrow_back_ios,
                              color: Colors.black54,
                              size: 25,
                            )),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget customSwitchBottom() => Transform.scale(
        scale: 2.5,
        child: SizedBox(
          width: 60.0,
          child: Switch.adaptive(
            activeColor: Colors.green,
            activeTrackColor: Colors.green.shade200,
            inactiveThumbColor: Colors.redAccent.shade700,
            inactiveTrackColor: Colors.redAccent.shade200,
            value: valueSwitchBottom,
            splashRadius: 40.0,
            onChanged: (val) {
              setState(() {
                valueSwitchBottom = val;
              });
              if (valueSwitchBottom == true) {
                // GeoFireSrv().makeDriverOnlineNow(context);
                GeoFireSrv().getLocationLiveUpdates(context, valueSwitchBottom);
                print(valueSwitchBottom);
              } else if (valueSwitchBottom == false) {
                GeoFireSrv().makeDriverOffLine(context);
                print(valueSwitchBottom);
              }
            },
          ),
        ),
      );

  Widget timerOffLineDriver() {
    final CountDownController downController = CountDownController();
    return CircularCountDownTimer(
        duration: 300,
        initialDuration: 0,
        controller: downController,
        width: MediaQuery.of(context).size.width / 9,
        height: MediaQuery.of(context).size.height / 9,
        ringColor: Colors.white,
        fillColor: Colors.black12,
        backgroundColor: const Color(0xFFFFD54F),
        strokeWidth: 8.0,
        strokeCap: StrokeCap.round,
        textStyle: const TextStyle(
            fontSize: 20.0, color: Colors.white, fontWeight: FontWeight.bold),
        textFormat: CountdownTextFormat.S,
        isReverse: true,
        isReverseAnimation: true,
        isTimerTextShown: true,
        autoStart: true,
        onStart: () {
          print('Countdown Started');
        },
        onComplete: () async {
          if (valueSwitchBottom == false) {
            await GeoFireSrv().makeDriverOffLine(context);
            SystemNavigator.pop();
          }
        });
  }
}
