
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import '../model/listSipyJson.dart';
// import '../model/sipayjson.dart';
//
// class SiPay {
//
//   static const testUrl = "https://provisioning.sipay.com.tr/ccpayment/api/paySmart2D";
//   static const liveUrl = "https://app.sipay.com.tr/ccpayment/api/paySmart2D";
//   static const sKey = "b46a67571aa1e7ef5641dc3fa6f1712a";
//   static const pKey = "6d4a7e9374a76c15260fcc75e315b0b9";
//   static const merchantKey =r"$2y$10$HmRgYosneqcwHj.UH7upGuyCZqpQ1ITgSMj9Vvxn.t6f.Vdf2SQFO";
//
//   Map<String, String> header = {
//     "Content type": "application/json",
//     "Authorization": " Bearer",
//     "Accept": "application/json",
//   };
//
// // var data  =
// // {
// //   "cc_holder_name": "John Dao",
// //   "cc_no": "4508034508034509",
// //   "expiry_month": 12,
// //   "expiry_year": 2026,
// //   "cvv": 543,
// //   "currency_code": "TRY",
// //   "installments_number": 1,
// //   "invoice_id": 5874544,
// //   "invoice_description": "5974544 Ödemesi",
// //   "name": "John",
// //   "surname": "Dao",
// //   "total": 458,
// //   "merchant_key": merchantKey,
// //   "items": "[{}]",
// //   "cancel_url": "string",
// //   "return_url": "string",
// //   "hash_key": "string",
// //   "order_type": 0,
// //   };
//
//   Future<void> doPayment() async {
//    var res = await http.post(
//         Uri.parse(testUrl),
//         headers: header,
//
//     );
//     if (res.statusCode == 200) {
//       print(res.statusCode);
//       print(res.body);
//     } else {
//       print(res.statusCode);
//       throw Exception("Payment error");
//     }
//   }
// }



