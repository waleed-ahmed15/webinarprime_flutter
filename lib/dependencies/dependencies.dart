import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webinarprime/controllers/auth_controller.dart';
import 'package:webinarprime/controllers/categoryController.dart';

import '../controllers/webinar_management_controller.dart';

Future<void> innit() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  Get.put(sharedPreferences, permanent: true);
  Get.put(AuthController(), permanent: true);
  Get.put(CategoryContorller());
  Get.put(WebinarManagementController());
  // Get.lazyPut(() => AuthController(), fenix: true);
  // Get.lazyPut(() => sharedPreferences);
  // Get.lazyPut(() => AuthController());
}
