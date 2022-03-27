// this class will include math methods

import 'dart:math';

class MathMethods {
  static double createRandomNumber(int number) {
    var random = Random();
    int randomNumber = random.nextInt(number);
    return randomNumber.toDouble();
  }
}
