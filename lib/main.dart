import 'package:driver/user_screen/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
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
import 'my_provider/new_ride_indector.dart';
import 'my_provider/ride_request_info.dart';
import 'my_provider/tilte_arrived_button_provider.dart';
import 'my_provider/user_id_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  if (defaultTargetPlatform == TargetPlatform.android) {
    AndroidGoogleMapsFlutter.useAndroidViewSurface = true;
  }

  runApp(const MyApp());
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
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Garanti driver',
        home: SplashScreen(),
      ),
    );
  }
}
