import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void ShowCustomSnackBar(String message,
    {bool isError = true, title = "Error"}) {
  Get.snackbar(title, message,
      messageText: Text(
        message,
        style: TextStyle(color: Colors.white),
      ),
      titleText: Text(
        title,
        style: TextStyle(color: Colors.white),
      ),
      colorText: Colors.white,
      backgroundColor:
          isError ? Colors.red.withOpacity(0.8) : Colors.green.withOpacity(0.3),
      snackPosition: SnackPosition.TOP);
}
