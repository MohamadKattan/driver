import 'dart:async';
import 'dart:io';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:driver/model/direction_details.dart';
import 'package:driver/model/rideDetails.dart';
import 'package:driver/notificatons/push_notifications_srv.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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
import '../tools/tools.dart';
import '../widget/call_rider_phone_whatApp.dart';
import '../widget/collect_money_dialog.dart';
import '../widget/custom_circuler.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../widget/driver_cancel_dialog.dart';
import '../widget/rider_cancel_trip.dart';

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
  DatabaseReference rideRequestRef =
      FirebaseDatabase.instance.ref().child("Ride Request");
  late GoogleMapController newRideControllerGoogleMap;
  Set<Polyline> polylineSet = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  Set<Marker> markersSet = {};
  // Set<Circle> circlesSet = {};
  late BitmapDescriptor anmiatedMarkerIcon;
  // late BitmapDescriptor pickUpIcon;
  late BitmapDescriptor dropOffIcon;
  late Position? myPosition;
  String status = "accepted";
  late Timer timer;
  int durationContour = 0;
  late MapBoxNavigation directions;
  bool isInductor = false;
  bool isRequestDirection = false;
  bool buttonPostion = false;
  bool isDriverCollectMoney = false;
  late final MapBoxNavigationViewController _controller;
  bool arrivedMapBox = false;
  String instruction = "";
  bool routeBuilt = false;
  bool isNavigating = false;
  bool isMultipleStop = false;

  @override
  void initState() {
    showGpsDailog = false;
    acceptedRideRequest();
    installationMapBoxNav();
    isInductor = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // createPickUpRideIcon();
    createDropOffIcon();
    createDriverNearIcon();
    final rideInfoProvider =
        Provider.of<RideRequestInfoProvider>(context).rideDetails;
    final initialPos =
        Provider.of<DriverCurrentPosition>(context).currentPosition;
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: SafeArea(
          child: Scaffold(
              backgroundColor: Colors.grey.shade700,
              body: SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Stack(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 60 / 100,
                      width: MediaQuery.of(context).size.width,
                      child: GoogleMap(
                        mapType: MapType.normal,
                        initialCameraPosition:
                            const NewRideScreen().kGooglePlex,
                        myLocationButtonEnabled: true,
                        myLocationEnabled: true,
                        markers: markersSet,
                        polylines: polylineSet,
                        padding: const EdgeInsets.only(top: 55.0),
                        onMapCreated: (GoogleMapController controller) async {
                          controllerGoogleMap.complete(controller);
                          newRideControllerGoogleMap = controller;
                          Position _newPosition =
                              await Geolocator.getCurrentPosition(
                                  desiredAccuracy: LocationAccuracy.best);
                          Provider.of<DriverCurrentPosition>(context,
                                  listen: false)
                              .updateSate(_newPosition);
                          LatLng startPontLoc = LatLng(initialPos.latitude,
                              initialPos.longitude); //driver
                          LatLng secondPontLoc = LatLng(
                              rideInfoProvider.pickup.latitude,
                              rideInfoProvider.pickup.longitude);
                          riderName = rideInfoProvider.riderName;
                          await getPlaceDirection(
                              context, startPontLoc, secondPontLoc);
                          getRideLiveLocationUpdate();
                          Provider.of<TitleArrived>(context, listen: false)
                              .updateState(
                                  AppLocalizations.of(context)!.arrived);
                          timer1(context);
                          LogicGoogleMap()
                              .darkOrWhite(newRideControllerGoogleMap);
                          Tools().toastMsg(
                              AppLocalizations.of(context)!.goToRider,
                              Colors.greenAccent.shade700);
                          Tools().toastMsg(
                              AppLocalizations.of(context)!.goToRider,
                              Colors.greenAccent.shade700);
                        },
                      ),
                    ),
                    Positioned(
                        top: 50.0,
                        left: 0.0,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FloatingActionButton(
                            onPressed: () {
                              if (status == "accepted") {
                                switchGoToRiderOrTrip();
                              } else {
                                openGoogleMapTripNav();
                              }
                            },
                            backgroundColor: const Color(0xFF00A3E0),
                            child: const Center(
                                child: Icon(Icons.map,
                                    color: Colors.white, size: 25)),
                          ),
                        )),
                    Positioned(
                        top: 115.0,
                        left: 0.0,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FloatingActionButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (_) {
                                    return callRider(context, rideInfoProvider);
                                  });
                            },
                            backgroundColor: Colors.white,
                            child: Center(
                                child: Icon(Icons.call,
                                    color: Colors.greenAccent.shade400,
                                    size: 25)),
                          ),
                        )),
                    status == "accepted"
                        ? Positioned(
                            top: 185.0,
                            left: 0.0,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: FloatingActionButton(
                                onPressed: () => showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (_) => cancelTrip(context)),
                                backgroundColor: Colors.red,
                                child: const Center(
                                    child: Icon(Icons.close,
                                        color: Colors.white, size: 25)),
                              ),
                            ))
                        : const SizedBox(),
                    Positioned(
                      right: 0.0,
                      left: 0.0,
                      bottom: 0.0,
                      child: Container(
                        padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: Colors.grey.shade700,
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(8.0),
                                topRight: Radius.circular(8.0))),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    flex: 0,
                                    child: Consumer<DirectionDetailsPro>(
                                      builder: (BuildContext context, value,
                                          Widget? child) {
                                        return Text(
                                          // AppLocalizations.of(context)!.km +
                                          value.directionDetails.distanceText,
                                          textAlign: TextAlign.start,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 18.0),
                                        );
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    flex: 0,
                                    child: Consumer<DirectionDetailsPro>(
                                      builder: (BuildContext context, value,
                                          Widget? child) {
                                        return Text(
                                          AppLocalizations.of(context)!.time +
                                              value.directionDetails
                                                  .durationText,
                                          textAlign: TextAlign.start,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 18.0),
                                        );
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    flex: 0,
                                    child: Text(
                                      AppLocalizations.of(context)!.fare +
                                          currencyTypeCheck(context) +
                                          rideInfoProvider.amount,
                                      textAlign: TextAlign.start,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color: Colors.greenAccent.shade700,
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  AppLocalizations.of(context)!.riderName +
                                      rideInfoProvider.riderName,
                                  textAlign: TextAlign.start,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 20.0),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.add_location_alt_outlined,
                                      color: Colors.redAccent.shade700,
                                      size: 20.0,
                                    ),
                                    Text(AppLocalizations.of(context)!.from,
                                        style: TextStyle(
                                            color: Colors.greenAccent.shade700,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold)),
                                    Expanded(
                                        flex: 1,
                                        child: Text(
                                            rideInfoProvider.pickupAddress,
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold,
                                                overflow:
                                                    TextOverflow.ellipsis)))
                                  ]),
                              const SizedBox(
                                height: 16.0,
                              ),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.add_location_alt_outlined,
                                      color: Colors.redAccent.shade700,
                                      size: 20.0,
                                    ),
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
                              // buttomPostion == false
                              //     ? GestureDetector(
                              //         onTap: () async {
                              //           buttomPostion = true;
                              //           setState(() {});
                              //           await switchGoToRiderOrTrip();
                              //         },
                              //         child: AnimatedContainer(
                              //           margin: const EdgeInsets.only(
                              //               top: 15, bottom: 15),
                              //           height: 50,
                              //           width: 180,
                              //           decoration: BoxDecoration(
                              //               color: const Color(0xFF00A3E0),
                              //               borderRadius:
                              //                   BorderRadius.circular(12.0)),
                              //           duration:
                              //               const Duration(milliseconds: 700),
                              //           child: Center(
                              //               child: Text(
                              //             AppLocalizations.of(context)!.rider,
                              //             style: const TextStyle(
                              //                 color: Colors.white,
                              //                 fontSize: 20,
                              //                 fontWeight: FontWeight.bold),
                              //           )),
                              //         ),
                              //       )
                              //     : GestureDetector(
                              //         onTap: () async {
                              //           changeColorArrivedAndTileButton(
                              //               context, rideInfoProvider);
                              //           if (status == "onride") {
                              //             await openGoogleMapTripNav(context);
                              //           }
                              //         },
                              //         child: Container(
                              //           margin: const EdgeInsets.only(
                              //               top: 15, bottom: 15),
                              //           height: 50,
                              //           width: 180,
                              //           decoration: BoxDecoration(
                              //               borderRadius:
                              //                   BorderRadius.circular(3.0),
                              //               color:
                              //                   Colors.greenAccent.shade700),
                              //           child: Center(
                              //             child: Consumer<TitleArrived>(
                              //               builder: (BuildContext context,
                              //                   value, Widget? child) {
                              //                 final buttonColor = Provider.of<
                              //                             ColorButtonArrived>(
                              //                         context,
                              //                         listen: false)
                              //                     .colorButton;
                              //                 return Text(
                              //                   value.titleButton,
                              //                   maxLines: 2,
                              //                   textAlign: TextAlign.center,
                              //                   style: TextStyle(
                              //                       color: buttonColor,
                              //                       fontSize: 16,
                              //                       fontWeight:
                              //                           FontWeight.bold),
                              //                 );
                              //               },
                              //             ),
                              //           ),
                              //         ),
                              //       ),
                              Center(
                                child: GestureDetector(
                                  onTap: () async {
                                    changeColorArrivedAndTileButton(
                                        context, rideInfoProvider);
                                    // if (status == "onride") {
                                    //   await openGoogleMapTripNav(context);
                                    // }
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(
                                        top: 15, bottom: 15),
                                    height: 50,
                                    width: 220,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                        color: Colors.greenAccent.shade700),
                                    child: Center(
                                      child: Consumer<TitleArrived>(
                                        builder: (BuildContext context, value,
                                            Widget? child) {
                                          final buttonColor =
                                              Provider.of<ColorButtonArrived>(
                                                      context,
                                                      listen: false)
                                                  .colorButton;
                                          return Text(
                                            value.titleButton,
                                            maxLines: 2,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: buttonColor,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    isInductor == true
                        ? CircularInductorCostem()
                            .circularInductorCostem(context)
                        : const SizedBox(),
                  ],
                ),
              ))),
    );
  }

  ///================================Start=========================================
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

    final _ref = rideRequestRef.child(riderInfo.userId);
    _ref.update({
      "status": "accepted",
      "driverId": driverInfo.userId,
      "carPlack": driverInfo.idNo,
      "driverImage": driverInfo.personImage,
      "driverName": driverInfo.firstName + " " + driverInfo.lastName,
      "driverPhone": driverInfo.phoneNumber,
      "carInfo": driverInfo.carBrand + "-" + driverInfo.carColor,
      "driverLocation": driveLoc
    });
    notifyIfRiderCancel();
  }

  void notifyIfRiderCancel() {
    final _riderId =
        Provider.of<RideRequestInfoProvider>(context, listen: false)
            .rideDetails
            .userId;
    final _ref = rideRequestRef.child(_riderId).child('riderName');
    _ref.onValue.listen((event) {
      if (!event.snapshot.exists) {
        if (!mounted) return;
        if (!isDriverCollectMoney) {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => riderCancelTrip(context));
        } else {
          return;
        }
      } else {
        return;
      }
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
    CameraPosition cameraPosition = CameraPosition(
        target: startPontLoc, zoom: 16.5, tilt: 80.0, bearing: 0.0);

    newRideControllerGoogleMap
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    addPolyline(details!, dropOfLatling);
    isInductor = false;

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
    setState(() {});
  }

  void addPolyline(DirectionDetails details, LatLng dropOfLatling) {
    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> decodedPolylineResult =
        polylinePoints.decodePolyline(details.enCodingPoints);
    polylineCoordinates.clear();
    if (decodedPolylineResult.isNotEmpty) {
      for (var pointLatLng in decodedPolylineResult) {
        polylineCoordinates
            .add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      }
    }
    polylineSet.clear();
    Polyline polyline = Polyline(
        polylineId: const PolylineId("polylineId"),
        color: Colors.greenAccent.shade700,
        width: 5,
        geodesic: true,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        jointType: JointType.round,
        points: polylineCoordinates);
    polylineSet.add(polyline);

    Marker markerDropOfLocation = Marker(
        icon: dropOffIcon,
        position: LatLng(dropOfLatling.latitude, dropOfLatling.longitude),
        markerId: const MarkerId("dropOfId"),
        infoWindow: InfoWindow(
            title: status == "accepted"
                ? "Rider Name : $riderName"
                : "Target : Rider dropOff location"));

    // markersSet.add(markerPickUpLocation);
    markersSet.add(markerDropOfLocation);

    // Marker markerPickUpLocation = Marker(
    //     icon: pickUpIcon,
    //     position: LatLng(pickUpLatling.latitude, pickUpLatling.longitude),
    //     markerId: const MarkerId("pickUpId"),
    //     infoWindow: const InfoWindow(title: "My Location"));
    ///
    // Circle pickUpLocCircle = Circle(
    //     fillColor: Colors.white,
    //     radius: 6.0,
    //     center: pickUpLatling,
    //     strokeWidth: 1,
    //     strokeColor: Colors.grey,
    //     circleId: const CircleId("pickUpId"));
    //
    // Circle dropOffLocCircle = Circle(
    //     fillColor: Colors.white,
    //     radius: 6.0,
    //     center: dropOfLatling,
    //     strokeWidth: 1,
    //     strokeColor: Colors.grey,
    //     circleId: const CircleId("dropOfId"));
    // circlesSet.add(pickUpLocCircle);
    // circlesSet.add(dropOffLocCircle);
    setState(() {});
  }

  //3..this method for live location when updating on map and set to realtime
  Future<void> getRideLiveLocationUpdate() async {
    late LocationSettings _locationSettings;
    myPosition = Provider.of<DriverCurrentPosition>(context, listen: false)
        .currentPosition;
    if (defaultTargetPlatform == TargetPlatform.android) {
      _locationSettings = AndroidSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 50,
          forceLocationManager: false,
          intervalDuration: const Duration(milliseconds: 1000),
          foregroundNotificationConfig: ForegroundNotificationConfig(
            notificationText: AppLocalizations.of(context)!.locationBackground,
            notificationTitle: "Garanti taxi",
            enableWakeLock: true,
          ));
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      _locationSettings = AppleSettings(
        accuracy: LocationAccuracy.high,
        activityType: ActivityType.automotiveNavigation,
        distanceFilter: 50,
        pauseLocationUpdatesAutomatically: false,
        showBackgroundLocationIndicator: true,
      );
    } else {
      _locationSettings = const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 50,
      );
    }

    newRideScreenStreamSubscription =
        Geolocator.getPositionStream(locationSettings: _locationSettings)
            .listen((Position position) async {
      setState(() {
        myPosition = position;
      });
      LatLng mPosition = LatLng(myPosition!.latitude, myPosition!.longitude);
      // LatLng oldLat = const LatLng(0, 0);
      // final rot = MapToolKit.getMarkerRotation(oldLat.latitude,
      //     oldLat.longitude, myPosition?.latitude, myPosition?.longitude);
      Marker anmiatedMarker = Marker(
          markerId: const MarkerId("animating"),
          infoWindow: const InfoWindow(title: "Current Location"),
          position: mPosition,
          icon: anmiatedMarkerIcon,
          rotation: myPosition?.heading ?? 0.0,
          flat: true);

      setState(() {
        CameraPosition cameraPosition = CameraPosition(
            target: mPosition,
            zoom: 16.50,
            tilt: 10.0,
            bearing: myPosition?.heading ?? 0.0);
        newRideControllerGoogleMap
            .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
        markersSet.removeWhere((ele) => ele.markerId.value == "animating");
        markersSet.add(anmiatedMarker);
      });

      // oldLat = mPosition;
      updateDirectionDetails(position);

      final riderId =
          Provider.of<RideRequestInfoProvider>(context, listen: false)
              .rideDetails
              .userId;

      Map driveLoc = {
        "latitude": myPosition?.latitude.toString(),
        "longitude": myPosition?.longitude.toString(),
      };
      final _ref = rideRequestRef.child(riderId);
      _ref.update(
          {"driverLocation": driveLoc, "heading": myPosition?.heading ?? 180});
    });
  }

  /*5..this method for update rider info to driver first when driver go to rider
* pickUp location after that when driver arrived info will changed to dropOff
* location where rider want to go + time trip */
  void updateDirectionDetails(Position livePosition) async {
    final driverLivePosition =
        LatLng(livePosition.latitude, livePosition.longitude);
    final riderInfo =
        Provider.of<RideRequestInfoProvider>(context, listen: false)
            .rideDetails;
    LatLng desertionLatLng;
    if (myPosition == null) {
      return;
    } else {
      if (status == "accepted") {
        desertionLatLng = riderInfo.pickup;
        final details = await ApiSrvDir.obtainPlaceDirectionDetails(
            driverLivePosition, desertionLatLng, context);
        addPolyline(details!, desertionLatLng);
      } else {
        return;
      }
    }
  }

  // contact to method getPlaceDirection
  // void createPickUpRideIcon() {
  //   ImageConfiguration imageConfiguration =
  //       createLocalImageConfiguration(context, size: const Size(1.0, 1.0));
  //   BitmapDescriptor.fromAssetImage(
  //           imageConfiguration,
  //           Platform.isIOS
  //               ? "images/100currentlocationicon.png"
  //               : "images/100currentlocationiconAn.png")
  //       .then((value) {
  //     pickUpIcon = value;
  //   });
  // }

// contact to method getPlaceDirection
  void createDropOffIcon() {
    ImageConfiguration imageConfiguration =
        createLocalImageConfiguration(context, size: const Size(1.0, 0.5));
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

// 4..this method for icon car
  void createDriverNearIcon() {
    final carType = Provider.of<DriverInfoModelProvider>(context, listen: false)
        .driverInfo
        .carType;
    ImageConfiguration imageConfiguration =
        createLocalImageConfiguration(context, size: const Size(0.6, 0.6));
    if (carType.contains("Taxi-4 seats")) {
      BitmapDescriptor.fromAssetImage(
              imageConfiguration,
              Platform.isIOS
                  ? "images/yellow_ios.png"
                  : "images/yellow_and.png")
          .then((value) {
        anmiatedMarkerIcon = value;
      });
    } else {
      BitmapDescriptor.fromAssetImage(imageConfiguration,
              Platform.isIOS ? "images/black_ios.png" : "images/black_and.png")
          .then((value) {
        anmiatedMarkerIcon = value;
      });
    }
  }

  /*6.. this method for change Status & title-color arrived button from
  & driver loc to rider pickUp loc then from rider pickUp to rider drop
  then update status on fire base
  */
  Future<void> changeColorArrivedAndTileButton(
      BuildContext context, RideDetails rideInfoProvider) async {
    final _ref = rideRequestRef.child(rideInfoProvider.userId).child("status");

    if (status == "accepted") {
      status = "arrived";
      Provider.of<TitleArrived>(context, listen: false)
          .updateState(AppLocalizations.of(context)!.startTrip);
      Provider.of<ColorButtonArrived>(context, listen: false)
          .updateState(Colors.yellowAccent.shade700);
      timerStop1.cancel();
      _ref.set(status);
      timer2();
      getPlaceDirection(
          context, rideInfoProvider.pickup, rideInfoProvider.dropoff);
    } else if (status == "arrived") {
      status = "onride";
      Provider.of<TitleArrived>(context, listen: false)
          .updateState(AppLocalizations.of(context)!.endTrip);
      Provider.of<ColorButtonArrived>(context, listen: false)
          .updateState(Colors.redAccent.shade700);
      _ref.set(status);
      timerStop2.cancel();
      time3(context, myPosition!, rideInfoProvider.dropoff);
      initTimer();
    } else if (status == "onride") {
      endTrip(rideInfoProvider, context);
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
  void endTrip(RideDetails rideInfoProvider, BuildContext context) async {
    final _ref = rideRequestRef.child(rideInfoProvider.userId);
    timer.cancel();
    timerStop3.cancel();
    Provider.of<NewRideScreenIndector>(context, listen: false)
        .updateState(true);
    status = "ended";
    Provider.of<TitleArrived>(context, listen: false)
        .updateState(AppLocalizations.of(context)!.arrived);
    Provider.of<ColorButtonArrived>(context, listen: false)
        .updateState(Colors.white);
    _ref.child("status").set(status);
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
    _ref.child("total").set(totalAmount.toString());
    newRideScreenStreamSubscription?.cancel();
    isDriverCollectMoney = true;
    await saveEarning(totalAmount);
    await saveTripHistory(rideInfoProvider, totalAmount);
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => collectMoney(context, rideInfoProvider, totalAmount));
  }

  // this method for save earning money in database
  Future<void> saveEarning(int totalAmount) async {
    final ref = driverRef.child(userId).child("earning");
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
  Future<void> saveTripHistory(
      RideDetails rideInfoProvider, int totalAmount) async {
    final ref = driverRef.child(userId).child("history");
    await ref.child(rideInfoProvider.userId).set({
      "pickAddress": rideInfoProvider.pickupAddress,
      "dropAddress": rideInfoProvider.dropoffAddress,
      "total": totalAmount.toStringAsFixed(2),
      "trip": "don"
    });
  }

  ///================================End=========================================

  ///=================================Start Navigation=============================
// installation mapBox navigation
  Future<void> installationMapBoxNav() async {
    if (!mounted) return;
    directions = MapBoxNavigation(onRouteEvent: _onRouteEvent);
    // String platformVersion;
    // // Platform messages may fail, so we use a try/catch PlatformException.
    // try {
    //   platformVersion = await directions.platformVersion;
    // } on PlatformException {
    //   platformVersion = 'Failed to get platform version.';
    // }
    // setState(() {
    //   _platformVersion = platformVersion;
    // });
  }

// draw rot mapBox navigation
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

// switch lang map Box
  String mapBoxLanguages() {
    String lan = "tr";
    if (AppLocalizations.of(context)!.rider == "Yolcuya git") {
      setState(() {
        lan = "tr";
      });
    } else if (AppLocalizations.of(context)!.rider == "اذهب الى الراكب") {
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

  // this method for Navigation between driver and pickUp rider
  Future<void> navigationDriverToRiderMapBox(BuildContext c) async {
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

  //this method for open google Map driver to rider nav
  Future<void> navigationDriverToRiderGoogleNav(BuildContext context) async {
    final rideInfo =
        Provider.of<RideRequestInfoProvider>(context, listen: false)
            .rideDetails;

    var _urlNavAndroid = Uri.parse(
        'google.navigation:q=${rideInfo.pickup.latitude},${rideInfo.pickup.longitude}&key=$mapKey');
    var _urlGoogleMapIos = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=${rideInfo.pickup.latitude},${rideInfo.pickup.longitude}');
    if (Platform.isAndroid) {
      await canLaunchUrl(_urlNavAndroid)
          ? launchUrl(_urlNavAndroid, mode: LaunchMode.externalApplication)
          : Tools().toastMsg(AppLocalizations.of(context)!.wrong, Colors.red);
    } else if (Platform.isIOS) {
      await canLaunchUrl(_urlGoogleMapIos)
          ? launchUrl(_urlGoogleMapIos, mode: LaunchMode.externalApplication)
          : Tools().toastMsg(AppLocalizations.of(context)!.wrong, Colors.red);
    }
  }

  //this method for open google Map trip rider navigation
  Future<void> openGoogleMapTripNav() async {
    final rideInfo =
        Provider.of<RideRequestInfoProvider>(context, listen: false)
            .rideDetails;
    var androidUrl = Uri.parse(
        'https://www.google.com/maps/dir/${rideInfo.pickup.latitude},${rideInfo.pickup.longitude}/${rideInfo.dropoffAddress},+${rideInfo.dropoffAddress}/@${rideInfo.dropoff.latitude},${rideInfo.dropoff.longitude},13z/');
    var iosUrl = Uri.parse(
        "https://www.google.com/maps/search/?api=1&query=${rideInfo.dropoff.latitude},${rideInfo.dropoff.longitude}");
    if (Platform.isIOS) {
      await canLaunchUrl(iosUrl)
          ? launchUrl(iosUrl, mode: LaunchMode.externalApplication)
          : Tools().toastMsg(AppLocalizations.of(context)!.wrong, Colors.red);
    } else if (Platform.isAndroid) {
      await canLaunchUrl(androidUrl)
          ? launchUrl(androidUrl, mode: LaunchMode.externalApplication)
          : Tools().toastMsg(AppLocalizations.of(context)!.wrong, Colors.red);
    }
    // String url =
    //     "https://www.google.com/maps/dir/${rideInfo.pickup.latitude},${rideInfo.pickup.longitude}/${rideInfo.dropoffAddress},+${rideInfo.dropoffAddress}/@${rideInfo.dropoff.latitude},${rideInfo.dropoff.longitude},13z/";
  }

  // this method for switch any navigation MapBox or googleMap
  Future<void> switchGoToRiderOrTrip() async {
    await driverRef.child(userId).child("map").once().then((value) async {
      if (value.snapshot.exists && value.snapshot.value != null) {
        final snap = value.snapshot.value;
        String _mapBox = snap.toString();
        if (_mapBox == "mapbox") {
          await navigationDriverToRiderMapBox(context);
        } else {
          await navigationDriverToRiderGoogleNav(context);
        }
      }
    });
  }

  ///==================================End Navigation==============================
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

// this method for remember driver to click button when start trip
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

  // this method calc time trip when than myPosition == drop notify end trip
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
}

// this method for Navigation between pickUp to drop of rider
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
///
// this method for switch title button nuv connect to status ride
//   String switchTitleButtonNav() {
//     String _text = '';
//     if (status == "accepted") {
//       _text = AppLocalizations.of(context)!.rider;
//     } else {
//       _text = AppLocalizations.of(context)!.toTrip;
//     }
//     return _text;
//   }
