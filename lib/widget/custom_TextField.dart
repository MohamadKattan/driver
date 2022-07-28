
// this class for Custom TextField

import 'package:flutter/material.dart';

class CustomTextField{

  Widget customTextField({required TextEditingController controller,TextInputType?keyboardType,InputDecoration?decoration,required int lenNumber}){
    return  Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller:controller ,
        maxLength: lenNumber,
        showCursor: true,
        cursorColor: const Color(0xFFFFD54F),
        style: const TextStyle(
            fontSize: 16, fontWeight: FontWeight.w600),
        keyboardType:keyboardType ,
        maxLines: 1,
        decoration:decoration ,
      ),
    );
  }
}