// this class for circular inductor

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// custom circularInductor will use in our app
class CircularInductorCostem{

  Widget circularInductorCostem(BuildContext context){
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        color: Colors.black45,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children:  [
          Center(
            child: CircularProgressIndicator(
              color: Colors.yellowAccent.shade700,
            ),
             ),
          Center(child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text( AppLocalizations.of(context)!.wait,style: const TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),),
          )),
        ],
      ),
    );
  }
}