// this widget for dialog collect money after finish trip

import 'package:driver/model/rideDetails.dart';
import 'package:driver/user_screen/splash_screen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../config.dart';
import '../my_provider/driver_model_provider.dart';
import '../my_provider/user_id_provider.dart';
import '../repo/geoFire_srv.dart';
import 'custom_divider.dart';

Widget collectMoney(BuildContext context, RideDetails rideInfoProvider, int totalAmount){

  return Dialog(
    elevation: 1.0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
    backgroundColor: Colors.transparent,
    child: Container(
      height: MediaQuery.of(context).size.height * 50 / 100,
      width: double.infinity,
      decoration: const BoxDecoration(color: Colors.white),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Center(
                child: Lottie.asset('images/51765-cash.json',
                    height: 90, width: 90)),
            const Text(
              "Total amount this trip",
              style: TextStyle(
                  color: Colors.black87,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 3 / 100),
             Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Payment method :${rideInfoProvider.paymentMethod} ",style: TextStyle(color: Colors.black87,fontSize: 16.0)),
            ),
             Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(" Total : \$$totalAmount " ,style: TextStyle(color: Colors.black87,fontSize: 16.0)),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 3/ 100),
            CustomDivider().customDivider(),
            SizedBox(height: MediaQuery.of(context).size.height * 3.5 / 100),
            GestureDetector(
              onTap: () {
                GeoFireSrv().enableLocationLiveUpdates(context);
                Navigator.pop(context);
                Navigator.pop(context);
                restNewRide(context);
              },
              child: Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 30 / 100,
                  height: MediaQuery.of(context).size.height * 8 / 100,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4.0),
                      color: Colors.greenAccent.shade700),
                  child: const Center(
                      child: Text(
                        "Ok",
                        style: TextStyle(color: Colors.white),
                      )),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
// this method for change key newRide:searching
void restNewRide(BuildContext context) {
  final currentUseId = Provider.of<DriverInfoModelProvider>(context,listen: false).driverInfo.userId;
  DatabaseReference rideRequestRef = FirebaseDatabase.instance
      .ref()
      .child("driver")
      .child(currentUseId)
      .child("newRide");
  rideRequestRef.set("searching");
}