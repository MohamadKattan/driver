// this widget dialog notification show to driver for accept or cancel order

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../my_provider/ride_request_info.dart';
import 'custom_divider.dart';

Widget customNotificationDialog(BuildContext context){
  final rideInfoProvider = Provider.of<RideRequestInfoProvider>(context,listen: false).rideDetails;
  return  Dialog(
    elevation: 1.0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
    backgroundColor: Colors.transparent,
    child: Container(
      height: MediaQuery.of(context).size.height*70/100,
      width: double.infinity,
      decoration: const BoxDecoration(color: Colors.white),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Center(
                child: Lottie.asset(
                    'images/lf30_editor_mtfshyfg.json',
                    height: 160,
                    width: 160)),
            const Text("New ride request",style: TextStyle(color: Colors.black87,fontSize: 24.0,fontWeight: FontWeight.bold),),
             SizedBox(height:MediaQuery.of(context).size.height*3/100),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0,right: 8,),
                child: Center(
                    child: Lottie.asset(
                        'images/lf30_editor_bkpvlwi9.json',
                        height: 40,
                        width: 40)),
              ),
               Expanded(flex: 1,child: Text(rideInfoProvider.pickupAddress,style: const TextStyle(color: Colors.black45,fontSize: 18.0,overflow: TextOverflow.ellipsis)))
            ]),
            SizedBox(height:MediaQuery.of(context).size.height*3/100),
            Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0,right: 8.0),
                    child: Center(
                        child: Lottie.asset(
                            'images/lf30_editor_bkpvlwi9.json',
                            height: 40,
                            width: 40)),
                  ),
                  Text(rideInfoProvider.dropoffAddress,style: const TextStyle(color: Colors.black45,fontSize: 18.0,overflow: TextOverflow.ellipsis))
                ]),
            SizedBox(height:MediaQuery.of(context).size.height*4/100),
            CustomDivider().customDivider(),
            SizedBox(height:MediaQuery.of(context).size.height*7/100),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: null,
                  child: Container(
                    width: MediaQuery.of(context).size.width*30/100,
                    height:MediaQuery.of(context).size.height*7/100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2.0),
                      color: Colors.redAccent.shade700
                    ),
                    child: const Center(child:  Text("Cancel",style: TextStyle(color: Colors.white),)),
                  ),
                ),
                GestureDetector(
                  onTap: null,
                  child: Container(
                      width: MediaQuery.of(context).size.width*30/100,
                      height:MediaQuery.of(context).size.height*7/100,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2.0),
                          color: Colors.green.shade700
                      ),
                      child:const Center(child:  Text("Accept",style: TextStyle(color: Colors.white),))
                  ),
                ),
              ],
            ),
        ],),
      ),
    ),
  );
}