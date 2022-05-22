import 'dart:async';
import 'package:driver/payment/couut_plan_days.dart';
import 'package:driver/repo/auth_srv.dart';
import 'package:driver/user_screen/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
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

    service.on('setAsBackground').listen((event) async {
      service.setAsBackgroundService();
      driverRef.child(userId).child("isLocal").set("local");
      /// stop for now under test
      // driverRef.child(userId).child("newRide").onDisconnect().remove();
    });
  }
  service.on('stopService').listen((event) {
    service.stopSelf();
  });
/// stop for now under test
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
    if (exPlan < 0) {
      driverRef.child(userId).child("status").once().then((value) {
        if (value.snapshot.exists && value.snapshot.value != null) {
          final snap = value.snapshot.value;
          String _status = snap.toString();
          if (_status == "checkIn") {
            timer.cancel();
            return;
          }
          driverRef.child(userId).child("status").set("payTime");
          timer.cancel();
        }
      });
    } else {
      exPlan = exPlan - 1;
      await driverRef.child(userId).child("exPlan").set(exPlan);

      if (exPlan < 0) {
        driverRef.child(userId).child("status").once().then((value) {
          if (value.snapshot.exists && value.snapshot.value != null) {
            final snap = value.snapshot.value;
            String _status = snap.toString();
            if (_status == "checkIn") {
              timer.cancel();
              return;
            }
            driverRef.child(userId).child("status").set("payTime");
            timer.cancel();
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
        home: SplashScreen(),
      ),
    );
  }
}
