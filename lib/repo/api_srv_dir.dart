//this class will use direction api between current location and drop of location

import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../config.dart';
import '../model/direction_details.dart';
import '../my_provider/direction_details_provider.dart';
import '../tools/get_url.dart';

class ApiSrvDir {
// got time/km/point
  static Future<DirectionDetails?> obtainPlaceDirectionDetails(
      LatLng initialPostion, LatLng finalPostion, BuildContext context) async {
    final directionUrl = Uri.parse(
        "https://maps.googleapis.com/maps/api/directions/json?origin=${initialPostion.latitude},${initialPostion.longitude}&destination=${finalPostion.latitude},${finalPostion.longitude}&key=$mapKey");

    final res = await GetUrl().getUrlMethod(directionUrl);
    if (res == "failed") {
      return null;
    }
    if (res["status"] == "OK") {
      DirectionDetails directionDetails = DirectionDetails(
          distanceText: "",
          durationText: "",
          distanceVale: 0,
          durationVale: 0,
          enCodingPoints: "");
      directionDetails.enCodingPoints =
          res["routes"][0]["overview_polyline"]["points"];
      directionDetails.durationText =
          res["routes"][0]["legs"][0]["duration"]["text"];
      directionDetails.durationVale =
          res["routes"][0]["legs"][0]["duration"]["value"];
      directionDetails.distanceText =
          res["routes"][0]["legs"][0]["distance"]["text"];
      directionDetails.distanceVale =
          res["routes"][0]["legs"][0]["distance"]["value"];
      Provider.of<DirectionDetailsPro>(context, listen: false)
          .updateDirectionDetails(directionDetails);

      return directionDetails;
    }

    /// new add
    return null;
  }
  //this method for calc total price

  static int calculateFares(
      DirectionDetails directionDetails, String carTypePro) {
    double timeTravleFare = (directionDetails.durationVale / 60) * 0.20;
    double distanceTravleFare = (directionDetails.distanceVale / 1000) * 0.60;
    double fareAmont = timeTravleFare + distanceTravleFare;
    final culculFinal = carTypePro == "Taxi"
        ? fareAmont * 13 + 0.70 * 13.00
        : carTypePro == "MediumCommercial"
            ? fareAmont * 13 + 1.5 * 13.00
            : carTypePro == "Big Commercial"
                ? fareAmont * 13 + 2 * 13.00
                : 0;

    return culculFinal.truncate();
  }
}
