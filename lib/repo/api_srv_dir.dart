//this class will use direction api between current location and drop of location

import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../config.dart';
import '../model/direction_details.dart';
import '../my_provider/direction_details_provider.dart';
import '../my_provider/driver_model_provider.dart';
import '../my_provider/ride_request_info.dart';
import '../tools/get_url.dart';

class ApiSrvDir {
// this method for got time/km/point from google ipa directions
  static Future<DirectionDetails?> obtainPlaceDirectionDetails(
      LatLng initialPostion, LatLng finalPostion, BuildContext context) async {
    DirectionDetails directionDetails = DirectionDetails(
        distanceText: "",
        durationText: "",
        distanceVale: 0,
        durationVale: 0,
        enCodingPoints: "");
    final directionUrl = Uri.parse(
        "https://maps.googleapis.com/maps/api/directions/json?origin=${initialPostion.latitude},${initialPostion.longitude}&destination=${finalPostion.latitude},${finalPostion.longitude}&key=$mapKey");

    final res = await GetUrl().getUrlMethod(directionUrl);
    if (res == "failed") {
      return null;
    }
    if (res["status"] == "OK") {
      // DirectionDetails directionDetails = DirectionDetails(
      //     distanceText: "",
      //     durationText: "",
      //     distanceVale: 0,
      //     durationVale: 0,
      //     enCodingPoints: "");
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
    return directionDetails;
  }

// this method for calc amount after check Country + carType
  static int calculateFares1(DirectionDetails directionDetails,
      String carTypePro, BuildContext context) {
    final countryName =
        Provider.of<DriverInfoModelProvider>(context, listen: false)
            .driverInfo
            .country;
    final rideInfoProvider =
        Provider.of<RideRequestInfoProvider>(context, listen: false)
            .rideDetails
            .amount;
    double culculFinal = 0.0;
    double timeTravelFare = (directionDetails.durationVale / 60) * 0.20;
    double distanceTravelFare = (directionDetails.distanceVale / 1000) * 0.60;
    double fareAmont = timeTravelFare + distanceTravelFare;
    if (carTypePro.contains("Taxi-4 seats")) {
      if (countryName.contains('T')) {
        culculFinal = fareAmont * 10 + 0.70 * 10.00;
      } else if (countryName.contains("Morocco")) {
        culculFinal = fareAmont * 10 + 0.70 * 10.00;
      } else if (countryName.contains("Sudan")) {
        culculFinal = fareAmont * 450 + 0.70 * 450;
      } else if (countryName.contains("Saudi Arabia")) {
        culculFinal = fareAmont + 1.85 * 3.75 + 2.70 * 3.75;
      } else if (countryName.contains("Qatar")) {
        culculFinal = fareAmont - 0.25 * 3.64 + 2.75 * 3.75;
      } else if (countryName.contains("Libya")) {
        culculFinal = fareAmont - 0.30 * 4.80 + 1 * 4.80;
      } else if (countryName.contains("Kuwait")) {
        culculFinal = fareAmont + 1.65 * 0.32 + 4.88 * 0.32;
      } else if (countryName.contains("Iraq")) {
        culculFinal = fareAmont + 1.20 + 2.73;
      } else if (countryName.contains("United Arab Emirates")) {
        culculFinal = fareAmont - 0.30 * 3.67 + 3.30 * 3.67;
      } else {
        culculFinal = fareAmont * 10 + 0.70 * 10.00;
      }
    }
    else if (carTypePro.contains("Medium commercial-6-10 seats")) {
    if (countryName.contains('T')) {
      culculFinal = double.parse(rideInfoProvider);
    } else if (countryName.contains("Morocco")) {
    culculFinal = fareAmont + 0.20 * 10 + 1.50 * 10.00;
    } else if (countryName.contains("Sudan")) {
    culculFinal = fareAmont * 450 + 1.50 * 450;
    } else if (countryName.contains("Saudi Arabia")) {
    culculFinal = fareAmont + 1.85 + 0.20 * 3.75 + 3.70 * 3.75;
    } else if (countryName.contains("Qatar")) {
    culculFinal = fareAmont * 3.64 + 4.75 * 3.75;
    } else if (countryName.contains("Libya")) {
    culculFinal = fareAmont * 4.80 + 3 * 4.80;
    } else if (countryName.contains("Kuwait")) {
    culculFinal = fareAmont + 0.10 + 1.65 * 0.32 + 5.88 * 0.32;
    } else if (countryName.contains("Iraq")) {
    culculFinal = fareAmont + 0.20 + 1.20 + 4.73;
    } else if (countryName.contains("United Arab Emirates")) {
    culculFinal = fareAmont * 3.67 + 5.30 * 3.67;
    } else {
    culculFinal = fareAmont * 10 + 0.70 * 10.00;
    }
    }
    else if (carTypePro.contains("Big commercial-11-19 seats")) {
    if (countryName.contains("T")) {
      culculFinal = double.parse(rideInfoProvider);
    } else if (countryName.contains("Morocco")) {
    culculFinal = fareAmont + 0.20 * 10 + 2 * 10.00;
    } else if (countryName.contains("Sudan")) {
    culculFinal = fareAmont * 450 + 2 * 450;
    } else if (countryName.contains("Saudi Arabia")) {
    culculFinal = fareAmont + 1.85 + 0.20 * 3.75 + 4.70 * 3.75;
    } else if (countryName.contains("Qatar")) {
    culculFinal = fareAmont * 3.64 + 5.75 * 3.64;
    } else if (countryName.contains("Libya")) {
    culculFinal = fareAmont * 4.80 + 4 * 4.80;
    } else if (countryName.contains("Kuwait")) {
    culculFinal = fareAmont + 0.10 + 1.65 * 0.32 + 6.88 * 0.32;
    } else if (countryName.contains("Iraq")) {
    culculFinal = fareAmont + 0.20 + 1.20 + 5.73;
    } else if (countryName.contains("United Arab Emirates")) {
    culculFinal = fareAmont * 3.67 + 6.30 * 3.67;
    } else {
    culculFinal = fareAmont * 10 + 0.70 * 16.00;
    }
    }
    else {
    culculFinal = fareAmont * 10 + 0.70 * 16.00;
    }
    return culculFinal.truncate();
  }
}
