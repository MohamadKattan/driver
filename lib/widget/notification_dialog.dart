// this widget dialog notification show to driver for accept or cancel order
import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:driver/tools/background_serv.dart';
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
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    ///stop for ios just
    // audioCache = AudioCache(fixedPlayer: audioPlayer,prefix:"sounds/");
    // _playSound();
    super.initState();
  }

  /// with ios just
  // @override
  // void dispose() {
  //   audioPlayer.release();
  //   audioPlayer.dispose();
  //   audioCache.clearAll();
  //   super.dispose();
  // }

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
        height: MediaQuery.of(context).size.height * 70 / 100,
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6.0), color: Colors.white),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Center(
                  child: Lottie.asset('images/lf30_editor_mtfshyfg.json',
                      height: 140, width: 140)),
              Text(
                AppLocalizations.of(context)!.rideRequest,
                style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
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
                    Text(AppLocalizations.of(context)!.from + " ",
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
              const SizedBox(height: 15),
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
                    Text(AppLocalizations.of(context)!.too + " ",
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
              const SizedBox(height: 15.0),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text("Km : ${rideInfoProvider.km}",
                      style: const TextStyle(
                          color: Colors.black45, fontSize: 16.0)),
                  Text(
                      AppLocalizations.of(context)!.fare +
                          currencyTypeCheck(context) +
                          " : " +
                          rideInfoProvider.amount,
                      style: TextStyle(
                          color: Colors.redAccent.shade700, fontSize: 20.0))
                ],
              ),
              const SizedBox(height: 10.0),
              CustomDivider().customDivider(),
              rideInfoProvider.tourismCityName != ""
                  ?  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        AppLocalizations.of(context)!.fullDay,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: Colors.black45,
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  : const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(""),
                    ),
              rideInfoProvider.tourismCityName != ""
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text( AppLocalizations.of(context)!.ini + " : ${rideInfoProvider.tourismCityName}",
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colors.greenAccent.shade700,
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                    )
                  : const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(""),
                    ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () async {
                      stopSound();

                      ///ios
                      // _stopSound();
                      driverCancelOrder(context);
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 30 / 100,
                      height: MediaQuery.of(context).size.height * 7 / 100,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2.0),
                          color: Colors.redAccent.shade700),
                      child: Center(
                          child: Text(
                        AppLocalizations.of(context)!.cancel,
                        style: const TextStyle(color: Colors.white),
                      )),
                    ),
                  ),
                  isHideButton == false
                      ? GestureDetector(
                          onTap: () async {
                            stopSound();
                            // _stopSound();
                            checkAvailableOfRide(context, rideInfoProvider);
                            setState(() {
                              isHideButton = true;
                            });
                          },
                          child: Container(
                              width:
                                  MediaQuery.of(context).size.width * 30 / 100,
                              height:
                                  MediaQuery.of(context).size.height * 7 / 100,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(2.0),
                                  color: Colors.green.shade700),
                              child: Center(
                                  child: Text(
                                AppLocalizations.of(context)!.ok,
                                style: const TextStyle(color: Colors.white),
                              ))),
                        )
                      : Container(
                          width: MediaQuery.of(context).size.width * 30 / 100,
                          height: MediaQuery.of(context).size.height * 7 / 100,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2.0),
                              color: Colors.green.shade700),
                          child: Center(
                              child: Text(
                            AppLocalizations.of(context)!.ok,
                            style: const TextStyle(color: Colors.white),
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
        Tools().toastMsg(AppLocalizations.of(context)!.beenCanceled,
            Colors.redAccent.shade700);
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
        Tools().toastMsg(AppLocalizations.of(context)!.beenCanceled,
            Colors.redAccent.shade700);
        rideRequestRef.set("searching");
        Navigator.pop(context);
      } else if (newRideState == "timeOut") {
        rideRequestRef.set("searching");
        Tools().toastMsg(
            AppLocalizations.of(context)!.timeOut, Colors.redAccent.shade700);
        Navigator.pop(context);
      } else {
        rideRequestRef.set("searching");
        Tools().toastMsg(AppLocalizations.of(context)!.beenCanceled,
            Colors.redAccent.shade700);
        Navigator.pop(context);
      }
    });
    setState(() {
      isHideButton = false;
    });
  }

  // this method if driver press cancel button
  Future<void> driverCancelOrder(BuildContext context) async {
    DatabaseReference _ref = FirebaseDatabase.instance.ref().child("driver");
    final position = Provider.of<DriverCurrentPosition>(context, listen: false)
        .currentPosition;
    final currentUseId =
        Provider.of<DriverInfoModelProvider>(context, listen: false).driverInfo;

    final newRef = _ref.child(currentUseId.userId).child("newRide");
    newRef.onDisconnect();
    newRef.remove();

    homeScreenStreamSubscription?.pause();
    Geofire.stopListener();
    Geofire.removeLocation(currentUseId.userId);

    _ref.child(currentUseId.userId).child("offLine").set("notAvailable");
    const duration = Duration(seconds: 1);
    Timer.periodic(duration, (timer) async {
      rideRequestTimeOut = rideRequestTimeOut - 1;
      if (rideRequestTimeOut == 0) {
        timer.cancel();
        homeScreenStreamSubscription?.resume();
        await Geofire.setLocation(
            currentUseId.userId, position.latitude, position.longitude);
        _ref.child(currentUseId.userId).child("newRide").set("searching");
        _ref.child(currentUseId.userId).child("offLine").set("Available");
        rideRequestTimeOut = 120;
      }
    });
  }

  ///ios
  Future<void> _playSound() async {
    await audioCache.play(path);
  }

  ///ios
  Future<void> _stopSound() async {
    await audioPlayer.stop();
  }
}
