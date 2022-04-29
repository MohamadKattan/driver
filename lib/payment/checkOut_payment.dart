// this class for payment getWay
//10738 Test Test 0c13d406-873b-403b-9c09-a5766840d98c

import 'dart:async';

import 'package:driver/model/card_payment.dart';
import 'package:driver/user_screen/splash_screen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert' as convert;
import '../my_provider/payment_indector_provider.dart';
import '../repo/auth_srv.dart';
import '../tools/tools.dart';
import '../user_screen/HomeScreen.dart';
import 'couut_plan_days.dart';

class CheckOutPayment {
  DatabaseReference driverRef = FirebaseDatabase.instance.ref().child("driver");
  String userId = AuthSev().auth.currentUser!.uid;

  static const sKey = "sk_test_8aa0f823-806d-4b1d-9bf7-244214a8a6f8";
  static const pKey = "pk_test_bb8702b9-9c5a-4b6d-b245-2f1daee310ec";
  static const tokenUrl = "https://api.sandbox.checkout.com/tokens";
  static const paymentUrl = "https://api.sandbox.checkout.com/payments";

  static const Map<String, String> _headerToken = {
    "Content-Type": "application/json",
    "Authorization": pKey,
  };

  static const Map<String, String> _headerPayment = {
    "Content-Type": "application/json",
    "Authorization": sKey,
  };

  Future<String> _getToken(CardPayment card,BuildContext context) async {
    Map<String, String> body = {
      "type": "card",
      "number": card.cardNumber,
      "expiry_month": card.expiryDateMouthe,
      "expiry_year": card.expiryDateYear
    };
    http.Response response = await http.post(Uri.parse(tokenUrl),
        headers: _headerToken, body: convert.jsonEncode(body));
    if (response.statusCode == 201) {
      var data = convert.jsonDecode(response.body);
      return data["token"];
    } else {
      Provider.of<PaymentIndector>(context,listen: false).updateState(false);
      Tools().toastMsg("transaction noy successful !!", Colors.redAccent.shade700);
      Tools().toastMsg("Try again and check your card info", Colors.redAccent.shade700);
      throw Exception("Card error");
    }
  }

  Future<bool> makePayment(CardPayment card, int amount, String s, BuildContext context, int planExpirt) async {
    var _token = await _getToken(card,context);
    print("ttttttt$_token");
    Map<String, dynamic> body = {
      "source": {"type": "token", "token": _token},
      "amount": amount,
      "currency": s,
    };
    http.Response res = await http.post(Uri.parse(paymentUrl),
        headers: _headerPayment, body: convert.jsonEncode(body));
    if (res.statusCode == 201) {
      Tools().toastMsg("transaction successful", Colors.green.shade700);
      await PlanDays().setExPlanToRealTime(planExpirt);
      await PlanDays().setIfBackgroundOrForeground(false);
      Navigator.push(context,MaterialPageRoute(builder: (_)=>const SplashScreen()));
      return true;
    } else {
      Provider.of<PaymentIndector>(context,listen: false).updateState(false);
      Tools().toastMsg("transaction noy successful !!", Colors.redAccent.shade700);
      Tools().toastMsg("Try again and check your card info", Colors.redAccent.shade700);
      throw Exception("Payment error");
    }
  }
}
