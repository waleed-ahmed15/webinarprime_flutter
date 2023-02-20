import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webinarprime/utils/dimension.dart';

class Mystyles {
  static const TextStyle title = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );
  static const TextStyle subtitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );
  static const TextStyle body = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: Colors.black,
  );
  static const TextStyle body2 = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: Colors.black,
  );
  static const TextStyle body3 = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.normal,
    color: Colors.black,
  );
  static const TextStyle body4 = TextStyle(
    fontSize: 8,
    fontWeight: FontWeight.normal,
    color: Colors.black,
  );
  static TextStyle tabTextstyle = TextStyle(
    letterSpacing: 1,
    height: 1.5,
    fontSize: AppLayout.getHeight(12),
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
      fontSize: AppLayout.getHeight(18),
      fontFamily: 'JosefinSans Regular');
}

class mycolors {
  static Color iconColor = Get.isDarkMode
      ? const Color.fromRGBO(122, 121, 121, 1)
      : const Color.fromRGBO(176, 179, 190, 1);
}
