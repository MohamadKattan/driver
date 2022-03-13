// this class will include method dataBase Real time


 import 'package:driver/model/driverInfo.dart';
import 'package:driver/repo/auth_sev.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../my_provider/driver_model_provider.dart';

class DataBaseReal{
final currentUser = AuthSev().auth.currentUser;
late final DataSnapshot snapshot;

  // this method for got Driver info and save in model then Provider
  void getDriverInfoFromDataBase(BuildContext context)async{
    final ref = FirebaseDatabase.instance.ref();
  snapshot = await ref.child("driver").child(currentUser!.uid).get();
    if (snapshot.exists) {
      Map<String,dynamic>map=Map<String,dynamic>.from(snapshot.value  as Map);
      DriverInfo driverInfo = DriverInfo.fromMap(map);
      Provider.of<DriverInfoModelProvider>(context,listen: false).updateDriverInfo(driverInfo);
      print("DriverInfo is ${driverInfo.status}");
      return;
    } else {
      print('No data available.');
    }
  }
}