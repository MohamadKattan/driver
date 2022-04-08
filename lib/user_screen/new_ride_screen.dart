import 'dart:async';
import 'package:driver/model/rideDetails.dart';
import 'package:driver/repo/auth_srv.dart';
import 'package:driver/user_screen/turn_by_nav.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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
import '../tools/maps_tooL_kit.dart';
import '../tools/url_lunched.dart';
import '../widget/collect_money_dialog.dart';
import '../widget/custom_circuler.dart';
import '../widget/custom_divider.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class NewRideScreen extends StatefulWidget {
  const NewRideScreen({Key? key}) : super(key: key);

  final CameraPosition kGooglePlex = const CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 11.0,
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
  final locationOptions =
      const LocationSettings(accuracy: LocationAccuracy.bestForNavigation);
  late BitmapDescriptor anmiatedMarkerIcon;
  late BitmapDescriptor pickUpIcon;
  late BitmapDescriptor dropOffIcon;
  late Position? myPosition;
  String status = "accepted";
  bool isRequestDirection = false;
  late Timer timer;
  int durationContour = 0;

  @override
  void initState() {
    acceptedRideRequest();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    createPickUpRideIcon();
    createDropOffIcon();
    createDriverNearIcon();
    final rideInfoProvider =
        Provider.of<RideRequestInfoProvider>(context).rideDetails;
    final initialPos =
        Provider.of<DriverCurrentPosition>(context, listen: false)
            .currentPosition;
    final directionDetails =
        Provider.of<DirectionDetailsPro>(context).directionDetails;
    final buttonTitle = Provider.of<TitleArrived>(context).titleButton;
    final buttonColor = Provider.of<ColorButtonArrived>(context).colorButton;
    final isInductor = Provider.of<NewRideScreenIndector>(context).isInductor;
    return SafeArea(
        child: Scaffold(
            body: Stack(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height,
          child: GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: const NewRideScreen().kGooglePlex,
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            trafficEnabled: false,
            liteModeEnabled: true,
            markers: markersSet,
            polylines: polylineSet,
            circles: circlesSet,
            minMaxZoomPreference: const MinMaxZoomPreference(12.0, 17.0),
            onMapCreated: (GoogleMapController controller) async {
              controllerGoogleMap.complete(controller);
              newRideControllerGoogleMap = controller;
              LatLng startPontLoc =
                  LatLng(initialPos.latitude, initialPos.longitude); //driver
              LatLng secondPontLoc = LatLng(rideInfoProvider.pickup.latitude,
                  rideInfoProvider.pickup.longitude); //rider pickUp
              await getPlaceDirection(context, startPontLoc, secondPontLoc);
              getRideLiveLocationUpdate();
            },
          ),
        ),
        Positioned(
            left: 0.0,
            right: 0.0,
            bottom: 0.0,
            child: Container(
              height: MediaQuery.of(context).size.height * 40 / 100,
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
                          "Time : " + directionDetails.durationText,
                          style: const TextStyle(
                              color: Colors.black45, fontSize: 18.0),
                        ),
                        Text(
                          "Fare : \$ " + rideInfoProvider.amount,
                          style: TextStyle(
                              color: Colors.greenAccent.shade700,
                              fontSize: 18.0),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 12.0),
                          child: Text(
                            "Rider name : ${rideInfoProvider.riderName}",
                            style: const TextStyle(
                                color: Colors.black, fontSize: 20.0),
                          ),
                        ),
                        Column(
                          children: [
                            IconButton(
                                onPressed: () {
                                  ToUrlLunch().toCallLunch(
                                      phoneNumber: rideInfoProvider.riderPhone);
                                },
                                icon: Icon(
                                  Icons.phone,
                                  color: Colors.greenAccent.shade700,
                                  size: 20.0,
                                )),
                            IconButton(
                                onPressed: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (_) {
                                    return const TurnByNav();
                                  }));
                                },
                                icon: Icon(
                                  Icons.map,
                                  color: Colors.blue.shade700,
                                  size: 20.0,
                                )),
                          ],
                        ),
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
                          Text("From : ",
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
                              padding:
                                  const EdgeInsets.only(left: 8.0, right: 8.0),
                              child: Icon(
                                Icons.add_location_alt_outlined,
                                color: Colors.redAccent.shade700,
                                size: 20.0,
                              )),
                          Text("To : ",
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
                      height: 3.0,
                    ),
                    CustomDivider().customDivider(),
                    const SizedBox(
                      height: 3.0,
                    ),
                    GestureDetector(
                      onTap: () {
                        changeColorArrivedAndTileButton(
                            context, rideInfoProvider);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: Container(
                            width: MediaQuery.of(context).size.width * 60 / 100,
                            height:
                                MediaQuery.of(context).size.height * 7 / 100,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3.0),
                                color: buttonColor),
                            child: Center(
                                child: Text(
                              buttonTitle,
                              style: const TextStyle(color: Colors.white),
                            ))),
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
    )));
  }

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
    BuildContext context,
    LatLng startPontLoc,
    LatLng secondPontLoc,
  ) async {
    // from api geo driver current location
    final initialPos = startPontLoc;

    // rider current location from database Ride request collection
    final finalPos = secondPontLoc;

    final pickUpLatling = LatLng(initialPos.latitude, initialPos.longitude);
    print("thisfinalPos Driver $pickUpLatling");

    final dropOfLatling = LatLng(finalPos.latitude, finalPos.longitude);
    print("thisfinalPos rider $dropOfLatling");

    ///from api dir
    final details = await ApiSrvDir.obtainPlaceDirectionDetails(
        pickUpLatling, dropOfLatling, context);

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
          color: Colors.red,
          width: 6,
          geodesic: true,
          startCap: Cap.roundCap,
          endCap: Cap.roundCap,
          jointType: JointType.round,
          points: polylineCoordinates);

      ///set from above
      polylineSet.add(polyline);
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
    // }
    // else {
    //   latLngBounds =
    //       LatLngBounds(southwest: dropOfLatling, northeast: pickUpLatling);
    // }
    // newRideControllerGoogleMap
    //     .animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 70));

    ///Marker
    Marker markerPickUpLocation = Marker(
        icon: pickUpIcon,
        position: LatLng(pickUpLatling.latitude, pickUpLatling.longitude),
        markerId: const MarkerId("pickUpId"));

    Marker markerDropOfLocation = Marker(
        icon: dropOffIcon,
        position: LatLng(dropOfLatling.latitude, dropOfLatling.longitude),
        markerId: const MarkerId("dropOfId"));

    setState(() {
      markersSet.add(markerPickUpLocation);
      markersSet.add(markerDropOfLocation);
    });

    ///Circle
    Circle pickUpLocCircle = Circle(
        fillColor: Colors.white,
        radius: 8.0,
        center: pickUpLatling,
        strokeWidth: 2,
        strokeColor: Colors.grey,
        circleId: const CircleId("pickUpId"));

    Circle dropOffLocCircle = Circle(
        fillColor: Colors.white,
        radius: 8.0,
        center: dropOfLatling,
        strokeWidth: 2,
        strokeColor: Colors.grey,
        circleId: const CircleId("dropOfId"));
    setState(() {
      circlesSet.add(pickUpLocCircle);
      circlesSet.add(dropOffLocCircle);
    });

    const _duration = Duration(seconds: 1);
    int timeCount = 10;
    final _timer = Timer.periodic(_duration, (timer) {
      timeCount = timeCount - 1;
      if (timeCount == 0) {
        timer.cancel();
        timeCount = 10;

        ///todo
        Provider.of<NewRideScreenIndector>(context, listen: false)
            .updateState(false);
      }
    });
    if (kDebugMode) {
      print("this is details enCodingPoints:::::: ${details.enCodingPoints}");
    }
  }

// contact to method getPlaceDirection
  void createPickUpRideIcon() {
    ImageConfiguration imageConfiguration =
        createLocalImageConfiguration(context, size: const Size(0.6, 0.6));
    BitmapDescriptor.fromAssetImage(
            imageConfiguration, "images/passenger_location.png")
        .then((value) {
      setState(() {
        pickUpIcon = value;
      });
    });
  }

// contact to method getPlaceDirection
  void createDropOffIcon() {
    ImageConfiguration imageConfiguration =
        createLocalImageConfiguration(context, size: const Size(0.6, 0.6));
    BitmapDescriptor.fromAssetImage(
            imageConfiguration, "images/desenation_icon.png")
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
        // icon: anmiatedMarkerIcon,
        rotation: rot,
      );

      ///...
      setState(() {
        CameraPosition cameraPosition =
            CameraPosition(target: mPosition, zoom: 14);
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
    BitmapDescriptor.fromAssetImage(imageConfiguration, "images/car_icon.png")
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
  void changeColorArrivedAndTileButton(
      BuildContext context, RideDetails rideInfoProvider) async {
    DatabaseReference rideRequestRef = FirebaseDatabase.instance
        .ref()
        .child("Ride Request")
        .child(rideInfoProvider.userId);

    if (status == "accepted") {
      setState(() {
        status = "arrived";
      });
      rideRequestRef.child("status").set(status);
      Provider.of<TitleArrived>(context, listen: false)
          .updateState("Start trip");
      Provider.of<ColorButtonArrived>(context, listen: false)
          .updateState(Colors.yellowAccent.shade700);
      await getPlaceDirection(
          context, rideInfoProvider.pickup, rideInfoProvider.dropoff);
    } else if (status == "arrived") {
      setState(() {
        status = "onride";
      });
      Provider.of<TitleArrived>(context, listen: false).updateState("End trip");
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

    ///todo
    Provider.of<NewRideScreenIndector>(context, listen: false)
        .updateState(true);
    setState(() {
      status = "ended";
    });
    Provider.of<TitleArrived>(context, listen: false).updateState("Arrived");
    Provider.of<ColorButtonArrived>(context, listen: false)
        .updateState(Colors.greenAccent.shade700);
    rideRequestRef.child("status").set(status);
    final driverCurrentLoc =
        LatLng(myPosition!.latitude, myPosition!.longitude);
    final riderFirstPickUp = LatLng(
        rideInfoProvider.pickup.latitude, rideInfoProvider.pickup.longitude);
    final directionDetails = await ApiSrvDir.obtainPlaceDirectionDetails(
        riderFirstPickUp, driverCurrentLoc, context);

    /// todo
    Provider.of<NewRideScreenIndector>(context, listen: false)
        .updateState(false);
    int totalAmount = ApiSrvDir.calculateFares(directionDetails!, "Taxi");
    rideRequestRef.child("total").set(totalAmount.toString());
    newRideScreenStreamSubscription?.cancel();
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => collectMoney(context, rideInfoProvider, totalAmount));
    saveEarning(totalAmount);
    saveTripHistory(rideInfoProvider, totalAmount);
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
}
