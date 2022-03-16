// this class will include method dataBase Real time

import 'package:driver/model/driverInfo.dart';
import 'package:driver/repo/auth_srv.dart';
import 'package:driver/tools/tools.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../my_provider/driver_model_provider.dart';

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
        print("DriverInfo is ${driverInfo.status}");
        return;
      } else {
        Tools().toastMsg("snapshot.exists-error");
      }
    } catch (ex) {
      Tools().toastMsg("Data!!!");
    }
  }
}
