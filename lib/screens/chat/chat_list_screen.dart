import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:webinarprime/controllers/auth_controller.dart';
import 'package:webinarprime/controllers/chat_controlller.dart';
import 'package:webinarprime/screens/chat/chat_screen.dart';
import 'package:webinarprime/screens/home_screen/home_screen.dart';
import 'package:webinarprime/utils/app_constants.dart';
import 'package:webinarprime/utils/styles.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen>
    with SingleTickerProviderStateMixin {
  TextEditingController searchController = TextEditingController();
  bool hideSearch = true;

  @override
  Widget build(BuildContext context) {
    print('object');
    return WillPopScope(
      onWillPop: () async {
        Get.to(() => HomeScreen(
              currIndex: 3,
            ));
        return false;
      },
      child: Scaffold(
          backgroundColor:
              Get.isDarkMode ? Colors.black : const Color(0xffffffff),
          appBar: AppBar(
            automaticallyImplyLeading: false,
            // backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            // backgroundColor:  myappbarcolor,
            backgroundColor:
                Get.isDarkMode ? Colors.black : const Color(0xffffffff),

            title: SizedBox(
              child: TextFormField(
                controller: searchController,
                style: Theme.of(context)
                    .textTheme
                    .displayMedium!
                    .copyWith(fontWeight: FontWeight.w500),
                decoration: InputDecoration(
                  hintText: 'Search. . .',
                  hintStyle: Theme.of(context)
                      .textTheme
                      .displayMedium!
                      .copyWith(fontWeight: FontWeight.w500),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.cyan),
                  ),
                ),
                onChanged: (value) {
                  setState(() {});
                },
              ),
            ),
            elevation: 0,
          ),
          body: GetBuilder<ChatStreamController>(
            builder: (controller) {
              if (ChatStreamController.userchats.isEmpty) {
                return Center(
                  child: Text(
                    'No Chats Yet',
                    style: Theme.of(context).textTheme.displayLarge!,
                  ),
                );
              }
              return ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: ChatStreamController.userchats.length,
                itemBuilder: (BuildContext context, int index) {
                  int otheruserIndex = ChatStreamController.userchats[index]
                              ['users'][0]['_id'] ==
                          Get.find<AuthController>().currentUser['_id']
                      ? 1
                      : 0;
                  print('other user index $otheruserIndex');
                  String user = ChatStreamController.userchats[index]['users']
                      [otheruserIndex]['name'];
                  if (searchController.text.isEmpty) {
                    return ElevatedButton(
                      onPressed: () async {
                        await Get.find<ChatStreamController>()
                            .GetmessagesForAconversation(
                                ChatStreamController.userchats[index]['_id']);
                        Get.to(() => ChatScreen(
                            ChatStreamController.userchats[index]['_id'],
                            ChatStreamController.userchats[index]['users']
                                [otheruserIndex]));
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        elevation: 0,
                        // backgroundColor:
                        // Theme.of(context).scaffoldBackgroundColor,
                        backgroundColor: Get.isDarkMode
                            ? Colors.black
                            : const Color(0xffffffff),
                      ),
                      child: Container(
                        margin: EdgeInsets.only(
                          top: 10.h,
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 30,
                            backgroundImage: NetworkImage(AppConstants.baseURL +
                                ChatStreamController.userchats[index]['users']
                                    [otheruserIndex]['profile_image']),
                          ),
                          title: Text(
                            ChatStreamController.userchats[index]['users']
                                [otheruserIndex]['name'],
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium!
                                .copyWith(fontWeight: FontWeight.w700),
                          ),
                          subtitle: Text(
                            ChatStreamController
                                    .userchats[index]['messages'].isEmpty
                                ? 'start a conversation'
                                : ChatStreamController.userchats[index]
                                    ['messages'][0]['text'],
                            style:
                                listtileSubtitleStyle.copyWith(fontSize: 14.sp),
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: Text(
                              "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}"),
                        ),
                      ),
                    );
                  } else if (user.contains(
                      searchController.text.toLowerCase().toString())) {
                    return ElevatedButton(
                      onPressed: () async {
                        await Get.find<ChatStreamController>()
                            .GetmessagesForAconversation(
                                ChatStreamController.userchats[index]['_id']);
                        Get.to(() => ChatScreen(
                            ChatStreamController.userchats[index]['_id'],
                            ChatStreamController.userchats[index]['users']
                                [otheruserIndex]));
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        elevation: 0,
                        // backgroundColor:
                        // Theme.of(context).scaffoldBackgroundColor,
                        backgroundColor: Get.isDarkMode
                            ? Colors.black
                            : const Color(0xffffffff),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 30,
                            backgroundImage: NetworkImage(AppConstants.baseURL +
                                ChatStreamController.userchats[index]['users']
                                    [otheruserIndex]['profile_image']),
                          ),
                          title: Text(
                            ChatStreamController.userchats[index]['users']
                                [otheruserIndex]['name'],
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium!
                                .copyWith(fontWeight: FontWeight.w500),
                          ),
                          subtitle: Text(
                            ChatStreamController
                                    .userchats[index]['messages'].isEmpty
                                ? 'start a conversation'
                                : ChatStreamController.userchats[index]
                                    ['messages'][0]['text'],
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium!
                                .copyWith(fontSize: 14.sp),
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: Text(
                              "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}"),
                        ),
                      ),
                    );
                  }
                  return Container();
                },
              );
            },
          )),
    );
  }
}
