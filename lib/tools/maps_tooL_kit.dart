// this class for calc icon marker rotation when driver drive his car
import 'package:maps_toolkit/maps_toolkit.dart';

class MapToolKit {
  static double getMarkerRotation(sLat, sLon, dLat, dLan) {
    var rot =
        SphericalUtil.computeHeading(LatLng(sLat, sLon), LatLng(dLat, dLan));
    return rot.toDouble();
  }
}
