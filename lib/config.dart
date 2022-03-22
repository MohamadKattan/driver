
import 'dart:async';

import 'package:driver/repo/auth_srv.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

String mapKey = "AIzaSyBt7etvZRY_OrzFcCsawNb22jqSzE2mRDg";

GoogleMapController? newGoogleMapController;

StreamSubscription<Position>?homeScreenStreamSubscription;

User? currentUser = AuthSev().auth.currentUser;