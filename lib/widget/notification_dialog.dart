// this widget dialog notification show to driver for accept or cancel order
import 'dart:async';
import 'dart:io';
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
import '../my_provider/driver_model_provider.dart';
import '../my_provider/ride_request_info.dart';
import '../tools/tools.dart';
import '../user_screen/new_ride_screen.dart';
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
  // String path = "new_order.mp3";
  String path = "notify.wav";
  bool isHideButton = false;


  @override
  void initState() {
    ///stop for ios just
    if (Platform.isIOS) {
      audioCache = AudioCache(fixedPlayer: audioPlayer, prefix: "sounds/");
      _playSound();
    }
    super.initState();
  }

  /// with ios just
  @override
  void dispose() {
    if (Platform.isIOS) {
      audioPlayer.release();
      audioPlayer.dispose();
      audioCache.clearAll();
    }
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
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(width: 2.0, color: Colors.white),
            color: const Color(0xFF00A3E0)),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Center(
                  child: Lottie.asset('images/lf30_editor_mtfshyfg.json',
                      height: 60, width: 60)),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(left: 4.0,right: 4.0),
                  child: Text(
                    AppLocalizations.of(context)!.rideRequest,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 20),
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
                              height: 35,
                              width: 35)),
                    ),
                    Text(AppLocalizations.of(context)!.from + " ",
                        overflow: TextOverflow.ellipsis,
                        style:  TextStyle(
                            color: Colors.greenAccent.shade400,
                            fontWeight: FontWeight.bold,
                            fontSize: 30)),
                    Expanded(
                        flex: 1,
                        child: Text(rideInfoProvider.pickupAddress,
                            textAlign: TextAlign.start,
                            style: const TextStyle(
                                color: Colors.white70,
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                               )))
                  ]),
              const SizedBox(height: 20),
              Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: Center(
                          child: Lottie.asset(
                              'images/lf30_editor_bkpvlwi9.json',
                              height: 35,
                              width: 35)),
                    ),
                    Text(AppLocalizations.of(context)!.too + " ",
                        style:  TextStyle(
                            color: Colors.greenAccent.shade400,
                            fontWeight: FontWeight.bold,
                            fontSize: 35)),
                    Expanded(
                      child: Text(rideInfoProvider.dropoffAddress,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                             )),
                    )
                  ]),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("K.m :${rideInfoProvider.km}",
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 35.0)),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                    AppLocalizations.of(context)!.fare +
                        rideInfoProvider.amount +
                        currencyTypeCheck(context),
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 35.0)),
              ),
              rideInfoProvider.tourismCityName != ""
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        AppLocalizations.of(context)!.fullDay,
                        textAlign: TextAlign.center,
                        // overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  : const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: SizedBox(),
                    ),
              rideInfoProvider.tourismCityName != ""
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                            AppLocalizations.of(context)!.ini +
                                " : ${rideInfoProvider.tourismCityName}",
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                color: Colors.greenAccent,
                                fontSize: 20,
                                fontWeight: FontWeight.bold)),
                      ),
                    )
                  : const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: SizedBox(),
                    ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () async {
                      driverCancelOrder(context);
                      if (Platform.isAndroid) {
                        stopSound();
                      }
                      ///ios
                      _stopSound();
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 120,
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          color: Colors.redAccent.shade700),
                      child: Center(
                          child: Text(
                        AppLocalizations.of(context)!.cancel,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      )),
                    ),
                  ),
                  isHideButton == false
                      ? GestureDetector(
                          onTap: () async {
                            checkAvailableOfRide(context, rideInfoProvider);
                            if (Platform.isAndroid) {
                              stopSound();
                            }
                            _stopSound();
                            setState(() {
                              isHideButton = true;
                            });
                          },
                          child: Container(
                              width: 120,
                              height: 50,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                  color: const Color(0xFFFBC408)),
                              child: Center(
                                  child: Text(
                                AppLocalizations.of(context)!.ok,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
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
              const SizedBox(height: 24,)
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
        homeScreenStreamSubscription.cancel();
        subscriptionNot1.pause();
        Geofire.stopListener();
        await Geofire.removeLocation(currentUseId);
        await rideRequestRef.set("accepted").whenComplete(() {
          Navigator.of(context)
              .push(Tools().createRoute(context, const NewRideScreen()));
        });
      } else if (newRideState == "canceled") {
        Tools().toastMsg(AppLocalizations.of(context)!.beenCanceled,
            Colors.redAccent.shade700);
        Navigator.pop(context);
      } else if (newRideState == "timeOut") {
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

    final currentUseId =
        Provider.of<DriverInfoModelProvider>(context, listen: false).driverInfo;
    _ref.child(currentUseId.userId).child("newRide").set("canceled");
    _ref.child(currentUseId.userId).child("offLine").set("notAvailable");
  }

  ///ios
  Future<void> _playSound() async {
    await audioCache.play(path);
  }

  ///ios
  Future<void> _stopSound() async {
    if (Platform.isIOS) {
      await audioPlayer.stop();
    } else {
      return;
    }
  }
}
