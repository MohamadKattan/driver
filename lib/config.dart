
import 'dart:async';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:driver/repo/auth_srv.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

String mapKey = "AIzaSyAKMapANMFqO7-hXUfsjfQHtQG6JlSnuAo";
String mapBox = "pk.eyJ1Ijoibml6YW04NCIsImEiOiJjbDN2bzBjcHEwNjR5M2Rsemtra29qZmJ4In0.R5AN3bDWWvCgFiy3ZzMwlQ";
GoogleMapController? newGoogleMapController;
StreamSubscription<Position>?homeScreenStreamSubscription;
StreamSubscription<Position>?newRideScreenStreamSubscription;
StreamSubscription<Position>?newStreamSubscription;
User? currentUser = AuthSev().auth.currentUser;
bool isLite = false;
int rideRequestTimeOut = 120;
String riderName = "";
final AssetsAudioPlayer assetsAudioPlayer =AssetsAudioPlayer();
 int exPlan = 0;
 int tripcount = 5;
 bool isBackground=false;
///for payment
double finalAmont = 0;
double finalPlan = 0;







