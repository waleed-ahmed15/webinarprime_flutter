import 'package:get/get.dart';

class PagesNav extends GetxController {
  static int chatPagesindex = 0;
  

  Future<void> updateChat(int index) async {
    chatPagesindex = index;
    update();
  }
}
