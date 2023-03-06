import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AppConstants {
  // static String baseURL = 'http://10.113.30.19:5000';
  static const String baseURL = 'http://10.0.2.2:5000';
  static const String liveKitUrl = 'ws://10.0.2.2:7880';
  static TextStyle popmenuitemStyle = TextStyle(
      fontFamily: 'Montserrats',
      fontWeight: FontWeight.w300,
      color: Theme.of(Get.context!).colorScheme.secondary);
  static TextStyle paragraphStyle = TextStyle(
      fontFamily: 'Montserrat',
      fontSize: 15.sp,
      fontWeight: FontWeight.w400,
      color: Theme.of(Get.context!).colorScheme.secondary);
  static TextStyle PrimarayheadingStyle = TextStyle(
      fontFamily: 'Montserrat-Bold',
      fontSize: 25,
      fontWeight: FontWeight.w600,
      color: Theme.of(Get.context!).colorScheme.primary);
  static TextStyle secondaryHeadingStyle = TextStyle(
      fontFamily: 'Montserrat-Bold',
      fontSize: 20,
      fontWeight: FontWeight.w400,
      color: Theme.of(Get.context!).colorScheme.secondary);
}
