import 'package:awesome_card/credit_card.dart';
import 'package:awesome_card/style/card_background.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/card_payment.dart';
import '../my_provider/payment_indector_provider.dart';
import '../payment/param_payment.dart';
import '../widget/custom_circuler.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../widget/payment_process_dialog.dart';

class CardPaymentScreen extends StatefulWidget {
  final String amount;
  final int planDay;
  final int currencyType;
  final int oldExplan;
  const CardPaymentScreen(
      {Key? key,
      required this.amount,
      required this.planDay,
      required this.currencyType,
      required this.oldExplan})
      : super(key: key);

  @override
  State<CardPaymentScreen> createState() => _CardPaymentScreenState();
}

class _CardPaymentScreenState extends State<CardPaymentScreen> {
  String cardNumber = "";
  String expiryDateMouthe = "";
  String expiryDateYear = "";
  String cardHolderName = "";
  String cvv = "";
  bool showBack = false;
  FocusNode _focusNode = FocusNode();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  void initState() {
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() {
        _focusNode.hasFocus ? showBack = true : showBack = false;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isLoadingPayment = Provider.of<PaymentIndector>(context).isTrue;
    return WillPopScope(
      onWillPop: () async => false,
      child: SafeArea(
          child: Scaffold(
        key: formKey,
        body: Stack(
          children: [
            isLoadingPayment
                ? CircularInductorCostem().circularInductorCostem(context)
                : const Text(""),
            SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  CreditCard(
                    cardNumber: cardNumber,
                    cardExpiry: "$expiryDateMouthe/$expiryDateYear",
                    cvv: cvv,
                    cardHolderName: cardHolderName,
                    showBackSide: showBack,
                    frontBackground: CardBackgrounds.black,
                    backBackground: CardBackgrounds.white,
                    showShadow: true,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    child: TextFormField(
                      decoration: InputDecoration(
                          hintText: AppLocalizations.of(context)!.card16),
                      maxLength: 16,
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() {
                          cardNumber = value;
                        });
                      },
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    child: TextFormField(
                      decoration: const InputDecoration(hintText: "Cvv"),
                      maxLength: 3,
                      focusNode: _focusNode,
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() {
                          cvv = value;
                        });
                      },
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    child: TextFormField(
                      decoration: InputDecoration(
                          hintText: AppLocalizations.of(context)!.mexpiry),
                      maxLength: 2,
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() {
                          expiryDateMouthe = value;
                        });
                      },
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    child: TextFormField(
                      decoration: InputDecoration(
                          hintText: AppLocalizations.of(context)!.yexpiry),
                      maxLength: 4,
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() {
                          expiryDateYear = value;
                        });
                      },
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    child: TextFormField(
                      decoration: InputDecoration(
                          hintText: AppLocalizations.of(context)!.holderName),
                      maxLength: 20,
                      keyboardType: TextInputType.text,
                      onChanged: (value) {
                        setState(() {
                          cardHolderName = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize:const Size(120, 40),
                              backgroundColor: Colors.greenAccent[700]),
                          child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Text(
                                AppLocalizations.of(context)!.pay,
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.white),
                              )),
                          onPressed: () async {
                            Provider.of<PaymentIndector>(context,listen: false).updateState(true);
                            CardPayment card = CardPayment(
                                cvv: cvv,
                                expiryDateYear: expiryDateYear,
                                expiryDateMouthe: expiryDateMouthe,
                                cardNumber: cardNumber,
                                holderName: cardHolderName);
                            showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (_) {
                                  return paymentProcess(context,
                                      voidCallback: () {
                                    ParamPayment().paramToken(
                                        card,
                                        widget.amount,
                                        widget.planDay,
                                        widget.currencyType,
                                        context,
                                        widget.oldExplan);
                                  });
                                });
                          }),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              minimumSize:const Size(120, 40),
                              backgroundColor: Colors.red[700]),
                          child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Text(
                                AppLocalizations.of(context)!.cancel,
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.white),
                              )),
                          onPressed: () async {
                            Navigator.pop(context);
                          }),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      )),
    );
  }

  void clearText() {
    setState(() {
      cardNumber = "";
      expiryDateMouthe = "";
      expiryDateYear = "";
      cardHolderName = "";
      cvv = "";
    });
  }
}
