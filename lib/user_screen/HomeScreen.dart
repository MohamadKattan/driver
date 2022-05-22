
import 'dart:math';
import 'package:driver/repo/geoFire_srv.dart';
import 'package:driver/tools/tools.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../config.dart';
import '../logic_google_map.dart';
import '../my_provider/change_color_bottom.dart';
import '../my_provider/drawer_value_provider.dart';
import '../my_provider/driver_model_provider.dart';
import '../notificatons/local_notifications.dart';
import '../notificatons/push_notifications_srv.dart';
import '../payment/couut_plan_days.dart';
import '../repo/api_srv_geolocater.dart';
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
  // String _platformVersion = 'Unknown';
  // sys.SystemWindowPrefMode prefMode = sys.SystemWindowPrefMode.OVERLAY;
  @override
  void initState(){
    onBackgroundMessage(context);
    FlutterBackgroundService().invoke("setAsBackground");
    ///local
    initializationLocal(context);
    ///local
    requestPermissions();
    tostDriverAvailable();
    PlanDays().countDayPlansInForeground();
    PushNotificationsSrv().gotNotificationInBackground(context);
    // PushNotificationsSrv().getCurrentInfoDriverForNotification(context);
    ///system dailog alert 3 methodes
    // initPlatformState();
    // requestPermissionsSystem();
    // checkOnclick();
    super.initState();
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
                                  myLocationButtonEnabled: true,
                                  myLocationEnabled: true,
                                  liteModeEnabled: true,
                                  onMapCreated:
                                      (GoogleMapController controller) async {
                                    LogicGoogleMap()
                                        .controllerGoogleMap
                                        .complete(controller);
                                    newGoogleMapController = controller;
                                    await LogicGoogleMap()
                                        .locationPosition(context);
                                    GeoFireSrv().getLocationLiveUpdates(
                                        valueSwitchBottom);
                                    driverRef.child(userId).child("isLocal").set("notLocal");
                                    getCountryName();
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
                              PlanDays().getExPlanFromReal();
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
                            onPressed: () async {
                              playNot();
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
                              Icons.arrow_back_ios,
                              color: Colors.black54,
                              size: 25,
                            )),
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
                tostDriverAvailable();
                GeoFireSrv().getLocationLiveUpdates(valueSwitchBottom);
              } else if (valueSwitchBottom == false) {
                GeoFireSrv().makeDriverOffLine();
                tostDriverAvailable();
              }
            },
          ),
        ),
      );

// this method for show tost driver if he Available or not
  void tostDriverAvailable() {
    if (valueSwitchBottom == true) {
      Tools()
          .toastMsg("You are Available for new order ", Colors.green.shade700);
    } else {
      Tools().toastMsg(
          "You aren't Available for new order ", Colors.redAccent.shade700);
    }
  }

  void getCountryName() {
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
}
