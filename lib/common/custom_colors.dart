import 'package:flutter/material.dart';

class CustomColors {
  static const MaterialColor customSwatchColor = MaterialColor(
    _customPrimaryValue,
    <int, Color>{
      50: Color(0xFFE0E0E0),
      100: Color(0xFFB3B3B3),
      200: Color(0xFF808080),
      300: Color(0xFF4D4D4D),
      400: Color(0xFF262626),
      500: Color(_customPrimaryValue),
      600: Color(0xFF000000),
      700: Color(0xFF000000),
      800: Color(0xFF000000),
      900: Color(0xFF000000),
    },
  );
  static const int _customPrimaryValue = 0xFF000000;

  static const Color customTransparentColor = Colors.transparent;
}
