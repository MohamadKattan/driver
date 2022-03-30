// this class for listing to trip history will got from realTime

import 'package:driver/model/trip_history.dart';
import 'package:flutter/cupertino.dart';

class TripHistoryProvider extends ChangeNotifier {
  late TripHistory history = TripHistory("", "", "", "");

  void updateState(TripHistory state) {
    history = state;
    notifyListeners();
  }
}
