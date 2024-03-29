import 'package:driver/user_screen/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:wakelock/wakelock.dart';
import 'my_provider/auth__inductor_provider.dart';
import 'my_provider/bottom_sheet_preBook.dart';
import 'my_provider/bottom_sheet_value.dart';
import 'my_provider/change_color_bottom.dart';
import 'my_provider/circle_indectorWeek.dart';
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
import 'my_provider/preBook_imagePro.dart';
import 'my_provider/ride_request_info.dart';
import 'my_provider/tilte_arrived_button_provider.dart';
import 'my_provider/trip_history_provider.dart';
import 'my_provider/user_id_provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';


// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  Wakelock.enable();
  final GoogleMapsFlutterPlatform mapsImplementation =
      GoogleMapsFlutterPlatform.instance;
  if (mapsImplementation is GoogleMapsFlutterAndroid) {
    mapsImplementation.useAndroidViewSurface = true;
  }
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(const MyApp());
  });
}
// last update at 10-2-2023
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
        ChangeNotifierProvider(create: (context) => IsNetWeek()),
        ChangeNotifierProvider(
            create: (context) => BottomSheetProviderPreBooking()),
        ChangeNotifierProvider(create: (context) => GetImagePreBook()),
      ],
      child: const MaterialApp(
        title: 'Garanti driver',
        debugShowCheckedModeBanner: false,
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
