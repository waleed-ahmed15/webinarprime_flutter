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
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Text(
          "Banned Chats",
          style: Mystyles.mediumHeadingStyle,
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
                  decoration: MyBoxDecorations.listtileDecoration.copyWith(
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
                      style: Mystyles.listtileTitleStyle,
                    ),
                    subtitle: Text(
                      AuthController.bannedChats[index]['email'],
                      style: Mystyles.listtileTitleStyle,
                    ),
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.person_remove,
                        color: Colors.red,
                      ),
                      onPressed: () async {
                        await Get.find<ChatStreamController>().unbanUser(
                            AuthController.bannedChats[index]['_id']);
                        AuthController.bannedChats.removeAt(index);
                        Get.find<AuthController>().update(['bannedchats']);
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