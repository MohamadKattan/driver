// this class for custom divider

import 'package:flutter/material.dart';

class CustomDivider{
  // divider
  Widget customDivider() {
    return Container(
      height: 0.6,
      decoration: const BoxDecoration(color: Colors.black12, boxShadow: [
        BoxShadow(
            blurRadius: 5.0,
            spreadRadius: 0.4,
            color: Colors.black54,
            offset: Offset(0.6, 0.6))
      ]),
    );
  }
}