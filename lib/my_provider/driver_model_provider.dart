// this class for listing to driverModel after save it from real time in model

import 'package:driver/model/driverInfo.dart';
import 'package:flutter/cupertino.dart';

class DriverInfoModelProvider extends ChangeNotifier {
  late DriverInfo driverInfo = DriverInfo("","","","","","","","","","");
  void updateDriverInfo(DriverInfo driver){
    driverInfo = driver;
    notifyListeners();
  }
}