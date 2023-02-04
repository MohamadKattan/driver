// this widget for dialog collect money after finish trip

import 'dart:io';
import 'package:driver/model/rideDetails.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../config.dart';
import '../my_provider/driver_model_provider.dart';
import '../repo/geoFire_srv.dart';
import '../tools/background_serv.dart';
import '../tools/curanny_type.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Widget collectMoney(
    BuildContext context, RideDetails rideInfoProvider, int totalAmount) {
  return Dialog(
    elevation: 1.0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
    backgroundColor: Colors.transparent,
    child: Container(
      height: 275,
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          color: const Color(0xFF00A3E0)),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Center(
                child: Lottie.asset('images/51765-cash.json',
                    height: 90, width: 90)),
            Text(
              AppLocalizations.of(context)!.amountTrip,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 2),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                  AppLocalizations.of(context)!.paymentMethod +
                      rideInfoProvider.paymentMethod,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white, fontSize: 16.0)),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(" ${currencyTypeCheck(context)} $totalAmount ",
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white, fontSize: 16.0)),
            ),
            GestureDetector(
              onTap: () async {
                showGpsDailog = true;
                restNewRide(context);
                subscriptionNot1.resume();
                // homeScreenStreamSubscription.resume();
                await GeoFireSrv().getLocationLiveUpdates(context);
                if (Platform.isAndroid) clearCash();
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  width: 90,
                  height: 40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4.0),
                      color: const Color(0xFFFBC408)),
                  child: Center(
                      child: Text(
                    AppLocalizations.of(context)!.ok,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
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
Future<void> restNewRide(BuildContext context) async {
  final currentUseId =
      Provider.of<DriverInfoModelProvider>(context, listen: false)
          .driverInfo
          .userId;
  DatabaseReference rideRequestRef = FirebaseDatabase.instance
      .ref()
      .child("driver")
      .child(currentUseId)
      .child("newRide");
  rideRequestRef.set("searching");
}
