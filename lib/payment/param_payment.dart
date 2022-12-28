import 'dart:math';
import 'package:driver/model/card_payment.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../config.dart';
import '../my_provider/change_color_bottom.dart';
import '../my_provider/drawer_value_provider.dart';
import '../my_provider/driver_model_provider.dart';
import '../my_provider/payment_indector_provider.dart';
import '../notificatons/push_notifications_srv.dart';
import '../tools/tools.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:xml/xml.dart' as xml;

class ParamPayment {
  static String paramUrl =
      "https://posws.param.com.tr/turkpos.ws/service_turkpos_prod.asmx?wsdl";
  static String serverUrl = "https://param-pay.herokuapp.com/pay";
  static Map<String, String> paramHeader = {'content-type': 'text/xml'};
  static Map<String, String> serverHeader = {
    'content-type': 'application/json'
  };
  DatabaseReference paidCheckRef =
      FirebaseDatabase.instance.ref().child("paidcheck");
  DatabaseReference paidRef = FirebaseDatabase.instance.ref().child("paid");

  // this method for set data when driver paid
  DateTime _setDateTime() {
    int _day;
    int _month;
    int _year;
    if (DateTime.now().month == 2 && DateTime.now().day == 28) {
      _day = 1;
      _month = DateTime.now().month + 1;
      _year = DateTime.now().year;
    }
    if (DateTime.now().month == 2 && DateTime.now().day == 29) {
      _day = 1;
      _month = DateTime.now().month + 1;
      _year = DateTime.now().year;
    } else if (DateTime.now().month == 2 && DateTime.now().day < 28) {
      _day = DateTime.now().day + 1;
      _month = DateTime.now().month;
      _year = DateTime.now().year;
    } else if (DateTime.now().month == 12 && DateTime.now().day < 30) {
      _day = DateTime.now().day + 1;
      _month = DateTime.now().month;
      _year = DateTime.now().year;
    } else if (DateTime.now().month == 12 && DateTime.now().day == 30) {
      _day = 1;
      _month = 1;
      _year = DateTime.now().year + 1;
    } else if (DateTime.now().month == 12 && DateTime.now().day == 31) {
      _day = 1;
      _month = 1;
      _year = DateTime.now().year + 1;
    } else if (DateTime.now().day < 30) {
      _day = DateTime.now().day + 1;
      _month = DateTime.now().month;
      _year = DateTime.now().year;
    } else {
      _day = 1;
      _month = DateTime.now().month + 1;
      _year = DateTime.now().year;
    }
    DateTime datePlan1 = DateTime(_year, _month, _day);
    return datePlan1;
  }

  // this method for create token hash from param ipa
  Future<void> paramToken(CardPayment card, String amount, int planDay,
      int currencyType, BuildContext context, int oldExplan) async {
    final user =
        Provider.of<DriverInfoModelProvider>(context, listen: false).driverInfo;
    Set<int> setOfInts = {};
    setOfInts.add(Random().nextInt(max(0, 1000000)));
    String idOrder = setOfInts.toString();
    var builder = xml.XmlBuilder();
    builder.processing('xml', 'version="1.0" encoding="utf-8"');
    builder.element('soap:Envelope', nest: () {
      builder.attribute(
          'xmlns:xsi', 'http://www.w3.org/2001/XMLSchema-instance');
      builder.attribute('xmlns:xsd', 'http://www.w3.org/2001/XMLSchema');
      builder.attribute(
          'xmlns:soap', 'http://schemas.xmlsoap.org/soap/envelope/');
      builder.element('soap:Body', nest: () {
        builder.element('SHA2B64', nest: () {
          builder.attribute('xmlns', 'https://turkpos.com.tr/');
          builder.element('Data', nest: () {
            builder.text(
                '33485211B6527-D2E1-4247-9590-00B3985504DE1$amount$amount${idOrder}https://errorparam-10.web.app/https://payment-ok.firebaseapp.com/');
          });
        });
      });
    });
    var bookshelfXml = builder.buildDocument();
    String _bodyHash = bookshelfXml.toString();
    final res = await http.post(Uri.parse(paramUrl),
        headers: paramHeader, body: convert.utf8.encode(_bodyHash));
    if (res.statusCode == 200) {
      final document = xml.XmlDocument.parse(res.body);
      final _hashCode = document.findAllElements('SHA2B64Result').single.text;
      startPayment(_hashCode, idOrder, amount, user.firstName, user.phoneNumber,
          card, context, planDay, oldExplan);
    } else {
      Provider.of<PaymentIndector>(context, listen: false).updateState(false);
      Tools()
          .toastMsg("SomeThing went wrong 402 hash", Colors.redAccent.shade700);
      Tools()
          .toastMsg("SomeThing went wrong 402 hash", Colors.redAccent.shade700);
    }
  }

// this method for start 3D payment or NS connect to our server N.js
  Future<void> startPayment(
    String hashCode,
    String idorder,
    String amount,
    String firstName,
    String phoneNumber,
    CardPayment card,
    BuildContext context,
    int planDay,
    int oldExplan,
  ) async {
    //map parameter that will post to our server
    Map<String, dynamic> toServer = {
      "hash": hashCode,
      "id": idorder,
      "amount": amount,
      "holder": card.holderName,
      "number": card.cardNumber,
      "cvv": card.cvv,
      "month": card.expiryDateMouthe,
      "year": card.expiryDateYear,
      "phone": phoneNumber
    };
    // post to our server
    final resServer = await http.post(Uri.parse(serverUrl),
        headers: serverHeader, body: convert.jsonEncode(toServer));
    if (resServer.statusCode == 200) {
      final document = xml.XmlDocument.parse(resServer.body);
      final _paramResult = document.findAllElements('Sonuc').single.text;
      final _url3d = document.findAllElements('UCD_URL').single.text;
      dekontId = document.findAllElements('Islem_ID').single.text;
      if (_paramResult == "1") {
        String url = _url3d;
        await canLaunch(url)
            ? launch(url).whenComplete(() async {
                await paidRef.child(userId).set({
                  "userid": userId,
                  "plan": planDay,
                });
                await paidCheckRef.child(userId).set({
                  "userid": userId,
                  "plan": planDay,
                  "cardNo": card.cardNumber,
                  "cardHolder": card.holderName,
                  "phoneNo": phoneNumber,
                  "amount": amount,
                  "token": tokenPhone,
                  "time": DateTime.now().toString()
                });
                await driverRef.child(userId).update({
                  "plandate": _setDateTime().toString(),
                  // "exPlan": oldExplan,
                  // "status": "payed",
                });
                if (isHomeScreenStartPay) {
                  isHomeScreenStartPay=false;
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Provider.of<DrawerValueChange>(context, listen: false)
                      .updateValue(0);
                  Provider.of<ChangeColorBottomDrawer>(context, listen: false)
                      .updateColorBottom(false);
                }
              })
            : Tools().toastMsg(
                AppLocalizations.of(context)!.paymentFailed, Colors.red);
        Provider.of<PaymentIndector>(context, listen: false).updateState(false);
      } else {
        Provider.of<PaymentIndector>(context, listen: false).updateState(false);
        final errorMessage = document.findAllElements('Sonuc_Str').single.text;
        Tools().toastMsg(AppLocalizations.of(context)!.paymentFailed, Colors.redAccent);
        Tools().toastMsg(errorMessage, Colors.redAccent);
        Tools().toastMsg(errorMessage, Colors.redAccent);
      }
    }
    else {
      Provider.of<PaymentIndector>(context, listen: false).updateState(false);
      Tools().toastMsg(
          AppLocalizations.of(context)!.paymentFailed, Colors.redAccent);
      Tools().toastMsg(
          AppLocalizations.of(context)!.paymentFailed, Colors.redAccent);
    }
  }

  ///  this method canceled for now No (Ns) parameter from param
  // Future<void> checkResultPayment() async {
  //   if (kDebugMode) {
  //     print("xxxx$dekontId");
  //   }
  //   var builder = xml.XmlBuilder();
  //   builder.processing('xml', 'version="1.0" encoding="utf-8"');
  //   builder.element('soap:Envelope ', nest: () {
  //     builder.attribute(
  //         'xmlns:xsi', 'http://www.w3.org/2001/XMLSchema-instance');
  //     builder.attribute('xmlns:xsd', 'http://www.w3.org/2001/XMLSchema');
  //     builder.attribute(
  //         'xmlns:soap', 'http://schemas.xmlsoap.org/soap/envelope/');
  //     builder.element('soap:Body', nest: () {
  //       builder.element('TP_Islem_Sorgulama', nest: () {
  //         builder.attribute('xmlns', 'https://turkpos.com.tr/');
  //         builder.element('G', nest: () {
  //           builder.element('CLIENT_CODE', nest: 33485);
  //           builder.element('CLIENT_USERNAME', nest: 'TP10053946');
  //           builder.element('CLIENT_PASSWORD', nest: '0877490DE492A078');
  //         });
  //         builder.element('GUID', nest: '211B6527-D2E1-4247-9590-00B3985504DE');
  //         builder.element('Dekont_ID', nest: dekontId);
  //         builder.element('Siparis_ID', nest: '');
  //         builder.element('Islem_ID', nest: '');
  //       });
  //     });
  //   });
  //   var bookshelfXml = builder.buildDocument();
  //   String _bodySendReceipt = bookshelfXml.toString();
  //   final res = await http.post(Uri.parse(paramUrl),
  //       headers: paramHeader, body: convert.utf8.encode(_bodySendReceipt));
  //   if (kDebugMode) {
  //     print("ResponseBody${res.body}");
  //   }
  //   if (res.statusCode == 200) {
  //     final document = xml.XmlDocument.parse(res.body);
  //     final _receiptResult =
  //         document.findAllElements('Odeme_Sonuc_Aciklama').single.text;
  //     if (kDebugMode) {
  //       print("res000$_receiptResult");
  //     }
  //     // if (_receiptResult == "İşlem Başarılı") {
  //     //   if (kDebugMode) {
  //     //     print("res111$_receiptResult");
  //     //   }
  //     // }
  //   }
  // }

  ///this old method legacy ipa v1.7
// tgis method for request payment by 3d url
//   Future<void> startPayment1(
//     String hashCode,
//     String idorder,
//     String amount,
//     String firstName,
//     String phoneNumber,
//     CardPayment card,
//     BuildContext context,
//     int planDay,
//     int oldExplan,
//     String ipv4,
//   ) async {
//     Uri _url = Uri.parse(
//         "https://posws.param.com.tr/turkpos.ws/service_turkpos_prod.asmx?wsdl");
//
//     Map<String, String> _headerPayment = {'content-type': 'text/xml'};
//
//     var builder = xml.XmlBuilder();
//     builder.processing('xml', 'version="1.0" encoding="utf-8"');
//     builder.element('soap:Envelope', nest: () {
//       builder.attribute(
//           'xmlns:xsi', 'http://www.w3.org/2001/XMLSchema-instance');
//       builder.attribute('xmlns:xsd', 'http://www.w3.org/2001/XMLSchema');
//       builder.attribute(
//           'xmlns:soap', 'http://schemas.xmlsoap.org/soap/envelope/');
//       builder.element('soap:Body', nest: () {
//         builder.element('TP_Islem_Odeme', nest: () {
//           builder.attribute('xmlns', 'https://turkpos.com.tr/');
//           builder.element('G', nest: () {
//             builder.element('CLIENT_CODE', nest: 33485);
//             builder.element('CLIENT_USERNAME', nest: 'TP10053946');
//             builder.element('CLIENT_PASSWORD', nest: '0877490DE492A078');
//           });
//           builder.element('SanalPOS_ID', nest: '119');
//           builder.element('GUID', nest: '211B6527-D2E1-4247-9590-00B3985504DE');
//           builder.element('KK_Sahibi', nest: card.holderName);
//           builder.element('KK_No', nest: card.cardNumber);
//           builder.element('KK_SK_Ay', nest: card.expiryDateMouthe);
//           builder.element('KK_SK_Yil', nest: card.expiryDateYear);
//           builder.element('KK_CVC', nest: card.cvv);
//           builder.element('KK_Sahibi_GSM', nest: phoneNumber);
//           builder.element('Hata_URL',
//               nest: 'https://garantitaxi.github.io/errorpayment');
//           builder.element('Basarili_URL',
//               nest: 'https://garantitaxi.github.io/payment');
//           builder.element('Siparis_ID', nest: '$firstName$idorder');
//           builder.element('Islem_Guvenlik_Tip', nest: 'NS');
//           builder.element('Taksit', nest: 1);
//           builder.element('Islem_Tutar', nest: amount);
//           builder.element('Toplam_Tutar', nest: amount);
//           builder.element('Islem_Hash', nest: hashCode);
//           builder.element('Islem_ID', nest: 'sipariş1');
//           builder.element('IPAdr', nest: ipv4);
//         });
//       });
//     });
//     var bookshelfXml = builder.buildDocument();
//     String _bodyStartPayment1 = bookshelfXml.toString();
//     final res = await http.post(_url,
//         headers: _headerPayment, body: convert.utf8.encode(_bodyStartPayment1));
//     if (res.statusCode == 200 && res.reasonPhrase == "OK") {
//       final document = xml.XmlDocument.parse(res.body);
//       final _paymentResult = document.findAllElements('Sonuc').single.text;
//       final _bankResult =
//           document.findAllElements('Banka_Sonuc_Kod').single.text;
//       dekontId = document.findAllElements('Islem_ID').single.text;
//       final _url3d = document.findAllElements('UCD_URL').single.text;
//       if (_paymentResult == "1" && _bankResult == "0") {
//         print("bodyyyyCode: ${res.statusCode}");
//         print("bodyyyy: ${res.body}");
//         print("isssssss: $dekontId");
//         Provider.of<PaymentIndector>(context, listen: false).updateState(false);
//         String url = _url3d;
//         await canLaunch(url).whenComplete(() {})
//             ? launch(url)
//             : Tools().toastMsg(AppLocalizations.of(context)!.wrong, Colors.red);
//         await driverRef.child(userId).update({
//           "exPlan": planDay,
//           "status": "payed",
//         });
//       } else {
//         Provider.of<PaymentIndector>(context, listen: false).updateState(false);
//         final _erroeMessage = document.findAllElements('Sonuc_Str').single.text;
//         Tools().toastMsg("Payment Failed", Colors.redAccent);
//         Tools().toastMsg(_erroeMessage, Colors.redAccent);
//         Tools().toastMsg(_erroeMessage, Colors.redAccent);
//       }
//     } else {
//       Provider.of<PaymentIndector>(context, listen: false).updateState(false);
//       Tools().toastMsg("Payment Failed 402", Colors.redAccent);
//       Tools().toastMsg("Payment Failed 402", Colors.redAccent);
//     }
//   }
}
