//this class will use direction api between current location and drop of location

import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../config.dart';
import '../model/direction_details.dart';
import '../my_provider/direction_details_provider.dart';
import '../my_provider/driver_model_provider.dart';
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


  // static int calculateFares(DirectionDetails directionDetails,
  //     String carTypePro, BuildContext context) {
  //   final contryName =
  //       Provider.of<DriverInfoModelProvider>(context, listen: false)
  //           .driverInfo
  //           .country;
  //   double timeTravleFare = (directionDetails.durationVale / 60) * 0.20;
  //   double distanceTravleFare = (directionDetails.distanceVale / 1000) * 0.60;
  //   double fareAmont = timeTravleFare + distanceTravleFare;
  //   final culculFinal = carTypePro == "Taxi-4 seats" && contryName == "Turkey"
  //       ? fareAmont * 13 + 0.70 * 13.00
  //       : carTypePro == "Medium commercial-6-10 seats" && contryName == "Turkey"
  //           ? fareAmont * 13 + 1.5 * 13.00
  //           : carTypePro == "Big commercial-11-19 seats" &&
  //                   contryName == "Turkey"
  //               ? fareAmont * 13 + 2 * 13.00
  //               : 0;
  //
  //   return culculFinal.truncate();
  // }

  static int calculateFares1(DirectionDetails directionDetails,
      String carTypePro, BuildContext context) {
    final contryName =
        Provider.of<DriverInfoModelProvider>(context, listen: false)
            .driverInfo.country;
    late  double culculFinal;
    double timeTravleFare = (directionDetails.durationVale / 60) * 0.20;
    double distanceTravleFare = (directionDetails.distanceVale / 1000) * 0.60;
    double fareAmont = timeTravleFare + distanceTravleFare;
    if (carTypePro == "Taxi-4 seats" && contryName == "Turkey") {
     culculFinal= fareAmont * 13 + 0.70 * 13.00;
    } else if (carTypePro == "Taxi-4 seats" && contryName == "Morocco") {
      culculFinal= fareAmont * 10 + 0.70 * 10.00;
    } else if (carTypePro == "Taxi-4 seats" && contryName == "Sudan") {
      culculFinal= fareAmont *450+ 0.70 * 450;
    } else if (carTypePro == "Taxi-4 seats" && contryName == "Saudi Arabia") {
      culculFinal=fareAmont + 1.85 * 3.75 + 2.70 * 3.75;
    } else if (carTypePro == "Taxi-4 seats" && contryName == "Qatar") {
      culculFinal=fareAmont - 0.25 * 3.64 + 2.75 * 3.75;
    } else if (carTypePro == "Taxi-4 seats" && contryName == "Libya") {
      culculFinal=fareAmont - 0.30 * 4.80 + 1 * 4.80;
    } else if (carTypePro == "Taxi-4 seats" && contryName == "Kuwait") {
      culculFinal=fareAmont + 1.65 * 0.32 + 4.88 * 0.32;
    } else if (carTypePro == "Taxi-4 seats" && contryName == "Iraq") {
      culculFinal=fareAmont + 1.20 + 2.73;
    } else if (carTypePro == "Taxi-4 seats" &&
        contryName == "United Arab Emirates") {
      culculFinal=fareAmont - 0.30 * 3.67 + 3.30 * 3.67;
    }
    else if (carTypePro == "Medium commercial-6-10 seats" && contryName == "Turkey") {
      culculFinal=100;
    } else if (carTypePro == "Medium commercial-6-10 seats" && contryName == "Morocco") {
      culculFinal=fareAmont + 0.20 * 10 + 1.50 * 10.00;
    } else if (carTypePro == "Medium commercial-6-10 seats" && contryName == "Sudan") {
      culculFinal=fareAmont *450+ 1.50 * 450;
    } else if (carTypePro == "Medium commercial-6-10 seats" && contryName == "Saudi Arabia") {
      culculFinal=fareAmont + 1.85 + 0.20 * 3.75 + 3.70 * 3.75;
    } else if (carTypePro == "Medium commercial-6-10 seats" && contryName == "Qatar") {
      culculFinal=fareAmont  * 3.64 + 4.75 * 3.75;
    } else if (carTypePro == "Medium commercial-6-10 seats" && contryName == "Libya") {
      culculFinal=fareAmont  * 4.80 + 3 * 4.80;
    } else if (carTypePro == "Medium commercial-6-10 seats" && contryName == "Kuwait") {
      culculFinal=fareAmont +0.10+ 1.65 * 0.32 + 5.88 * 0.32;
    } else if (carTypePro == "Medium commercial-6-10 seats" && contryName == "Iraq") {
      culculFinal=fareAmont +0.20 + 1.20 + 4.73;
    } else if (carTypePro == "Medium commercial-6-10 seats" &&
        contryName == "United Arab Emirates") {
      culculFinal=fareAmont  * 3.67 + 5.30 * 3.67;
    }
    else if (carTypePro == "Big commercial-11-19 seats" && contryName == "Turkey") {
      culculFinal=120;
    } else if (carTypePro == "Big commercial-11-19 seats" && contryName == "Morocco") {
      culculFinal=fareAmont + 0.20 * 10 + 2 * 10.00;
    } else if (carTypePro == "Big commercial-11-19 seats" && contryName == "Sudan") {
      culculFinal=fareAmont *450+ 2 * 450;
    } else if (carTypePro == "Big commercial-11-19 seats" && contryName == "Saudi Arabia") {
      culculFinal=fareAmont + 1.85 + 0.20 * 3.75 + 4.70 * 3.75;
    } else if (carTypePro == "Big commercial-11-19 seats" && contryName == "Qatar") {
      culculFinal=fareAmont  * 3.64 + 5.75 * 3.64;
    } else if (carTypePro == "Big commercial-11-19 seats" && contryName == "Libya") {
      culculFinal=fareAmont  * 4.80 + 4 * 4.80;
    } else if (carTypePro == "Big commercial-11-19 seats" && contryName == "Kuwait") {
      culculFinal=fareAmont +0.10+ 1.65 * 0.32 + 6.88 * 0.32;
    } else if (carTypePro == "Big commercial-11-19 seats" && contryName == "Iraq") {
      culculFinal=fareAmont +0.20 + 1.20 + 5.73;
    } else if (carTypePro == "Big commercial-11-19 seats" &&
        contryName == "United Arab Emirates") {
      culculFinal= fareAmont  * 3.67 + 6.30 * 3.67;
    }else{
      culculFinal = 0.0;
    }
    return culculFinal.truncate();
  }
}
