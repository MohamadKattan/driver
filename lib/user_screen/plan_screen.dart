import 'package:driver/user_screen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../my_provider/driver_model_provider.dart';
import '../my_provider/payment_indector_provider.dart';
import '../notificatons/push_notifications_srv.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../widget/custom_circuler.dart';
import 'card_payment_screen.dart';

class PlanScreen extends StatefulWidget {
  const PlanScreen({Key? key}) : super(key: key);

  @override
  State<PlanScreen> createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> {
  late String amountPlan;
  late int currencyType;
  late int endExPlan;
  late int oldExPlan;
  // late double amountPlan1 ;
  // late  double amountPlan2 ;
  // late double amountPlan3 ;
  // String urlEn = "https://garantidriver.com/New_Pay";
  // String urlAn = "https://garantidriver.com/New_pay_ar";
  // String urlTr = "https://garantidriver.com/tr_pay";
  // String currencyTr = "TRY";
  // String currencyUsd= "USD";

  @override
  Widget build(BuildContext context) {
    final info = Provider.of<DriverInfoModelProvider>(context).driverInfo;
    bool isLoadingPayment = Provider.of<PaymentIndector>(context).isTrue;
    return WillPopScope(
      onWillPop: () async => false,
      child: SafeArea(
        child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              leading: IconButton(
                  onPressed: () {
                    info.status == "payed"
                        ? Navigator.pop(context)
                        : Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const SplashScreen()));
                  },
                  icon: const Icon(Icons.arrow_back_ios)),
              backgroundColor: const Color(0xFF00A3E0),
              title: Text(AppLocalizations.of(context)!.paymentScreen,
                  style: const TextStyle(color: Colors.white)),
            ),
            body: Stack(
              children: [
                SingleChildScrollView(
                    child: Column(
                  children: [
                    const SizedBox(height: 8.0),
                    Text(AppLocalizations.of(context)!.planChoose,
                        style: const TextStyle(
                            color: Colors.black45, fontSize: 16.0)),
                    const SizedBox(height: 8.0),
                    GestureDetector(
                      onTap: () {
                        checkamout1(info.carType, context, info.country);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        margin: const EdgeInsets.all(14.0),
                        height: 200,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: const Color(0xFF5CAFE5),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(AppLocalizations.of(context)!.plan1,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold)),
                            ),
                            Text(AppLocalizations.of(context)!.working30day,
                                style: const TextStyle(
                                    fontSize: 16.0, color: Colors.white)),
                            const SizedBox(height: 40.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(AppLocalizations.of(context)!.cost,
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 20.0)),
                                info.country.contains("T")
                                    ? Text(
                                        info.carType == "Taxi-4 seats"
                                            ? "180 TL"
                                            : "300 TL",
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold))
                                    : Text(
                                        info.carType == "Taxi-4 seats"
                                            ? "10\$"
                                            : "20\$",
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold))
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () =>
                          checkAmount2(info.carType, context, info.country),
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        margin: const EdgeInsets.all(14.0),
                        height: 200,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: const Color(0xFF00A3E0),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(AppLocalizations.of(context)!.plan2,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold)),
                            ),
                            Text(AppLocalizations.of(context)!.working90day,
                                style: const TextStyle(
                                    fontSize: 16.0, color: Colors.white70)),
                            const SizedBox(height: 40.0),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(AppLocalizations.of(context)!.cost,
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 20.0)),
                                  info.country.contains("T")
                                      ? Text(
                                          info.carType == "Taxi-4 seats"
                                              ? "470 TL"
                                              : "800 TL",
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.bold))
                                      : Text(
                                          info.carType == "Taxi-4 seats"
                                              ? " 30\$"
                                              : "55\$",
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.bold))
                                ])
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () =>
                          checkAmount3(info.carType, context, info.country),
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        margin: const EdgeInsets.all(14.0),
                        height: 200,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFBC408),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(AppLocalizations.of(context)!.plan3,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold)),
                            ),
                            Text(AppLocalizations.of(context)!.working180day,
                                style: const TextStyle(
                                    fontSize: 16.0, color: Colors.white70)),
                            const SizedBox(height: 40.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(AppLocalizations.of(context)!.cost,
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 20.0)),
                                info.country.contains("T")
                                    ? Text(
                                        info.carType == "Taxi-4 seats"
                                            ? "800TL"
                                            : "1350TL",
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold))
                                    : Text(
                                        info.carType == "Taxi-4 seats"
                                            ? " 55\$"
                                            : "95\$",
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold))
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                )),
                isLoadingPayment
                    ? CircularInductorCostem().circularInductorCostem(context)
                    : const SizedBox(),
              ],
            )),
      ),
    );
  }

  Future<void> checkamout1(
      String carType, BuildContext context, String countryName) async {
    if (countryName.contains("T")) {
      currencyType = 1000;
      if (carType == "Taxi-4 seats") {
        // amountPlan1 =180;
        amountPlan = "180,00";
      } else {
        // amountPlan1 = 300;
        amountPlan = "300,00";
      }
    } else {
      currencyType = 1001;
      if (carType == "Taxi-4 seats") {
        // amountPlan1 =180;
        amountPlan = "180,00";
        // amountPlan = "10,00";
      } else {
        amountPlan = "300,00";
        // amountPlan = "300,00";
        // amountPlan1 = 2000;
      }
    }
    await driverRef.child(userId).child("exPlan").once().then((value) async {
      if (value.snapshot.exists && value.snapshot.value != null) {
        final snap = value.snapshot.value.toString();
        oldExPlan = int.parse(snap);
        if (oldExPlan > 0) {
          int updateExPlan = oldExPlan + 43200;
          endExPlan = updateExPlan;
          // await driverRef.child(userId).child("exPlan").set(updateExPlan);
        } else if (oldExPlan <= 0) {
          endExPlan = 43200;
          // await driverRef.child(userId).child("exPlan").set(exPlan);
        } else {
          endExPlan = 43200;
        }
      }
    });
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => CardPaymentScreen(
                  amount: amountPlan,
                  planDay: endExPlan,
                  currencyType: currencyType,
                  oldExplan: oldExPlan,
                )));
  }

  checkAmount2(String carType, BuildContext context, String countryName) async {
    if (countryName.contains("T")) {
      currencyType = 1000;
      if (carType == "Taxi-4 seats") {
        // amountPlan2 =47000;
        amountPlan = "470,00";
      } else {
        // amountPlan2 = 70000;
        amountPlan = "800,00";
      }
    } else {
      currencyType = 1001;
      if (carType == "Taxi-4 seats") {
        // amountPlan2 =3000;
        // amountPlan = "30,00";
        amountPlan = "470,00";
      } else {
        // amountPlan2 = 5500;
        // amountPlan = "55,00";
        amountPlan = "800,00";
      }
    }
    await driverRef.child(userId).child("exPlan").once().then((value) async {
      if (value.snapshot.exists && value.snapshot.value != null) {
        final snap = value.snapshot.value.toString();
        oldExPlan = int.parse(snap);
        if (oldExPlan > 0) {
          int updateExPlan = oldExPlan + 129600;
          endExPlan = updateExPlan;
          // await driverRef.child(userId).child("exPlan").set(updateExPlan);
        } else if (oldExPlan <= 0) {
          endExPlan = 129600;
          // await driverRef.child(userId).child("exPlan").set(exPlan);
        } else {
          endExPlan = 129600;
        }
      }
    });
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => CardPaymentScreen(
                  amount: amountPlan,
                  planDay: endExPlan,
                  currencyType: currencyType,
                  oldExplan: oldExPlan,
                )));
  }

  checkAmount3(String carType, BuildContext context, String countryName) async {
    if (countryName.contains("T")) {
      currencyType = 1000;
      if (carType == "Taxi-4 seats") {
        // amountPlan3 =80000;
        amountPlan = "800,00";
      } else {
        // amountPlan3 = 135000;
        amountPlan = "1350,00";
      }
    } else {
      currencyType = 1001;
      if (carType == "Taxi-4 seats") {
        // amountPlan3 =5500;
        // amountPlan = "55,00";
        amountPlan = "800,00";
      } else {
        amountPlan = "1350,00";
        // amountPlan = "95,00";
        // amountPlan3 = 9500;
      }
    }
    await driverRef.child(userId).child("exPlan").once().then((value) async {
      if (value.snapshot.exists && value.snapshot.value != null) {
        final snap = value.snapshot.value.toString();
        oldExPlan = int.parse(snap);
        if (oldExPlan > 0) {
          int updateExPlan = oldExPlan + 259200;
          endExPlan = updateExPlan;
          // await driverRef.child(userId).child("exPlan").set(updateExPlan);
        } else if (oldExPlan <= 0) {
          endExPlan = 259200;
          // await driverRef.child(userId).child("exPlan").set(exPlan);
        } else {
          endExPlan = 259200;
        }
      }
    });
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => CardPaymentScreen(
                  amount: amountPlan,
                  planDay: endExPlan,
                  currencyType: currencyType,
                  oldExplan: oldExPlan,
                )));
  }
}
