import 'dart:math';
import 'package:driver/repo/geoFire_srv.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../config.dart';
import '../logic_google_map.dart';
import '../my_provider/change_color_bottom.dart';
import '../my_provider/drawer_value_provider.dart';
import '../widget/custom_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool valueSwitchBottom = false;
  @override
  Widget build(BuildContext context) {
    final drawerValue = Provider.of<DrawerValueChange>(context).value;
    final changeColorBottom =
        Provider.of<ChangeColorBottomDrawer>(context).isTrue;
    return Scaffold(
        body: Stack(
      children: [
        customDrawer(context),
        GestureDetector(
          onTap: () {
            Provider.of<DrawerValueChange>(context, listen: false)
                .updateValue(0);
            Provider.of<ChangeColorBottomDrawer>(context, listen: false)
                .updateColorBottom(false);
          },
          child: TweenAnimationBuilder(
            tween: Tween<double>(begin: 0.0, end: drawerValue),
            duration: const Duration(milliseconds: 300),
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
                        GoogleMap(
                          padding: const EdgeInsets.only(top: 25.0),
                          mapType: MapType.normal,
                          initialCameraPosition: LogicGoogleMap().kGooglePlex,
                          myLocationButtonEnabled: true,
                          myLocationEnabled: true,
                          zoomGesturesEnabled: true,
                          zoomControlsEnabled: true,
                          liteModeEnabled: false,
                          trafficEnabled: false,
                          compassEnabled: true,
                          buildingsEnabled: true,
                          onMapCreated: (GoogleMapController controller) {
                            LogicGoogleMap()
                                .controllerGoogleMap
                                .complete(controller);
                            newGoogleMapController = controller;
                            LogicGoogleMap().locationPosition(context);
                          },
                        ),
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
                        Provider.of<DrawerValueChange>(context, listen: false)
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
                      onPressed: () {
                        Provider.of<DrawerValueChange>(context, listen: false)
                            .updateValue(0);
                        Provider.of<ChangeColorBottomDrawer>(context,
                                listen: false)
                            .updateColorBottom(false);
                      },
                      icon: const Icon(
                        Icons.format_list_numbered_rtl_rounded,
                        color: Colors.black54,
                        size: 25,
                      )),
                ),
              ),
      ],
    ));
  }

  Widget customSwitchBottom() => Transform.scale(
        scale: 3,
        child: SizedBox(
          width: 75.0,
          child: Switch.adaptive(
            activeColor: Colors.green,
            activeTrackColor: Colors.green.shade200,
            inactiveThumbColor: Colors.redAccent.shade700,
            inactiveTrackColor: Colors.redAccent.shade200,
            value: valueSwitchBottom,
            onChanged: (val) {
              setState(() {
                valueSwitchBottom = val;
                if (valueSwitchBottom == true) {
                  GeoFireSrv().makeDriverOnlineNow(context);
                  GeoFireSrv().getLocationLiveUpdates(context);
                  print("fuck");
                } else if (valueSwitchBottom == false) {
                  print("2");
                }
              });
            },
          ),
        ),
      );
}
