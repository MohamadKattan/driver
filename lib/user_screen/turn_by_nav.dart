import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mapbox_navigation/library.dart';
import 'package:provider/provider.dart';
import '../my_provider/driver_currentPosition_provider.dart';
import '../my_provider/ride_request_info.dart';

class TurnByNav extends StatefulWidget {
  const TurnByNav({Key? key}) : super(key: key);

  @override
  State<TurnByNav> createState() => _TurnByNavState();
}

class _TurnByNavState extends State<TurnByNav> {
  late WayPoint sourceWayPoint, distintionWayPoint, sourceWayPointDriver;
  // var wayPoint = <WayPoint>[];
  final _origin = WayPoint(
      name: "Way Point 1",
      latitude: 38.9111117447887,
      longitude: -77.04012393951416);

  final _stop1 = WayPoint(
      name: "Way Point 2",
      latitude: 38.91113678979344,
      longitude: -77.03847169876099);

  late MapBoxNavigation directions;
  late MapBoxOptions _options;

   double? _distanceRemaining;
   double? _durationRemaining;

  late MapBoxNavigationViewController _controller;

  bool arrivedMapBox = false;
  String instruction = "";
  bool routeBuilt = false;
  bool isNavigating = false;
  bool isMultipleStop = false;
  // String platformVersion1 = 'Unknown';

  @override
  void initState() {
    inTailiz();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final rideInfo =
        Provider.of<RideRequestInfoProvider>(context, listen: false)
            .rideDetails;
    final driver = Provider.of<DriverCurrentPosition>(context, listen: false)
        .currentPosition;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade700,
        title: const Text("Helper Map"),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue.shade700,
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Icon(Icons.close),
      ),
      body: Center(
        child: Column(children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    color: Colors.grey,
                    width: double.infinity,
                    child: const Padding(
                      padding: EdgeInsets.all(10),
                      child: (Text(
                        "Full Screen Navigation",
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      )),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.location_history,
                        color: Colors.greenAccent.shade700,
                        size: 35,
                      ),
                      const SizedBox(
                        width: 4.0,
                      ),
                      ElevatedButton(
                        child: const Text("To rider"),
                        onPressed: () async {
                          sourceWayPointDriver = WayPoint(
                              name: "Driver",
                              latitude: driver.latitude,
                              longitude: driver.longitude);
                          sourceWayPoint = WayPoint(
                              name: "Source",
                              latitude: rideInfo.pickup.latitude,
                              longitude: rideInfo.pickup.longitude);
                          var wayPoints = <WayPoint>[];
                          wayPoints.add(sourceWayPointDriver);
                          wayPoints.add(sourceWayPoint);

                          await directions.startNavigation(
                              wayPoints: wayPoints,
                              options: MapBoxOptions(
                                  mode: MapBoxNavigationMode.drivingWithTraffic,
                                  simulateRoute: false,
                                  language: "en",
                                  zoom: 16.0,
                                  units: VoiceUnits.metric));
                        },
                      ),
                      const SizedBox(
                        width: 10,
                      ),

                      ///here
                      Icon(
                        Icons.track_changes_sharp,
                        color: Colors.yellowAccent.shade700,
                        size: 30,
                      ),
                      const SizedBox(
                        width: 4.0,
                      ),
                      ElevatedButton(
                        child: const Text("Start Trip"),
                        onPressed: () async {
                          sourceWayPoint = WayPoint(
                              name: "Distintion",
                              latitude: rideInfo.pickup.latitude,
                              longitude: rideInfo.pickup.longitude);
                          distintionWayPoint = WayPoint(
                              name: "Distintion",
                              latitude: rideInfo.dropoff.latitude,
                              longitude: rideInfo.dropoff.longitude);
                          var wayPoints = <WayPoint>[];
                          wayPoints.add(sourceWayPoint);
                          wayPoints.add(distintionWayPoint);

                          await directions.startNavigation(
                              wayPoints: wayPoints,
                              options: MapBoxOptions(
                                  mode: MapBoxNavigationMode.drivingWithTraffic,
                                  simulateRoute: false,
                                  language: "en",
                                  zoom: 16.0,
                                  units: VoiceUnits.metric));
                        },
                      ),
                    ],
                  ),
                  Container(
                    color: Colors.grey,
                    width: double.infinity,
                    child: const Padding(
                      padding: EdgeInsets.all(10),
                      child: (Text(
                        "Embedded Navigation",
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      )),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        child: Text(routeBuilt && !isNavigating
                            ? "Clear Route"
                            : "Build Route"),
                        onPressed: isNavigating
                            ? null
                            : () {
                                if (routeBuilt) {
                                  _controller.clearRoute();
                                } else {
                                  var wayPoints = <WayPoint>[];
                                  wayPoints.add(_origin);
                                  wayPoints.add(_stop1);
                                  isMultipleStop = wayPoints.length > 2;
                                  _controller.buildRoute(wayPoints: wayPoints);
                                }
                              },
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      ElevatedButton(
                        child: const Text("Start "),
                        onPressed: routeBuilt && !isNavigating
                            ? () {
                                _controller.startNavigation();
                              }
                            : null,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      ElevatedButton(
                        child: const Text("Cancel "),

                        ///todo
                        onPressed: isNavigating
                            ? () {
                                Navigator.pop(context);
                                print("--------------------------");
                                _controller.finishNavigation();

                                ///todo
                              }
                            : null,
                      )
                    ],
                  ),
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        "Long-Press Embedded Map to Set Destination",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Container(
                    color: Colors.grey,
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: (Text(
                        instruction == "" || instruction.isEmpty
                            ? "Banner Instruction Here"
                            : instruction,
                        style: const TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 20.0, right: 20, top: 20, bottom: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ///todo
                        Row(
                          children: <Widget>[
                            const Text("Duration Remaining: "),
                            Text(_durationRemaining != null
                                ? "${(_durationRemaining! / 60).toStringAsFixed(0)} minutes"
                                : "---")
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            const Text("Distance Remaining: "),
                            Text(_distanceRemaining != null
                                ? "${(_distanceRemaining! * 0.000621371).toStringAsFixed(1)} miles"
                                : "---")
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                ],
              ),
            ),
          ),

          ///todo
          // Expanded(
          //   flex: 1,
          //   child: Container(
          //     color: Colors.grey,
          //     child: MapBoxNavigationView(
          //         options: _options,
          //         onRouteEvent: _onRouteEvent,
          //         onCreated: (MapBoxNavigationViewController controller) async {
          //           _controller = controller;
          //           controller.initialize();
          //         }),
          //   ),
          // )
        ]),
      ),
    );
  }

  Future<void> _onRouteEvent(e) async {
    _distanceRemaining = await directions.distanceRemaining;
    _durationRemaining = await directions.durationRemaining;
    // distanceRemaining = await directions.distanceRemaining;
    // durationRemaining = await directions.durationRemaining;

    switch (e.eventType) {
      case MapBoxEvent.progress_change:
        var progressEvent = e.data as RouteProgressEvent;
        arrivedMapBox = progressEvent.arrived!;
        if (progressEvent.currentStepInstruction != null) {
          instruction = progressEvent.currentStepInstruction!;
        }
        break;
      case MapBoxEvent.route_building:
      case MapBoxEvent.route_built:
        routeBuilt = true;
        break;
      case MapBoxEvent.route_build_failed:
        routeBuilt = false;
        break;
      case MapBoxEvent.navigation_running:
        isNavigating = true;
        break;
      case MapBoxEvent.on_arrival:
        arrivedMapBox = true;
        if (!isMultipleStop) {
          await Future.delayed(const Duration(seconds: 3));
          await _controller.finishNavigation();
        } else {}
        break;
      case MapBoxEvent.navigation_finished:
      case MapBoxEvent.navigation_cancelled:
        routeBuilt = false;
        isNavigating = false;
        break;
      default:
        break;
    }
    //refresh UI
    setState(() {});
  }

  Future<void> inTailiz() async {
    // // final driver=Provider.of<DriverCurrentPosition>(context,listen: false).currentPosition;
    // final rideInfo = Provider.of<RideRequestInfoProvider>(context, listen: false).rideDetails;
    if (!mounted) return;
    directions = MapBoxNavigation(onRouteEvent: _onRouteEvent);
    _options = MapBoxOptions(
        zoom: 13.0,
        tilt: 0.0,
        bearing: 0.0,
        enableRefresh: false,
        alternatives: true,
        voiceInstructionsEnabled: true,
        bannerInstructionsEnabled: true,
        allowsUTurnAtWayPoints: true,
        mode: MapBoxNavigationMode.drivingWithTraffic,
        units: VoiceUnits.imperial,
        simulateRoute: true,
        language: "en");

    // try {
    //   platformVersion = await directions.platformVersion;
    // } on PlatformException {
    //   platformVersion = 'Failed to get platform version.';
    // }

    // sourceWayPoint = WayPoint(name: "Source", latitude: rideInfo.pickup.latitude, longitude: rideInfo.pickup.longitude);
    // distintionWayPoint = WayPoint(name: "Distintion", latitude: rideInfo.dropoff.latitude, longitude: rideInfo.dropoff.longitude);
    // wayPoint.add(sourceWayPoint);
    // wayPoint.add(distintionWayPoint);
    // await directions.startNavigation(wayPoints: wayPoint, options: _options);
  }
}
