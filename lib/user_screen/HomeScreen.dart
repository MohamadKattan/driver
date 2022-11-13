import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:driver/repo/geoFire_srv.dart';
import 'package:driver/tools/tools.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import '../repo/dataBaseReal_sev.dart';
import '../tools/turn_GBS.dart';
import '../widget/custom_container_ofLine.dart';
import '../widget/custom_drawer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'active_account.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  bool valueSwitchBottom = true;
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    _loadMapStyles();
    TurnOnGBS().turnOnGBSifNot();
    initializationLocal(context);
    PushNotificationsSrv().gotNotificationInBackground(context);
    requestPermissionsSystem();
    PlanDays().getDateTime();
    refreshApp();
    DataBaseReal().listingForChangeInStatusPay(context);
    // FirebaseMessaging.onBackgroundMessage(onBackgroundMessage);
    // PushNotificationsSrv().getCurrentInfoDriverForNotification(context);
    // initPlatformState();
    super.initState();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    // final isBackGround = state == AppLifecycleState.paused;
    // final isdead = state == AppLifecycleState.detached;
    super.didChangeAppLifecycleState(state);
    // if ( state ==AppLifecycleState.inactive||state ==AppLifecycleState.detached) return;

    switch (state) {
      case AppLifecycleState.paused:
        runLocale = true;
        break;
      case AppLifecycleState.resumed:
        runLocale = false;
        break;
      case AppLifecycleState.inactive:
        // TODO: Handle this case.
        break;
      case AppLifecycleState.detached:
        Geofire.removeLocation(userId);
        Geofire.stopListener();
        break;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
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
                                  myLocationButtonEnabled:false,
                                  myLocationEnabled: true,
                                  onMapCreated:
                                      (GoogleMapController controller) async {
                                    LogicGoogleMap()
                                        .controllerGoogleMap
                                        .complete(controller);
                                    newGoogleMapController = controller;
                                    await LogicGoogleMap()
                                        .locationPosition(context);
                                    await GeoFireSrv()
                                        .getLocationLiveUpdates(context);
                                    await checkToken();
                                    getCountryName();
                                    lastSeen();
                                    tostDriverAvailable();
                                    await DataBaseReal()
                                        .getDriverInfoFromDataBase(context);
                                    LogicGoogleMap().darkOrwhite(newGoogleMapController!);
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
                        padding: const EdgeInsets.only(top: 50.0, left: 15.0),
                        child: CircleAvatar(
                          radius: 30,
                          backgroundColor: const Color(0xFF00A3E0),
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
                                color: Colors.white,
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
                          backgroundColor: const Color(0xFFFBC408),
                          child: IconButton(
                              onPressed: () async {
                                Provider.of<DrawerValueChange>(context,
                                        listen: false)
                                    .updateValue(0);
                                Provider.of<ChangeColorBottomDrawer>(context,
                                        listen: false)
                                    .updateColorBottom(false);
                              },
                              icon: const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 25,
                              )),
                        ),
                      ),
                    ),
            ],
          ),
          floatingActionButton: Padding(
            padding:  EdgeInsets.only(left: 8.0,right:Platform.isAndroid? 40.0:8.0),
            child: FloatingActionButton(
              backgroundColor: const Color(0xFF00A3E0),
              onPressed: () async {
                await TurnOnGBS().turnOnGBSifNot();
                await LogicGoogleMap().locationPosition(context);
                await GeoFireSrv().getLocationLiveUpdates(context);
                getCountryName();
              },
              child: const Icon(
                Icons.my_location,
                color: Colors.white,
                size: 25,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // of line on line
  Widget customSwitchBottom() => Transform.scale(
        scale: 1.5,
        child: Padding(
          padding: const EdgeInsets.only(right: 25.0,left: 8.0,top: 8.0,bottom: 8.0),
          child: SizedBox(
            width: 50.0,
            child: Switch.adaptive(
              activeColor: const Color(0xFF00A3E0),
              activeTrackColor: Colors.green.shade200,
              inactiveThumbColor: Colors.redAccent.shade700,
              inactiveTrackColor: Colors.redAccent.shade200,
              value: valueSwitchBottom,
              splashRadius: 40.0,
              onChanged: (val) async {
                setState(() {
                  valueSwitchBottom = val;
                });
                if (valueSwitchBottom == true) {
                  // GeoFireSrv().makeDriverOnlineNow(context);
                  tostDriverAvailable();
                  await GeoFireSrv().getLocationLiveUpdates(context);
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

  // todo new if country name came null this method it will work
  Future<void> getCountryName() async {
    await ApiSrvGeolocater().searchCoordinatesAddress(context);
    //  var _country =
    //      Provider.of<DriverInfoModelProvider>(context, listen: false)
    //          .driverInfo
    //          .country;
    // final _result = Provider.of<PlaceName>(context, listen: false).placeName;
    //  setState(() {
    //    _country=_result;
    //  });
  }

// this method for stop local Notification
  void onForground() {
    driverRef.child(userId).child("service").set("not");
  }

// this method for check token after map loading
  Future<void> checkToken() async {
    final driverInfo =
        Provider.of<DriverInfoModelProvider>(context, listen: false).driverInfo;
    final _user = AuthSev().auth.currentUser;
    if (_user?.email == "test036@gmail.com") {
      await getToken();
    } else {
      requestPermissions();
      if (_user?.uid != null &&
          driverInfo.tok.substring(0, 5) != tokenPhone?.substring(0, 5)) {
        Tools().toastMsg(
            AppLocalizations.of(context)!.tokenUesd, Colors.redAccent);
        await GeoFireSrv().makeDriverOffLine();
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => const ActiveAccount()));
      } else {
        getToken();
      }
    }
  }

  //todo this method new under check for refresh app
  void refreshApp() {
    Timer.periodic(const Duration(seconds: 10), (timer) {
      if (!mounted) return;
      setState(() {});
    });
  }

  //todo new method last seen
  void lastSeen() async {
    driverRef.child(userId).child('lastseen').set(DateTime.now().toString());
  }

  Future _loadMapStyles() async {
    darkMapStyle =
        await rootBundle.loadString('images/map_style/dark-mode.json');
    lightMapStyle =
        await rootBundle.loadString('images/map_style/lite-mode.json');
  }

}
