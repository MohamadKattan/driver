// this class for count days plan

import 'dart:async';
import 'package:driver/repo/auth_srv.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../config.dart';
import '../repo/geoFire_srv.dart';
import '../tools/tools.dart';




class PlanDays {
  DatabaseReference driverRef = FirebaseDatabase.instance.ref().child("driver");
  String userId = AuthSev().auth.currentUser!.uid;

// this method for set value plan to real time
  Future<void> setExPlanToRealTime(int exPlan) async {
    await driverRef.child(userId).child("exPlan").once().then((value) async {
      if(value.snapshot.exists&&value.snapshot.value!=null){
        final snap = value.snapshot.value.toString();
        int oldExPlan = int.parse(snap);
        if(oldExPlan>0){
          int updateExPlan = oldExPlan + exPlan;
          await driverRef.child(userId).child("exPlan").set(updateExPlan);
        }else if(oldExPlan <=0){
          await driverRef.child(userId).child("exPlan").set(exPlan);
        }else{
          return;
        }
      }
    });
  }

// this method for get value plan from real time
 Future <int?> getExPlanFromReal() async {
    await driverRef.child(userId).child("exPlan").once().then((value) {
      final snap = value.snapshot.value;
      if (snap != null) {
        final plan = snap.toString();
        exPlan = int.parse(plan);
      }
    });
    return exPlan;
  }

  // this method for set true or false if background service or not
  Future<void> setIfBackgroundOrForeground(bool isTrue) async {
    await driverRef.child(userId).child("backbool").set(isTrue);
  }

  // this method will set value payed if payment don
  Future<void> setDriverPayed() async {
    await driverRef.child(userId).child("status").set("payed");
  }

  // this method for background bool value working or not
  void getBackGroundBoolValue()async{
    await driverRef.child(userId).once().then((value) {
      if(value.snapshot.exists&&value.snapshot.value!=null){
        final snap = value.snapshot.value;
        Map<String,dynamic>map=Map<String,dynamic>.from(snap as Map);
        if(map["backbool"]!=null){
          isBackground = map["backbool"];
        }
      }
    });
  }

  Future<void> setDateTime() async {
    int _day;
    int _month = DateTime.now().month;
    int _year = DateTime.now().year;
    if (DateTime.now().day < 30) {
      _day = DateTime.now().day +1;
    } else {
      _day = 1;
    }
    DateTime datePlan1 = DateTime(_year, _month, _day);
    await driverRef.child(userId).child("plandate").set(datePlan1.toString());
    // final DateFormat formatter = DateFormat('yy-MM-dd');
    // final  String formatted = formatter.format(exPlan1);
  }

  Future<void> countAndCalcPlan() async {
    await  driverRef.child(userId).child("exPlan").once().then((value) {
      if (value.snapshot.value != null) {
        final snap = value.snapshot.value;
        if (snap != null) {
          exPlan = int.parse(snap.toString());
        }
      }
    });
    if (exPlan == 0) {
      await  driverRef.child(userId).child("status").once().then((value) {
        if (value.snapshot.exists && value.snapshot.value != null) {
          final snap = value.snapshot.value;
          String _status = snap.toString();
          if (_status == "checkIn" || _status == "") {
            return;
          }
          driverRef.child(userId).child("status").set("payTime");
          GeoFireSrv().makeDriverOffLine();
        }
      });
    } else if (exPlan! >= 1400) {
      exPlan = exPlan! - 1400;
      await driverRef.child(userId).child("exPlan").set(exPlan);
    } else if (exPlan! < 1400 || exPlan == 0 || exPlan! < 0) {
      exPlan = 0;
      await driverRef.child(userId).child("exPlan").set(exPlan);
      await driverRef.child(userId).child("status").once().then((value) {
        if (value.snapshot.exists && value.snapshot.value != null) {
          final snap = value.snapshot.value;
          String _status = snap.toString();
          if (_status == "checkIn" || _status == "") {
            return;
          }
          driverRef.child(userId).child("status").set("payTime");
          GeoFireSrv().makeDriverOffLine();
        }
      });
    }
  }

  Future<void> countAndCalcPlanLate() async {
    await  driverRef.child(userId).child("exPlan").once().then((value) {
      if (value.snapshot.value != null) {
        final snap = value.snapshot.value;
        if (snap != null) {
          exPlan = int.parse(snap.toString());
        }
      }
    });
    if (exPlan == 0) {
      await  driverRef.child(userId).child("status").once().then((value) {
        if (value.snapshot.exists && value.snapshot.value != null) {
          final snap = value.snapshot.value;
          String _status = snap.toString();
          if (_status == "checkIn" || _status == "") {
            return;
          }
          driverRef.child(userId).child("status").set("payTime");
          GeoFireSrv().makeDriverOffLine();
        }
      });
    } else if (exPlan! >= 1400) {
      exPlan = exPlan! - 2800;
      await driverRef.child(userId).child("exPlan").set(exPlan);
    } else if (exPlan! < 1400 || exPlan == 0 || exPlan! < 0) {
      exPlan = 0;
      await driverRef.child(userId).child("exPlan").set(exPlan);
      await driverRef.child(userId).child("status").once().then((value) {
        if (value.snapshot.exists && value.snapshot.value != null) {
          final snap = value.snapshot.value;
          String _status = snap.toString();
          if (_status == "checkIn" || _status == "") {
            return;
          }
          driverRef.child(userId).child("status").set("payTime");
          GeoFireSrv().makeDriverOffLine();
        }
      });
    }
  }

  Future<void> getDateTime() async {
    await driverRef.child(userId).child("plandate").once().then((value) async {
      if (value.snapshot.exists && value.snapshot.value != null) {
        final _val = value.snapshot.value;
        DateTime _valDateTime = DateTime.parse(_val.toString());
        if (_valDateTime.day == DateTime.now().day) {
          await setDateTime();
          await countAndCalcPlan();
        }else if(_valDateTime.day < DateTime.now().day){
          await setDateTime();
          await countAndCalcPlanLate();
        }
      }
    });
  }

  // this method for foreground service
/// stop for now
 // Future <void> countDayPlansInForeground()async {
 //
 //    if(isBackground == false){
 //      await getExPlanFromReal();
 //      Timer.periodic(const Duration(seconds: 40), (timer) async {
 //        if (exPlan! < 0) {
 //          Tools().toastMsg("", Colors.redAccent.shade700);
 //          driverRef.child(userId).child("status").once().then((value){
 //            if(value.snapshot.exists&&value.snapshot.value!=null){
 //              final snap = value.snapshot.value;
 //              String _status = snap.toString();
 //              if(_status=="checkIn"){
 //                return;
 //              }
 //              driverRef.child(userId).child("status").set("payTime");
 //            }
 //          });
 //          timer.cancel();
 //        }
 //        else {
 //          exPlan = exPlan! - 1;
 //          await driverRef.child(userId).child("exPlan").set(exPlan);
 //          if(exPlan==0){
 //            Tools().toastMsg("", Colors.redAccent.shade700);
 //          }
 //          if(exPlan! < 0){
 //            Tools().toastMsg("", Colors.redAccent.shade700);
 //            driverRef.child(userId).child("status").once().then((value){
 //              if(value.snapshot.exists&&value.snapshot.value!=null){
 //                final snap = value.snapshot.value;
 //                String _status = snap.toString();
 //                if(_status=="checkIn"){
 //                  return;
 //                }
 //                driverRef.child(userId).child("status").set("payTime");
 //              }
 //            });
 //            timer.cancel();
 //          }
 //        }
 //      });
 //    }
 //    else{
 //      return;
 //    }
 //  }

}
