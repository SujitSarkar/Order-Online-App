import 'package:flutter/material.dart';

class AppColor {
  static const Color primaryColor = Color(0xffBE0B19);
  static const int primarySwatch = 0xffBE0B19;
  static const Color secondaryColor = Color(0xff832161);

  static const Color errorColor = Colors.red;
  static const Color enableColor = Colors.green;
  static const Color disableColor = Colors.grey;
  static const Color warningColor = Color.fromARGB(255, 217, 155, 9);

  static const Color appBodyBg = Color(0xffF5F0F0);
  static const Color appbarBgColor = primaryColor;
  static const Color cardColor = Color(0xffFFFFFF);
  static const Color bottomSheetColor = Color(0xffFFFFFF);
  static const Color navBarBgColor = secondaryColor;

  static const Color googleButtonColor = Color(0xff4285F4);
  static const Color facebookButtonColor = Color(0xff2374F2);

  static const Color textFieldHintColor = Color(0xff9CA3AF);
  static const Color textFieldIconColor = Color(0xff9CA3AF);
  static const Color textFieldOutlineColor = Colors.grey;

  static final Color textColor = Colors.grey.shade800;
  static const Color secondaryTextColor = Color(0xff79767E);

  static const Map<int, Color> primaryColorMap = {
    50: Color.fromRGBO(190, 11, 25, .1),
    100: Color.fromRGBO(190, 11, 25, .2),
    200: Color.fromRGBO(190, 11, 25, .3),
    300: Color.fromRGBO(190, 11, 25, .4),
    400: Color.fromRGBO(190, 11, 25, .5),
    500: Color.fromRGBO(190, 11, 25, .6),
    600: Color.fromRGBO(190, 11, 25, .7),
    700: Color.fromRGBO(190, 11, 25, .8),
    800: Color.fromRGBO(190, 11, 25, .9),
    900: Color.fromRGBO(190, 11, 25, 1)
  };
}
