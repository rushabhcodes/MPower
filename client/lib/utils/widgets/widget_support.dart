import 'package:flutter/material.dart';

class AppWidget{
  static TextStyle boldTextStyle()
  {
    return TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 20);
  }

  static TextStyle headlineTextStyle()
  {
    return TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 24);
  }

  static TextStyle lightTextStyle()
  {
    return TextStyle(
        color: Colors.black38,
        fontWeight: FontWeight.bold,
        fontSize: 16);
  }
}