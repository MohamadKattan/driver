
import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config.dart';
import '../logic_google_map.dart';
import '../my_provider/new_ride_indector.dart';
import '../my_provider/ride_request_info.dart';
import '../repo/geoFire_srv.dart';
import '../tools/background_serv.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Widget cancelTrip(BuildContext context){
  return Dialog(
    elevation: 1.0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
    backgroundColor: Colors.transparent,
    child: Container(
      height: 150,
      width: double.infinity,
      decoration:  BoxDecoration(
          borderRadius: BorderRadius.circular(12.0)
          ,color:Colors.red.shade700),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
               Text(
                AppLocalizations.of(context)!.driverCancelTrip,
                textAlign: TextAlign.center,
                style:const TextStyle(
                    color: Colors.white,
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: ()=>Navigator.pop(context),
                    child: Container(
                      height: 40,
                      width: 120,
                      decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(12)),
                      child:  Center(child: Text( AppLocalizations.of(context)!.no,style: TextStyle(color: Colors.greenAccent.shade700),)),
                    ),
                  ),
                  GestureDetector(
                    onTap: ()=>driverCanceldTrip(context),
                    child: Container(
                      height: 40,
                      width: 120,
                      decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(12)),
                      child:  Center(child: Text( AppLocalizations.of(context)!.yes,style: TextStyle(color: Colors.red.shade700))),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    ),
  );
}

void driverCanceldTrip(BuildContext context) async {
  final _riderId =
      Provider.of<RideRequestInfoProvider>(context, listen: false)
          .rideDetails.userId;
  DatabaseReference rideRequestRef = FirebaseDatabase.instance
      .ref()
      .child("Ride Request")
      .child(_riderId);
  await  rideRequestRef.child('status').set('0');
  timerStop1.cancel();
  Provider.of<NewRideScreenIndector>(context, listen: false)
      .updateState(true);
  newRideScreenStreamSubscription?.cancel();
  subscriptionNot1.resume();
  serviceStatusStreamSubscription?.resume();
  showGpsDailog = true;
  Navigator.pop(context);
  await LogicGoogleMap().locationPosition(context);
  GeoFireSrv().getLocationLiveUpdates(context);
  if (Platform.isAndroid)clearCash();
  Provider.of<NewRideScreenIndector>(context, listen: false)
      .updateState(false);
  Navigator.pop(context);
  Navigator.pop(context);
}