import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void ShowCustomSnackBar(String message,
    {bool isError = true, title = "Error"}) {
  Get.snackbar(title, message,
      messageText: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
      titleText: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
      colorText: Colors.white,
      backgroundColor:
          isError ? Colors.red.withOpacity(0.4) : Colors.green.withOpacity(0.3),
      snackPosition: SnackPosition.TOP);
}
