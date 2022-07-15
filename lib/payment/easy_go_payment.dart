// import 'package:driver/config.dart';
// import 'package:driver/model/card_payment.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_background_service/flutter_background_service.dart';
// import 'package:iyzico/iyzico.dart';
// import 'package:provider/provider.dart';
//
// import '../my_provider/driver_model_provider.dart';
// import '../my_provider/payment_indector_provider.dart';
// import '../tools/tools.dart';
// import '../user_screen/splash_screen.dart';
// import 'couut_plan_days.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
//
// class PayNow {
//   static const iyziConfig = IyziConfig(
//       'sandbox-I2ztkzvJrncBcSGWjBBlknCu8eKDHhvU',
//       'sandbox-BEMvtoaAYHQTvdtjbODeeot4eK5avqGk',
//       'https://sandbox-api.iyzipay.com');
//
//   final iyzico = Iyzico.fromConfig(configuration: iyziConfig);
//
//
//   Future<bool> tryPay(BuildContext context, CardPayment card, int planexpirt,
//       double amount) async {
//     String countryName =
//         Provider.of<DriverInfoModelProvider>(context, listen: false)
//             .driverInfo
//             .country;
//     const double price = 1;
//     final double paidPrice = amount;
//
//     final paymentCard = PaymentCard(
//       cardHolderName: card.holderName,
//       cardNumber: card.cardNumber,
//       expireYear: card.expiryDateYear,
//       expireMonth: card.expiryDateMouthe,
//       cvc: card.cvv,
//     );
//     final shippingAddress = Address(
//         address: 'Nidakule Göztepe, Merdivenköy Mah. Bora Sok. No:1',
//         contactName: 'Jane Doe',
//         zipCode: '34742',
//         city: 'Istanbul',
//         country: 'Turkey');
//     final billingAddress = Address(
//         address: 'Nidakule Göztepe, Merdivenköy Mah. Bora Sok. No:1',
//         contactName: 'Jane Doe',
//         city: 'Istanbul',
//         country: 'Turkey');
//     final buyer = Buyer(
//         id: 'BY789',
//         name: 'Nizam',
//         surname: 'Akyol',
//         identityNumber: '74300864791',
//         email: 'vba@garantitaxi.com',
//         registrationAddress:
//             'Nidakule Göztepe, Merdivenköy Mah. Bora Sok. No:1',
//         city: 'Istanbul',
//         country: 'Turkey',
//         ip: '85.34.78.112');
//     final basketItems = <BasketItem>[
//       BasketItem(
//           id: 'BI101',
//           price: '0.3',
//           name: 'Binocular',
//           category1: 'Collectibles',
//           category2: 'Accessories',
//           itemType: BasketItemType.PHYSICAL),
//       BasketItem(
//           id: 'BI102',
//           price: '0.5',
//           name: 'Game code',
//           category1: 'Game',
//           category2: 'Online Game Items',
//           itemType: BasketItemType.VIRTUAL),
//       BasketItem(
//           id: 'BI103',
//           price: '0.2',
//           name: 'Usb',
//           category1: 'Electronics',
//           category2: 'Usb / Cable',
//           itemType: BasketItemType.PHYSICAL),
//     ];
//
//     final paymentResult = await iyzico.CreatePaymentRequest(
//         price: price,
//         currency: countryName == "Turkey" ? Currency.TRY : Currency.USD,
//         paidPrice: paidPrice,
//         paymentCard: paymentCard,
//         buyer: buyer,
//         shippingAddress: shippingAddress,
//         billingAddress: billingAddress,
//         basketItems: basketItems);
//     print("rrrrrr${paymentResult.status}");
//     if (paymentResult.status == "success") {
//       Tools().toastMsg(
//           AppLocalizations.of(context)!.successful, Colors.green.shade700);
//       await PlanDays().setExPlanToRealTime(planexpirt);
//       await PlanDays().setIfBackgroundOrForeground(true);
//       await PlanDays().setDriverPayed();
//       FlutterBackgroundService().invoke("setAsBackground");
//       Provider.of<PaymentIndector>(context, listen: false).updateState(false);
//       Navigator.push(
//           context, MaterialPageRoute(builder: (_) => const SplashScreen()));
//       return true;
//     } else {
//       Provider.of<PaymentIndector>(context, listen: false).updateState(false);
//       Tools().toastMsg(AppLocalizations.of(context)!.notSuccessfully,
//           Colors.redAccent.shade700);
//       Tools().toastMsg(
//           AppLocalizations.of(context)!.anotherCard, Colors.redAccent.shade700);
//       Navigator.push(
//           context, MaterialPageRoute(builder: (_) => const SplashScreen()));
//       throw Exception("Payment error");
//     }
//   }
// }
