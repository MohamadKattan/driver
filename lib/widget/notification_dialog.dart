// this widget dialog notification show to driver for accept or cancel order
import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:driver/tools/curanny_type.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../config.dart';
import '../model/rideDetails.dart';
import '../my_provider/driver_currentPosition_provider.dart';
import '../my_provider/driver_model_provider.dart';
import '../my_provider/ride_request_info.dart';
import '../repo/geoFire_srv.dart';
import '../tools/tools.dart';
import '../user_screen/new_ride_screen.dart';
import '../widget/custom_divider.dart';


class NotificationDialog extends StatefulWidget {
  const NotificationDialog(BuildContext context, {Key? key}) : super(key: key);

  @override
  State<NotificationDialog> createState() => _NotificationDialogState();
}

class _NotificationDialogState extends State<NotificationDialog> {
  bool buttonAccepted = false;
  AudioPlayer audioPlayer = AudioPlayer();
  late AudioCache audioCache;
  String path = "new_order.mp3";
  bool isHideButton = false;

  @override
  void initState() {
    audioCache = AudioCache(fixedPlayer: audioPlayer,prefix:"sounds/");
    playSound();
    super.initState();
  }
  @override
  void dispose() {
    audioPlayer.release();
    audioPlayer.dispose();
    audioCache.clearAll();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final rideInfoProvider =
        Provider.of<RideRequestInfoProvider>(context, listen: false)
            .rideDetails;
    return Dialog(
      elevation: 1.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      backgroundColor: Colors.transparent,
      child: Container(
        height: MediaQuery.of(context).size.height * 65 / 100,
        width: double.infinity,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(6.0),color: Colors.white),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Center(
                  child: Lottie.asset('images/lf30_editor_mtfshyfg.json',
                      height: 160, width: 160)),
              const Text(
                "New ride request",
                style: TextStyle(
                    color: Colors.black87,
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 3 / 100),
              Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 8.0,
                        right: 8,
                      ),
                      child: Center(
                          child: Lottie.asset(
                              'images/lf30_editor_bkpvlwi9.json',
                              height: 20,
                              width: 20)),
                    ),
                    Text("From : ",
                        style: TextStyle(
                            color: Colors.greenAccent.shade700, fontSize: 14)),
                    Expanded(
                        flex: 1,
                        child: Text(rideInfoProvider.pickupAddress,
                            style: const TextStyle(
                                color: Colors.black45,
                                fontSize: 18.0,
                                overflow: TextOverflow.ellipsis)))
                  ]),
              SizedBox(height: MediaQuery.of(context).size.height * 3 / 100),
              Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: Center(
                          child: Lottie.asset(
                              'images/lf30_editor_bkpvlwi9.json',
                              height: 20,
                              width: 20)),
                    ),
                    Text("To : ",
                        style: TextStyle(
                            color: Colors.redAccent.shade700, fontSize: 14)),
                    Expanded(
                      child: Text(rideInfoProvider.dropoffAddress,
                          style: const TextStyle(
                              color: Colors.black45,
                              fontSize: 18.0,
                              overflow: TextOverflow.ellipsis)),
                    )
                  ]),
              SizedBox(height: MediaQuery.of(context).size.height * 4 / 100),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text("Km : ${rideInfoProvider.km}",
                      style: const TextStyle(
                          color: Colors.black45, fontSize: 16.0)),
                  Text("Fare : ${currencyTypeCheck(context)} : ${rideInfoProvider.amount}",
                      style:  TextStyle(
                          color: Colors.redAccent.shade700, fontSize: 20.0))
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 2 / 100),
              CustomDivider().customDivider(),
              SizedBox(height: MediaQuery.of(context).size.height * 3 / 100),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () async {
                      stopSound();
                      driverCancelOrder(context);
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 30 / 100,
                      height: MediaQuery.of(context).size.height * 7 / 100,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2.0),
                          color: Colors.redAccent.shade700),
                      child: const Center(
                          child: Text(
                        "Cancel",
                        style: TextStyle(color: Colors.white),
                      )),
                    ),
                  ),
                  isHideButton==false?
                  GestureDetector(
                    onTap: () async {
                    stopSound();
                      checkAvailableOfRide(context, rideInfoProvider);
                      setState(() {
                        isHideButton=true;
                      });
                    },
                    child: Container(
                        width: MediaQuery.of(context).size.width * 30 / 100,
                        height: MediaQuery.of(context).size.height * 7 / 100,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2.0),
                            color: Colors.green.shade700),
                        child: const Center(
                            child: Text(
                          "Accept",
                          style: TextStyle(color: Colors.white),
                        ))),
                  )
                      :Container(
                          width: MediaQuery.of(context).size.width * 30 / 100,
                          height: MediaQuery.of(context).size.height * 7 / 100,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2.0),
                              color: Colors.green.shade700),
                          child: const Center(
                              child: Text(
                                "Accept",
                                style: TextStyle(color: Colors.white),
                              )))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // this method when driver got a new request rider and he accepted it will check state for this ride
  Future<void> checkAvailableOfRide(
      BuildContext context, RideDetails rideInfoProvider) async {
    // Navigator.pop(context);
    final currentUseId =
        Provider.of<DriverInfoModelProvider>(context, listen: false)
            .driverInfo
            .userId;
    String newRideState = "";
    // first listing to value newRide in driver collection to check value state
    DatabaseReference rideRequestRef = FirebaseDatabase.instance
        .ref()
        .child("driver")
        .child(currentUseId)
        .child("newRide");

    await rideRequestRef.once().then((value) async {
      if (value.snapshot.value != null) {
        newRideState = value.snapshot.value.toString();
      } else {
        Tools().toastMsg("Ride not exist",Colors.redAccent.shade700);
        rideRequestRef.set("searching");
        Navigator.pop(context);
      }
      //id in newRide value = rider id from Ride Request collection
      if (newRideState == rideInfoProvider.userId) {
        homeScreenStreamSubscription?.pause();
        Geofire.stopListener();
        Geofire.removeLocation(currentUseId);
       await GeoFireSrv().displayLocationLiveUpdates();
        await rideRequestRef.set("accepted").whenComplete(() {
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => const NewRideScreen()));
        });
      } else if (newRideState == "canceled") {
        Tools().toastMsg("Ride has been canceled",Colors.redAccent.shade700);
        rideRequestRef.set("searching");
        Navigator.pop(context);
      } else if (newRideState == "timeOut") {
        rideRequestRef.set("searching");
        Tools().toastMsg("Ride timeOut",Colors.redAccent.shade700);
        Navigator.pop(context);
      } else {
        rideRequestRef.set("searching");
        Tools().toastMsg("Ride not exist",Colors.redAccent.shade700);
        Navigator.pop(context);
      }
    });
    setState(() {
       isHideButton = false;
    });
  }

  // this method if driver press cancel button
  Future<void> driverCancelOrder(BuildContext context) async {
    final position = Provider.of<DriverCurrentPosition>(context, listen: false)
        .currentPosition;
    final currentUseId =
        Provider.of<DriverInfoModelProvider>(context, listen: false)
            .driverInfo
            .userId;
    DatabaseReference rideRequestRef = FirebaseDatabase.instance
        .ref()
        .child("driver")
        .child(currentUseId)
        .child("newRide");

  rideRequestRef.onDisconnect();
    rideRequestRef.remove();
    homeScreenStreamSubscription?.pause();
    Geofire.stopListener();
    Geofire.removeLocation(currentUseId);

    const duration = Duration(seconds: 1);
    Timer.periodic(duration, (timer) async {
      rideRequestTimeOut = rideRequestTimeOut - 1;
      if (rideRequestTimeOut == 0) {
        timer.cancel();
        homeScreenStreamSubscription?.resume();
        await Geofire.setLocation(
            currentUseId, position.latitude, position.longitude);
        rideRequestRef.set("searching");
        rideRequestTimeOut = 120;
      }
    });
  }

 Future <void> playSound()async {
   await audioCache.play(path);
 }
  Future <void> stopSound()async {
    await audioPlayer.stop();
  }
}

