import 'dart:math';
import 'package:driver/model/card_payment.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:provider/provider.dart';
import '../my_provider/driver_model_provider.dart';
import '../my_provider/payment_indector_provider.dart';
import '../tools/tools.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../tools/url_lunched.dart';
import 'package:xml/xml.dart' as xml;

class ParamPayment {

  Future<void> paramStartPayment(CardPayment card, String amount, int planDay, String currencyType, BuildContext context) async {
    final user = Provider.of<DriverInfoModelProvider>(context,listen: false).driverInfo;
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
                '107380c13d406-873b-403b-9c09-a5766840d98c1$amount$amount${user.firstName}${idOrder}http://localhost:3000http://localhost:3000/sepet');
          });
        });
      });
    });
    var bookshelfXml = builder.buildDocument();
    String _uriMsj = bookshelfXml.toString();
    print("_uriMsj: $_uriMsj");
    Uri _uri = Uri.parse(
        "https://test-dmz.param.com.tr:4443/turkpos.ws/service_turkpos_test.asmx?wsdl");
    Map<String, String> _headerHash = {'content-type': 'text/xml'};
    final res = await http.post(_uri,
        headers: _headerHash, body: convert.utf8.encode(_uriMsj));
    // print("_responseOtp: ${res.statusCode}");
    // print("_responseOtp: ${res.body}");
    if (res.reasonPhrase == "OK" && res.statusCode == 200) {
      final document = xml.XmlDocument.parse(res.body);
      final _hashCode = document.findAllElements('SHA2B64Result').single.text;
      print("hashhhh: $_hashCode");
      startPayment(_hashCode, idOrder,amount,user.firstName,user.phoneNumber,card,context);
    } else {
      Provider.of<PaymentIndector>(context,listen: false).updateState(false);
      Tools()
          .toastMsg("SomeThing went wrong 402 hash", Colors.redAccent.shade700);
      Tools()
          .toastMsg("SomeThing went wrong 402 hash", Colors.redAccent.shade700);
    }
  }

  Future<void> startPayment(String hashCode, String idorder, String amount, String firstName, String phoneNumber, CardPayment card, BuildContext context) async {
    Uri _url = Uri.parse(
        "https://test-dmz.param.com.tr:4443/turkpos.ws/service_turkpos_test.asmx?wsdl");

    Map<String, String> _headerPayment = {'content-type': 'text/xml'};

    var builder = xml.XmlBuilder();
    builder.processing('xml', 'version="1.0" encoding="utf-8"');
    builder.element('soap:Envelope', nest: () {
      builder.attribute(
          'xmlns:xsi', 'http://www.w3.org/2001/XMLSchema-instance');
      builder.attribute('xmlns:xsd', 'http://www.w3.org/2001/XMLSchema');
      builder.attribute(
          'xmlns:soap', 'http://schemas.xmlsoap.org/soap/envelope/');
      builder.element('soap:Body', nest: () {
        builder.element('Pos_Odeme', nest: () {
          builder.attribute('xmlns', 'https://turkpos.com.tr/');
          builder.element('G', nest: () {
            builder.element('CLIENT_CODE', nest: 10738);
            builder.element('CLIENT_USERNAME', nest: 'Test');
            builder.element('CLIENT_PASSWORD', nest: 'Test');
          });
          builder.element('GUID', nest: '0c13d406-873b-403b-9c09-a5766840d98c');
          builder.element('KK_Sahibi', nest: card.holderName);
          builder.element('KK_No', nest: card.cardNumber);
          builder.element('KK_SK_Ay', nest: card.expiryDateMouthe);
          builder.element('KK_SK_Yil', nest: card.expiryDateYear);
          builder.element('KK_CVC', nest: card.cvv);
          builder.element('KK_Sahibi_GSM', nest: phoneNumber);
          builder.element('Hata_URL', nest: 'http://localhost:3000');
          builder.element('Basarili_URL', nest: 'http://localhost:3000/sepet');
          builder.element('Siparis_ID', nest: '$firstName$idorder');
          builder.element('Siparis_Aciklama');
          builder.element('Taksit', nest: 1);
          builder.element('Islem_Tutar', nest: amount);
          builder.element('Toplam_Tutar', nest: amount);
          builder.element('Islem_Hash', nest: hashCode);
          builder.element('Islem_Guvenlik_Tip', nest: 'NS');
          builder.element('Islem_ID');
          builder.element('IPAdr', nest: '127.0.0.1');
          builder.element('Ref_URL', nest: '');
          builder.element('Data1', nest: '');
          builder.element('Data2', nest: '');
          builder.element('Data3', nest: '');
          builder.element('Data4', nest: '');
          builder.element('Data5', nest: '');
          builder.element('Data6', nest: '');
          builder.element('Data7', nest: '');
          builder.element('Data8', nest: '');
          builder.element('Data9', nest: '');
          builder.element('Data10', nest: '');
        });
      });
    });
    var bookshelfXml = builder.buildDocument();
    String _uriMsj = bookshelfXml.toString();
    print("payment_uriMsj: $_uriMsj");
    final res = await http.post(_url,
        headers: _headerPayment, body: convert.utf8.encode(_uriMsj));
    print("_responseOtp: ${res.statusCode}");
    print("_responseOtp: ${res.body}");
    if (res.statusCode == 200 && res.reasonPhrase == "OK") {
      final document = xml.XmlDocument.parse(res.body);
      final _paymentResult = document.findAllElements('Sonuc').single.text;
      final _bankResult = document.findAllElements('Banka_Sonuc_Kod').single.text;
      print("SonucResult: $_paymentResult");
      print("SonucResult: $_bankResult");
      if (_paymentResult == "1"&&_bankResult=="0") {
        Provider.of<PaymentIndector>(context,listen: false).updateState(false);
        Tools().toastMsg("Payment don", Colors.green);
      } else {
        Provider.of<PaymentIndector>(context,listen: false).updateState(false);
        final _erroeMessage = document.findAllElements('Sonuc_Str').single.text;
        Tools().toastMsg("Payment Failed", Colors.redAccent);
        Tools().toastMsg(_erroeMessage, Colors.redAccent);
        Tools().toastMsg(_erroeMessage, Colors.redAccent);
      }
    } else {
      Provider.of<PaymentIndector>(context,listen: false).updateState(false);
      Tools().toastMsg("Payment Failed 402", Colors.redAccent);
      Tools().toastMsg("Payment Failed 402", Colors.redAccent);
    }
  }
}
