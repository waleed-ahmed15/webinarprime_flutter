import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:webinarprime/utils/colors.dart';
import 'package:webinarprime/utils/styles.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: AppColors.LTprimaryColor,
  appBarTheme: const AppBarTheme(color: Colors.white),
  secondaryHeaderColor: AppColors.LTsecondaryColor,
  scaffoldBackgroundColor: AppColors.LTBackgroundColor,
  cardColor: const Color(0XFFEFEFEF), // textfor
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
  // brightness: Brightness.dark,
  fontFamily: 'JosefinSans',
  inputDecorationTheme: const InputDecorationTheme(
    border: InputBorder.none,
  ),

  primaryColor: AppColors.LTsecondaryColor,
  secondaryHeaderColor: AppColors.LTsecondaryColor,
  scaffoldBackgroundColor: AppColors.DTbackGroundColor,
  cardColor: const Color(0xff262626),
  textTheme: TextTheme(
    displayLarge: TextStyle(
      // bigTitleStyle
      fontSize: 40.sp,
      fontFamily: 'JosefinSans Bold',
      fontWeight: FontWeight.w700,
      color: Colors.white.withOpacity(0.98),
      overflow: TextOverflow.visible,
    ),
    displayMedium: TextStyle(
      // listtileTitleStyle
      height: 1.5,
      fontSize: 16.sp,
      color: Colors.white.withOpacity(0.9),
      fontWeight: FontWeight.w500,
      letterSpacing: 1,
      fontFamily: 'JosefinSans Regular',
    ),
    displaySmall: listtileSubtitleStyle, //
    headlineMedium: TextStyle( 
        // tabTextstyle
        letterSpacing: 1,
        height: 1.5,
        fontSize: 12.sp,
        fontFamily: 'JosefinSans Bold',
        fontWeight: FontWeight.w600,
        color: Colors.white.withOpacity(0.8)),
    headlineSmall: myhintTextstyle,
    titleLarge: const TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    bodyLarge: const TextStyle(
      fontFamily: 'JosefinSans Medium',
      fontSize: 16,
      color: Colors.white,
    ),
    bodyMedium: const TextStyle(
      fontFamily: 'JosefinSans Medium',
      fontSize: 14,
      color: Colors.white,
    ),
  ),
  colorScheme: ColorScheme.fromSwatch().copyWith(
      secondary: const Color(0xff262626), brightness: Brightness.dark),
);
