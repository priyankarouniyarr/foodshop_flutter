import 'package:flutter/material.dart';

class AppWidget {
  static TextStyle boldTextFieldWidget() {
    return TextStyle(
        fontSize: 20,
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontFamily: 'Poppins');
  }

  static TextStyle HeadlineTextFieldWidget() {
    return TextStyle(
        fontSize: 24,
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontFamily: 'Poppins');
  }

  static TextStyle LightTextFieldWidget() {
    return TextStyle(
        fontSize: 15,
        color: Colors.black38,
        fontWeight: FontWeight.w500,
        fontFamily: 'Poppins');
  }

  static TextStyle SemiBoldTextFieldWidget() {
    return TextStyle(
        fontSize: 18,
        color: Colors.black38,
        fontWeight: FontWeight.w500,
        fontFamily: 'Poppins');
  }
}
