// this method for check currency type connect to country

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../my_provider/driver_model_provider.dart';
import '../my_provider/ride_request_info.dart';

String currencyTypeCheck(BuildContext context) {
  final driverInfo =
      Provider.of<DriverInfoModelProvider>(context, listen: false).driverInfo;

  final rideInfoProvider =
      Provider.of<RideRequestInfoProvider>(context, listen: false)
          .rideDetails
          .tourismCityName;
  String _currencyType = "";
  if (driverInfo.country.contains("T")) {
    if (driverInfo.carType.contains("Taxi-4 seats")) {
      _currencyType = "TL";
    }
    else {
      if (rideInfoProvider == "") {
        _currencyType = "TL";
      } else {
        _currencyType = "\$";
      }
    }
  } else if (driverInfo.country.contains("Morocco")) {
    _currencyType == "MAD";
  } else if (driverInfo.country.contains("Sudan")) {
    _currencyType == "SUP";
  } else if (driverInfo.country.contains("Saudi")) {
    _currencyType == "SAR";
  } else if (driverInfo.country.contains("Qatar")) {
    _currencyType == "QAR";
  } else if (driverInfo.country.contains("Libya")) {
    _currencyType == "LYD";
  } else if (driverInfo.country.contains("Kuwait")) {
    _currencyType == "KWD";
  } else if (driverInfo.country.contains("Iraq")) {
    _currencyType == "\$";
  } else if (driverInfo.country.contains("United Arab")) {
    _currencyType == "AED";
  } else {
    _currencyType == "";
  }

  return _currencyType;
}
