// this class will include method dataBase Real time

import 'package:driver/model/driverInfo.dart';
import 'package:driver/notificatons/push_notifications_srv.dart';
import 'package:driver/repo/auth_srv.dart';
import 'package:driver/tools/tools.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../my_provider/driver_model_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';



class DataBaseReal {
  final currentUser = AuthSev().auth.currentUser;
  late final DataSnapshot snapshot;
  // this method for got Driver info and save in model then Provider
  Future<void> getDriverInfoFromDataBase(BuildContext context) async {
    try {
      final ref = FirebaseDatabase.instance.ref();
      snapshot = await ref.child("driver").child(currentUser!.uid).get();
      if (snapshot.exists) {
        Map<String, dynamic> map =
            Map<String, dynamic>.from(snapshot.value as Map);
        DriverInfo driverInfo = DriverInfo.fromMap(map);
        Provider.of<DriverInfoModelProvider>(context, listen: false)
            .updateDriverInfo(driverInfo);
        return;
      } else {
        Tools().toastMsg(AppLocalizations.of(context)!.welcome,Colors.green.shade700);
      }
    } catch (ex) {
      Tools().toastMsg(AppLocalizations.of(context)!.welcome,Colors.green.shade700);
    }
  }
  Future<void>deleteAccount(BuildContext context)async{
    try{
      driverRef.child(userId).onDisconnect();
      driverRef.child(userId).remove();
     // await FirebaseAuth.instance.currentUser!.delete();
     Tools().toastMsg( AppLocalizations.of(context)!.delDon, Colors.redAccent);
     Tools().toastMsg( AppLocalizations.of(context)!.youCanExit, Colors.green);
    }catch(ex){
      ex.toString();
    }
  }
}
