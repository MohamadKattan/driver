import 'dart:async';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'dart:math';
import 'package:driver/repo/geoFire_srv.dart';
import 'package:driver/tools/tools.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../config.dart';
import '../logic_google_map.dart';
import '../my_provider/change_color_bottom.dart';
import '../my_provider/drawer_value_provider.dart';
import '../my_provider/driver_model_provider.dart';
import '../notificatons/local_notifications.dart';
import '../notificatons/push_notifications_srv.dart';
import '../notificatons/system_alert_window.dart';
import '../payment/couut_plan_days.dart';
import '../repo/api_srv_geolocater.dart';
import '../repo/auth_srv.dart';
import '../widget/custom_container_ofLine.dart';
import '../widget/custom_drawer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<void> initializeService() async {
  final service = FlutterBackgroundService();
  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: true,
      isForegroundMode: true,
    ),
    iosConfiguration: IosConfiguration(
      autoStart: true,
      onForeground: onStart,
      onBackground: onIosBackground,
    ),
  );
  service.startService();
}

bool onIosBackground(ServiceInstance service) {
  WidgetsFlutterBinding.ensureInitialized();
  return true;
}

void onStart(ServiceInstance service) async {
  await Firebase.initializeApp();
  final userId = AuthSev().auth.currentUser!.uid;
  DatabaseReference driverRef = FirebaseDatabase.instance.ref().child("driver");

  if (service is AndroidServiceInstance) {

    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }
  service.on('stopService').listen((event) {
    service.stopSelf();
  });
  if (userId.isNotEmpty) {
    Geofire.initialize("availableDrivers");
     Geofire.stopListener();
     Geofire.removeLocation(userId);
    driverRef.child(userId).child("service").onDisconnect();
    await driverRef.child(userId).child("service").remove();
    PlanDays().setIfBackgroundOrForeground(true);
  }

  Timer.periodic(const Duration(minutes: 60), (timer) async {
    if(Platform.isAndroid){
      PlanDays().getDateTime();
    }
    if (service is AndroidServiceInstance) {
      service.setForegroundNotificationInfo(
        title: "Garanti Taxi : ",
        content: "Location working in background",
      );
      // test using external plugin
      final deviceInfo = DeviceInfoPlugin();
      String? device;
      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        device = androidInfo.model;
      }

      if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        device = iosInfo.model;
      }

      service.invoke(
        'update',
        {
          "current_date": DateTime.now().toIso8601String(),
          "device": device,
        },
      );
    }
    // if (exPlan == 0) {
    //   driverRef.child(userId).child("status").once().then((value) {
    //     if (value.snapshot.exists && value.snapshot.value != null) {
    //       final snap = value.snapshot.value;
    //       String _status = snap.toString();
    //       if (_status == "checkIn" || _status == "") {
    //         timer.cancel();
    //         return;
    //       }
    //       driverRef.child(userId).child("status").set("payTime");
    //       timer.cancel();
    //       GeoFireSrv().makeDriverOffLine();
    //     }
    //   });
    // } else if (exPlan > 0) {
    //   exPlan = exPlan - 1;
    //   await driverRef.child(userId).child("exPlan").set(exPlan);
    //   // if (exPlan <= 0) {
    //   //   driverRef.child(userId).child("status").once().then((value) {
    //   //     if (value.snapshot.exists && value.snapshot.value != null) {
    //   //       final snap = value.snapshot.value;
    //   //       String _status = snap.toString();
    //   //       if (_status == "checkIn" || _status == "") {
    //   //         timer.cancel();
    //   //         return;
    //   //       }
    //   //       driverRef.child(userId).child("status").set("payTime");
    //   //       timer.cancel();
    //   //       GeoFireSrv().makeDriverOffLine();
    //   //     }
    //   //   });
    //   // }
    // }
  });
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  late bool valueSwitchBottom = true;
  // String _platformVersion = 'Unknown';
  // sys.SystemWindowPrefMode prefMode = sys.SystemWindowPrefMode.OVERLAY;
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    getToken();
    initializeService();
    requestPermissions();
    initializationLocal(context);
    FlutterBackgroundService().invoke("setAsBackground");
    PushNotificationsSrv().gotNotificationInBackground(context);
    requestPermissionsSystem();
    onForground();
    PlanDays().getDateTime();
    // FirebaseMessaging.onBackgroundMessage(onBackgroundMessage);
    /// for fire base messaging will use in ios app
    // PushNotificationsSrv().getCurrentInfoDriverForNotification(context);
    ///system dailog alert 3 methodes
    // initPlatformState();
    /// count
    //PlanDays().countDayPlansInForeground();
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.inactive||
        state == AppLifecycleState.detached
    ) return;
    final isBackGround = state == AppLifecycleState.paused;
    if (isBackGround) {
      setState(() {
        runLocale = true;
      });
    } else {
      setState(() {
        runLocale = false;
      });
    }
  }

  // system over vlowy
  // Future<void> initPlatformState() async {
  //   await SystemAlertWindow.enableLogs(true);
  //   String? platformVersion;
  //   // Platform messages may fail, so we use a try/catch PlatformException.
  //   try {
  //     platformVersion = await SystemAlertWindow.platformVersion;
  //   } on PlatformException {
  //     platformVersion = 'Failed to get platform version.';
  //   }
  //   if (!mounted) return;
  //
  //   setState(() {
  //     _platformVersion = platformVersion!;
  //   });
  // }

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
                              SizedBox(
                                height: MediaQuery.of(context).size.height,
                                child: GoogleMap(
                                  padding: const EdgeInsets.only(top: 25.0),
                                  mapType: MapType.normal,
                                  initialCameraPosition:
                                      LogicGoogleMap().kGooglePlex,
                                  myLocationButtonEnabled:
                                      Platform.isAndroid ? true : false,
                                  myLocationEnabled: true,
                                  liteModeEnabled:
                                      Platform.isAndroid ? true : false,
                                  onMapCreated:
                                      (GoogleMapController controller) async {
                                    LogicGoogleMap()
                                        .controllerGoogleMap
                                        .complete(controller);
                                    newGoogleMapController = controller;
                                    await LogicGoogleMap()
                                        .locationPosition(context);
                                   await GeoFireSrv().getLocationLiveUpdates(
                                        valueSwitchBottom);
                                    getCountryName();
                                    tostDriverAvailable();
                                  },
                                ),
                              ),
                              //widget
                              valueSwitchBottom == false
                                  ? customContainerOffLineDriver(context)
                                  : const Text(""),
                              //widget
                              Positioned(
                                  right:
                                      AppLocalizations.of(context)!.day == "يوم"
                                          ? 25.0
                                          : null,
                                  left:
                                      AppLocalizations.of(context)!.day == "يوم"
                                          ? null
                                          : 25.0,
                                  bottom: 10.0,
                                  child: customSwitchBottom())
                            ],
                          ),
                        ));
                  },
                ),
              ),
              changeColorBottom == false
                  ? Positioned(
                      left: AppLocalizations.of(context)!.day == "يوم"
                          ? 0.0
                          : null,
                      child: Padding(
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
                      ),
                    )
                  : Positioned(
                      left: AppLocalizations.of(context)!.day == "يوم"
                          ? 0.0
                          : null,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 30.0, left: 15.0),
                        child: CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.white,
                          child: IconButton(
                              onPressed: () async {
                                FlutterBackgroundService()
                                    .invoke("setAsBackground");
                                Provider.of<DrawerValueChange>(context,
                                        listen: false)
                                    .updateValue(0);
                                Provider.of<ChangeColorBottomDrawer>(context,
                                        listen: false)
                                    .updateColorBottom(false);
                              },
                              icon: const Icon(
                                Icons.close,
                                color: Colors.black54,
                                size: 25,
                              )),
                        ),
                      ),
                    ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: const Color(0xFFFFD54F),
            onPressed: () async {
              await LogicGoogleMap().locationPosition(context);
              GeoFireSrv().getLocationLiveUpdates(valueSwitchBottom);
              getCountryName();
            },
            child: const Icon(
              Icons.my_location,
              color: Colors.black45,
              size: 25,
            ),
          ),
        ),
      ),
    );
  }

  Widget customSwitchBottom() => Transform.scale(
        scale: 1.5,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: 50.0,
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
                  tostDriverAvailable();
                  GeoFireSrv().getLocationLiveUpdates(valueSwitchBottom);
                } else if (valueSwitchBottom == false) {
                  GeoFireSrv().makeDriverOffLine();
                  tostDriverAvailable();
                }
              },
            ),
          ),
        ),
      );

// this method for show tost driver if he Available or not
  void tostDriverAvailable() {
    if (valueSwitchBottom == true) {
      Tools().toastMsg(
          AppLocalizations.of(context)!.avilbel, Colors.green.shade700);
    } else {
      Tools().toastMsg(
          AppLocalizations.of(context)!.notAvilbel, Colors.redAccent.shade700);
    }
  }

  void getCountryName() {
    ApiSrvGeolocater().searchCoordinatesAddress(context);
    final _country =
        Provider.of<DriverInfoModelProvider>(context, listen: false)
            .driverInfo
            .country;
    if (_country == "") {
      ApiSrvGeolocater().searchCoordinatesAddress(context);
    } else {
      return;
    }
  }

// this method for stop local Notification
  void onForground() {
    driverRef.child(userId).child("service").set("not");
  }

}
