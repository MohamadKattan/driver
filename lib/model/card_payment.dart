// this class for store card payment

class CardPayment {
  late String cardNumber;
  late String expiryDateMouthe;
  late String expiryDateYear;
  late String cvv;
  late String holderName;

  CardPayment({
    required this.cardNumber,
    required this.cvv,
    required this.expiryDateMouthe,
    required this.expiryDateYear,
    required this.holderName,
  });
}
