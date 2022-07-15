// this class for save data all trip driver

class TripHistory {
  late String pickAddress;
  late String dropAddress;
  late String total;
  late String trip;
  TripHistory(this.pickAddress, this.dropAddress, this.total, this.trip);

  TripHistory.fromMap(Map<String, dynamic> map) {
    pickAddress = map["pickAddress"];
    dropAddress = map["dropAddress"];
    total = map["total"];
    trip = map["trip"];
  }
}
