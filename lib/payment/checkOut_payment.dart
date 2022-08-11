import 'dart:math';
import 'package:driver/model/card_payment.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../config.dart';
import '../my_provider/driver_model_provider.dart';
import '../my_provider/payment_indector_provider.dart';
import '../notificatons/push_notifications_srv.dart';
import '../tools/tools.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:xml/xml.dart' as xml;
// class ParamPaymentTest {
//   // this method for create token
//   Future<void> paramStartPaymentTest(CardPayment card, String amount, int planDay,
//       int currencyType, BuildContext context) async {
//     Uri _uri = Uri.parse(
//         "https://test-dmz.param.com.tr:4443/turkpos.ws/service_turkpos_test.asmx?wsdl");
//     Map<String, String> _headerHash = {'content-type': 'text/xml'};
//     final user =
//         Provider.of<DriverInfoModelProvider>(context, listen: false).driverInfo;
//     Set<int> setOfInts = {};
//     setOfInts.add(Random().nextInt(max(0, 1000000)));
//     String idOrder = setOfInts.toString();
//     var builder = xml.XmlBuilder();
//     builder.processing('xml', 'version="1.0" encoding="utf-8"');
//     builder.element('soap:Envelope', nest: () {
//       builder.attribute(
//           'xmlns:xsi', 'http://www.w3.org/2001/XMLSchema-instance');
//       builder.attribute('xmlns:xsd', 'http://www.w3.org/2001/XMLSchema');
//       builder.attribute(
//           'xmlns:soap', 'http://schemas.xmlsoap.org/soap/envelope/');
//       builder.element('soap:Body', nest: () {
//         builder.element('SHA2B64', nest: () {
//           builder.attribute('xmlns', 'https://turkpos.com.tr/');
//           builder.element('Data', nest: () {
//             builder.text(
//                 '107380c13d406-873b-403b-9c09-a5766840d98c1$amount$amount${user.firstName}${idOrder}https://www.garantiads.comhttps://www.garantiads.com/kategori/5077-emlak');
//           });
//         });
//       });
//     });
//     var bookshelfXml = builder.buildDocument();
//     String _bodyHash = bookshelfXml.toString();
//     final res = await http.post(_uri,
//         headers: _headerHash, body: convert.utf8.encode(_bodyHash));
//     if (res.reasonPhrase == "OK" && res.statusCode == 200) {
//       final document = xml.XmlDocument.parse(res.body);
//       final _hashCode = document.findAllElements('SHA2B64Result').single.text;
//       startPaymentTest(_hashCode, idOrder, amount, user.firstName, user.phoneNumber,
//           card, context, planDay);
//     } else {
//       Provider.of<PaymentIndector>(context, listen: false).updateState(false);
//       Tools()
//           .toastMsg("SomeThing went wrong 402 hash", Colors.redAccent.shade700);
//       Tools()
//           .toastMsg("SomeThing went wrong 402 hash", Colors.redAccent.shade700);
//     }
//   }
//
//   ///stop for now
//   Future<void> startPaymentTest(
//       String hashCode,
//       String idorder,
//       String amount,
//       String firstName,
//       String phoneNumber,
//       CardPayment card,
//       BuildContext context,
//       int planDay) async {
//     Uri _url = Uri.parse(
//         "https://test-dmz.param.com.tr:4443/turkpos.ws/service_turkpos_test.asmx?wsdl");
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
//         builder.element('Pos_Odeme', nest: () {
//           builder.attribute('xmlns', 'https://turkpos.com.tr/');
//           builder.element('G', nest: () {
//             builder.element('CLIENT_CODE', nest: 10738);
//             builder.element('CLIENT_USERNAME', nest: 'Test');
//             builder.element('CLIENT_PASSWORD', nest: 'Test');
//           });
//           builder.element('GUID', nest: '0c13d406-873b-403b-9c09-a5766840d98c');
//           builder.element('KK_Sahibi', nest: 'Albert Einstein');
//           builder.element('KK_No', nest: '4022774022774026');
//           builder.element('KK_SK_Ay', nest: '12');
//           builder.element('KK_SK_Yil', nest: '26');
//           builder.element('KK_CVC', nest: '000');
//           builder.element('KK_Sahibi_GSM', nest: '5350179608');
//           builder.element('Hata_URL', nest: 'https://www.garantiads.com');
//           builder.element('Basarili_URL', nest: 'https://www.garantiads.com/kategori/5077-emlak');
//           builder.element('Siparis_ID', nest: '$firstName$idorder');
//           builder.element('Siparis_Aciklama',nest: '');
//           builder.element('Taksit', nest: 1);
//           builder.element('Islem_Tutar', nest: amount);
//           builder.element('Toplam_Tutar', nest: amount);
//           builder.element('Islem_Hash', nest: hashCode);
//           builder.element('Islem_Guvenlik_Tip', nest: 'NS');
//           builder.element('Islem_ID', nest: '');
//           builder.element('IPAdr', nest: '78.191.84.62');
//           builder.element('Ref_URL', nest: '');
//           builder.element('Data1', nest: '');
//           builder.element('Data2', nest: '');
//           builder.element('Data3', nest: '');
//           builder.element('Data4', nest: '');
//           builder.element('Data5', nest: '');
//           builder.element('Data6', nest: '');
//           builder.element('Data7', nest: '');
//           builder.element('Data8', nest: '');
//           builder.element('Data9', nest: '');
//           builder.element('Data10', nest: '');
//         });
//       });
//     });
//     var bookshelfXml = builder.buildDocument();
//     String _uriMsj = bookshelfXml.toString();
//     // print("payment_uriMsj: $_uriMsj");
//     final res = await http.post(_url,
//         headers: _headerPayment, body: convert.utf8.encode(_uriMsj));
//     print("_responseOtp: ${res.statusCode}");
//     print("_responseOtp: ${res.body}");
//     if (res.statusCode == 200 && res.reasonPhrase == "OK") {
//       final document = xml.XmlDocument.parse(res.body);
//       final _paramResult = document.findAllElements('Sonuc').single.text;
//       final _bankResult = document.findAllElements('Banka_Sonuc_Kod').single.text;
//       final _url3d = document.findAllElements('UCD_URL').single.text;
//       dekontId = document.findAllElements('Islem_ID').single.text;
//       print("SonucResult: $_paramResult");
//       print("dekon: $dekontId");
//       print("banktrseilt: $_bankResult");
//       if (_paramResult == "1") {
//         Provider.of<PaymentIndector>(context, listen: false).updateState(false);
//         // String url = _url3d;
//         // await canLaunch(url).whenComplete(() {})
//         //     ? launch(url)
//         //     : Tools().toastMsg(AppLocalizations.of(context)!.wrong, Colors.red);
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
//
//   // this method for send receipt to customer
//   Future<void> sendReceipt() async {
//
//     Uri _url = Uri.parse(
//         "https://test-dmz.param.com.tr:4443/turkpos.ws/service_turkpos_test.asmx?wsdl");
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
//         builder.element('TP_Islem_Dekont_Gonder', nest: () {
//           builder.attribute('xmlns', 'https://turkpos.com.tr/');
//           builder.element('G', nest: () {
//             builder.element('CLIENT_CODE', nest: 33485);
//             builder.element('CLIENT_USERNAME', nest: 'TP10053946');
//             builder.element('CLIENT_PASSWORD', nest: '0877490DE492A078');
//           });
//           builder.element('GUID', nest: '211B6527-D2E1-4247-9590-00B3985504DE');
//           builder.element('Dekont_ID', nest: dekontId);
//           builder.element('E_Posta', nest: 'garantitaxi@gmail.com');
//         });
//       });
//     });
//     var bookshelfXml = builder.buildDocument();
//     String _bodySendReceipt = bookshelfXml.toString();
//     print("bodyyy: $_bodySendReceipt");
//     final res = await http.post(_url,
//         headers: _headerPayment,
//         body: convert.utf8.encode(_bodySendReceipt));
//     print("00000${res.body}");
//     if (res.statusCode == 200) {
//       final document = xml.XmlDocument.parse(res.body);
//       print(document);
//       final _receiptResult = document.findAllElements('Sonuc_Str').single.text;
//       if (_receiptResult == "Başarılı") {
//         print("0000");
//       }
//     }
//   }
//
//   Future<void> sorgulamaTest() async {
//     print("xxxx$dekontId");
//     //1183811710
//     Uri _url = Uri.parse("https://test-dmz.param.com.tr:4443/turkpos.ws/service_turkpos_test.asmx?wsdl");
//     Map<String, String> _headerSendReceipt = {'content-type': 'text/xml'};
//     var builder = xml.XmlBuilder();
//     builder.processing('xml', 'version="1.0" encoding="utf-8"');
//     builder.element('soap:Envelope ', nest: () {
//       builder.attribute('xmlns:xsi', 'http://www.w3.org/2001/XMLSchema-instance');
//       builder.attribute('xmlns:xsd', 'http://www.w3.org/2001/XMLSchema');
//       builder.attribute('xmlns:soap', 'http://schemas.xmlsoap.org/soap/envelope/');
//       builder.element('soap:Body', nest: () {
//         builder.element('TP_Islem_Sorgulama', nest: () {
//           builder.attribute('xmlns', 'https://turkpos.com.tr/');
//           builder.element('G', nest: () {
//             builder.element('CLIENT_CODE', nest: 10738);
//             builder.element('CLIENT_USERNAME', nest: 'Test');
//             builder.element('CLIENT_PASSWORD', nest: 'Test');
//           });
//           builder.element('GUID', nest: '0c13d406-873b-403b-9c09-a5766840d98c');
//           builder.element('Dekont_ID', nest: dekontId);
//           builder.element('Siparis_ID', nest: '');
//           builder.element('Islem_ID', nest: '');
//         });
//       });
//     });
//     var bookshelfXml = builder.buildDocument();
//     String _bodySendReceipt = bookshelfXml.toString();
//     print("reqqqqq: $_bodySendReceipt");
//     final res = await http.post(_url,
//         headers: _headerSendReceipt,
//         body: convert.utf8.encode(_bodySendReceipt));
//     print("ressss${res.body}");
//     // if (res.statusCode == 200) {
//     //   final document = xml.XmlDocument.parse(res.body);
//     //   final _receiptResult = document.findAllElements('Odeme_Sonuc_Aciklama').single.text;
//     //   print("res000$_receiptResult");
//     //   if (_receiptResult == "İşlem Başarılı") {
//     //     print("res111$_receiptResult");
//     //   }
//     // }
//   }
//
// // tgis method for request payment by 3d url
// // Future<void> startPayment1(
// //   String hashCode,
// //   String idorder,
// //   String amount,
// //   String firstName,
// //   String phoneNumber,
// //   CardPayment card,
// //   BuildContext context,
// //   int planDay,
// // ) async {
// //   Uri _url = Uri.parse(
// //       "https://posws.param.com.tr/turkpos.ws/service_turkpos_prod.asmx?wsdl");
// //
// //   Map<String, String> _headerPayment = {'content-type': 'text/xml'};
// //
// //   var builder = xml.XmlBuilder();
// //   builder.processing('xml', 'version="1.0" encoding="utf-8"');
// //   builder.element('soap:Envelope', nest: () {
// //     builder.attribute(
// //         'xmlns:xsi', 'http://www.w3.org/2001/XMLSchema-instance');
// //     builder.attribute('xmlns:xsd', 'http://www.w3.org/2001/XMLSchema');
// //     builder.attribute(
// //         'xmlns:soap', 'http://schemas.xmlsoap.org/soap/envelope/');
// //     builder.element('soap:Body', nest: () {
// //       builder.element('TP_Islem_Odeme', nest: () {
// //         builder.attribute('xmlns', 'https://turkpos.com.tr/');
// //         builder.element('G', nest: () {
// //           builder.element('CLIENT_CODE', nest: 33485);
// //           builder.element('CLIENT_USERNAME', nest: 'TP10053946');
// //           builder.element('CLIENT_PASSWORD', nest: '0877490DE492A078');
// //         });
// //         builder.element('SanalPOS_ID', nest: '119');
// //         builder.element('GUID', nest: '211B6527-D2E1-4247-9590-00B3985504DE');
// //         builder.element('KK_Sahibi', nest: card.holderName);
// //         builder.element('KK_No', nest: card.cardNumber);
// //         builder.element('KK_SK_Ay', nest: card.expiryDateMouthe);
// //         builder.element('KK_SK_Yil', nest: card.expiryDateYear);
// //         builder.element('KK_CVC', nest: card.cvv);
// //         builder.element('KK_Sahibi_GSM', nest: phoneNumber);
// //         builder.element('Hata_URL', nest: 'https://garantitaxi.github.io/errorpayment');
// //         builder.element('Basarili_URL', nest: 'https://garantitaxi.github.io/payment');
// //         builder.element('Siparis_ID', nest: '$firstName$idorder');
// //         builder.element('Islem_Guvenlik_Tip', nest: '3D');
// //         builder.element('Taksit', nest: 1);
// //         builder.element('Islem_Tutar', nest: amount);
// //         builder.element('Toplam_Tutar', nest: amount);
// //         builder.element('Islem_Hash', nest: hashCode);
// //         builder.element('Islem_ID', nest: 'sipariş1');
// //         builder.element('IPAdr', nest: '78.191.84.62');
// //       });
// //     });
// //   });
// //   var bookshelfXml = builder.buildDocument();
// //   String _bodyStartPayment1 = bookshelfXml.toString();
// //   final res = await http.post(_url,
// //       headers: _headerPayment, body: convert.utf8.encode(_bodyStartPayment1));
// //   if (res.statusCode == 200 && res.reasonPhrase == "OK") {
// //     final document = xml.XmlDocument.parse(res.body);
// //     final _paymentResult = document.findAllElements('Sonuc').single.text;
// //     final _bankResult =
// //         document.findAllElements('Banka_Sonuc_Kod').single.text;
// //         dekontId = document.findAllElements('Islem_ID').single.text;
// //     final _url3d = document.findAllElements('UCD_URL').single.text;
// //     if (_paymentResult == "1" && _bankResult == "0") {
// //       print("bodyyyyCode: ${res.statusCode}");
// //       print("bodyyyy: ${res.body}");
// //       print("isssssss: $dekontId");
// //       Provider.of<PaymentIndector>(context, listen: false).updateState(false);
// //       String url = _url3d;
// //       await canLaunch(url).whenComplete(() {})
// //           ? launch(url)
// //           : Tools().toastMsg(AppLocalizations.of(context)!.wrong, Colors.red);
// //       await driverRef.child(userId).update({
// //         "exPlan": planDay,
// //         "status": "payed",
// //       });
// //     } else {
// //       Provider.of<PaymentIndector>(context, listen: false).updateState(false);
// //       final _erroeMessage = document.findAllElements('Sonuc_Str').single.text;
// //       Tools().toastMsg("Payment Failed", Colors.redAccent);
// //       Tools().toastMsg(_erroeMessage, Colors.redAccent);
// //       Tools().toastMsg(_erroeMessage, Colors.redAccent);
// //     }
// //   } else {
// //     Provider.of<PaymentIndector>(context, listen: false).updateState(false);
// //     Tools().toastMsg("Payment Failed 402", Colors.redAccent);
// //     Tools().toastMsg("Payment Failed 402", Colors.redAccent);
// //   }
// // }
//
// //   // this mehtod for send Receipt
// //   Future<void> sendReceipt() async {
// //     Uri _url = Uri.parse(
// //         "https://posws.param.com.tr/turkpos.ws/service_turkpos_prod.asmx?wsdl");
// //     Map<String, String> _headerSendReceipt = {'content-type': 'text/xml'};
// //     var builder = xml.XmlBuilder();
// //     builder.processing('xml', 'version="1.0" encoding="utf-8"');
// //     builder.element('soap:Envelope', nest: () {
// //       builder.attribute(
// //           'xmlns:xsi', 'http://www.w3.org/2001/XMLSchema-instance');
// //       builder.attribute('xmlns:xsd', 'http://www.w3.org/2001/XMLSchema');
// //       builder.attribute(
// //           'xmlns:soap', 'http://schemas.xmlsoap.org/soap/envelope/');
// //       builder.element('soap:Body', nest: () {
// //         builder.element('TP_Islem_Dekont_Gonder', nest: () {
// //           builder.attribute('xmlns', 'https://turkpos.com.tr/');
// //           builder.element('G', nest: () {
// //             builder.element('CLIENT_CODE', nest: 33485);
// //             builder.element('CLIENT_USERNAME', nest: 'TP10053946');
// //             builder.element('CLIENT_PASSWORD', nest: '0877490DE492A078');
// //           });
// //           builder.element('GUID', nest: '211B6527-D2E1-4247-9590-00B3985504DE');
// //           builder.element('Dekont_ID', nest: '3000159388');
// //           builder.element('E_Posta', nest: 'garantitaxi@gmail.com');
// //         });
// //       });
// //     });
// //     var bookshelfXml = builder.buildDocument();
// //     String _bodySendReceipt = bookshelfXml.toString();
// //     print("bodyyy: $_bodySendReceipt");
// //     final res = await http.post(_url,
// //         headers: _headerSendReceipt,
// //         body: convert.utf8.encode(_bodySendReceipt));
// //     print("00000${res.body}");
// //     if (res.statusCode == 200) {
// //       final document = xml.XmlDocument.parse(res.body);
// //       final _receiptResult = document.findAllElements('Sonuc_Str').single.text;
// //       if (_receiptResult == "Başarılı") {
// //
// //       }
// //      await sorgulama();
// //     }
// //   }
// //
// //   // this method for check result if true or false
// }

class ParamPaymentTest {
  static String paramurl =
      "https://posws.param.com.tr/turkpos.ws/service_turkpos_prod.asmx?wsdl";
  static Map<String, String> paramHeader = {'content-type': 'text/xml'};

  // this method for create token
  Future<void> paramToken(CardPayment card, String amount, int planDay,
      int currencyType, BuildContext context) async {
    final user =
        Provider.of<DriverInfoModelProvider>(context, listen: false).driverInfo;
    Set<int> setOfInts = {};
    setOfInts.add(Random().nextInt(max(0, 1000000)));
    String idOrder = setOfInts.toString();
    var builder = xml.XmlBuilder();
    builder.processing('xml', 'version="1.0" encoding="utf-8"');
    builder.element('soap:Envelope', nest: () {
      builder.attribute('xmlns:xsi', 'http://www.w3.org/2001/XMLSchema-instance');
      builder.attribute('xmlns:xsd', 'http://www.w3.org/2001/XMLSchema');
      builder.attribute('xmlns:soap', 'http://schemas.xmlsoap.org/soap/envelope/');
      builder.element('soap:Body', nest: () {
        builder.element('SHA2B64', nest: () {
          builder.attribute('xmlns', 'https://turkpos.com.tr/');
          builder.element('Data', nest: () {
            builder.text(
                '33485211B6527-D2E1-4247-9590-00B3985504DE1$amount$amount${user.firstName}$idOrder');
          });
        });
      });
    });
    var bookshelfXml = builder.buildDocument();
    String _bodyHash = bookshelfXml.toString();
    final res = await http.post(Uri.parse(paramurl),
        headers: paramHeader, body: convert.utf8.encode(_bodyHash));
    if (res.reasonPhrase == "OK" && res.statusCode == 200) {
      final document = xml.XmlDocument.parse(res.body);
      final _hashCode = document.findAllElements('SHA2B64Result').single.text;
      startPayment(_hashCode, idOrder, amount, user.firstName, user.phoneNumber,
          card, context, planDay);
    } else {
      Provider.of<PaymentIndector>(context, listen: false).updateState(false);
      Tools()
          .toastMsg("SomeThing went wrong 402 hash", Colors.redAccent.shade700);
      Tools()
          .toastMsg("SomeThing went wrong 402 hash", Colors.redAccent.shade700);
    }
  }

// this method for start 3D payment or NS
  Future<void> startPayment(
      String hashCode,
      String idorder,
      String amount,
      String firstName,
      String phoneNumber,
      CardPayment card,
      BuildContext context,
      int planDay) async {
    var builder = xml.XmlBuilder();
    builder.processing('xml', 'version="1.0" encoding="utf-8"');
    builder.element('soap:Envelope', nest: () {
      builder.attribute(
          'xmlns:xsi', 'http://www.w3.org/2001/XMLSchema-instance');
      builder.attribute('xmlns:xsd', 'http://www.w3.org/2001/XMLSchema');
      builder.attribute(
          'xmlns:soap', 'http://schemas.xmlsoap.org/soap/envelope/');
      builder.element('soap:Body', nest: () {
        builder.element('TP_WMD_UCD', nest: () {
          builder.attribute('xmlns', 'https://turkpos.com.tr/');
          builder.element('G', nest: () {
            builder.element('CLIENT_CODE', nest: 33485);
            builder.element('CLIENT_USERNAME', nest: 'TP10053946');
            builder.element('CLIENT_PASSWORD', nest: '0877490DE492A078');
          });
          builder.element('GUID', nest: '211B6527-D2E1-4247-9590-00B3985504DE');
          builder.element('KK_Sahibi', nest: card.holderName);
          builder.element('KK_No', nest: card.cardNumber);
          builder.element('KK_SK_Ay', nest: card.expiryDateMouthe);
          builder.element('KK_SK_Yil', nest: card.expiryDateYear);
          builder.element('KK_CVC', nest: card.cvv);
          builder.element('KK_Sahibi_GSM', nest: '5384643348');
          builder.element('Hata_URL', nest: 'https://garantitaxi.github.io/errorpaymen');
          builder.element('Basarili_URL', nest: 'https://garantitaxi.github.io/payment');
          builder.element('Siparis_ID', nest: '$firstName$idorder');
          builder.element('Siparis_Aciklama', nest: 'a');
          builder.element('Taksit', nest: 1);
          builder.element('Islem_Tutar', nest: amount);
          builder.element('Toplam_Tutar', nest: amount);
          builder.element('Islem_Hash', nest: hashCode);
          builder.element('Islem_Guvenlik_Tip', nest: '3D');
          builder.element('Islem_ID', nest: '123');
          builder.element('IPAdr', nest: '78.185.60.184');
          builder.element('Ref_URL', nest: 'https://dev.param.com.tr/tr');
          builder.element('Data1', nest: 'a');
          builder.element('Data2', nest: 'a');
          builder.element('Data3', nest: 'a');
          builder.element('Data4', nest: 'a');
          builder.element('Data5', nest: 'a');
        });
      });
    });
    var bookshelfXml = builder.buildDocument();
    String _uriMsj = bookshelfXml.toString();
    final res = await http.post(Uri.parse(paramurl),
        headers: paramHeader, body: convert.utf8.encode(_uriMsj));
    print("_responseOtp: ${res.statusCode}");
    print("_responseOtp: ${res.body}");
    if (res.statusCode == 200 && res.reasonPhrase == "OK") {
      Provider.of<PaymentIndector>(context, listen: false).updateState(false);
      final document = xml.XmlDocument.parse(res.body);
      final _paramResult = document.findAllElements('Sonuc').single.text;
      final _bankResult = document.findAllElements('Banka_Sonuc_Kod').single.text;
      final _url3d = document.findAllElements('UCD_URL').single.text;
      dekontId = document.findAllElements('Islem_ID').single.text;
      final _erroeMessage = document.findAllElements('Sonuc_Str').single.text;
      print("SonucResult: $_paramResult");
      print("dekon: $dekontId");
      print("banktrseilt: $_bankResult");
      Tools().toastMsg(_erroeMessage, Colors.green);
      if (_paramResult == "1") {
        Provider.of<PaymentIndector>(context, listen: false).updateState(false);
        String url = _url3d;
        await canLaunch(url).whenComplete(() {})
            ? launch(url)
            : Tools().toastMsg(AppLocalizations.of(context)!.wrong, Colors.red);
        await driverRef.child(userId).update({
          "exPlan": planDay,
          "status": "payed",
        });
      } else {
        Provider.of<PaymentIndector>(context, listen: false).updateState(false);
        final _erroeMessage = document.findAllElements('Sonuc_Str').single.text;
        Tools().toastMsg("Payment Failed", Colors.redAccent);
        Tools().toastMsg(_erroeMessage, Colors.redAccent);
        Tools().toastMsg(_erroeMessage, Colors.redAccent);
      }
    } else {
      Provider.of<PaymentIndector>(context, listen: false).updateState(false);
      Tools().toastMsg("Payment Failed 402", Colors.redAccent);
      Tools().toastMsg("Payment Failed 402", Colors.redAccent);
    }
  }

  // this method for send receipt to customer
  Future<void> sendReceiptTest() async {
    var builder = xml.XmlBuilder();
    builder.processing('xml', 'version="1.0" encoding="utf-8"');
    builder.element('soap:Envelope', nest: () {
      builder.attribute(
          'xmlns:xsi', 'http://www.w3.org/2001/XMLSchema-instance');
      builder.attribute('xmlns:xsd', 'http://www.w3.org/2001/XMLSchema');
      builder.attribute(
          'xmlns:soap', 'http://schemas.xmlsoap.org/soap/envelope/');
      builder.element('soap:Body', nest: () {
        builder.element('TP_Islem_Dekont_Gonder', nest: () {
          builder.attribute('xmlns', 'https://turkpos.com.tr/');
          builder.element('G', nest: () {
            builder.element('CLIENT_CODE', nest: 33485);
            builder.element('CLIENT_USERNAME', nest: 'TP10053946');
            builder.element('CLIENT_PASSWORD', nest: '0877490DE492A078');
          });
          builder.element('GUID', nest: '211B6527-D2E1-4247-9590-00B3985504DE');
          builder.element('Dekont_ID', nest: dekontId);
          builder.element('E_Posta', nest: 'garantitaxi@gmail.com');
        });
      });
    });
    var bookshelfXml = builder.buildDocument();
    String _bodySendReceipt = bookshelfXml.toString();
    print("bodyyy: $_bodySendReceipt");
    final res = await http.post(Uri.parse(paramurl),
        headers: paramHeader,
        body: convert.utf8.encode(_bodySendReceipt));
    print("00000${res.body}");
    if (res.statusCode == 200) {
      final document = xml.XmlDocument.parse(res.body);
      final _receiptResult = document.findAllElements('Sonuc_Str').single.text;
      if (_receiptResult == "Başarılı") {
      }
    }
  }

  // this method for check result if true or false
  Future<void> sorgulamaTest() async {
    print("xxxx$dekontId");
    //1183811710
    var builder = xml.XmlBuilder();
    builder.processing('xml', 'version="1.0" encoding="utf-8"');
    builder.element('soap:Envelope ', nest: () {
      builder.attribute(
          'xmlns:xsi', 'http://www.w3.org/2001/XMLSchema-instance');
      builder.attribute('xmlns:xsd', 'http://www.w3.org/2001/XMLSchema');
      builder.attribute(
          'xmlns:soap', 'http://schemas.xmlsoap.org/soap/envelope/');
      builder.element('soap:Body', nest: () {
        builder.element('TP_Islem_Sorgulama', nest: () {
          builder.attribute('xmlns', 'https://turkpos.com.tr/');
          builder.element('G', nest: () {
            builder.element('CLIENT_CODE', nest: 33485);
            builder.element('CLIENT_USERNAME', nest: 'TP10053946');
            builder.element('CLIENT_PASSWORD', nest: '0877490DE492A078');
          });
          builder.element('GUID', nest: '211B6527-D2E1-4247-9590-00B3985504DE');
          builder.element('Dekont_ID', nest: dekontId);
          builder.element('Siparis_ID', nest: '');
          builder.element('Islem_ID', nest: '');
        });
      });
    });
    var bookshelfXml = builder.buildDocument();
    String _bodySendReceipt = bookshelfXml.toString();
    print("reqqqqq: $_bodySendReceipt");
    final res = await http.post(Uri.parse(paramurl),
        headers: paramHeader, body: convert.utf8.encode(_bodySendReceipt));
    print("ressss${res.body}");
    // if (res.statusCode == 200) {
    //   final document = xml.XmlDocument.parse(res.body);
    //   final _receiptResult = document.findAllElements('Odeme_Sonuc_Aciklama').single.text;
    //   print("res000$_receiptResult");
    //   if (_receiptResult == "İşlem Başarılı") {
    //     print("res111$_receiptResult");
    //   }
    // }
  }

// tgis method for request payment by 3d url
// Future<void> startPayment1(
//   String hashCode,
//   String idorder,
//   String amount,
//   String firstName,
//   String phoneNumber,
//   CardPayment card,
//   BuildContext context,
//   int planDay,
// ) async {
//   Uri _url = Uri.parse(
//       "https://posws.param.com.tr/turkpos.ws/service_turkpos_prod.asmx?wsdl");
//
//   Map<String, String> _headerPayment = {'content-type': 'text/xml'};
//
//   var builder = xml.XmlBuilder();
//   builder.processing('xml', 'version="1.0" encoding="utf-8"');
//   builder.element('soap:Envelope', nest: () {
//     builder.attribute(
//         'xmlns:xsi', 'http://www.w3.org/2001/XMLSchema-instance');
//     builder.attribute('xmlns:xsd', 'http://www.w3.org/2001/XMLSchema');
//     builder.attribute(
//         'xmlns:soap', 'http://schemas.xmlsoap.org/soap/envelope/');
//     builder.element('soap:Body', nest: () {
//       builder.element('TP_Islem_Odeme', nest: () {
//         builder.attribute('xmlns', 'https://turkpos.com.tr/');
//         builder.element('G', nest: () {
//           builder.element('CLIENT_CODE', nest: 33485);
//           builder.element('CLIENT_USERNAME', nest: 'TP10053946');
//           builder.element('CLIENT_PASSWORD', nest: '0877490DE492A078');
//         });
//         builder.element('SanalPOS_ID', nest: '119');
//         builder.element('GUID', nest: '211B6527-D2E1-4247-9590-00B3985504DE');
//         builder.element('KK_Sahibi', nest: card.holderName);
//         builder.element('KK_No', nest: card.cardNumber);
//         builder.element('KK_SK_Ay', nest: card.expiryDateMouthe);
//         builder.element('KK_SK_Yil', nest: card.expiryDateYear);
//         builder.element('KK_CVC', nest: card.cvv);
//         builder.element('KK_Sahibi_GSM', nest: phoneNumber);
//         builder.element('Hata_URL', nest: 'https://garantitaxi.github.io/errorpayment');
//         builder.element('Basarili_URL', nest: 'https://garantitaxi.github.io/payment');
//         builder.element('Siparis_ID', nest: '$firstName$idorder');
//         builder.element('Islem_Guvenlik_Tip', nest: '3D');
//         builder.element('Taksit', nest: 1);
//         builder.element('Islem_Tutar', nest: amount);
//         builder.element('Toplam_Tutar', nest: amount);
//         builder.element('Islem_Hash', nest: hashCode);
//         builder.element('Islem_ID', nest: 'sipariş1');
//         builder.element('IPAdr', nest: '78.191.84.62');
//       });
//     });
//   });
//   var bookshelfXml = builder.buildDocument();
//   String _bodyStartPayment1 = bookshelfXml.toString();
//   final res = await http.post(_url,
//       headers: _headerPayment, body: convert.utf8.encode(_bodyStartPayment1));
//   if (res.statusCode == 200 && res.reasonPhrase == "OK") {
//     final document = xml.XmlDocument.parse(res.body);
//     final _paymentResult = document.findAllElements('Sonuc').single.text;
//     final _bankResult =
//         document.findAllElements('Banka_Sonuc_Kod').single.text;
//         dekontId = document.findAllElements('Islem_ID').single.text;
//     final _url3d = document.findAllElements('UCD_URL').single.text;
//     if (_paymentResult == "1" && _bankResult == "0") {
//       print("bodyyyyCode: ${res.statusCode}");
//       print("bodyyyy: ${res.body}");
//       print("isssssss: $dekontId");
//       Provider.of<PaymentIndector>(context, listen: false).updateState(false);
//       String url = _url3d;
//       await canLaunch(url).whenComplete(() {})
//           ? launch(url)
//           : Tools().toastMsg(AppLocalizations.of(context)!.wrong, Colors.red);
//       await driverRef.child(userId).update({
//         "exPlan": planDay,
//         "status": "payed",
//       });
//     } else {
//       Provider.of<PaymentIndector>(context, listen: false).updateState(false);
//       final _erroeMessage = document.findAllElements('Sonuc_Str').single.text;
//       Tools().toastMsg("Payment Failed", Colors.redAccent);
//       Tools().toastMsg(_erroeMessage, Colors.redAccent);
//       Tools().toastMsg(_erroeMessage, Colors.redAccent);
//     }
//   } else {
//     Provider.of<PaymentIndector>(context, listen: false).updateState(false);
//     Tools().toastMsg("Payment Failed 402", Colors.redAccent);
//     Tools().toastMsg("Payment Failed 402", Colors.redAccent);
//   }
// }

// this mehtod for send Receipt
}
