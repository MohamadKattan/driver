// this class for bottom sheet provider
import 'package:flutter/cupertino.dart';

class BottomSheetProviderPreBooking extends ChangeNotifier{
  double val = -700.0;
  void updateState(double state){
    val=state;
    notifyListeners();
  }
}