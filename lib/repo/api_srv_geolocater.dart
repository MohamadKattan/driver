// this class for using geolocater api for use country code for plan currency

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../config.dart';
import '../my_provider/driver_currentPosition_provider.dart';
import '../my_provider/placeAdrees_name.dart';
import '../tools/get_url.dart';

class ApiSrvGeolocater{
  final GetUrl _getUrl = GetUrl();
  // this method for got geocoding api for current position address readable
  Future<dynamic> searchCoordinatesAddress(BuildContext context) async {
   final position = Provider.of<DriverCurrentPosition>(context,listen: false).currentPosition;
    String placeAddress = "";
    var url = Uri.parse("https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapKey");
    final response = await _getUrl.getUrlMethod(url);
    if (response != "failed") {
      placeAddress = response["results"][0]["address_components"][5]["long_name"];
      //for update
      Provider.of<PlaceName>(context, listen: false).updateState(placeAddress);
      print(":::::::"+placeAddress.toString());
    }
    return placeAddress;
  }
}