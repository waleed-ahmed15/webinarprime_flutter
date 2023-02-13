import 'package:flutter/material.dart';
import 'package:webinarprime/utils/colors.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  accentColor: AppColors.LTforgroundColor,
  primaryColor: AppColors.LTprimaryColor,
  secondaryHeaderColor: AppColors.LTsecondaryColor,
  scaffoldBackgroundColor: AppColors.LTBackgroundColor,
);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  fontFamily: 'JosefinSans',

  inputDecorationTheme: InputDecorationTheme(
  
    border: InputBorder.none,
  ),
  accentColor: AppColors.DTforgroundColor,
  primaryColor: AppColors.LTsecondaryColor,

  secondaryHeaderColor: AppColors.LTsecondaryColor,
  scaffoldBackgroundColor: AppColors.DTbackGroundColor,
  textTheme: TextTheme(
    bodyLarge: TextStyle(color: Colors.black),
  ),
);
