import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_color.dart';
import 'app_string.dart';

class AppTheme {
  static final ThemeData themeData = ThemeData(
      colorScheme: ColorScheme.fromSeed(
          seedColor: AppColor.primaryColor, brightness: Brightness.light),
      // useMaterial3: true,
      // primarySwatch:
      //     const MaterialColor(AppColor.primarySwatch, AppColor.primaryColorMap),
      scaffoldBackgroundColor: AppColor.appBodyBg,
      navigationBarTheme: const NavigationBarThemeData(
          backgroundColor: AppColor.appBodyBg,
          elevation: 0.0,
          indicatorColor: AppColor.primaryColor),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey.shade400,
          backgroundColor: AppColor.navBarBgColor),
      cupertinoOverrideTheme: NoDefaultCupertinoThemeData(
          brightness: Brightness.light,
          scaffoldBackgroundColor: AppColor.appBodyBg,
          barBackgroundColor: AppColor.appBodyBg,
          primaryColor: AppColor.primaryColor,
          primaryContrastingColor: AppColor.primaryColor,
          textTheme: CupertinoTextThemeData(
            textStyle: const TextStyle(fontFamily: AppString.fontName),
            actionTextStyle: const TextStyle(fontFamily: AppString.fontName),
            tabLabelTextStyle: const TextStyle(fontFamily: AppString.fontName),
            navTitleTextStyle: const TextStyle(fontFamily: AppString.fontName),
            navLargeTitleTextStyle:
                const TextStyle(fontFamily: AppString.fontName),
            navActionTextStyle: const TextStyle(fontFamily: AppString.fontName),
            pickerTextStyle: const TextStyle(fontFamily: AppString.fontName),
            dateTimePickerTextStyle: TextStyle(
                fontFamily: AppString.fontName,
                color: AppColor.textColor,
                fontSize: 18.0),
          )),
      appBarTheme: AppBarTheme(
          backgroundColor: AppColor.appbarBgColor,
          titleTextStyle:
              TextStyle(color: AppColor.textColor, fontWeight: FontWeight.bold),
          elevation: 0.0,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: AppColor.appbarBgColor,
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.dark,
          )),
      canvasColor: Colors.transparent,
      textSelectionTheme: const TextSelectionThemeData(
          cursorColor: AppColor.primaryColor,
          selectionColor: AppColor.secondaryColor),
      bottomSheetTheme:
          const BottomSheetThemeData(modalBackgroundColor: Colors.transparent),
      fontFamily: AppString.fontName,
      textTheme: TextTheme(
        displayLarge: TextStyle(
            fontFamily: AppString.fontName, color: AppColor.textColor),
        displayMedium: TextStyle(
            fontFamily: AppString.fontName, color: AppColor.textColor),
        displaySmall: TextStyle(
            fontFamily: AppString.fontName, color: AppColor.textColor),
        headlineMedium: TextStyle(
            fontFamily: AppString.fontName, color: AppColor.textColor),
        headlineSmall: TextStyle(
            fontFamily: AppString.fontName, color: AppColor.textColor),
        titleLarge: TextStyle(
            fontFamily: AppString.fontName, color: AppColor.textColor),
        titleMedium: TextStyle(
            fontFamily: AppString.fontName, color: AppColor.textColor),
        titleSmall: TextStyle(
            fontFamily: AppString.fontName, color: AppColor.textColor),
        bodyLarge: TextStyle(
            fontFamily: AppString.fontName, color: AppColor.textColor),
        bodyMedium: TextStyle(
            fontFamily: AppString.fontName, color: AppColor.textColor),
        bodySmall: TextStyle(
            fontFamily: AppString.fontName, color: AppColor.textColor),
        labelLarge: TextStyle(
            fontFamily: AppString.fontName, color: AppColor.textColor),
        labelSmall: TextStyle(
            fontFamily: AppString.fontName, color: AppColor.textColor),
      ));

  static var deviceOrientation = SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
}
