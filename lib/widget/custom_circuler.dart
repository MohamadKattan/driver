// this class for circular inductor

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
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
        children: [
          Center(
              child: Lottie.asset(
                  'images/lf30_editor_lzxfkcgw.json',
                  height: 250,
                  width: 250)),
        ],
      ),
    );
  }
}