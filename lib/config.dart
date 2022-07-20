
import 'dart:async';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:driver/repo/auth_srv.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

String mapKey = "AIzaSyDh5NNwfDJFU27Y_yMpVcWeeepBQBbewmM";
String mapBox = "pk.eyJ1Ijoibml6YW04NCIsImEiOiJjbDR3c3FhdDUxbHM5M2NzM2kydjR0Zzl0In0.24gmrxZ6tyh636f7bkV3og";
GoogleMapController? newGoogleMapController;
StreamSubscription<Position>?homeScreenStreamSubscription;
StreamSubscription<Position>?newRideScreenStreamSubscription;
StreamSubscription<Position>?newStreamSubscription;
late StreamSubscription<DatabaseEvent> subscriptionNot1;
User? currentUser = AuthSev().auth.currentUser;
bool isLite = false;
int rideRequestTimeOut = 120;
String riderName = "";
final AssetsAudioPlayer assetsAudioPlayer =AssetsAudioPlayer();
int? exPlan;
DateTime? valDateTime;
int tripcount = 5;
 bool isBackground=false;
///for payment
double finalAmont = 0;
double finalPlan = 0;
String? tokenPhone;
bool runLocale = false;







