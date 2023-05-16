import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyThemeController extends GetxController {
  // By default, use light theme
  var isDarkMode = false.obs;

  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }
}
