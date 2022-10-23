// this class it will work in preBooking sheet
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class GetImagePreBook extends ChangeNotifier {
  XFile? carInside;
  XFile? carOutSide;
  XFile? carOutSide1;

  void updateCarInside(XFile val) {
    carInside = val;
    notifyListeners();
  }

  void updateCarOutSide(XFile val) {
    carOutSide = val;
    notifyListeners();
  }

  void updateCarOutSide1(XFile val) {
    carOutSide1 = val;
    notifyListeners();
  }
}
