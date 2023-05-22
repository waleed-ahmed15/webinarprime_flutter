import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:webinarprime/controllers/auth_controller.dart';
import 'package:webinarprime/controllers/chat_controlller.dart';
import 'package:webinarprime/utils/app_constants.dart';
import 'package:webinarprime/utils/styles.dart';

class BannedChats extends StatelessWidget {
  const BannedChats({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.isDarkMode
          ? Colors.black.withOpacity(0.4)
          : const Color(0xffffffff),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Get.isDarkMode
            ? Colors.black.withOpacity(0.4)
            : const Color(0xffffffff),
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Text(
          "Banned Chats",
          style: mediumHeadingStyle.copyWith(
            color: Get.isDarkMode ? Colors.white : Colors.black,
          ),
        ),
      ),
      body: GetBuilder<AuthController>(
          assignId: true,
          id: 'bannedchats',
          builder: (context) {
            return ListView.builder(
              padding: EdgeInsets.only(left: 10.w, right: 10.w, top: 10.h),
              itemCount: AuthController.bannedChats.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  margin: EdgeInsets.only(bottom: 10.h),
                  decoration: listtileDecoration.copyWith(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 0.5,
                        blurRadius: 3,
                        offset:
                            const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 30.r,
                      backgroundImage: NetworkImage(AppConstants.baseURL +
                          AuthController.bannedChats[index]['profile_image']),
                    ),
                    title: Text(
                      AuthController.bannedChats[index]['name'],
                      style: Theme.of(context).textTheme.displayMedium!,
                    ),
                    subtitle: Text(
                      AuthController.bannedChats[index]['email'],
                      style: Theme.of(context).textTheme.displayMedium!,
                    ),
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.person_remove,
                        color: Colors.red,
                      ),
                      onPressed: () async {
                        // print(ChatStreamController.userchats[index]);
                        // print(AuthController.bannedChats[index]['name']);

                        for (var element in ChatStreamController.userchats) {
                          // print(element);
                          if (element['users'][0]['_id'] ==
                              AuthController.bannedChats[index]['_id']) {
                            print('found');
                            print(element['users'][0]['_id']);
                            print(element['users'][1]['_id']);
                            print(element['_id']);
                            await Get.find<ChatStreamController>().unbanUser(
                                element['users'][0]['_id'], element['_id']);
                            AuthController.bannedChats.removeAt(index);
                            Get.find<AuthController>().update(['bannedchats']);

                            break;

                            // await Get.find<ChatStreamController>().unbanUser(
                            // element['_id'], element['users'][1]['_id']);
                          } else if (element['users'][1]['_id'] ==
                              AuthController.bannedChats[index]['_id']) {
                            await Get.find<ChatStreamController>().unbanUser(
                                element['users'][0]['_id'], element['_id']);
                            AuthController.bannedChats.removeAt(index);
                            Get.find<AuthController>().update(['bannedchats']);

                            break;
                          }
                          // if (element['name'] ==
                          // AuthController.bannedChats[index]['name']) {
                          // print(element['name']);
                          // print(element['_id']);
                          // Get.find<ChatStreamController>().unbanUser(
                          // element['_id'], element['name']);
                          // }
                        }
                        // print(AuthController.bannedChats[index]['_id']);
                        // await Get.find<ChatStreamController>().unbanUser(
                        // AuthController.bannedChats[index]['_id'],AuthController.bannedChats[index]['']);
                      },
                    ),
                  ),
                );
              },
            );
          }),
    );
  }
}
