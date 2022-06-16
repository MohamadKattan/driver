/// canceled for now

// import 'dart:async';
// import 'package:driver/model/card_payment.dart';
// import 'package:driver/user_screen/splash_screen.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_background_service/flutter_background_service.dart';
// import 'package:http/http.dart' as http;
// import 'package:provider/provider.dart';
// import 'dart:convert' as convert;
// import '../my_provider/payment_indector_provider.dart';
// import '../repo/auth_srv.dart';
// import '../tools/tools.dart';
// import 'couut_plan_days.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
//
//
// class CheckOutPayment {
//   DatabaseReference driverRef = FirebaseDatabase.instance.ref().child("driver");
//   String userId = AuthSev().auth.currentUser!.uid;
//
//   static const sKey = "sk_test_12b7ef97-088b-485f-95a8-66fa3b6ceb4e";
//   static const pKey = "pk_test_7b4eb3a5-8986-4537-b3be-7015a5695538";
//   static const tokenUrl = "https://api.checkout.com/tokens";
//   static const paymentUrl = "https://api.checkout.com/payments";
//
//   static const Map<String, String> _headerToken = {
//     "Content-Type": "application/json",
//     "Authorization": pKey,
//   };
//
//   static const Map<String, String> _headerPayment = {
//     "Content-Type": "application/json",
//     "Authorization": sKey,
//   };
//
//   Future<String> _getToken(CardPayment card,BuildContext context) async {
//     Map<String, String> body = {
//       "type": "card",
//       "number": card.cardNumber,
//       "expiry_month": card.expiryDateMouthe,
//       "expiry_year": card.expiryDateYear
//     };
//     http.Response response = await http.post(Uri.parse(tokenUrl),
//         headers: _headerToken, body: convert.jsonEncode(body));
//     if (response.statusCode == 201) {
//       var data = convert.jsonDecode(response.body);
//       return data["token"];
//     } else {
//       Provider.of<PaymentIndector>(context,listen: false).updateState(false);
//       Tools().toastMsg(AppLocalizations.of(context)!.notSuccessfully, Colors.redAccent.shade700);
//       Tools().toastMsg(AppLocalizations.of(context)!.anotherCard, Colors.redAccent.shade700);
//       throw Exception("Card error");
//     }
//   }
//
//   Future<bool> makePayment(CardPayment card, int amount, String s, BuildContext context, int planExpirt) async {
//     var _token = await _getToken(card,context);
//     Map<String, dynamic> body = {
//       "source": {"type": "token", "token": _token},
//       "amount": amount,
//       "currency": s,
//     };
//     http.Response res = await http.post(Uri.parse(paymentUrl),
//         headers: _headerPayment, body: convert.jsonEncode(body));
//     if (res.statusCode == 201) {
//       Tools().toastMsg(AppLocalizations.of(context)!.successful, Colors.green.shade700);
//       await PlanDays().setExPlanToRealTime(planExpirt);
//       await PlanDays().setIfBackgroundOrForeground(false);
//       await PlanDays().setDriverPayed();
//       FlutterBackgroundService().invoke("setAsBackground");
//       Provider.of<PaymentIndector>(context,listen: false).updateState(false);
//       Navigator.push(context,MaterialPageRoute(builder:(_)=>const SplashScreen()));
//       return true;
//     } else {
//       Provider.of<PaymentIndector>(context,listen: false).updateState(false);
//       Tools().toastMsg(AppLocalizations.of(context)!.notSuccessfully, Colors.redAccent.shade700);
//       Tools().toastMsg(AppLocalizations.of(context)!.anotherCard, Colors.redAccent.shade700);
//       Navigator.push(context,MaterialPageRoute(builder: (_)=>const SplashScreen()));
//       throw Exception("Payment error");
//     }
//   }
// }
