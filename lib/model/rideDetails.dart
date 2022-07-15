// this class for save ride info to show to driver when rider do order by push notification

import 'package:google_maps_flutter/google_maps_flutter.dart';

class RideDetails {
  late String riderName;
  late String riderPhone;
  late String userId;
  late String vehicleTypeId;
  late String pickupAddress;
  late String dropoffAddress;
  late String paymentMethod;
  late LatLng pickup;
  late LatLng dropoff;
  late String km;
  late String amount;
  late String tourismCityName;
  RideDetails({
    required this.userId,
    required this.riderName,
    required this.riderPhone,
    required this.paymentMethod,
    required this.vehicleTypeId,
    required this.pickupAddress,
    required this.pickup,
    required this.dropoffAddress,
    required this.dropoff,
    required this.km,
    required this.amount,
    required this.tourismCityName,
  });
}
