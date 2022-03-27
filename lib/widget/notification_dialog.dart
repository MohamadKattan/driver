// this widget dialog notification show to driver for accept or cancel order

import 'package:driver/model/rideDetails.dart';
import 'package:driver/repo/auth_srv.dart';
import 'package:driver/repo/geoFire_srv.dart';
import 'package:driver/tools/tools.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../config.dart';
import '../my_provider/new_ride_indector.dart';
import '../my_provider/ride_request_info.dart';
import '../user_screen/new_ride_screen.dart';
import 'custom_divider.dart';

Widget customNotificationDialog(BuildContext context) {
  final rideInfoProvider =
      Provider.of<RideRequestInfoProvider>(context, listen: false).rideDetails;
  return Dialog(
    elevation: 1.0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
    backgroundColor: Colors.transparent,
    child: Container(
      height: MediaQuery.of(context).size.height * 70 / 100,
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
                        child: Lottie.asset('images/lf30_editor_bkpvlwi9.json',
                            height: 20, width: 20)),
                  ),
                   Text("From : ",style: TextStyle(color: Colors.greenAccent.shade700,fontSize: 14)),
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
                        child: Lottie.asset('images/lf30_editor_bkpvlwi9.json',
                            height: 20, width: 20)),
                  ),
                  Text("To : ",style: TextStyle(color: Colors.redAccent.shade700,fontSize: 14)),
                  Text(rideInfoProvider.dropoffAddress,
                      style: const TextStyle(
                          color: Colors.black45,
                          fontSize: 18.0,
                          overflow: TextOverflow.ellipsis))
                ]),
            SizedBox(height: MediaQuery.of(context).size.height * 4 / 100),
            Row(crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
              Text("Km : 18",style: TextStyle(color: Colors.black45,fontSize: 16.0)),
              Text("Total : \$ 100",style: TextStyle(color: Colors.black45,fontSize: 16.0))
            ],),
            SizedBox(height: MediaQuery.of(context).size.height * 4 / 100),
            CustomDivider().customDivider(),
            SizedBox(height: MediaQuery.of(context).size.height * 7 / 100),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    assetsAudioPlayer.stop();
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
                    Provider.of<NewRideScreenIndector>(context,listen: false).updateState(true);
                    assetsAudioPlayer.dispose();
                    assetsAudioPlayer.stop();
                    checkAvailableOfRide(context, rideInfoProvider);
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
void checkAvailableOfRide(
    BuildContext context, RideDetails rideInfoProvider) async {
  Navigator.pop(context);
  final currentUseId = AuthSev().auth.currentUser;
  String rideId = "";

  // first list to value newRide in driver collection to check value state
  DatabaseReference rideRequestRef = FirebaseDatabase.instance
      .ref()
      .child("driver")
      .child(currentUseId!.uid)
      .child("newRide");
  await rideRequestRef.once().then((value) {
    if (value.snapshot.value != null) {
      rideId = value.snapshot.value.toString();
    } else {
      Tools().toastMsg("Ride not exist");
    }
    //id in newRide value = rider id from Ride Request collection
    if (rideId == rideInfoProvider.userId) {
      rideRequestRef.set("accepted");
      GeoFireSrv().displayLocationLiveUpdates();
      Navigator.push(context, MaterialPageRoute(builder:(_)=>const NewRideScreen()));
    } else if (rideId == "canceled") {
      Tools().toastMsg("Ride has been canceled ");
    } else if (rideId == "timeOut") {
      Tools().toastMsg("Ride timeOut");
    } else {
      Tools().toastMsg("Ride not exist");
    }
  });
}
