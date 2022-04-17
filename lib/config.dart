
import 'dart:async';
import 'package:driver/repo/auth_srv.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

String mapKey = "AIzaSyBt7etvZRY_OrzFcCsawNb22jqSzE2mRDg";
String mapBox = "pk.eyJ1IjoibW9oYW1hZDg4IiwiYSI6ImNsMWl5NGdwdjBvcnUzY24zOWs0ejUyczYifQ.yvLkipuTn_XHHBz-lCAUAA";

GoogleMapController? newGoogleMapController;

StreamSubscription<Position>?homeScreenStreamSubscription;
StreamSubscription<Position>?newRideScreenStreamSubscription;
StreamSubscription<Position>?newStreamSubscription;

User? currentUser = AuthSev().auth.currentUser;
double myRating = 0.0;
bool isLite = false;
int rideRequestTimeOut = 30;


