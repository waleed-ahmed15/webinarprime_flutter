import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webinarprime/controllers/auth_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SharedPreferences sharedPreferences = Get.find();
    AuthController authController = Get.find();
    authController
        .authenticateUser(sharedPreferences.getString('token') != null);
    print(authController.currentUser);
    // if (!authController.currentUser.containsKey('registration_number')) {
    //   Get.offAllNamed(RoutesHelper.uploadProfileRoute);
    // }
    // print('hereerrer');
    // print(authController.currentUser['registration_number']!);

    return Scaffold(
      appBar: AppBar(
        actions: [
          GestureDetector(
            child: const Icon(Icons.logout_outlined),
            onTap: () {
              authController.logout();
            },
          )
        ],
        title: const Text('Home Screen'),
      ),
      body: Container(
        child: const Text("sharedPreferences.getString('token')!"),
      ),
    );
  }
}
