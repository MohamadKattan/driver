// this class for save all driver info+car+status came from data base

import 'package:flutter/foundation.dart';

class DriverInfo {
  late String userId;
  late String status;
  late String firstName;
  late String lastName;
  late String idNo;
  late String phoneNumber;
  late String email;
  late String driverLis;
  late String carLis;
  DriverInfo(this.userId, this.status, this.firstName, this.lastName, this.idNo,
      this.phoneNumber, this.email, this.driverLis, this.carLis);
  DriverInfo.fromMap(Map<String, dynamic> map) {
    userId = map["userId"];
    status = map["status"];
    firstName = map["firstName"];
    lastName = map["lastName"];
    idNo = map["idNo"];
    phoneNumber = map["phoneNumber"];
    email = map["email"];
    driverLis = map["driverLis"];
    carLis = map["carLis"];
  }
}
