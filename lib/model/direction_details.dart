// this class for save data DirectionDetails from geolocater api

class DirectionDetails {
  late String enCodingPoints;
  late String distanceText;
  late String durationText;
  late int distanceVale;
  late int durationVale;

  DirectionDetails(
      {required this.distanceText,
      required this.durationText,
      required this.distanceVale,
      required this.durationVale,
      required this.enCodingPoints});
}
