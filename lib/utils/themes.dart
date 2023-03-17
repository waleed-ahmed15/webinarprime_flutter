import 'package:flutter/material.dart';
import 'package:webinarprime/utils/colors.dart';
import 'package:webinarprime/utils/styles.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: AppColors.LTprimaryColor,
  appBarTheme: const AppBarTheme(color: Colors.white),
  secondaryHeaderColor: AppColors.LTsecondaryColor,
  scaffoldBackgroundColor: AppColors.LTBackgroundColor,
  textTheme: TextTheme(
      displayLarge: bigTitleStyle,
      displayMedium: listtileTitleStyle,
      displaySmall: listtileSubtitleStyle,
      headlineMedium: tabTextstyle,
      headlineSmall: myhintTextstyle,
      titleLarge: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      bodyLarge: const TextStyle(
        fontSize: 16,
        color: Colors.black,
      ),
      bodyMedium: const TextStyle(
        fontSize: 14,
        color: Colors.black,
      )),
  colorScheme:
      ColorScheme.fromSwatch().copyWith(secondary: AppColors.LTforgroundColor),
  
);

ThemeData darkTheme = ThemeData(
  appBarTheme: const AppBarTheme(color: Color(0xff0A2647)),
  brightness: Brightness.dark,
  fontFamily: 'JosefinSans',
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
