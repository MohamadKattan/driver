// this class for using geolocater api for use country code for plan currency

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import '../config.dart';
import '../my_provider/driver_currentPosition_provider.dart';
import '../my_provider/driver_model_provider.dart';
import '../my_provider/placeAdrees_name.dart';
import '../tools/get_url.dart';
import 'auth_srv.dart';

class ApiSrvGeolocater {
  String userId = AuthSev().auth.currentUser!.uid;
  DatabaseReference driverRef = FirebaseDatabase.instance.ref().child("driver");
  final GetUrl _getUrl = GetUrl();

  // this method for got geocoding api for current position address readable
  Future<dynamic> searchCoordinatesAddress(BuildContext context) async {
    final position = Provider.of<DriverCurrentPosition>(context, listen: false)
        .currentPosition;
    String placeAddress = "";
    String placeAddress0 = "";
    String placeAddress1 = "";
    var url = Uri.parse(
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapKey");
    final response = await _getUrl.getUrlMethod(url);
    if (response != "failed") {
      placeAddress0 =
          response["results"][0]["address_components"][5]["long_name"];
      placeAddress1 =
          response["results"][0]["address_components"][6]["long_name"];
      if (placeAddress0 == '0') {
        placeAddress = placeAddress0;
      } else if (placeAddress1 == 'Turkey') {
        placeAddress = placeAddress1;
      } else {
        placeAddress = placeAddress0;
        print("elsedon");
      }
      driverRef.child(userId).update({"country": placeAddress});
      //for update
      Provider.of<PlaceName>(context, listen: false).updateState(placeAddress);
    }
    return placeAddress;
  }

  // thus method it will work in check in screen just for return country name and set
  Future<dynamic> getContry() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    String placeAddress = "";
    String placeAddress0 = "";
    String placeAddress1 = "";
    var url = Uri.parse(
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapKey");
    final response = await _getUrl.getUrlMethod(url);
    if (response != "failed") {
      placeAddress0 =
          response["results"][0]["address_components"][5]["long_name"];
      placeAddress1 =
          response["results"][0]["address_components"][6]["long_name"];
      if (placeAddress0 == 'Turkey') {
        placeAddress = placeAddress0;
      } else if (placeAddress1 == 'Turkey') {
        placeAddress = placeAddress1;
      } else {
        placeAddress = placeAddress0;
      }
      driverRef.child(userId).child("country").set(placeAddress);
    }
    return placeAddress;
  }
}
