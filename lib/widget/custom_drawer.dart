// this class for custom drawer
import 'package:driver/user_screen/book_screen.dart';
import 'package:driver/user_screen/earn_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../my_provider/change_color_bottom.dart';
import '../my_provider/drawer_value_provider.dart';
import '../my_provider/driver_model_provider.dart';
import '../repo/geoFire_srv.dart';
import '../user_screen/payment_screen.dart';
import '../user_screen/profile_screen.dart';
import '../user_screen/rating_screen.dart';
import 'custom_divider.dart';

Widget customDrawer(BuildContext context) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: MediaQuery.of(context).size.height,
    decoration: const BoxDecoration(
      gradient: LinearGradient(colors: [
        Color(0xFFFFD54F),
        Color(0xFFFFD55F),
        Color(0xFFFFD56F),
        Color(0xFFFFD57F),
      ], begin: Alignment.bottomCenter, end: Alignment.topCenter),
    ),
    child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 25 / 100,
            child: GestureDetector(
              onTap: (){
                Provider.of<DrawerValueChange>(context, listen: false).updateValue(0);
                Provider.of<ChangeColorBottomDrawer>(context, listen: false).updateColorBottom(false);
              },
              child: DrawerHeader(
                child: Padding(
                  padding: const EdgeInsets.only(left: 80),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      showImage(context),
                      showUserName(context),
                      showUserPhone(context),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Column(
            children: [
              const SizedBox(
                height: 4.0,
              ),
              GestureDetector(
                onTap: ()=>
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const BookingScreen())),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                      children: const [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(Icons.history, color: Colors.black45,size: 30,),
                    ),
                    SizedBox(width: 8.0),
                    Padding(
                        padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                        child: Text(
                          "My Bookings",
                          style: TextStyle(color: Colors.black45,fontSize: 16.0),
                        ))
                  ]),
                ),
              ),
              const SizedBox(
                height: 8.0,
              ),
              CustomDivider().customDivider(),
              GestureDetector(
                onTap:()=> Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const EarningScreen())),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: const [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(Icons.money, color: Colors.black45,size: 30),
                      ),
                      SizedBox(
                        width: 8.0,
                      ),
                      Text(
                        "My Earning",
                        style: TextStyle(color: Colors.black45,fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 8.0,
              ),
              CustomDivider().customDivider(),
              GestureDetector(
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const ProfileScreen())),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: const [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(Icons.person, color: Colors.black45,size: 30),
                      ),
                      SizedBox(
                        width: 8.0,
                      ),
                      Text(
                        "My profile",
                        style: TextStyle(color: Colors.black45,fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 8.0,
              ),
              CustomDivider().customDivider(),
              GestureDetector(
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(
                      builder:(_)=>const RatingScreen()));
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: const [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(Icons.star, color: Colors.black45,size: 30,),
                      ),
                      SizedBox(
                        width: 8.0,
                      ),
                      Text(
                        "My Rating",
                        style: TextStyle(color: Colors.black45,fontSize: 16.0),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 8.0,
              ),
              CustomDivider().customDivider(),
              GestureDetector(
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const PaymentScreen())),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: const [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(Icons.payment, color: Colors.black45,size: 30,),
                      ),
                      SizedBox(width: 8.0),
                      Text(
                        "Payment screen",
                        style: TextStyle(color: Colors.black45,fontSize: 16.0),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 8.0,
              ),
              CustomDivider().customDivider(),
              GestureDetector(
                onTap: (){
                  GeoFireSrv().makeDriverOffLine(context);
                  SystemNavigator.pop();
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: const [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(Icons.exit_to_app, color: Colors.black45,size: 30.0,),
                      ),
                      SizedBox(
                        width: 8.0,
                      ),
                      Text("Exit",style: TextStyle(color: Colors.black45,fontSize: 16.0),),
                    ],
                  ),
                ),
              ),
              CustomDivider().customDivider(),
            ],
          ),
        ],
      ),
    ),
  );
}

Widget showImage(BuildContext context) {
  final userInfoRealTime =
  Provider.of<DriverInfoModelProvider>(context,listen: false).driverInfo;
  return userInfoRealTime.personImage.isNotEmpty
      ? Expanded(
    child: CachedNetworkImage(
      imageBuilder: (context, imageProvider) => Container(
        width: 60.0,
        height: 60.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
        ),
      ),
      imageUrl: userInfoRealTime.personImage,
      placeholder: (context, url) => const CircularProgressIndicator(),
      errorWidget: (context, url, error) => const Icon(Icons.person),
    ),
  )
      : const Expanded(
    flex: 0,
    child: CircleAvatar(
      radius: 30,
      backgroundColor: Colors.white,
      child: Icon(
        Icons.person,
        color: Colors.black12,
        size: 35,
      ),
    ),
  );
}

Widget showUserName(BuildContext context) {
  final userInfoRealTime =
      Provider.of<DriverInfoModelProvider>(context, listen: false).driverInfo;
  return userInfoRealTime.firstName.isNotEmpty
      ? Text("Hi ${userInfoRealTime.firstName}")
      : const Expanded(child: Text("Welcome back"));
}

Widget showUserPhone(BuildContext context) {
  final userInfoRealTime =
      Provider.of<DriverInfoModelProvider>(context, listen: false).driverInfo;
  return userInfoRealTime.phoneNumber.isNotEmpty
      ? Text(userInfoRealTime.phoneNumber)
      : const Text("");
}
