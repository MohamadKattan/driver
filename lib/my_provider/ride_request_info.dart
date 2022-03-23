// this class for listing to rider request info when rider order a taxi for show his info to driver in dialog

import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../model/rideDetails.dart';

class RideRequestInfoProvider extends ChangeNotifier {
  late RideDetails rideDetails = RideDetails(
      userId: "",
      riderName: "",
      riderPhone: "",
      paymentMethod: "",
      vehicleTypeId: "",
      pickupAddress: "",
      pickup: const LatLng(0.0, 0.0),
      dropoffAddress: "",
      dropoff: const LatLng(0.0, 0.0));
  void updateState(RideDetails rideInfo) {
    rideDetails = rideInfo;
    notifyListeners();
  }
}
