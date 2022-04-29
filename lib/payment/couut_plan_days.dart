// this class for count days plan

import 'dart:async';
import 'package:driver/repo/auth_srv.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../config.dart';
import '../tools/tools.dart';

class PlanDays {
  DatabaseReference driverRef = FirebaseDatabase.instance.ref().child("driver");
  String userId = AuthSev().auth.currentUser!.uid;

// this method for set value plan to real time
  Future<void> setExPlanToRealTime(int exPlan) async {
    await driverRef.child(userId).child("exPlan").set(exPlan);
  }

// this method for get value plan from real time
 Future <void> getExPlanFromReal() async {
    await driverRef.child(userId).child("exPlan").once().then((value) {
      final snap = value.snapshot.value;
      if (snap != null) {
        final plan = snap.toString();
        exPlan = int.parse(plan);
      }
    });
  }

  // this method for set true or false if background service or not
  Future<void> setIfBackgroundOrForeground(bool isTrue) async {
    await driverRef.child(userId).child("backbool").set(isTrue);
  }

  // this method for background bool value working or not
  void getBackGroundBoolValue()async{
    await driverRef.child(userId).once().then((value) {
      if(value.snapshot.exists&&value.snapshot.value!=null){
        final snap = value.snapshot.value;
        Map<String,dynamic>map=Map<String,dynamic>.from(snap as Map);
        if(map["backbool"]!=null){
          isBackground = map["backbool"];
          print("zzzzzzzz$isBackground");
        }
      }
    });
  }

  // this method for foreground service
 Future <void> countDayPlansInForeground()async {

    if(isBackground == false){
      print("mmmmmm$isBackground");
      await getExPlanFromReal();
      Timer.periodic(const Duration(seconds: 1), (timer) async {
        if (exPlan < 0) {
          timer.cancel();
          Tools().toastMsg("Your Plan finished ForGROUND ", Colors.redAccent.shade700);
        }
        else {
          exPlan = exPlan - 1;
          await PlanDays().setExPlanToRealTime(exPlan);
          print("plan FORgROUND$exPlan");
          if(exPlan==0){
            Tools().toastMsg("Your Plan finished charge your plan ForGROUND", Colors.redAccent.shade700);
          }
          if(exPlan<0){
            timer.cancel();
            Tools().toastMsg("Your Plan finished ForGROUND ", Colors.redAccent.shade700);
          }
        }
      });
    }
    else{
      return;
    }
  }

}
