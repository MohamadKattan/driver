// this class for Custom TextField

import 'package:flutter/material.dart';

class CustomTextField {
  Widget customTextField(
      {required TextEditingController controller,
      TextInputType? keyboardType,
      InputDecoration? decoration,
      required int lenNumber}) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
          color: Colors.white70,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(width: 2.0, color: Colors.white70)),
      child: TextField(
        controller: controller,
        showCursor: true,
        cursorColor: const Color(0xFFFFD54F),
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        keyboardType: keyboardType,
        maxLines: 1,
        decoration: decoration,
      ),
    );
  }
}
