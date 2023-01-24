// this class for using geolocater api for use country code for plan currency

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import '../config.dart';
import '../tools/get_url.dart';
import 'auth_srv.dart';

class ApiSrvGeolocater {
  String userId = AuthSev().auth.currentUser!.uid;
  DatabaseReference driverRef = FirebaseDatabase.instance.ref().child("driver");
  DatabaseReference preBookRef =
      FirebaseDatabase.instance.ref().child("prebook");

  final GetUrl _getUrl = GetUrl();

  // this method for got geocoding api for current position address readable
  Future<void> searchCoordinatesAddress(BuildContext context) async {
    // final position = Provider.of<DriverCurrentPosition>(context, listen: false)
    //     .currentPosition;
    // String placeAddress0, placeAddress1, placeAddress2, type1, type2;
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
    String? city, country, type1, type2, type3, type4;
    var url = Uri.parse(
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapKey");
    final response = await _getUrl.getUrlMethod(url);
    if (response != "failed") {
      if (response["results"][1]["address_components"][3]["types"][0] != null) {
        type1 = response["results"][1]["address_components"][3]["types"][0];
        if (type1 == 'administrative_area_level_1') {
          city = response["results"][1]["address_components"][3]["long_name"];
          country =
              response["results"][1]["address_components"][4]["long_name"];
        } else if (response["results"][1]["address_components"][4]["types"]
                [0] !=
            null) {
          type2 = response["results"][1]["address_components"][4]["types"][0];
          if (type2 == 'administrative_area_level_1') {
            city = response["results"][1]["address_components"][4]["long_name"];
            country =
                response["results"][1]["address_components"][5]["long_name"];
          } else if (response["results"][1]["address_components"][5]["types"]
                  [0] !=
              null) {
            type3 = response["results"][1]["address_components"][5]["types"][0];
            if (type3 == 'administrative_area_level_1') {
              city =
                  response["results"][1]["address_components"][5]["long_name"];
              country =
                  response["results"][1]["address_components"][6]["long_name"];
            } else if (response["results"][1]["address_components"][6]["types"]
                    [0] !=
                null) {
              type4 =
                  response["results"][1]["address_components"][6]["types"][0];
              if (type4 == 'administrative_area_level_1') {
                city = response["results"][1]["address_components"][6]
                    ["long_name"];
                country = response["results"][1]["address_components"][7]
                    ["long_name"];
              }
            }
          }
        }
      }
      driverRef.child(userId).update({
        "city": city ?? "globule",
        "country": country ?? "globule"
      }).whenComplete(() {
        preBookRef.child(userId).once().then((value) {
          if (!value.snapshot.exists) {
            return;
          } else {
            preBookRef.child(userId).update(
                {"city": city ?? "globule", "country": country ?? "globule"});
          }
        });
      });
    }
  }

  // thus method it will work in check in screen just for return country name and set
  // Future<void> getCountry() async {
  //   Position position = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high);
  //   // String placeAddress0, placeAddress1, placeAddress2, type1, type2;
  //   String? city, country, type1, type2, type3, type4;
  //   var url = Uri.parse(
  //       "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapKey");
  //   final response = await _getUrl.getUrlMethod(url);
  //   // if (response != "failed") {
  //   //   type1 = response["results"][0]["address_components"][4]["types"][0];
  //   //   type2 = response["results"][0]["address_components"][5]["types"][0];
  //   //   placeAddress0 =
  //   //       response["results"][0]["address_components"][4]["long_name"];
  //   //   placeAddress1 =
  //   //       response["results"][0]["address_components"][5]["long_name"];
  //   //   placeAddress2 =
  //   //       response["results"][0]["address_components"][6]["long_name"];
  //   //
  //   //   if (type1 == 'administrative_area_level_1') {
  //   //     driverRef
  //   //         .child(userId)
  //   //         .update({"city": placeAddress0, "country": placeAddress1});
  //   //   } else if (type2 == 'administrative_area_level_1') {
  //   //     driverRef
  //   //         .child(userId)
  //   //         .update({"city": placeAddress1, "country": placeAddress2});
  //   //   } else {
  //   //     driverRef
  //   //         .child(userId)
  //   //         .update({"city": placeAddress1, "country": placeAddress2});
  //   //   }
  //   // }
  //   if (response != "failed") {
  //     if (response["results"][1]["address_components"][3]["types"][0] != null) {
  //       type1 = response["results"][1]["address_components"][3]["types"][0];
  //       if (type1 == 'administrative_area_level_1') {
  //         city = response["results"][1]["address_components"][3]["long_name"];
  //         country =
  //             response["results"][1]["address_components"][4]["long_name"];
  //       } else if (response["results"][1]["address_components"][4]["types"]
  //               [0] !=
  //           null) {
  //         type2 = response["results"][1]["address_components"][4]["types"][0];
  //         if (type2 == 'administrative_area_level_1') {
  //           city = response["results"][1]["address_components"][4]["long_name"];
  //           country =
  //               response["results"][1]["address_components"][5]["long_name"];
  //         } else if (response["results"][1]["address_components"][5]["types"]
  //                 [0] !=
  //             null) {
  //           type3 = response["results"][1]["address_components"][5]["types"][0];
  //           if (type3 == 'administrative_area_level_1') {
  //             city =
  //                 response["results"][1]["address_components"][5]["long_name"];
  //             country =
  //                 response["results"][1]["address_components"][6]["long_name"];
  //           } else if (response["results"][1]["address_components"][6]["types"]
  //                   [0] !=
  //               null) {
  //             type4 =
  //                 response["results"][1]["address_components"][6]["types"][0];
  //             if (type4 == 'administrative_area_level_1') {
  //               city = response["results"][1]["address_components"][6]
  //                   ["long_name"];
  //               country = response["results"][1]["address_components"][7]
  //                   ["long_name"];
  //             }
  //           }
  //         }
  //       }
  //     }
  //     driverRef
  //         .child(userId)
  //         .update({"city": city ?? "globule", "country": country ?? "globule"});
  //   }
  // }
}
