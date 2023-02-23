import 'package:flutter/material.dart';
import 'package:webinarprime/utils/colors.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: AppColors.LTprimaryColor,
  secondaryHeaderColor: AppColors.LTsecondaryColor,
  scaffoldBackgroundColor: AppColors.LTBackgroundColor,
  textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      displayMedium: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      displaySmall: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      headlineMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      headlineSmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      titleLarge: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: Colors.black,
      ),
      bodyMedium: TextStyle(
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
    displayLarge: TextStyle(
      fontFamily: 'JosefinSans Bold',
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    displayMedium: TextStyle(
      fontFamily: 'JosefinSans Bold',
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    displaySmall: TextStyle(
      fontFamily: 'JosefinSans Bold',
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    headlineMedium: TextStyle(
      fontFamily: 'JosefinSans',
      fontSize: 16,
      color: Colors.white,
    ),
    headlineSmall: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    titleLarge: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    bodyLarge: TextStyle(
      fontFamily: 'JosefinSans Medium',
      fontSize: 16,
      color: Colors.white,
    ),
    bodyMedium: TextStyle(
      fontFamily: 'JosefinSans Medium',
      fontSize: 14,
      color: Colors.white,
    ),
  ),
);
