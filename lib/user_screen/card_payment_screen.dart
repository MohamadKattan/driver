
import 'package:awesome_card/credit_card.dart';
import 'package:awesome_card/style/card_background.dart';
import 'package:driver/payment/checkOut_payment.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/card_payment.dart';
import '../my_provider/driver_model_provider.dart';
import '../my_provider/payment_indector_provider.dart';
import '../my_provider/placeAdrees_name.dart';
import '../widget/custom_circuler.dart';


class CardPaymentScreen extends StatefulWidget {
  final int amount;
  final int planexpirt;
  const CardPaymentScreen({Key? key, required this.amount,required this.planexpirt}) : super(key: key);

  @override
  State<CardPaymentScreen> createState() => _CardPaymentScreenState();
}

class _CardPaymentScreenState extends State<CardPaymentScreen> {
  String cardNumber = "";
  String expiryDateMouthe = "";
  String expiryDateYear = "";
  String cvv = "";
  bool showBack = false;
   FocusNode _focusNode = FocusNode();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  void initState() {
    _focusNode =  FocusNode();
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
    String countryName = Provider.of<DriverInfoModelProvider>(context).driverInfo.country;
    return WillPopScope(
      onWillPop: ()async=>false,
      child: SafeArea(
          child: Scaffold(
            key: formKey,
        body: Stack(
          children: [
            isLoadingPayment ? CircularInductorCostem().circularInductorCostem(context): const Text(""),
            SingleChildScrollView(
              child: Column(
                children:  [
                  const SizedBox(height: 10),
                  CreditCard(
                      cardNumber: cardNumber,
                      cardExpiry: "$expiryDateMouthe/$expiryDateYear",
                      cvv: cvv,
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
                      decoration: const InputDecoration(hintText:"Card number 16 number"),
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
                      decoration: const InputDecoration(hintText:"Mouthe Expiry on your card"),
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
                      decoration: const InputDecoration(hintText:"Year Expiry 2 number"),
                      maxLength: 2,
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() {
                          expiryDateYear = value;
                        });
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary:  Colors.green[700]
                        ),
                          child: const Padding(
                              padding: EdgeInsets.all(12),
                              child: Text(
                                "pay",
                                style: TextStyle(
                                    fontSize: 14, color:Colors.white),
                              )),
                          onPressed: () async {
                            Provider.of<PaymentIndector>(context,listen: false).updateState(true);
                            CardPayment card = CardPayment(
                                cvv: cvv,
                              expiryDateYear:expiryDateYear,
                              expiryDateMouthe: expiryDateMouthe,
                              cardNumber: cardNumber,
                               );
                            CheckOutPayment checkOut = CheckOutPayment();
                            await checkOut.makePayment(
                                card,
                                widget.amount,
                              countryName=="Turkey"?"TRY":"USD",
                                context,
                              widget.planexpirt
                        );
                            Provider.of<PaymentIndector>(context,listen: false).updateState(false);

                          }),
                      ElevatedButton(
                          style:ElevatedButton.styleFrom(
                            onPrimary:Colors.redAccent.shade700,
                          ),
                          child: const Padding(
                              padding: EdgeInsets.all(12),
                              child: Text(
                                "cancel",
                                style: TextStyle(
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
}
