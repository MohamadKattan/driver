// this class for store card payment

class CardPayment {
  late String cardNumber;
  late String expiryDateMouthe;
  late String expiryDateYear;
  late String cvv;

  CardPayment(
      {required this.cardNumber,
      required this.cvv,
      required this.expiryDateMouthe,
      required this.expiryDateYear});
}
