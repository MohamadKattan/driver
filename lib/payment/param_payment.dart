import 'package:driver/notificatons/push_notifications_srv.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:provider/provider.dart';
import '../my_provider/payment_indector_provider.dart';
import '../tools/tools.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../tools/url_lunched.dart';
class ParamPayment{


  static const Map<String, String> _headerPayment = {
    "Content-Type": "application/json",
  };
  Future<void>makePayment(String newAmountPlan, int newExPlan, String newCurrencyType, String url, BuildContext context)async{
    Map<String, dynamic> body = {
      "user_id": userId,
      "amount": newAmountPlan,
      "exPlan":newExPlan,
      "currency": newCurrencyType,
      "status":"payed"
    };
    http.Response res = await http.post(Uri.parse(url),
        headers: _headerPayment, body: convert.jsonEncode(body));
    if (res.statusCode == 200) {
      // var data = convert.jsonDecode(res.body);
      Provider.of<PaymentIndector>(context,listen: false).updateState(false);
      await ToUrlLunch().toUrlLunch(url: url);
    } else {
      Provider.of<PaymentIndector>(context,listen: false).updateState(false);
      Provider.of<PaymentIndector>(context,listen: false).updateState(false);
      Tools().toastMsg(AppLocalizations.of(context)!.notSuccessfully, Colors.redAccent.shade700);
      Tools().toastMsg(AppLocalizations.of(context)!.anotherCard, Colors.redAccent.shade700);
      throw Exception("some thing error");
    }
  }
}