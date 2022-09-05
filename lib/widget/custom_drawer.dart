// this class for custom drawer

import 'dart:io';
import 'package:driver/user_screen/book_screen.dart';
import 'package:driver/user_screen/earn_screen.dart';
import 'package:driver/user_screen/plan_screen.dart';
import 'package:driver/user_screen/policy_screen.dart';
import 'package:driver/widget/switch_bottom_drarwer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../my_provider/change_color_bottom.dart';
import '../my_provider/drawer_value_provider.dart';
import '../my_provider/driver_model_provider.dart';
import '../user_screen/contact_us.dart';
import '../user_screen/profile_screen.dart';
import '../user_screen/rating_screen.dart';
import 'custom_divider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Widget customDrawer(BuildContext context) {
  final planProvider =
      Provider.of<DriverInfoModelProvider>(context).driverInfo.exPlan;
  double day = planProvider / 60 / 24;
  int newDay = day.floor();
  return Container(
    width: MediaQuery.of(context).size.width,
    height: MediaQuery.of(context).size.height,
    decoration: const BoxDecoration(
      gradient: LinearGradient(colors: [
        Color(0xFF00A3E0),
        Colors.white,
        Colors.white,
        Colors.white,
        Colors.white,
      ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
    ),
    child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 25 / 100,
            child: GestureDetector(
              onTap: () {
                Provider.of<DrawerValueChange>(context, listen: false)
                    .updateValue(0);
                Provider.of<ChangeColorBottomDrawer>(context, listen: false)
                    .updateColorBottom(false);
              },
              child: DrawerHeader(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    showImage(context),
                    showUserName(context),
                    showUserPhone(context),
                    const SizedBox(height: 3.0),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Text(
                                planProvider <= 0
                                    ? AppLocalizations.of(context)!.planFinished
                                    : AppLocalizations.of(context)!.yPlan,
                                style: const TextStyle(
                                    color: Colors.black45, fontSize: 16.0)),
                            Text(
                                newDay.toString() +
                                    AppLocalizations.of(context)!.day,
                                style: TextStyle(
                                    fontSize: 20.0,
                                    color: planProvider <= 7200
                                        ? Colors.redAccent.shade700
                                        : Colors.greenAccent.shade700))
                          ],
                        ),
                      ],
                    )
                  ],
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
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const BookingScreen())),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(mainAxisSize: MainAxisSize.max, children: [
                    Padding(
                      padding: EdgeInsets.only(
                          left: 8.0,
                          bottom: 8.0,
                          top: 8.0,
                          right: valueIconPadding(context)),
                      child: const Icon(
                        Icons.history,
                        color: Colors.black45,
                        size: 35,
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                        child: Text(
                          AppLocalizations.of(context)!.booking,
                          style: const TextStyle(
                              color: Colors.black45, fontSize: 20.0),
                        ))
                  ]),
                ),
              ),
              const SizedBox(
                height: 8.0,
              ),
              CustomDivider().customDivider(),
              GestureDetector(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const EarningScreen())),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            left: 8.0,
                            bottom: 8.0,
                            top: 8.0,
                            right: valueIconPadding(context)),
                        child: const Icon(Icons.money,
                            color: Colors.black45, size: 35),
                      ),
                      const SizedBox(
                        width: 8.0,
                      ),
                      Text(
                        AppLocalizations.of(context)!.myEarning,
                        style: const TextStyle(
                            color: Colors.black45, fontSize: 20),
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
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ProfileScreen())),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            left: 8.0,
                            bottom: 8.0,
                            top: 8.0,
                            right: valueIconPadding(context)),
                        child: const Icon(Icons.person,
                            color: Colors.black45, size: 35),
                      ),
                      const SizedBox(
                        width: 8.0,
                      ),
                      Text(
                        AppLocalizations.of(context)!.update,
                        style: const TextStyle(
                            color: Colors.black45, fontSize: 20),
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
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const RatingScreen()));
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            left: 8.0,
                            bottom: 8.0,
                            top: 8.0,
                            right: valueIconPadding(context)),
                        child: const Icon(
                          Icons.star,
                          color: Colors.black45,
                          size: 35,
                        ),
                      ),
                      const SizedBox(
                        width: 8.0,
                      ),
                      Text(
                        AppLocalizations.of(context)!.myRating,
                        style: const TextStyle(
                            color: Colors.black45, fontSize: 20.0),
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
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PlanScreen())),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                left: 8.0,
                                bottom: 8.0,
                                top: 8.0,
                                right: valueIconPadding(context)),
                            child: const Icon(
                              Icons.payment,
                              color: Colors.black45,
                              size: 35,
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          Text(
                            AppLocalizations.of(context)!.paymentScreen,
                            style: const TextStyle(
                                color: Colors.black45, fontSize: 20.0),
                          ),
                        ],
                      ),
                      Center(
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: 8.0,
                              bottom: 8.0,
                              left: 8.0,
                              right: valueIconPadding1(context)),
                          child: Container(
                              height: 20,
                              decoration:
                                  const BoxDecoration(shape: BoxShape.circle),
                              child: Image.asset(
                                "images/credit.png",
                                width: 40,
                                height: 40,
                                fit: BoxFit.cover,
                              )),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 8.0,
              ),
              CustomDivider().customDivider(),
              GestureDetector(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PolicyScreen())),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(mainAxisSize: MainAxisSize.max, children: [
                    Padding(
                      padding: EdgeInsets.only(
                          left: 8.0,
                          bottom: 8.0,
                          top: 8.0,
                          right: valueIconPadding(context)),
                      child: const Icon(
                        Icons.policy,
                        color: Colors.black45,
                        size: 35,
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                        child: Text(
                          AppLocalizations.of(context)!.policy,
                          style: const TextStyle(
                              color: Colors.black45, fontSize: 20.0),
                        ))
                  ]),
                ),
              ),
              CustomDivider().customDivider(),
              GestureDetector(
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const ContactUs())),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(mainAxisSize: MainAxisSize.max, children: [
                    Padding(
                      padding: EdgeInsets.only(
                          left: 8.0,
                          bottom: 8.0,
                          top: 8.0,
                          right: valueIconPadding(context)),
                      child: const Icon(
                        Icons.email,
                        color: Colors.black45,
                        size: 35,
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                        child: Text(
                          AppLocalizations.of(context)!.uss,
                          style: const TextStyle(
                              color: Colors.black45, fontSize: 20.0),
                        ))
                  ]),
                ),
              ),
              const SizedBox(
                height: 8.0,
              ),
              CustomDivider().customDivider(),
              GestureDetector(
                onTap: () {
                  if (Platform.isAndroid) {
                    SystemNavigator.pop();
                  }
                  Provider.of<DrawerValueChange>(context, listen: false)
                      .updateValue(0);
                  Provider.of<ChangeColorBottomDrawer>(context, listen: false)
                      .updateColorBottom(false);
                  // exit(0);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            left: 8.0,
                            bottom: 8.0,
                            top: 8.0,
                            right: valueIconPadding(context)),
                        child: const Icon(
                          Icons.exit_to_app,
                          color: Colors.black45,
                          size: 35.0,
                        ),
                      ),
                      const SizedBox(
                        width: 8.0,
                      ),
                      Text(
                        AppLocalizations.of(context)!.exit,
                        style: const TextStyle(
                            color: Colors.black45, fontSize: 20.0),
                      ),
                    ],
                  ),
                ),
              ),
              CustomDivider().customDivider(),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SwitchBottomDrawer(),
                    const SizedBox(
                      width: 16.0,
                    ),
                    Image.asset(
                      "images/iconDrop.png",
                      height: 60.0,
                      width: 60.0,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0, right: 35),
                child: Text(
                  AppLocalizations.of(context)!.withCard,
                  style: const TextStyle(
                      color: Colors.black45,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

Widget showImage(BuildContext context) {
  final userInfoRealTime =
      Provider.of<DriverInfoModelProvider>(context, listen: false).driverInfo;
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
      ? Text(AppLocalizations.of(context)!.welcome +
          " " +
          userInfoRealTime.firstName)
      : Expanded(child: Text(AppLocalizations.of(context)!.welcome));
}

Widget showUserPhone(BuildContext context) {
  final userInfoRealTime =
      Provider.of<DriverInfoModelProvider>(context, listen: false).driverInfo;
  return userInfoRealTime.phoneNumber.isNotEmpty
      ? Text(userInfoRealTime.phoneNumber)
      : const Text("");
}

double valueIconPadding(BuildContext context) {
  late double val;
  if (AppLocalizations.of(context)!.day == "يوم") {
    val = 65.0;
  } else {
    val = 8.0;
  }
  return val.toDouble();
}

double valueIconPadding1(BuildContext context) {
  late double val;
  if (AppLocalizations.of(context)!.day == "Day" ||
      AppLocalizations.of(context)!.day == "Gun") {
    val = 95.0;
  } else {
    val = 8.0;
  }
  return val.toDouble();
}
