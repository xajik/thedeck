/*
 *
 *  *
 *  * Created on 1 4 2023
 *
 */

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'color_utils.dart';

mixin AppTheme {
  static final ThemeData themeData = _lightThemeData;

  static final ThemeData _lightThemeData = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.lightBlue,
    scaffoldBackgroundColor: AppColors.white,
    canvasColor: AppColors.blue,
    splashColor: AppColors.purpleDark,
    textTheme: _textThemeData(true),
  );

  static final ThemeData darkThemeData = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.lightBlue,
    scaffoldBackgroundColor: AppColors.white,
    canvasColor: AppColors.blue,
    textTheme: _textThemeData(true),
  );

  static void setSystemBarColor() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
  }

  static TextTheme _textThemeData(bool isDarkMode) {
    final color = isDarkMode ? AppColors.black : AppColors.white;
    final secondaryColor = isDarkMode ? AppColors.grey : AppColors.grey;
    return TextTheme(
      displayLarge:
          TextStyle(color: color, fontWeight: FontWeight.w400, fontSize: 32),
      displayMedium:
          TextStyle(color: color, fontWeight: FontWeight.w500, fontSize: 28),
      displaySmall:
          TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: 26),
      headlineLarge:
          TextStyle(color: color, fontWeight: FontWeight.w400, fontSize: 22),
      headlineMedium:
          TextStyle(color: color, fontWeight: FontWeight.w500, fontSize: 20),
      headlineSmall:
          TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: 14),
      titleLarge:
          TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.w400),
      titleMedium:
          TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.w400),
      titleSmall: TextStyle(
          color: secondaryColor, fontSize: 14, fontWeight: FontWeight.w400),
      bodyLarge: TextStyle(
          color: color, fontSize: 14, fontWeight: FontWeight.w500, height: 1.5),
      bodyMedium: TextStyle(
          color: color, fontSize: 12, fontWeight: FontWeight.w400, height: 1.3),
    );
  }

  static bool isDarkMode(BuildContext context) {
    Brightness brightness = MediaQuery.of(context).platformBrightness;
    return brightness == Brightness.dark;
  }
}
