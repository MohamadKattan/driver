//this class for listing to direction api

import 'package:flutter/cupertino.dart';
import '../model/direction_details.dart';

class DirectionDetailsPro extends ChangeNotifier {
  DirectionDetails directionDetails = DirectionDetails(
      distanceText: "",
      durationText: "",
      distanceVale: 0,
      durationVale: 0,
      enCodingPoints: "");

  Future<void> updateDirectionDetails(DirectionDetails details) async {
    directionDetails = details;
    notifyListeners();
  }
}
