import 'package:flutter/material.dart';
import 'package:webinarprime/utils/colors.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: AppColors.LTprimaryColor,
  secondaryHeaderColor: AppColors.LTsecondaryColor,
  scaffoldBackgroundColor: AppColors.LTBackgroundColor,
  textTheme: const TextTheme(
      headline1: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      headline2: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      headline3: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      headline4: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      headline5: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      headline6: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      bodyText1: TextStyle(
        fontSize: 16,
        color: Colors.black,
      ),
      bodyText2: TextStyle(
        fontSize: 14,
        color: Colors.black,
      )),
  colorScheme:
      ColorScheme.fromSwatch().copyWith(secondary: AppColors.LTforgroundColor),
);


ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,  
  fontFamily: 'Montserrat',
  inputDecorationTheme: const InputDecorationTheme(
    border: InputBorder.none,
  ),
  primaryColor: AppColors.LTsecondaryColor,
  secondaryHeaderColor: AppColors.LTsecondaryColor,
  scaffoldBackgroundColor: AppColors.DTbackGroundColor,
  textTheme: const TextTheme(
    headline1: TextStyle(
      fontFamily: 'JosefinSans Bold',
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    headline2: TextStyle(
      fontFamily: 'JosefinSans Bold',
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    headline3: TextStyle(
      fontFamily: 'JosefinSans Bold',
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    headline4: TextStyle(
      fontFamily: 'JosefinSans',
      fontSize: 16,
      color: Colors.white,
    ),
    headline5: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    headline6: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    bodyText1: TextStyle(
      fontFamily: 'JosefinSans Medium',
      fontSize: 16,
      color: Colors.white,
    ),
    bodyText2: TextStyle(
      fontFamily: 'JosefinSans Medium',
      fontSize: 14,
      color: Colors.white,
    ),
  ),
);
