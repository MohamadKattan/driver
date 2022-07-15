// this class for got current user

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class UserIdProvider extends ChangeNotifier {
  late User currentUserId;

  Future<void> getUserIdProvider(User user) async {
    currentUserId = user;
    notifyListeners();
  }
}
