import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webinarprime/utils/dimension.dart';

class Mystyles {
  static TextStyle tabTextstyle = TextStyle(
    letterSpacing: 1,
    height: 1.5,
    fontSize: 12.sp,
    fontFamily: 'JosefinSans Bold',
    fontWeight: FontWeight.w600,
    color: Get.isDarkMode
        ? Colors.white.withOpacity(0.8)
        : Colors.black.withOpacity(0.9),
  );
  static TextStyle myhintTextstyle = TextStyle(
      height: 1.5,
      letterSpacing: 1,
      color: Get.isDarkMode ? const Color(0xffA1a1aa) : const Color(0xff475569),
      fontSize: 18.sp,
      fontFamily: 'JosefinSans SemiBold');
  static TextStyle listtileTitleStyle = TextStyle(
    height: 1.5,
    fontSize: 16.sp,
    color: Get.isDarkMode
        ? Colors.white.withOpacity(0.9)
        : Colors.black.withOpacity(0.9),
    fontWeight: FontWeight.w500,
    letterSpacing: 1,
    fontFamily: 'JosefinSans Regular',
  );
  static TextStyle listtileSubtitleStyle = TextStyle(
    letterSpacing: 1,
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
    fontFamily: 'JosefinSans Medium',
  );

  static TextStyle bigTitleStyle = TextStyle(
    fontSize: 40.sp,
    fontFamily: 'JosefinSans Bold',
    fontWeight: FontWeight.w700,
    color: Get.isDarkMode
        ? Colors.white.withOpacity(0.98)
        : const Color(0xff181b1f),
    overflow: TextOverflow.visible,
  );

  static TextStyle onelineStyle = TextStyle(
      height: 1.5,
      color: Get.isDarkMode ? const Color(0xffA1a1aa) : const Color(0xff475569),
      fontSize: 20.sp,
      fontFamily: 'JosefinSans Regular');

  static TextStyle onpageheadingsyle = TextStyle(
    letterSpacing: 1,
    fontSize: 14.sp,
    color: Get.isDarkMode
        ? const Color.fromRGBO(122, 121, 121, 1)
        : const Color.fromRGBO(176, 179, 190, 1),
    fontWeight: FontWeight.w700,
    fontFamily: 'JosefinSans Bold',
  );
  static TextStyle categoriesHeadingStyle = TextStyle(
      fontFamily: 'JosefinSans Bold',
      fontWeight: FontWeight.w500,
      color: Get.isDarkMode
          ? const Color.fromRGBO(212, 212, 216, 1)
          : const Color(0xff475569),
      fontSize: 17.sp);

  static TextStyle myParagraphStyle = TextStyle(
      height: 1.5,
      fontFamily: 'JosefinSans Regular',
      fontWeight: FontWeight.w500,
      color: Get.isDarkMode ? const Color(0xffa1a1aa) : const Color(0xff475569),
      fontSize: 17.sp);
  static TextStyle mediumHeadingStyle = TextStyle(
    fontSize: 20.sp,
    fontFamily: 'JosefinSans Bold',
    letterSpacing: 0.2,
    fontWeight: FontWeight.w500,
    color: const Color.fromRGBO(122, 121, 121, 1),
  );

  static TextStyle popupHeadingStyle = TextStyle(
      fontSize: 13.sp,
      fontFamily: 'JosefinSans Medium',
      letterSpacing: 1,
      fontWeight: FontWeight.w400,
      color:
          Get.isDarkMode ? const Color(0xffFDFDF6) : const Color(0xff0A2647));
//==========================================================================================
  static TextTheme myTexttheme = TextTheme(
    displayLarge: GoogleFonts.josefinSans(
        fontSize: 123,
        fontWeight: FontWeight.w300,
        letterSpacing: -1.5,
        color: Get.isDarkMode
            ? Colors.white.withOpacity(0.9)
            : Colors.black.withOpacity(0.9)),
    displayMedium: GoogleFonts.josefinSans(
        fontSize: 77, fontWeight: FontWeight.w300, letterSpacing: -0.5),
    displaySmall:
        GoogleFonts.josefinSans(fontSize: 61, fontWeight: FontWeight.w400),
    headlineMedium: GoogleFonts.josefinSans(
        fontSize: 43, fontWeight: FontWeight.w400, letterSpacing: 0.25),
    headlineSmall:
        GoogleFonts.josefinSans(fontSize: 31, fontWeight: FontWeight.w400),
    titleLarge: GoogleFonts.josefinSans(
        fontSize: 26, fontWeight: FontWeight.w500, letterSpacing: 0.15),
    titleMedium: GoogleFonts.josefinSans(
        fontSize: 20, fontWeight: FontWeight.w400, letterSpacing: 0.15),
    titleSmall: GoogleFonts.josefinSans(
        fontSize: 18, fontWeight: FontWeight.w500, letterSpacing: 0.1),
    bodyLarge: GoogleFonts.josefinSans(
        fontSize: 20, fontWeight: FontWeight.w400, letterSpacing: 0.5),
    bodyMedium: GoogleFonts.josefinSans(
        fontSize: 18, fontWeight: FontWeight.w200, letterSpacing: 0.25),
    labelLarge: GoogleFonts.josefinSans(
        fontSize: 18, fontWeight: FontWeight.w200, letterSpacing: 1.25),
    bodySmall: GoogleFonts.josefinSans(
        fontSize: 15, fontWeight: FontWeight.w400, letterSpacing: 0.4),
    labelSmall: GoogleFonts.josefinSans(
        fontSize: 13, fontWeight: FontWeight.w400, letterSpacing: 1.5),
  );
}

class Mycolors {
  static Color iconColor = Get.isDarkMode
      ? const Color.fromRGBO(122, 121, 121, 1)
      : const Color.fromRGBO(176, 179, 190, 1);

  static Color myappbarcolor =
      Get.isDarkMode ? const Color(0xff0A2647) : const Color(0xffFDFDF6);
}

class MyBoxDecorations {
  static BoxDecoration listtileDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(AppLayout.getHeight(10)),
    border: Border.all(
      color: Get.isDarkMode
          ? Colors.white.withOpacity(0.1)
          : Colors.black.withOpacity(0.1),
    ),
    color: Get.isDarkMode ? Colors.black54 : Colors.white,
    boxShadow: [
      BoxShadow(
          color: Colors.grey.withOpacity(0.1),
          offset: const Offset(0, -5),
          blurRadius: 7,
          spreadRadius: 3),
      BoxShadow(
          color: Colors.grey.withOpacity(0.1),
          offset: const Offset(0, 5),
          blurRadius: 7,
          spreadRadius: 3),
    ],
  );

  static const webinarInfoTileGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      transform: GradientRotation(0.5),
      colors: [
        Colors.black38,
        Color(0xff2A5470),
        Color.fromARGB(255, 86, 92, 207),
        Color(0xff4C4177),
      ]);
}
//[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]

Color receiverChatBubbleColor =
    Get.isDarkMode ? const Color(0xff262626) : const Color(0XFFEFEFEF);

    
