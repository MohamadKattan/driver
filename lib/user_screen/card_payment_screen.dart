
import 'package:awesome_card/credit_card.dart';
import 'package:awesome_card/style/card_background.dart';
import 'package:driver/payment/checkOut_payment.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/card_payment.dart';
import '../my_provider/payment_indector_provider.dart';
import '../my_provider/placeAdrees_name.dart';
import '../widget/custom_circuler.dart';
import 'HomeScreen.dart';

class CardPaymentScreen extends StatefulWidget {
  final int amount;
  final int planexpirt;
  const CardPaymentScreen({Key? key, required this.amount,required this.planexpirt}) : super(key: key);

  @override
  State<CardPaymentScreen> createState() => _CardPaymentScreenState();
}

class _CardPaymentScreenState extends State<CardPaymentScreen> {
  String cardNumber = "";
  String cardHolderName = "";
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
    String countryName = Provider.of<PlaceName>(context).placeName;
    return SafeArea(
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
                    cardHolderName: cardHolderName,
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
                    decoration: const InputDecoration(hintText:"Card number"),
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
                    decoration: const InputDecoration(hintText:"moutheExpiry"),
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
                    decoration: const InputDecoration(hintText:"yearExpiry"),
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
                        child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Text(
                              "pay",
                              style: TextStyle(
                                  fontSize: 14, color: Colors.green[700]),
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
                        child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Text(
                              "cancel",
                              style: TextStyle(
                                  fontSize: 14, color: Colors.redAccent[700]),
                            )),
                        onPressed: () async {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HomeScreen()),
                                  (route) => false);
                        }),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    ));
  }
}
