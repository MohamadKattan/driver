
// this widget if driver offline and if he don't want to work

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Widget customContainerOffLineDriver(BuildContext context){
  return Container(
    height: MediaQuery.of(context).size.height,
    width: MediaQuery.of(context).size.width,
    color: Colors.black26.withOpacity(0.6),
    child: Stack(
      children: [
        Center(
          child: Lottie.asset(
              'images/1611-online-offline.json',
              height: 250,
              width: 250),
        ),
         Positioned(right: 0.0,left: 0.0,bottom: 225.0,child: Center(child: Padding(
           padding: const  EdgeInsets.all(8.0),
           child: Text(AppLocalizations.of(context)!.offLine,style : TextStyle(color: Colors.redAccent.shade700,fontSize: 35.0,fontWeight: FontWeight.bold)),
         ))),
      ],
    ),
  );
}