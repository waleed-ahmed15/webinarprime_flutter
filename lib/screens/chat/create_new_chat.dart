import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:webinarprime/controllers/auth_controller.dart';
import 'package:webinarprime/controllers/chat_controlller.dart';
import 'package:webinarprime/screens/chat/chat_screen.dart';
import 'package:webinarprime/utils/app_constants.dart';
import 'package:webinarprime/utils/styles.dart';

class CreateNewChat extends StatefulWidget {
  const CreateNewChat({super.key});

  @override
  State<CreateNewChat> createState() => _CreateNewChatState();
}

class _CreateNewChatState extends State<CreateNewChat> {
  TextEditingController serachcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Mycolors.myappbarcolor,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: serachcontroller,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search_sharp),
                  color: Mycolors.iconColor,
                  iconSize: 30.h,
                  onPressed: () async {
                    if (serachcontroller.text.trim().isEmpty) {
                      return;
                    }

                    await Get.find<AuthController>()
                        .searchUserAll(serachcontroller.text.trim());
                    print('object--------------------------');
                    // setState(() {});
                  },
                ),
                hintText: 'Search. . .',
                hintStyle: Mystyles.myhintTextstyle,
                border: InputBorder.none,
              ),
              // style: const TextStyle(color: Colors.white),
            ),
          )),
      body: GetBuilder<AuthController>(builder: (controller) {
        if (controller.searchedUsers.isEmpty) {
          return const Center(
            child: Text('No Users Found'),
          );
        }
        return ListView.builder(
          itemCount: Get.find<AuthController>().searchedUsers.length,
          itemBuilder: (context, index) {
            return Container(
              decoration:
                  MyBoxDecorations.listtileDecoration.copyWith(boxShadow: []),
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: ElevatedButton(
                onPressed: () async {
                  await Get.find<ChatStreamController>().createNewConversation([
                    await Get.find<AuthController>().searchedUsers[index]
                        ['_id'],
                    await Get.find<AuthController>().currentUser['id']
                  ]);
                  await Get.find<ChatStreamController>()
                      .GetmessagesForAconversation(
                          ChatStreamController.userchats[0]['_id']);
                  // find index of receiver in userchats
                  int otheruserIndex = await ChatStreamController.userchats[0]
                              ['users'][0]['_id'] ==
                          await Get.find<AuthController>().currentUser['id']
                      ? 1
                      : 0;
                  Get.find<AuthController>().searchedUsers.clear();

                  Get.to(() => ChatScreen(
                      ChatStreamController.userchats[0]['_id'],
                      ChatStreamController.userchats[0]['users']
                          [otheruserIndex]));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(AppConstants.baseURL +
                        Get.find<AuthController>().searchedUsers[index]
                            ['profile_image']),
                  ),
                  title: Text(
                    Get.find<AuthController>().searchedUsers[index]['name'],
                    style: Mystyles.listtileTitleStyle,
                  ),
                  subtitle: Text(
                    Get.find<AuthController>().searchedUsers[index]['email'],
                    style: Mystyles.listtileSubtitleStyle,
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
