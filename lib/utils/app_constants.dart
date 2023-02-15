import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppConstants {
  static String baseURL = 'http://10.0.2.2:5000';
  static TextStyle popmenuitemStyle = TextStyle(
      fontFamily: 'Montserrats',
      fontWeight: FontWeight.w300,
      color: Theme.of(Get.context!).colorScheme.secondary);
  static TextStyle paragraphStyle = TextStyle(
      fontFamily: 'Montserrat',
      fontSize: 15,
      fontWeight: FontWeight.w400,
      color: Theme.of(Get.context!).colorScheme.secondary);
  static TextStyle PrimarayheadingStyle = TextStyle(
      fontFamily: 'Montserrat-Bold',
      fontSize: 25,
      fontWeight: FontWeight.w600,
      color: Theme.of(Get.context!).colorScheme.secondary);
  static TextStyle secondaryHeadingStyle = TextStyle(
      fontFamily: 'Montserrat-Bold',
      fontSize: 20,
      fontWeight: FontWeight.w400,
      color: Theme.of(Get.context!).colorScheme.secondary);
}
