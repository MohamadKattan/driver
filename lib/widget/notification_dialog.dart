// this widget dialog notification show to driver for accept or cancel order
import 'dart:async';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../config.dart';
import '../model/rideDetails.dart';
import '../my_provider/driver_model_provider.dart';
import '../my_provider/new_ride_indector.dart';
import '../my_provider/ride_request_info.dart';
import '../repo/geoFire_srv.dart';
import '../tools/play_sounds.dart';
import '../tools/tools.dart';
import '../user_screen/new_ride_screen.dart';
import '../widget/custom_divider.dart';

class NotificationDialog extends StatefulWidget {
  const NotificationDialog(BuildContext context, {Key? key}) : super(key: key);

  @override
  State<NotificationDialog> createState() => _NotificationDialogState();
}

class _NotificationDialogState extends State<NotificationDialog> {
  final player = PlaySoundTool();
  final AssetsAudioPlayer _assetsAudioPlayer = AssetsAudioPlayer();

  @override
  void initState() {
    AssetsAudioPlayer.newPlayer()
        .open(Audio("sounds/new_order.mp3"), autoStart: true);
    super.initState();
  }

  @override
  void dispose() {
    _assetsAudioPlayer.dispose();
    super.dispose();
  }

  bool buttonAccepted = false;

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
        decoration: const BoxDecoration(color: Colors.white),
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
                  Text("Fare : \$${rideInfoProvider.amount}",
                      style: const TextStyle(
                          color: Colors.black45, fontSize: 16.0))
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
                    onTap: () {
                      _assetsAudioPlayer.stop();
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
                  GestureDetector(
                    onTap: () {
                      checkAvailableOfRide(context, rideInfoProvider);
                      _assetsAudioPlayer.stop();
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
                  ),
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
        Tools().toastMsg("Ride not exist");
        rideRequestRef.set("searching");
        Navigator.pop(context);
      }
      //id in newRide value = rider id from Ride Request collection
      if (newRideState == rideInfoProvider.userId) {
        GeoFireSrv().displayLocationLiveUpdates();
        await rideRequestRef.set("accepted").whenComplete(() {
          Provider.of<NewRideScreenIndector>(context, listen: false)
              .updateState(true);
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => const NewRideScreen()));
        });
      } else if (newRideState == "canceled") {
        Tools().toastMsg("Ride has been canceled ");
        rideRequestRef.set("searching");
        Navigator.pop(context);
      } else if (newRideState == "timeOut") {
        rideRequestRef.set("searching");
        Tools().toastMsg("Ride timeOut");
        Navigator.pop(context);
      } else {
        rideRequestRef.set("searching");
        Tools().toastMsg("Ride not exist");
        Navigator.pop(context);
      }
    });
  }

  // this method if driver press cancel button
  Future<void> driverCancelOrder(BuildContext context) async {
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

    const duration = Duration(seconds: 1);
    final _timer = Timer.periodic(duration, (timer) {
      rideRequestTimeOut = rideRequestTimeOut - 1;
      if (rideRequestTimeOut == 0) {
        rideRequestRef.set("searching");
        timer.cancel();
        rideRequestTimeOut = 30;
      }
    });
  }
}