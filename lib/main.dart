import 'dart:async';
import 'package:driver/payment/couut_plan_days.dart';
import 'package:driver/repo/auth_srv.dart';
import 'package:driver/repo/geoFire_srv.dart';
import 'package:driver/user_screen/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'config.dart';
import 'my_provider/auth__inductor_provider.dart';
import 'my_provider/bottom_sheet_value.dart';
import 'my_provider/change_color_bottom.dart';
import 'my_provider/color_arrived_button_provider.dart';
import 'my_provider/direction_details_provider.dart';
import 'my_provider/drawer_value_provider.dart';
import 'my_provider/driverInfo_inductor.dart';
import 'my_provider/driver_currentPosition_provider.dart';
import 'my_provider/driver_model_provider.dart';
import 'my_provider/dropBottom_value_provider.dart';
import 'my_provider/get_image_provider.dart';
import 'my_provider/icon_phone_value.dart';
import 'my_provider/indctor_profile_screen.dart';
import 'my_provider/new_ride_indector.dart';
import 'my_provider/payment_indector_provider.dart';
import 'my_provider/placeAdrees_name.dart';
import 'my_provider/ride_request_info.dart';
import 'my_provider/tilte_arrived_button_provider.dart';
import 'my_provider/trip_history_provider.dart';
import 'my_provider/user_id_provider.dart';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeService();
  await Firebase.initializeApp();
  if (defaultTargetPlatform == TargetPlatform.android) {
    AndroidGoogleMapsFlutter.useAndroidViewSurface = true;
  }
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(const MyApp());
  });
}

Future<void> initializeService() async {
  final service = FlutterBackgroundService();
  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: true,
      isForegroundMode: true,
    ),
    iosConfiguration: IosConfiguration(
      autoStart: true,
      onForeground: onStart,
      onBackground: onIosBackground,
    ),
  );
  service.startService();
}

bool onIosBackground(ServiceInstance service) {
  WidgetsFlutterBinding.ensureInitialized();

  return true;
}

void onStart(ServiceInstance service) async {
  await Firebase.initializeApp();
  String userId = AuthSev().auth.currentUser!.uid;
  DatabaseReference driverRef = FirebaseDatabase.instance.ref().child("driver");

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }
  service.on('stopService').listen((event) {
    service.stopSelf();
  });
  driverRef.child(userId).child("service").set("working");

  /// stop for now under test
  // driverRef.child(userId).child("newRide").onDisconnect().remove();

  // await driverRef.child(userId).child("newRide").once().then((value) async {
  //   final snap = value.snapshot.value;
  //   if (snap == null) {
  //     Geofire.initialize("availableDrivers");
  //     await Geofire.setLocation(userId,37.42796133580664, 122.085749655962);
  //     homeScreenStreamSubscription?.pause();
  //     Geofire.stopListener();
  //     Geofire.removeLocation(userId);
  //   }
  // });

  if (userId.isNotEmpty) {
    await PlanDays().setIfBackgroundOrForeground(true);
    await driverRef.child(userId).child("exPlan").once().then((value) {
      if (value.snapshot.exists && value.snapshot.value != null) {
        final snap = value.snapshot.value;
        if (snap != null) {
          exPlan = int.parse(snap.toString());
        }
      }
    });
  }

  Timer.periodic(const Duration(seconds: 50), (timer) async {
    if (exPlan == 0) {
      driverRef.child(userId).child("status").once().then((value) {
        if (value.snapshot.exists && value.snapshot.value != null) {
          final snap = value.snapshot.value;
          String _status = snap.toString();
          if (_status == "checkIn" || _status == "") {
            timer.cancel();
            return;
          }
          driverRef.child(userId).child("status").set("payTime");
          timer.cancel();
          GeoFireSrv().makeDriverOffLine();
        }
      });
    }
    else if(exPlan>0){
      exPlan = exPlan - 1;
      await driverRef.child(userId).child("exPlan").set(exPlan);
      await driverRef.child(userId).child("service").once().then((value) {
        if (value.snapshot.value != null) {
          final snap = value.snapshot.value;
          String serviceWork = snap.toString();
          if (serviceWork == "working") {
            gotLocationInTermented(userId,driverRef);
          }
        } else {
          return;
        }
      });
      if (exPlan <= 0) {
        driverRef.child(userId).child("status").once().then((value) {
          if (value.snapshot.exists && value.snapshot.value != null) {
            final snap = value.snapshot.value;
            String _status = snap.toString();
            if (_status == "checkIn" || _status == "") {
              timer.cancel();
              return;
            }
            driverRef.child(userId).child("status").set("payTime");
            timer.cancel();
            GeoFireSrv().makeDriverOffLine();
          }
        });
      }
    }
    if (service is AndroidServiceInstance) {
      service.setForegroundNotificationInfo(
        title: "Garanti Taxi : ",
        content: "Location working in background",
      );
      // test using external plugin
      final deviceInfo = DeviceInfoPlugin();
      String? device;
      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        device = androidInfo.model;
      }

      if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        device = iosInfo.model;
      }

      service.invoke(
        'update',
        {
          "current_date": DateTime.now().toIso8601String(),
          "device": device,
        },
      );
    }
  });
}
//this method for got driver live location if app torment
Future<void> gotLocationInTermented(String userId, DatabaseReference driverRef) async {
 late String _notAvailable;
 late String _newRideStatus;
 await driverRef.child(userId).child("offLine").once().then((value){
    if(value.snapshot.value!=null){
      _notAvailable = value.snapshot.value.toString();
    }
  });
  await driverRef.child(userId).child("newRide").once().then((value){
    if(value.snapshot.value!=null){
      _newRideStatus = value.snapshot.value.toString();
    }
  });
  if(_notAvailable=="notAvailable"||_newRideStatus=="accepted"){
    return;
  }else{
    var geolocator = Geolocator();
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    Geofire.initialize("availableDrivers");
    await Geofire.setLocation(userId, position.latitude, position.longitude);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => TrueFalse()),
        ChangeNotifierProvider(create: (context) => UserIdProvider()),
        ChangeNotifierProvider(create: (context) => DropBottomValue()),
        ChangeNotifierProvider(create: (context) => BottomSheetValue()),
        ChangeNotifierProvider(create: (context) => GetImageProvider()),
        ChangeNotifierProvider(create: (context) => DriverInfoInductor()),
        ChangeNotifierProvider(create: (context) => PhoneIconValue()),
        ChangeNotifierProvider(create: (context) => DriverInfoModelProvider()),
        ChangeNotifierProvider(create: (context) => DrawerValueChange()),
        ChangeNotifierProvider(create: (context) => ChangeColorBottomDrawer()),
        ChangeNotifierProvider(create: (context) => DriverCurrentPosition()),
        ChangeNotifierProvider(create: (context) => RideRequestInfoProvider()),
        ChangeNotifierProvider(create: (context) => DirectionDetailsPro()),
        ChangeNotifierProvider(create: (context) => NewRideScreenIndector()),
        ChangeNotifierProvider(create: (context) => TitleArrived()),
        ChangeNotifierProvider(create: (context) => ColorButtonArrived()),
        ChangeNotifierProvider(create: (context) => TripHistoryProvider()),
        ChangeNotifierProvider(create: (context) => InductorProfileProvider()),
        ChangeNotifierProvider(create: (context) => PaymentIndector()),
        ChangeNotifierProvider(create: (context) => PlaceName()),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Garanti driver',
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          Locale('en', ''), // English, no country code
          Locale('ar', ''), // Arabic, no country code
          Locale('tr', ''), // Turkish, no country code
        ],
        home: SplashScreen(),
      ),
    );
  }
}
