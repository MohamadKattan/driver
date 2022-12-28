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
import '../widget/custom_container_ofLine.dart';
import '../widget/custom_drawer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../widget/location_stoped.dart';
import 'active_account.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  bool valueSwitchBottom = true;
  // this method for init some methods
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    initializationLocalNotifications(context);
    requestPermissionsOverlaySystem();
    _loadMapStyles();
    PlanDays().getDateTime();
    lastSeen();
    GeoFireSrv().serviceStatusStream(context);
    PushNotificationsSrv().gotNotificationInBackground(context);
    super.initState();
  }

// this method for check if app in backGround or else for do some functions
  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.detached:
        Geofire.removeLocation(userId);
        break;
      case AppLifecycleState.paused:
        runLocale = true;
        if (Platform.isIOS) {
          await Future.delayed(const Duration(minutes: 30));
          if (runLocale) {
            if (showGpsDailog) {
              showNotificationNoLocation(context);
              showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) => locationStoped(context));
            }
          }
        }
        break;
      case AppLifecycleState.resumed:
        runLocale = false;
        break;
      case AppLifecycleState.inactive:
        break;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    GeoFireSrv().cancelStreamLocation();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: SafeArea(
        child: Scaffold(
          body: Stack(
            children: [
              customDrawer(context),
              Consumer<DrawerValueChange>(
                builder: (context, drawerValue, child) => TweenAnimationBuilder(
                  tween: Tween<double>(begin: 0.0, end: drawerValue.value),
                  duration: const Duration(milliseconds: 150),
                  builder: (_, double val, __) {
                    return Transform(
                        transform: Matrix4.identity()
                          ..setEntry(3, 2, 0.001)
                          ..setEntry(0, 3, 300 * val)
                          ..rotateY((pi / 2) * val),
                        child: Stack(
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width,
                              color: Colors.white,
                              child: GoogleMap(
                                padding: const EdgeInsets.only(top: 25.0),
                                mapType: MapType.normal,
                                initialCameraPosition:
                                    LogicGoogleMap().kGooglePlex,
                                myLocationButtonEnabled: false,
                                myLocationEnabled: true,
                                onMapCreated:
                                    (GoogleMapController controller) async {
                                  LogicGoogleMap()
                                      .controllerGoogleMap
                                      .complete(controller);
                                  newGoogleMapController = controller;
                                  LogicGoogleMap()
                                      .darkOrWhite(newGoogleMapController!);
                                  await LogicGoogleMap()
                                      .locationPosition(context)
                                      .whenComplete(() async {
                                    await GeoFireSrv()
                                        .getLocationLiveUpdates(context);
                                    getCountryName();
                                    await DataBaseReal()
                                        .getDriverInfoFromDataBase(context);
                                    await checkToken();
                                    tostDriverAvailable();
                                  });
                                },
                              ),
                            ),
                            //widget
                            valueSwitchBottom == false
                                ? customContainerOffLineDriver(context)
                                : const SizedBox(),
                            //widget
                            Positioned(
                                right:
                                    AppLocalizations.of(context)!.day == "يوم"
                                        ? 25.0
                                        : null,
                                left: AppLocalizations.of(context)!.day == "يوم"
                                    ? null
                                    : 25.0,
                                bottom: 10.0,
                                child: customSwitchBottom())
                          ],
                        ));
                  },
                ),
              ),
              Consumer<ChangeColorBottomDrawer>(
                builder: (context, _val, child) => Positioned(
                  left: AppLocalizations.of(context)!.day == "يوم" ? 0.0 : null,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 50.0, left: 15.0),
                    child: CircleAvatar(
                      radius: 30,
                      backgroundColor: const Color(0xFF00A3E0),
                      child: IconButton(
                          onPressed: () {
                            if (_val.isTrue == false) {
                              DataBaseReal().updateExPlan(context);
                              Provider.of<DrawerValueChange>(context,
                                      listen: false)
                                  .updateValue(1);
                              Provider.of<ChangeColorBottomDrawer>(context,
                                      listen: false)
                                  .updateColorBottom(true);
                            } else {
                              Provider.of<DrawerValueChange>(context,
                                      listen: false)
                                  .updateValue(0);
                              Provider.of<ChangeColorBottomDrawer>(context,
                                      listen: false)
                                  .updateColorBottom(false);
                            }
                          },
                          icon: _val.isTrue == false
                              ? const Icon(
                                  Icons.format_list_numbered_rtl_rounded,
                                  color: Colors.white,
                                  size: 25,
                                )
                              : const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 25,
                                )),
                    ),
                  ),
                ),
              )
            ],
          ),
          floatingActionButton: Padding(
            padding: EdgeInsets.only(
                left: 8.0, right: Platform.isAndroid ? 40.0 : 8.0),
            child: FloatingActionButton(
              backgroundColor: const Color(0xFF00A3E0),
              onPressed: () async {
                await LogicGoogleMap().locationPosition(context);
                await GeoFireSrv().getLocationLiveUpdates(context);
                // ParamPayment().sorgulama();
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

  //this widget ofLine or  onLine driver as switch button
  Widget customSwitchBottom() => Transform.scale(
        scale: 1.5,
        child: Padding(
          padding: const EdgeInsets.only(
              right: 25.0, left: 8.0, top: 8.0, bottom: 8.0),
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
                  tostDriverAvailable();
                  await LogicGoogleMap().locationPosition(context);
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

// this method for set last seen to user connect with dash bord
  void lastSeen() {
    driverRef.child(userId).child('lastseen').set(DateTime.now().toString());
  }

// this method for set country name from google api
  Future<void> getCountryName() async {
    await ApiSrvGeolocater().searchCoordinatesAddress(context);
  }

// this method for check token after map loading
  Future<void> checkToken() async {
    final driverInfo =
        Provider.of<DriverInfoModelProvider>(context, listen: false).driverInfo;
    final _user = AuthSev().auth.currentUser;
    if (_user?.email == "test036@gmail.com") {
      await getToken();
    } else {
      requestPermissionsLocalNotifications();
      if (_user?.uid != null &&
          driverInfo.tok.substring(0, 5) != tokenPhone?.substring(0, 5)) {
        Tools().toastMsg(
            AppLocalizations.of(context)!.tokenUesd, Colors.redAccent);
        subscriptionNot1.cancel();
        serviceStatusStreamSubscription?.cancel();
        // listingForChangeStatusPay.cancel();
        await GeoFireSrv().makeDriverOffLine();
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => const ActiveAccount()));
      } else {
        getToken();
      }
    }
  }

// this method for set map assets json in root bundle
  Future _loadMapStyles() async {
    darkMapStyle =
        await rootBundle.loadString('images/map_style/dark-mode.json');
    lightMapStyle =
        await rootBundle.loadString('images/map_style/lite-mode.json');
  }
}
