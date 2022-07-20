import 'dart:async';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:driver/model/rideDetails.dart';
import 'package:driver/repo/auth_srv.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mapbox_navigation/library.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../config.dart';
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
import '../widget/call_rider_phone_whatApp.dart';
import '../widget/collect_money_dialog.dart';
import '../widget/custom_circuler.dart';
import '../widget/custom_divider.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NewRideScreen extends StatefulWidget {
  const NewRideScreen({Key? key}) : super(key: key);

  final CameraPosition kGooglePlex = const CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 17,
    tilt: 45,
    bearing: 45,
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
  int durationContour = 0;
  bool isInductor = false;

  late MapBoxNavigation directions;
   late final MapBoxNavigationViewController _controller;
  bool arrivedMapBox = false;
  String instruction = "";
  bool routeBuilt = false;
  bool isNavigating = false;
  bool isMultipleStop = false;
  late WayPoint sourceWayPoint, distintionWayPoint, sourceWayPointDriver;

  @override
  void initState() {
    acceptedRideRequest();
    inTailiz();
    isInductor = true;
    timer1(context);
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
        Provider.of<DriverCurrentPosition>(context)
            .currentPosition;
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
          SizedBox(
            height: MediaQuery.of(context).size.height,
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
                LatLng startPontLoc =
                    LatLng(initialPos.latitude, initialPos.longitude); //driver
                LatLng secondPontLoc = LatLng(rideInfoProvider.pickup.latitude,
                    rideInfoProvider.pickup.longitude);
                riderName = rideInfoProvider.riderName;
                //rider pickUp
                await getPlaceDirection(context, startPontLoc, secondPontLoc);
                getRideLiveLocationUpdate();
                Provider.of<TitleArrived>(context, listen: false)
                    .updateState(AppLocalizations.of(context)!.arrived);
              },
            ),
          ),
          Positioned(
              left: 0.0,
              right: 0.0,
              bottom: 0.0,
              child: Container(
                height: MediaQuery.of(context).size.height * 30 / 100,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(18.0),
                        topRight: Radius.circular(18.0))),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 3.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.km +
                                directionDetails.distanceText,
                            style: const TextStyle(
                                color: Colors.black45, fontSize: 18.0),
                          ),
                          Text(
                            AppLocalizations.of(context)!.time +
                                directionDetails.durationText,
                            style: const TextStyle(
                                color: Colors.black45, fontSize: 18.0),
                          ),
                          Text(
                            AppLocalizations.of(context)!.fare +
                                currencyTypeCheck(context) +
                                ":" +
                                rideInfoProvider.amount,
                            style: TextStyle(
                                color: Colors.redAccent.shade700,
                                fontSize: 20.0),
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
                                  color: Colors.black, fontSize: 20.0),
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
                                    fontSize: 14)),
                            Expanded(
                                flex: 1,
                                child: Text(rideInfoProvider.pickupAddress,
                                    style: const TextStyle(
                                        color: Colors.black45,
                                        fontSize: 18.0,
                                        overflow: TextOverflow.ellipsis)))
                          ]),
                      const SizedBox(
                        height: 12.0,
                      ),
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
                                    color: Colors.redAccent.shade700,
                                    fontSize: 14)),
                            Text(rideInfoProvider.dropoffAddress,
                                style: const TextStyle(
                                    color: Colors.black45,
                                    fontSize: 18.0,
                                    overflow: TextOverflow.ellipsis))
                          ]),
                      const SizedBox(
                        height: 2.0,
                      ),
                      CustomDivider().customDivider(),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0, top: 8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            status == "onride"
                                ? GestureDetector(
                                    onTap: () {
                                      navigationPickToDrop(context);
                                    },
                                    child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                20 /
                                                100,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                7.5 /
                                                100,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(3.0),
                                            color: Colors.blueAccent.shade700),
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(4.0),
                                              child: Center(
                                                  child: Text(
                                                AppLocalizations.of(context)!
                                                    .toTrip,
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14.0),
                                              )),
                                            ),
                                            const Center(
                                                child: Icon(Icons.map,
                                                    size: 16.0,
                                                    color: Colors.white))
                                          ],
                                        )),
                                  )
                                : const Text(""),
                            GestureDetector(
                              onTap: () {
                                changeColorArrivedAndTileButton(
                                    context, rideInfoProvider);
                              },
                              child: Container(
                                  width: MediaQuery.of(context).size.width *
                                      40 /
                                      100,
                                  height: MediaQuery.of(context).size.height *
                                      7 /
                                      100,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(3.0),
                                      color: Colors.greenAccent.shade700),
                                  child: Center(
                                      child: Text(
                                    buttonTitle,
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(color: buttonColor,fontSize: 16,fontWeight: FontWeight.bold),
                                  ))),
                            ),
                            status == "accepted"
                                ? GestureDetector(
                                    onTap: () {
                                      navigationDriverToPickUpRi(context);
                                    },
                                    child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                20 /
                                                100,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                7.5 /
                                                100,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(3.0),
                                            color:
                                                Colors.purpleAccent.shade700),
                                        child: Column(
                                          children: [
                                            Center(
                                                child: Padding(
                                              padding:
                                                  const EdgeInsets.all(4.0),
                                              child: Text(
                                                AppLocalizations.of(context)!
                                                    .rider,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 10.0),
                                              ),
                                            )),
                                            const Center(
                                                child: Icon(
                                              Icons.map,
                                              color: Colors.white,
                                              size: 14.0,
                                            ))
                                          ],
                                        )),
                                  )
                                : const Text("")
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )),
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

    rideRequestRef.child("status").set("accepted");
    rideRequestRef.child("driverId").set(driverInfo.userId);
    rideRequestRef
        .child("driverName")
        .set("${driverInfo.firstName} ${driverInfo.lastName}");
    rideRequestRef.child("driverPhone").set(driverInfo.phoneNumber);
    rideRequestRef
        .child("carInfo")
        .set("${driverInfo.carBrand} - ${driverInfo.carColor}");
    rideRequestRef.child("driverLocation").set(driveLoc);
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
        target: startPontLoc, zoom: 16.90, tilt: 80.0, bearing: 15.0);
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
          width: 6,
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
        strokeWidth: 2,
        strokeColor: Colors.grey,
        circleId: const CircleId("pickUpId"));

    Circle dropOffLocCircle = Circle(
        fillColor: Colors.white,
        radius: 6.0,
        center: dropOfLatling,
        strokeWidth: 2,
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

    ///for fit line on map PolylinePoints
    // LatLngBounds latLngBounds;
    // if (pickUpLatling.latitude > dropOfLatling.latitude &&
    //     pickUpLatling.longitude > dropOfLatling.longitude) {
    //   latLngBounds =
    //       LatLngBounds(southwest: dropOfLatling, northeast: pickUpLatling);
    // } else if (pickUpLatling.longitude > dropOfLatling.longitude) {
    //   latLngBounds = LatLngBounds(
    //       southwest: LatLng(pickUpLatling.latitude, dropOfLatling.longitude),
    //       northeast: LatLng(dropOfLatling.latitude, pickUpLatling.longitude));
    // } else if (pickUpLatling.latitude > dropOfLatling.latitude) {
    //   latLngBounds = LatLngBounds(
    //       southwest: LatLng(dropOfLatling.latitude, pickUpLatling.longitude),
    //       northeast: LatLng(pickUpLatling.latitude, dropOfLatling.longitude));
    // } else {
    //   latLngBounds =
    //       LatLngBounds(southwest: dropOfLatling, northeast: pickUpLatling);
    // }
    // newGoogleMapController
    //     ?.animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 70));
  }

// contact to method getPlaceDirection
  void createPickUpRideIcon() {
    ImageConfiguration imageConfiguration =
        createLocalImageConfiguration(context, size: const Size(1.0, 1.0));
    BitmapDescriptor.fromAssetImage(
            imageConfiguration, "images/100currentlocationicon.png")
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
                ? "images/100passengerlocationicon.png"
                : "images/100flagblackwhite.png")
        .then((value) {
      setState(() {
        dropOffIcon = value;
      });
    });
  }

  //3..this method for live location when updating on map and set to realtime
  void getRideLiveLocationUpdate() {
    newRideScreenStreamSubscription =
        Geolocator.getPositionStream().listen((Position position) async {
      LatLng oldLat = const LatLng(0, 0);
      myPosition = position;
      LatLng mPosition = LatLng(position.latitude, position.longitude);

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
            target: mPosition, zoom: 16.90, tilt: 80.0, bearing: 15.0);
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
            imageConfiguration, "images/100navigation.png")
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
  * & driver loc to rider pickUp loc then from rider pickUp to rider drop
  * then update status on fire base
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
      timerStop1.cancel();
      rideRequestRef.child("status").set(status);
      Provider.of<TitleArrived>(context, listen: false)
          .updateState(AppLocalizations.of(context)!.startTrip);
      Provider.of<ColorButtonArrived>(context, listen: false)
          .updateState(Colors.yellowAccent.shade700);
      timer2();
      await getPlaceDirection(
          context, rideInfoProvider.pickup, rideInfoProvider.dropoff);
    } else if (status == "arrived") {
      setState(() {
        status = "onride";
      });
      timerStop2.cancel();
      var count = Provider.of<DirectionDetailsPro>(context, listen: false)
          .directionDetails
          .durationVale;
      timerStop3 = Timer.periodic(const Duration(milliseconds: 1400), (timer) {
        count = count - 1;
        if (count == 0) {
          if (AppLocalizations.of(context)!.day == "Gun") {
            assetsAudioPlayer.open(Audio("sounds/end_trip_tr.mp3"));
          } else if (AppLocalizations.of(context)!.day == "يوم") {
            assetsAudioPlayer.open(Audio("sounds/end_trip_ar.wav"));
          } else {
            assetsAudioPlayer.open(Audio("sounds/end_trip_en.wav"));
          }
          timer.cancel();
          timerStop3.cancel();
        } else if (status == "ended") {
          timer.cancel();
          timerStop3.cancel();
        }
      });
      Provider.of<TitleArrived>(context, listen: false)
          .updateState(AppLocalizations.of(context)!.endTrip);
      Provider.of<ColorButtonArrived>(context, listen: false)
          .updateState(Colors.redAccent.shade700);
      rideRequestRef.child("status").set(status);
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
    final directionDetails = await ApiSrvDir.obtainPlaceDirectionDetails(
        riderFirstPickUp, driverCurrentLoc, context);

    Provider.of<NewRideScreenIndector>(context, listen: false)
        .updateState(false);
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
  navigationDriverToPickUpRi(BuildContext c) async {
    final rideInfo =
        Provider.of<RideRequestInfoProvider>(c, listen: false).rideDetails;

    sourceWayPointDriver = WayPoint(
        name: "Driver",
        latitude: myPosition?.latitude,
        longitude: myPosition?.longitude);
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
            initialLatitude: myPosition?.latitude ,
            initialLongitude: myPosition?.longitude,
            zoom: 13.0,
            tilt: 0.0,
            bearing: 0.0,
            mode: MapBoxNavigationMode.driving,
            language: mapBoxLanguages()
        ));
  }

  // this method for Navigation between pickUp to drop of rider
  navigationPickToDrop(BuildContext context) async {
    final rideInfo =
        Provider.of<RideRequestInfoProvider>(context, listen: false)
            .rideDetails;

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
            initialLatitude: rideInfo.pickup.latitude,
            initialLongitude: rideInfo.pickup.longitude,
            zoom: 13.0,
            tilt: 0.0,
            bearing: 0.0,
            mode: MapBoxNavigationMode.driving,
            language: mapBoxLanguages()
        ));
  }

  // this method for set lang mapBox
  String mapBoxLanguages(){
    String lan = "tr";
    if(AppLocalizations.of(context)!.rider=="Yolcuya git"){
      setState(() {
        lan = "tr";
      });
    }else if(AppLocalizations.of(context)!.rider=="زبون"){
      setState(() {
        lan = "ar";
      });
    }else{
      setState(() {
        lan = "en";
      });
    }
    return lan;
  }

//==================================End Navigation==============================
  timer1(BuildContext context) {
    const duration = Duration(minutes: 1);
    int timerCount1 = 3;
    timerStop1 = Timer.periodic(duration, (timer) {
      timerCount1 = timerCount1 - 1;
      if (timerCount1 == 0) {
        if (AppLocalizations.of(context)!.day == "Gun") {
          assetsAudioPlayer
              .open(Audio("sounds/notify_passenger_accessing_tr.mp3"));
        } else if (AppLocalizations.of(context)!.day == "يوم") {
          assetsAudioPlayer
              .open(Audio("sounds/notify_passenger_accessing_ar.wav"));
        } else {
          assetsAudioPlayer
              .open(Audio("sounds/notify_passenger_accessing_en.mpeg"));
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

  timer2() {
    const duration = Duration(seconds: 1);
    int _timerCount2 = 5;
    timerStop2 = Timer.periodic(duration, (timer) {
      _timerCount2 = _timerCount2 - 1;
      if (_timerCount2 == 0) {
        if (AppLocalizations.of(context)!.day == "Gun") {
          assetsAudioPlayer.open(Audio("sounds/start_trip_tr.mp3"));
        } else if (AppLocalizations.of(context)!.day == "يوم") {
          assetsAudioPlayer.open(Audio("sounds/start_trip_ar.wav"));
        } else {
          assetsAudioPlayer.open(Audio("sounds/start_trip_en.wav"));
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
}
