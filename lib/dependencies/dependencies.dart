import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webinarprime/controllers/auth_controller.dart';
import 'package:webinarprime/controllers/categoryController.dart';
import 'package:webinarprime/controllers/chat_controlller.dart';
import 'package:webinarprime/controllers/reviews_controlller.dart';
import 'package:webinarprime/controllers/webinar_stream_controller.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:webinarprime/utils/app_constants.dart';

import '../controllers/webinar_management_controller.dart';

Future<void> innit() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  final IO.Socket socket = IO.io(AppConstants.baseURL,
      IO.OptionBuilder().setTransports(['websocket']).build());
  socket.onConnect((data) => print(' socket connected'));
  Get.put(socket, permanent: true);
  Get.put(sharedPreferences, permanent: true);
  Get.put(AuthController(), permanent: true);
  Get.put(CategoryContorller());
  Get.put(WebinarManagementController());
  Get.put(WebinarStreamController());
  Get.put(ChatStreamController(), permanent: true);
  Get.put(ReviewController(), permanent: true);
  // Get.lazyPut(() => AuthController(), fenix: true);
  // Get.lazyPut(() => sharedPreferences);
  // Get.lazyPut(() => AuthController());
}
