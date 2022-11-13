import 'dart:async';
import 'dart:io';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:driver/model/rideDetails.dart';
import 'package:driver/notificatons/push_notifications_srv.dart';
import 'package:driver/repo/auth_srv.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mapbox_navigation/library.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../config.dart';
import '../logic_google_map.dart';
import '../my_provider/color_arrived_button_provider.dart';
import '../my_provider/direction_details_provider.dart';
import '../my_provider/driver_currentPosition_provider.dart';
import '../my_provider/driver_model_provider.dart';
import '../my_provider/new_ride_indector.dart';
import '../my_provider/ride_request_info.dart';
import '../my_provider/tilte_arrived_button_provider.dart';
import '../repo/api_srv_dir.dart';
import '../tools/curanny_type.dart';
import '../tools/maps_tooL_kit.dart';
import '../tools/tools.dart';
import '../widget/call_rider_phone_whatApp.dart';
import '../widget/collect_money_dialog.dart';
import '../widget/custom_circuler.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NewRideScreen extends StatefulWidget {
  const NewRideScreen({Key? key}) : super(key: key);

  final CameraPosition kGooglePlex = const CameraPosition(
    target: LatLng(41.084253576036936, 28.89201922194848),
    zoom: 14,
    tilt: 0.0,
    bearing: 0.0,
  );

  @override
  State<NewRideScreen> createState() => _NewRideScreenState();
}

class _NewRideScreenState extends State<NewRideScreen> {
  Completer<GoogleMapController> controllerGoogleMap = Completer();
  late GoogleMapController newRideControllerGoogleMap;
  Set<Polyline> polylineSet = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  Set<Marker> markersSet = {};
  Set<Circle> circlesSet = {};
  final geolocator = Geolocator();
  late BitmapDescriptor anmiatedMarkerIcon;
  late BitmapDescriptor pickUpIcon;
  late BitmapDescriptor dropOffIcon;
  late Position? myPosition;
  String status = "accepted";
  bool isRequestDirection = false;
  late Timer timer;
  late Timer timerStop1;
  late Timer timerStop2;
  late Timer timerStop3;
  late Timer timerStop4;
  late Timer timerStop5;
  int durationContour = 0;
  bool isInductor = false;
  bool colorNavButton = false;

  /// mapBox
  late MapBoxNavigation directions;
  late final MapBoxNavigationViewController _controller;
  String _platformVersion = 'Unknown';
  bool arrivedMapBox = false;
  String instruction = "";
  bool routeBuilt = false;
  bool isNavigating = false;
  bool isMultipleStop = false;

  @override
  void initState() {
    acceptedRideRequest();
    inTailiz();
    isInductor = true;
    changeColorNavButton();
    changeColorNavButton1();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    createPickUpRideIcon();
    createDropOffIcon();
    createDriverNearIcon();
    final rideInfoProvider =
        Provider.of<RideRequestInfoProvider>(context).rideDetails;
    final initialPos =
        Provider.of<DriverCurrentPosition>(context).currentPosition;
    final directionDetails =
        Provider.of<DirectionDetailsPro>(context).directionDetails;
    final buttonTitle = Provider.of<TitleArrived>(context).titleButton;
    final buttonColor = Provider.of<ColorButtonArrived>(context).colorButton;
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: SafeArea(
          child: Scaffold(
              body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 65 / 100,
                  width: MediaQuery.of(context).size.width,
                  child: GoogleMap(
                    mapType: MapType.normal,
                    initialCameraPosition: const NewRideScreen().kGooglePlex,
                    myLocationButtonEnabled: true,
                    myLocationEnabled: true,
                    markers: markersSet,
                    polylines: polylineSet,
                    circles: circlesSet,
                    onMapCreated: (GoogleMapController controller) async {
                      controllerGoogleMap.complete(controller);
                      newRideControllerGoogleMap = controller;
                      Position _newPosition =
                          await Geolocator.getCurrentPosition(
                              desiredAccuracy: LocationAccuracy.best);
                      Provider.of<DriverCurrentPosition>(context, listen: false)
                          .updateSate(_newPosition);
                      LatLng startPontLoc = LatLng(
                          initialPos.latitude, initialPos.longitude); //driver
                      LatLng secondPontLoc = LatLng(
                          rideInfoProvider.pickup.latitude,
                          rideInfoProvider.pickup.longitude);
                      riderName = rideInfoProvider.riderName;
                      await getPlaceDirection(
                          context, startPontLoc, secondPontLoc);
                      getRideLiveLocationUpdate();
                      Provider.of<TitleArrived>(context, listen: false)
                          .updateState(AppLocalizations.of(context)!.arrived);
                      timer1(context);
                      LogicGoogleMap().darkOrwhite(newRideControllerGoogleMap);
                    },
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 35 / 100,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade700,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(8.0),
                          topRight: Radius.circular(8.0))),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 8.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.km +
                                  directionDetails.distanceText,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 18.0),
                            ),
                            Text(
                              AppLocalizations.of(context)!.time +
                                  directionDetails.durationText,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 18.0),
                            ),
                            Text(
                              AppLocalizations.of(context)!.fare +
                                  currencyTypeCheck(context) +
                                  ":" +
                                  rideInfoProvider.amount,
                              style: TextStyle(
                                  color: Colors.greenAccent.shade700,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 12.0),
                              child: Text(
                                AppLocalizations.of(context)!.riderName +
                                    " " +
                                    rideInfoProvider.riderName,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 20.0),
                              ),
                            ),
                            IconButton(
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (_) {
                                        return callRider(
                                            context, rideInfoProvider);
                                      });
                                },
                                icon: Icon(
                                  Icons.phone,
                                  color: Colors.greenAccent.shade700,
                                  size: 20.0,
                                )),
                          ],
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                  padding: const EdgeInsets.only(
                                    left: 8.0,
                                    right: 8,
                                  ),
                                  child: Icon(
                                    Icons.add_location_alt_outlined,
                                    color: Colors.redAccent.shade700,
                                    size: 20.0,
                                  )),
                              Text(AppLocalizations.of(context)!.from,
                                  style: TextStyle(
                                      color: Colors.greenAccent.shade700,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold)),
                              Expanded(
                                  flex: 1,
                                  child: Text(rideInfoProvider.pickupAddress,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold,
                                          overflow: TextOverflow.ellipsis)))
                            ]),
                        const SizedBox(
                          height: 4.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8.0, right: 8.0),
                                      child: Icon(
                                        Icons.add_location_alt_outlined,
                                        color: Colors.redAccent.shade700,
                                        size: 20.0,
                                      )),
                                  Text(AppLocalizations.of(context)!.too,
                                      style: TextStyle(
                                          color: Colors.greenAccent.shade700,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                  Text(rideInfoProvider.dropoffAddress,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 18.0,
                                          overflow: TextOverflow.ellipsis)),
                                ]),
                            status == "accepted"
                                ? Padding(
                                    padding: const EdgeInsets.only(
                                        left: 4.0, right: 4.0),
                                    child: Column(
                                      children: [
                                        GestureDetector(
                                            onTap: () async {
                                              await driverRef
                                                  .child(userId)
                                                  .child("map")
                                                  .once()
                                                  .then((value) async {
                                                if (value.snapshot.exists &&
                                                    value.snapshot.value !=
                                                        null) {
                                                  final snap =
                                                      value.snapshot.value;
                                                  String _mapBox =
                                                      snap.toString();
                                                  if (_mapBox == "mapbox") {
                                                    await navigationDriverToPickUpRi(
                                                        context);
                                                  } else {
                                                    await openGoogleMapDriverToRider(
                                                        context);
                                                  }
                                                }
                                              });
                                            },
                                            child: AnimatedContainer(
                                              duration: const Duration(
                                                  milliseconds: 500),
                                              height: 35,
                                              width: colorNavButton == true
                                                  ? 30
                                                  : 35,
                                              decoration: BoxDecoration(
                                                  color: colorNavButton == true
                                                      ? Colors.blueAccent
                                                      : Colors
                                                          .greenAccent.shade700,
                                                  shape: BoxShape.circle),
                                              padding:
                                                  const EdgeInsets.all(4.0),
                                              child: Image.asset(
                                                  'images/100navigationAn.png'),
                                            )),
                                        Center(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 4.0, right: 4.0),
                                            child: Text(
                                              AppLocalizations.of(context)!
                                                  .rider,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 10.0),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.only(
                                        left: 4.0, right: 4.0),
                                    child: Column(
                                      children: [
                                        GestureDetector(
                                            onTap: () async {
                                              openGoogleMap(context);
                                              // navigationPickToDrop(context);
                                            },
                                            child: AnimatedContainer(
                                              duration: const Duration(
                                                  milliseconds: 500),
                                              height: 35,
                                              width: colorNavButton == true
                                                  ? 30
                                                  : 35,
                                              decoration: BoxDecoration(
                                                  color: colorNavButton == true
                                                      ? Colors.blueAccent
                                                      : Colors.yellowAccent
                                                          .shade700,
                                                  shape: BoxShape.circle),
                                              padding:
                                                  const EdgeInsets.all(4.0),
                                              child: Image.asset(
                                                  'images/100navigationAn.png'),
                                            )),
                                        Center(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 4.0, right: 4.0),
                                            child: Text(
                                              AppLocalizations.of(context)!
                                                  .toTrip,
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  fontSize: 14.0),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                          ],
                        ),
                        const SizedBox(
                          height: 2.0,
                        ),
                        GestureDetector(
                          onTap: () {
                            changeColorArrivedAndTileButton(
                                context, rideInfoProvider);
                          },
                          child: Container(
                              margin: const EdgeInsets.only(bottom: 8.0),
                              width: 180,
                              height: 40,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3.0),
                                  color: Colors.greenAccent.shade700),
                              child: Center(
                                  child: Text(
                                buttonTitle,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: buttonColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ))),
                        ),
                        // CustomDivider().customDivider(),
                        // Padding(
                        //   padding: const EdgeInsets.only(bottom: 8.0, top: 8.0),
                        //   child: Row(
                        //     crossAxisAlignment: CrossAxisAlignment.center,
                        //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        //     children: [
                        //       // status == "onride"
                        //       //     ? GestureDetector(
                        //       //         onTap: () async {
                        //       //           openGoogleMap(context);
                        //       //           // navigationPickToDrop(context);
                        //       //         },
                        //       //         child: Container(
                        //       //             width: MediaQuery.of(context)
                        //       //                     .size
                        //       //                     .width *
                        //       //                 20 /
                        //       //                 100,
                        //       //             height: MediaQuery.of(context)
                        //       //                     .size
                        //       //                     .height *
                        //       //                 7.5 /
                        //       //                 100,
                        //       //             decoration: BoxDecoration(
                        //       //                 borderRadius:
                        //       //                     BorderRadius.circular(3.0),
                        //       //                 color:
                        //       //                     Colors.blueAccent.shade700),
                        //       //             child: Column(
                        //       //               children: [
                        //       //                 Padding(
                        //       //                   padding:
                        //       //                       const EdgeInsets.all(4.0),
                        //       //                   child: Center(
                        //       //                       child: Text(
                        //       //                     AppLocalizations.of(context)!
                        //       //                         .toTrip,
                        //       //                     style: const TextStyle(
                        //       //                         color: Colors.white,
                        //       //                         fontSize: 14.0),
                        //       //                   )),
                        //       //                 ),
                        //       //                 const Center(
                        //       //                     child: Icon(Icons.map,
                        //       //                         size: 16.0,
                        //       //                         color: Colors.white))
                        //       //               ],
                        //       //             )),
                        //       //       )
                        //       //     : const Text(""),
                        //       ///
                        //       GestureDetector(
                        //         onTap: () {
                        //           changeColorArrivedAndTileButton(
                        //               context, rideInfoProvider);
                        //         },
                        //         child: Container(
                        //             width: MediaQuery.of(context).size.width *
                        //                 40 /
                        //                 100,
                        //             height: MediaQuery.of(context).size.height *
                        //                 7 /
                        //                 100,
                        //             decoration: BoxDecoration(
                        //                 borderRadius:
                        //                     BorderRadius.circular(3.0),
                        //                 color: Colors.greenAccent.shade700),
                        //             child: Center(
                        //                 child: Text(
                        //               buttonTitle,
                        //               textAlign: TextAlign.center,
                        //               overflow: TextOverflow.ellipsis,
                        //               style: TextStyle(
                        //                   color: buttonColor,
                        //                   fontSize: 16,
                        //                   fontWeight: FontWeight.bold),
                        //             ))),
                        //       ),
                        //       ///
                        //       // status == "accepted"
                        //       //     ? Column(
                        //       //       children: [
                        //       //         GestureDetector(
                        //       //             onTap: () async {
                        //       //               await driverRef
                        //       //                   .child(userId)
                        //       //                   .child("map")
                        //       //                   .once()
                        //       //                   .then((value) async {
                        //       //                 if (value.snapshot.exists &&
                        //       //                     value.snapshot.value != null) {
                        //       //                   final snap = value.snapshot.value;
                        //       //                   String _mapBox = snap.toString();
                        //       //                   if (_mapBox == "mapbox") {
                        //       //                     await navigationDriverToPickUpRi(
                        //       //                         context);
                        //       //                   } else {
                        //       //                     await openGoogleMapDriverToRider(
                        //       //                         context);
                        //       //                   }
                        //       //                 }
                        //       //               });
                        //       //             },
                        //       //             child: AnimatedContainer(
                        //       //               duration: const Duration(milliseconds: 500),
                        //       //               height:colorNavButton==true? 35:45,
                        //       //               width: colorNavButton==true? 35:45,
                        //       //               decoration:  BoxDecoration(
                        //       //                 color: colorNavButton==true?Colors.red:Colors.greenAccent.shade700,
                        //       //                 shape: BoxShape.circle
                        //       //               ),
                        //       //               padding:const EdgeInsets.all(4.0),
                        //       //               child: Image.asset(
                        //       //                   'images/100navigationAn.png'),
                        //       //             )
                        //       //             ),
                        //       //         Text(
                        //       //                       AppLocalizations.of(
                        //       //                               context)!
                        //       //                           .rider,
                        //       //                       overflow: TextOverflow
                        //       //                           .ellipsis,
                        //       //                       style:
                        //       //                           const TextStyle(
                        //       //                               color: Colors
                        //       //                                   .white,
                        //       //                               fontSize:
                        //       //                                   10.0),
                        //       //                     ),
                        //       //       ],
                        //       //     )
                        //       //     : const Text("")
                        //     ],
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          isInductor == true
              ? CircularInductorCostem().circularInductorCostem(context)
              : const Text(""),
        ],
      ))),
    );
  }

//================================Start=========================================
  // 1..this method for set driver info in new Ride request collection after driver accepted new rider order
  void acceptedRideRequest() {
    //1 from api geo driver current location
    final dCurrentPosition =
        Provider.of<DriverCurrentPosition>(context, listen: false)
            .currentPosition;
    //2 driverInfo from database driver collection
    final driverInfo =
        Provider.of<DriverInfoModelProvider>(context, listen: false).driverInfo;
    //3 riderInfo from database Ride request collection
    final riderInfo =
        Provider.of<RideRequestInfoProvider>(context, listen: false)
            .rideDetails;
    //4
    Map driveLoc = {
      "latitude": dCurrentPosition.latitude.toString(),
      "longitude": dCurrentPosition.longitude.toString(),
    };

    DatabaseReference rideRequestRef = FirebaseDatabase.instance
        .ref()
        .child("Ride Request")
        .child(riderInfo.userId);
    rideRequestRef.set({
      "status": "accepted",
      "driverId": driverInfo.userId,
      "carPlack": driverInfo.idNo,
      "driverImage": driverInfo.personImage,
      "driverName": driverInfo.firstName + " " + driverInfo.lastName,
      "driverPhone": driverInfo.phoneNumber,
      "carInfo": driverInfo.carBrand + "-" + driverInfo.carColor,
      "driverLocation": driveLoc
    });
  }

  /*2..this them main logic for draw direction on marker+ polyline connect
   with class api show loc driver to ride when driver accepted order*/
  Future<void> getPlaceDirection(
      BuildContext context, LatLng startPontLoc, LatLng secondPontLoc) async {
    // from api geo driver current location
    final initialPos = startPontLoc;

    // rider current location from database Ride request collection
    final finalPos = secondPontLoc;

    final pickUpLatling = LatLng(initialPos.latitude, initialPos.longitude);

    final dropOfLatling = LatLng(finalPos.latitude, finalPos.longitude);

    ///from api dir
    final details = await ApiSrvDir.obtainPlaceDirectionDetails(
        pickUpLatling, dropOfLatling, context);

    // target: startPontLoc, zoom: 16.90, tilt: 80.0, bearing: 15.0);
    CameraPosition cameraPosition = CameraPosition(
        target: startPontLoc, zoom: 15.0, tilt: 0.0, bearing: 0.0);
    newRideControllerGoogleMap
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    /// PolylinePoints method
    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> decodedPolylineResult =
        polylinePoints.decodePolyline(details!.enCodingPoints);
    polylineCoordinates.clear();

    if (decodedPolylineResult.isNotEmpty) {
      ///new add
      for (var pointLatLng in decodedPolylineResult) {
        polylineCoordinates
            .add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      }
    }
    polylineSet.clear();
    setState(() {
      ///property PolylinePoints
      Polyline polyline = Polyline(
          polylineId: const PolylineId("polylineId"),
          color: Colors.greenAccent.shade700,
          width: 5,
          geodesic: true,
          startCap: Cap.roundCap,
          endCap: Cap.roundCap,
          jointType: JointType.round,
          points: polylineCoordinates);

      ///set from above
      polylineSet.add(polyline);
    });

    ///Marker
    Marker markerPickUpLocation = Marker(
        icon: pickUpIcon,
        position: LatLng(pickUpLatling.latitude, pickUpLatling.longitude),
        markerId: const MarkerId("pickUpId"),
        infoWindow: const InfoWindow(title: "My Location"));

    Marker markerDropOfLocation = Marker(
        icon: dropOffIcon,
        position: LatLng(dropOfLatling.latitude, dropOfLatling.longitude),
        markerId: const MarkerId("dropOfId"),
        infoWindow: InfoWindow(
            title: status == "accepted"
                ? "Rider Name : $riderName"
                : "Target : Rider dropOff location"));

    setState(() {
      markersSet.add(markerPickUpLocation);
      markersSet.add(markerDropOfLocation);
    });

    ///Circle
    Circle pickUpLocCircle = Circle(
        fillColor: Colors.white,
        radius: 6.0,
        center: pickUpLatling,
        strokeWidth: 1,
        strokeColor: Colors.grey,
        circleId: const CircleId("pickUpId"));

    Circle dropOffLocCircle = Circle(
        fillColor: Colors.white,
        radius: 6.0,
        center: dropOfLatling,
        strokeWidth: 1,
        strokeColor: Colors.grey,
        circleId: const CircleId("dropOfId"));
    setState(() {
      circlesSet.add(pickUpLocCircle);
      circlesSet.add(dropOffLocCircle);
    });
    const _timer = Duration(seconds: 1);
    int count = 4;
    Timer.periodic(_timer, (timer) {
      count = count - 1;
      if (count == 0) {
        timer.cancel();
        count = 4;
        isInductor = false;
      }
    });

    double nLat, nLon, sLat, sLon;

    if (dropOfLatling.latitude <= pickUpLatling.latitude) {
      sLat = dropOfLatling.latitude;
      nLat = pickUpLatling.latitude;
    } else {
      sLat = pickUpLatling.latitude;
      nLat = dropOfLatling.latitude;
    }
    if (dropOfLatling.longitude <= pickUpLatling.longitude) {
      sLon = dropOfLatling.longitude;
      nLon = pickUpLatling.longitude;
    } else {
      sLon = pickUpLatling.longitude;
      nLon = dropOfLatling.longitude;
    }
    LatLngBounds latLngBounds = LatLngBounds(
      northeast: LatLng(nLat, nLon),
      southwest: LatLng(sLat, sLon),
    );

    newGoogleMapController
        ?.animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 70));
  }

// contact to method getPlaceDirection
  void createPickUpRideIcon() {
    ImageConfiguration imageConfiguration =
        createLocalImageConfiguration(context, size: const Size(1.0, 1.0));
    BitmapDescriptor.fromAssetImage(
            imageConfiguration,
            Platform.isIOS
                ? "images/100currentlocationicon.png"
                : "images/100currentlocationiconAn.png")
        .then((value) {
      setState(() {
        pickUpIcon = value;
      });
    });
  }

// contact to method getPlaceDirection
  void createDropOffIcon() {
    ImageConfiguration imageConfiguration =
        createLocalImageConfiguration(context, size: const Size(0.1, 1.0));
    BitmapDescriptor.fromAssetImage(
            imageConfiguration,
            status == "accepted"
                ? Platform.isIOS
                    ? "images/100passengerlocationicon.png"
                    : "images/100passengerlocationiconAn.png"
                : Platform.isIOS
                    ? "images/100flagblackwhite.png"
                    : "images/100flagblackwhiteAn.png")
        .then((value) {
      setState(() {
        dropOffIcon = value;
      });
    });
  }

  //3..this method for live location when updating on map and set to realtime
  Future<void> getRideLiveLocationUpdate() async {
    late LocationSettings _locationSettings;
    myPosition = Provider.of<DriverCurrentPosition>(context, listen: false)
        .currentPosition;
    if (defaultTargetPlatform == TargetPlatform.android) {
      _locationSettings = AndroidSettings(
          accuracy: LocationAccuracy.best,
          distanceFilter: 2,
          forceLocationManager: false,
          intervalDuration: const Duration(milliseconds: 1000),
          foregroundNotificationConfig: ForegroundNotificationConfig(
            notificationText: AppLocalizations.of(context)!.locationBackground,
            notificationTitle: "Garanti taxi",
            enableWakeLock: true,
          ));
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      _locationSettings = AppleSettings(
        accuracy: LocationAccuracy.best,
        activityType: ActivityType.fitness,
        distanceFilter: 2,
        pauseLocationUpdatesAutomatically: false,
        showBackgroundLocationIndicator: true,
      );
    } else {
      _locationSettings = const LocationSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 2,
      );
    }
    // if (Platform.isAndroid) {
    //   var androidInfo = await DeviceInfoPlugin().androidInfo;
    //   var sdkInt = androidInfo.version.sdkInt;
    //   if (sdkInt! <= 27) {
    //     newRideScreenStreamSubscription =
    //         Geolocator.getPositionStream().listen((Position position) async {
    //       LatLng oldLat = const LatLng(0, 0);
    //       setState(() {
    //         myPosition = position;
    //       });
    //       print("hhhhh$position");
    //       LatLng mPosition =
    //           LatLng(myPosition!.latitude, myPosition!.longitude);
    //
    //       ///...
    //       final rot = MapToolKit.getMarkerRotation(oldLat.latitude,
    //           oldLat.longitude, myPosition?.latitude, myPosition?.longitude);
    //       Marker anmiatedMarker = Marker(
    //         markerId: const MarkerId("animating"),
    //         infoWindow: const InfoWindow(title: "Current Location"),
    //         position: mPosition,
    //         icon: anmiatedMarkerIcon,
    //         rotation: rot,
    //       );
    //
    //       ///...
    //       setState(() {
    //         CameraPosition cameraPosition = CameraPosition(
    //             target: mPosition, zoom: 16.90, tilt: 80.0, bearing: 15.0);
    //         newRideControllerGoogleMap
    //             .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    //         markersSet.removeWhere((ele) => ele.markerId.value == "animating");
    //         markersSet.add(anmiatedMarker);
    //       });
    //
    //       ///...
    //       oldLat = mPosition;
    //       updateRideDetails();
    //
    //       ///...
    //       final riderInfo =
    //           Provider.of<RideRequestInfoProvider>(context, listen: false)
    //               .rideDetails;
    //
    //       Map driveLoc = {
    //         "latitude": myPosition?.latitude.toString(),
    //         "longitude": myPosition?.longitude.toString(),
    //       };
    //
    //       DatabaseReference rideRequestRef = FirebaseDatabase.instance
    //           .ref()
    //           .child("Ride Request")
    //           .child(riderInfo.userId);
    //       rideRequestRef.child("driverLocation").set(driveLoc);
    //     });
    //   } else {
    //     newRideScreenStreamSubscription =
    //         Geolocator.getPositionStream(locationSettings: _locationSettings)
    //             .listen((Position position) async {
    //       LatLng oldLat = const LatLng(0, 0);
    //       setState(() {
    //         myPosition = position;
    //       });
    //       print("hhhhh$position");
    //       LatLng mPosition =
    //           LatLng(myPosition!.latitude, myPosition!.longitude);
    //
    //       ///...
    //       final rot = MapToolKit.getMarkerRotation(oldLat.latitude,
    //           oldLat.longitude, myPosition?.latitude, myPosition?.longitude);
    //       Marker anmiatedMarker = Marker(
    //         markerId: const MarkerId("animating"),
    //         infoWindow: const InfoWindow(title: "Current Location"),
    //         position: mPosition,
    //         icon: anmiatedMarkerIcon,
    //         rotation: rot,
    //       );
    //
    //       ///...
    //       setState(() {
    //         CameraPosition cameraPosition = CameraPosition(
    //             target: mPosition, zoom: 16.90, tilt: 80.0, bearing: 15.0);
    //         newRideControllerGoogleMap
    //             .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    //         markersSet.removeWhere((ele) => ele.markerId.value == "animating");
    //         markersSet.add(anmiatedMarker);
    //       });
    //
    //       ///...
    //       oldLat = mPosition;
    //       updateRideDetails();
    //
    //       ///...
    //       final riderInfo =
    //           Provider.of<RideRequestInfoProvider>(context, listen: false)
    //               .rideDetails;
    //
    //       Map driveLoc = {
    //         "latitude": myPosition?.latitude.toString(),
    //         "longitude": myPosition?.longitude.toString(),
    //       };
    //
    //       DatabaseReference rideRequestRef = FirebaseDatabase.instance
    //           .ref()
    //           .child("Ride Request")
    //           .child(riderInfo.userId);
    //       rideRequestRef.child("driverLocation").set(driveLoc);
    //     });
    //   }
    // }
    // else {
    //   newRideScreenStreamSubscription =
    //       Geolocator.getPositionStream(locationSettings: _locationSettings)
    //           .listen((Position position) async {
    //     LatLng oldLat = const LatLng(0, 0);
    //     setState(() {
    //       myPosition = position;
    //     });
    //     print("hhhhh$position");
    //     LatLng mPosition = LatLng(myPosition!.latitude, myPosition!.longitude);
    //
    //     ///...
    //     final rot = MapToolKit.getMarkerRotation(oldLat.latitude,
    //         oldLat.longitude, myPosition?.latitude, myPosition?.longitude);
    //     Marker anmiatedMarker = Marker(
    //       markerId: const MarkerId("animating"),
    //       infoWindow: const InfoWindow(title: "Current Location"),
    //       position: mPosition,
    //       icon: anmiatedMarkerIcon,
    //       rotation: rot,
    //     );
    //
    //     ///...
    //     setState(() {
    //       CameraPosition cameraPosition = CameraPosition(
    //           target: mPosition, zoom: 16.90, tilt: 80.0, bearing: 15.0);
    //       newRideControllerGoogleMap
    //           .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    //       markersSet.removeWhere((ele) => ele.markerId.value == "animating");
    //       markersSet.add(anmiatedMarker);
    //     });
    //
    //     ///...
    //     oldLat = mPosition;
    //     updateRideDetails();
    //
    //     ///...
    //     final riderInfo =
    //         Provider.of<RideRequestInfoProvider>(context, listen: false)
    //             .rideDetails;
    //
    //     Map driveLoc = {
    //       "latitude": myPosition?.latitude.toString(),
    //       "longitude": myPosition?.longitude.toString(),
    //     };
    //
    //     DatabaseReference rideRequestRef = FirebaseDatabase.instance
    //         .ref()
    //         .child("Ride Request")
    //         .child(riderInfo.userId);
    //     rideRequestRef.child("driverLocation").set(driveLoc);
    //   });
    // }
    newRideScreenStreamSubscription =
        Geolocator.getPositionStream(locationSettings: _locationSettings)
            .listen((Position position) async {
      LatLng oldLat = const LatLng(0, 0);
      setState(() {
        myPosition = position;
      });
      LatLng mPosition = LatLng(myPosition!.latitude, myPosition!.longitude);

      ///...
      final rot = MapToolKit.getMarkerRotation(oldLat.latitude,
          oldLat.longitude, myPosition?.latitude, myPosition?.longitude);
      Marker anmiatedMarker = Marker(
        markerId: const MarkerId("animating"),
        infoWindow: const InfoWindow(title: "Current Location"),
        position: mPosition,
        icon: anmiatedMarkerIcon,
        rotation: rot,
      );

      ///...
      setState(() {
        CameraPosition cameraPosition = CameraPosition(
            target: mPosition, zoom: 15.0, tilt: 0.0, bearing: 0.0);
        newRideControllerGoogleMap
            .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
        markersSet.removeWhere((ele) => ele.markerId.value == "animating");
        markersSet.add(anmiatedMarker);
      });

      ///...
      oldLat = mPosition;
      updateRideDetails();

      ///...
      final riderInfo =
          Provider.of<RideRequestInfoProvider>(context, listen: false)
              .rideDetails;

      Map driveLoc = {
        "latitude": myPosition?.latitude.toString(),
        "longitude": myPosition?.longitude.toString(),
      };

      DatabaseReference rideRequestRef = FirebaseDatabase.instance
          .ref()
          .child("Ride Request")
          .child(riderInfo.userId);
      rideRequestRef.child("driverLocation").set(driveLoc);
    });
  }

// 4..this method for icon car
  void createDriverNearIcon() {
    ImageConfiguration imageConfiguration =
        createLocalImageConfiguration(context, size: const Size(0.6, 0.6));
    BitmapDescriptor.fromAssetImage(
            imageConfiguration,
            Platform.isIOS
                ? "images/100navigation.png"
                : "images/100navigationAn.png")
        .then((value) {
      setState(() {
        anmiatedMarkerIcon = value;
      });
    });
  }

/*5..this method for update rider info to driver first when driver go to rider
* pickUp location after that when driver arrived info will changed to dropOff
* location where rider want to go + time trip */
  void updateRideDetails() async {
    final posLatLin = LatLng(myPosition!.latitude, myPosition!.longitude);
    final riderInfo =
        Provider.of<RideRequestInfoProvider>(context, listen: false)
            .rideDetails;
    LatLng desertionLatLng;
    if (isRequestDirection == false) {
      isRequestDirection = true;
      if (myPosition == null) {
        return;
      }
      if (status == "accepted") {
        desertionLatLng = riderInfo.pickup;
      } else {
        desertionLatLng = riderInfo.dropoff;
        await ApiSrvDir.obtainPlaceDirectionDetails(
            posLatLin, desertionLatLng, context);
        isRequestDirection = false;
      }
    }
  }

  /*6.. this method for change Status & title-color arrived button from
  & driver loc to rider pickUp loc then from rider pickUp to rider drop
  then update status on fire base
  */
  Future<void> changeColorArrivedAndTileButton(
      BuildContext context, RideDetails rideInfoProvider) async {
    DatabaseReference rideRequestRef = FirebaseDatabase.instance
        .ref()
        .child("Ride Request")
        .child(rideInfoProvider.userId);

    if (status == "accepted") {
      setState(() {
        status = "arrived";
      });
      Provider.of<TitleArrived>(context, listen: false)
          .updateState(AppLocalizations.of(context)!.startTrip);
      Provider.of<ColorButtonArrived>(context, listen: false)
          .updateState(Colors.yellowAccent.shade700);
      timerStop1.cancel();
      rideRequestRef.child("status").set(status);
      timer2();
      getPlaceDirection(
          context, rideInfoProvider.pickup, rideInfoProvider.dropoff);
    } else if (status == "arrived") {
      setState(() {
        status = "onride";
      });
      Provider.of<TitleArrived>(context, listen: false)
          .updateState(AppLocalizations.of(context)!.endTrip);
      Provider.of<ColorButtonArrived>(context, listen: false)
          .updateState(Colors.redAccent.shade700);
      rideRequestRef.child("status").set(status);
      timerStop2.cancel();
      time3(context, myPosition!, rideInfoProvider.dropoff);
      initTimer();
    } else if (status == "onride") {
      endTrip(rideInfoProvider, rideRequestRef, context);
    }
  }

  // this void for count time trip in second
  void initTimer() {
    const inTravel = Duration(seconds: 1);
    timer = Timer.periodic(inTravel, (timer) {
      durationContour = durationContour + 1;
    });
  }

// this method when trip don for repack all Sitting to default and calc amont
  void endTrip(RideDetails rideInfoProvider, DatabaseReference rideRequestRef,
      BuildContext context) async {
    timer.cancel();
    timerStop3.cancel();
    timerStop4.cancel();
    timerStop5.cancel();
    Provider.of<NewRideScreenIndector>(context, listen: false)
        .updateState(true);
    setState(() {
      status = "ended";
    });
    Provider.of<TitleArrived>(context, listen: false)
        .updateState(AppLocalizations.of(context)!.arrived);
    Provider.of<ColorButtonArrived>(context, listen: false)
        .updateState(Colors.white);
    rideRequestRef.child("status").set(status);
    final driverCurrentLoc =
        LatLng(myPosition!.latitude, myPosition!.longitude);
    final riderFirstPickUp = LatLng(
        rideInfoProvider.pickup.latitude, rideInfoProvider.pickup.longitude);
    Provider.of<NewRideScreenIndector>(context, listen: false)
        .updateState(false);
    final directionDetails = await ApiSrvDir.obtainPlaceDirectionDetails(
        riderFirstPickUp, driverCurrentLoc, context);
    int totalAmount = ApiSrvDir.calculateFares1(
        directionDetails!, rideInfoProvider.vehicleTypeId, context);
    rideRequestRef.child("total").set(totalAmount.toString());
    newRideScreenStreamSubscription?.cancel();
    saveEarning(totalAmount);
    saveTripHistory(rideInfoProvider, totalAmount);
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => collectMoney(context, rideInfoProvider, totalAmount));
  }

  // this method for save earning money in database
  void saveEarning(int totalAmount) async {
    final currentUserId = AuthSev().auth.currentUser?.uid;
    DatabaseReference ref = FirebaseDatabase.instance
        .ref()
        .child("driver")
        .child(currentUserId!)
        .child("earning");
    await ref.once().then((value) {
      if (value.snapshot.value != null || value.snapshot.value != "0.0") {
        double oldEarn = double.parse(value.snapshot.value.toString());
        double totalEarn = totalAmount + oldEarn;
        ref.set(totalEarn.toStringAsFixed(2));
      } else {
        double totalEarn = totalAmount.toDouble();
        ref.set(totalEarn.toStringAsFixed(2));
      }
    });
  }

  // this method for save history trip in driver collection after finished
  void saveTripHistory(RideDetails rideInfoProvider, int totalAmount) {
    final currentUserId = AuthSev().auth.currentUser?.uid;
    DatabaseReference ref = FirebaseDatabase.instance
        .ref()
        .child("driver")
        .child(currentUserId!)
        .child("history");
    ref.child(rideInfoProvider.userId).set({
      "pickAddress": rideInfoProvider.pickupAddress,
      "dropAddress": rideInfoProvider.dropoffAddress,
      "total": totalAmount.toStringAsFixed(2),
      "trip": "don"
    });
  }
  //================================End=========================================

//=================================Start Navigation=============================

  Future<void> inTailiz() async {
    if (!mounted) return;
    directions = MapBoxNavigation(onRouteEvent: _onRouteEvent);
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await directions.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }
    setState(() {
      _platformVersion = platformVersion;
    });
  }

  Future<void> _onRouteEvent(e) async {
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
        } else {
          MapBoxEvent.navigation_finished;
          MapBoxEvent.navigation_cancelled;
          isNavigating = false;
          routeBuilt = false;
          await _controller.finishNavigation();
          Navigator.pop(context);
        }
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

  // this method for Navigation between driver and pickUp rider
  Future<void> navigationDriverToPickUpRi(BuildContext c) async {
    final rideInfo =
        Provider.of<RideRequestInfoProvider>(c, listen: false).rideDetails;
    final _driver =
        Provider.of<DriverCurrentPosition>(c, listen: false).currentPosition;

    final start1 = WayPoint(
        name: "start",
        latitude: _driver.latitude,
        longitude: _driver.longitude);
    final stop1 = WayPoint(
        name: "stop",
        latitude: rideInfo.pickup.latitude,
        longitude: rideInfo.pickup.longitude);
    var wayPoints = <WayPoint>[];
    wayPoints.add(start1);
    wayPoints.add(stop1);
    await directions.startNavigation(
        wayPoints: wayPoints,
        options: MapBoxOptions(
          // initialLatitude: 36.1175275,
          // initialLongitude: -115.1839524,
          initialLatitude: _driver.latitude,
          initialLongitude: _driver.longitude,
          mode: MapBoxNavigationMode.driving,
          simulateRoute: false,
          language: mapBoxLanguages(),
          units: VoiceUnits.metric,
          zoom: 13.0,
          tilt: 0.0,
          bearing: 0.0,
        ));
  }

  // this method for Navigation between pickUp to drop of rider
  ///
  // navigationPickToDrop(BuildContext context) async {
  //   final rideInfo =
  //       Provider.of<RideRequestInfoProvider>(context, listen: false)
  //           .rideDetails;
  //   final start2 = WayPoint(
  //       name: "start1",
  //       latitude: rideInfo.pickup.latitude,
  //       longitude: rideInfo.pickup.longitude);
  //   final stop2 = WayPoint(
  //       name: "stop1",
  //       latitude: rideInfo.dropoff.latitude,
  //       longitude: rideInfo.dropoff.longitude);
  //   var wayPoints = <WayPoint>[];
  //   wayPoints.add(start2);
  //   wayPoints.add(stop2);
  //
  //   await directions.startNavigation(
  //       wayPoints: wayPoints,
  //       options: MapBoxOptions(
  //         initialLatitude:rideInfo.pickup.latitude ,
  //         initialLongitude: rideInfo.pickup.longitude,
  //         mode: MapBoxNavigationMode.driving,
  //         simulateRoute: false,
  //         language: mapBoxLanguages(),
  //         units: VoiceUnits.metric,
  //         zoom: 13.0,
  //         tilt: 0.0,
  //         bearing: 0.0,
  //       ));
  // }

  // this method for set lang mapBox
  ///
  //this method for open google Map
  Future<void> openGoogleMap(BuildContext context) async {
    String url;
    final rideInfo =
        Provider.of<RideRequestInfoProvider>(context, listen: false)
            .rideDetails;
    if (Platform.isIOS) {
      url =
          "https://www.google.com/maps/search/?api=1&query=${rideInfo.dropoff.latitude},${rideInfo.dropoff.longitude}";
    } else {
      url =
          'https://www.google.com/maps/dir/${rideInfo.pickup.latitude},${rideInfo.pickup.longitude}/${rideInfo.dropoffAddress},+${rideInfo.dropoffAddress}/@${rideInfo.dropoff.latitude},${rideInfo.dropoff.longitude},13z/';
    }
    // String url =
    //     "https://www.google.com/maps/dir/${rideInfo.pickup.latitude},${rideInfo.pickup.longitude}/${rideInfo.dropoffAddress},+${rideInfo.dropoffAddress}/@${rideInfo.dropoff.latitude},${rideInfo.dropoff.longitude},13z/";
    await canLaunch(url)
        ? launch(url)
        : Tools().toastMsg(AppLocalizations.of(context)!.wrong, Colors.red);
  }

  //this method for open google Map
  Future<void> openGoogleMapDriverToRider(BuildContext context) async {
    String url;
    final _driver = Provider.of<DriverCurrentPosition>(context, listen: false)
        .currentPosition;
    final rideInfo =
        Provider.of<RideRequestInfoProvider>(context, listen: false)
            .rideDetails;

    String _urlNavAndroid =
        'google.navigation:q=${rideInfo.pickup.latitude},${rideInfo.pickup.longitude}&key=$mapKey';
    String _urlGoogleMap =
        'https://www.google.com/maps/search/?api=1&query=${rideInfo.pickup.latitude},${rideInfo.pickup.longitude}';
    // if (Platform.isIOS) {
    //   url =
    //       'https://www.google.com/maps/search/?api=1&query=${rideInfo.pickup.latitude},${rideInfo.pickup.longitude}';
    // }
    // else {
    //   url =
    //       'https://www.google.com/maps/dir/${_driver.latitude},${_driver.longitude}/${rideInfo.pickupAddress},+${rideInfo.pickupAddress}/@${rideInfo.pickup.latitude},${rideInfo.pickup.longitude},13z/';
    // }
    // String url =
    //     "https://www.google.com/maps/dir/${_driver.latitude},${_driver.longitude}/${rideInfo.pickupAddress},+${rideInfo.pickupAddress}/@${rideInfo.pickup.latitude},${rideInfo.pickup.longitude},13z/";
    await canLaunch(_urlNavAndroid)
        ? launch(_urlNavAndroid)
        : await canLaunch(_urlNavAndroid)
            ? launch(_urlGoogleMap)
            : Tools().toastMsg(AppLocalizations.of(context)!.wrong, Colors.red);
  }

  String mapBoxLanguages() {
    String lan = "tr";
    if (AppLocalizations.of(context)!.rider == "Yolcuya git") {
      setState(() {
        lan = "tr";
      });
    } else if (AppLocalizations.of(context)!.rider == "زبون") {
      setState(() {
        lan = "ar";
      });
    } else {
      setState(() {
        lan = "en";
      });
    }
    return lan;
  }

//==================================End Navigation==============================
  // when driver arrived to rider for notify rider just by time
  void timer1(BuildContext context) {
    String _voiceLan = AppLocalizations.of(context)!.day;
    const duration = Duration(minutes: 1);
    int timerCount1 = 3;
    timerStop1 = Timer.periodic(duration, (timer) {
      timerCount1 = timerCount1 - 1;
      if (timerCount1 == 0) {
        switch (_voiceLan) {
          case 'Gun':
            assetsAudioPlayer
                .open(Audio("sounds/notify_passenger_accessing_tr.mp3"));
            break;
          case 'يوم':
            assetsAudioPlayer
                .open(Audio("sounds/notify_passenger_accessing_ar.wav"));
            break;
          default:
            assetsAudioPlayer
                .open(Audio("sounds/notify_passenger_accessing_en.mpeg"));
            break;
        }
        timer.cancel();
        timerStop1.cancel();
        setState(() {
          timerCount1 = 3;
        });
      } else if (status == "arrived") {
        timer.cancel();
        timerStop1.cancel();
        setState(() {
          timerCount1 = 3;
        });
      }
    });
  }

// this method for remaber driver to click button when start trip
  void timer2() {
    String voiceLang = AppLocalizations.of(context)!.day;
    const duration = Duration(seconds: 1);
    int _timerCount2 = 5;
    timerStop2 = Timer.periodic(duration, (timer) {
      _timerCount2 = _timerCount2 - 1;
      if (_timerCount2 == 0) {
        switch (voiceLang) {
          case 'Gun':
            assetsAudioPlayer.open(Audio("sounds/start_trip_tr.mp3"));
            break;
          case 'يوم':
            assetsAudioPlayer.open(Audio("sounds/start_trip_ar.wav"));
            break;
          default:
            assetsAudioPlayer.open(Audio("sounds/start_trip_en.wav"));
            break;
        }
        timer.cancel();
        setState(() {
          _timerCount2 = 5;
        });
      } else if (status == "onride") {
        timer.cancel();
        timerStop2.cancel();
        setState(() {
          _timerCount2 = 5;
        });
      }
    });
  }

  // this mehtod calck time trip when than myPosition == dropoff notify end trip
  void time3(BuildContext context, Position myPosition, LatLng dropoff) {
    final res = LatLng(myPosition.latitude, myPosition.longitude);
    final String soundLan = AppLocalizations.of(context)!.day;
    var count = Provider.of<DirectionDetailsPro>(context, listen: false)
        .directionDetails;
    timerStop3 = Timer.periodic(const Duration(milliseconds: 2000), (timer) {
      count.durationVale = count.durationVale - 1;
      if (count.durationVale <= 0) {
        if (res == dropoff) {
          switch (soundLan) {
            case 'Gun':
              assetsAudioPlayer.open(Audio("sounds/end_trip_tr.mp3"));
              break;
            case 'يوم':
              assetsAudioPlayer.open(Audio("sounds/end_trip_ar.wav"));
              break;
            default:
              assetsAudioPlayer.open(Audio("sounds/end_trip_en.wav"));
              break;
          }
          timer.cancel();
          timerStop3.cancel();
        }
      } else if (status == "ended") {
        timer.cancel();
        timerStop3.cancel();
      } else {
        timer.cancel();
        timerStop3.cancel();
      }
    });
  }

  void changeColorNavButton() {
    timerStop4 = Timer.periodic(const Duration(seconds: 2), (timer) {
      setState(() {
        colorNavButton = true;
      });
    });
  }

  void changeColorNavButton1() {
    timerStop5 = Timer.periodic(const Duration(seconds: 4), (timer) {
      setState(() {
        colorNavButton = false;
      });
    });
  }
}
