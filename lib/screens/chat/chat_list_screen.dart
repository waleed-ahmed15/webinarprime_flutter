import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:webinarprime/controllers/auth_controller.dart';
import 'package:webinarprime/controllers/chat_controlller.dart';
import 'package:webinarprime/screens/chat/chat_screen.dart';
import 'package:webinarprime/screens/chat/create_new_chat.dart';
import 'package:webinarprime/screens/home_screen/home_screen.dart';
import 'package:webinarprime/utils/app_constants.dart';
import 'package:webinarprime/utils/styles.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  TextEditingController searchController = TextEditingController();
  bool hideSearch = true;

  // List<String> users = [
  //   'ali',
  //   'ahmed',
  //   'mohamed',
  //   'umar',
  //   'hazim',
  //   'kk',
  //   'sdk',
  //   'xami',
  //   'issam'
  // ];

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
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              Get.to(() => const CreateNewChat());
              // await ChatStreamController().createNewConversation(
              // ["63ea1f91bb071d3c3298000f", "63ea1fc7bb071d3c32980017"]);

              // print(Get.find<AuthController>().currentUser['id']);
              ChatStreamController().getConversations(
                  Get.find<AuthController>().currentUser['id']);
            },
            child: const Icon(Icons.add),
          ),
          appBar: AppBar(
            automaticallyImplyLeading: false,
            // backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            backgroundColor: Mycolors.myappbarcolor,
            title: SizedBox(
              child: TextFormField(
                controller: searchController,
                style: Mystyles.bigTitleStyle
                    .copyWith(fontSize: 18.sp, fontWeight: FontWeight.w500),
                decoration: InputDecoration(
                  hintText: 'Search. . .',
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 19.sp,
                  ),
                  border: InputBorder.none,
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
                    style: Mystyles.bigTitleStyle,
                  ),
                );
              }
              return ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: ChatStreamController.userchats.length,
                itemBuilder: (BuildContext context, int index) {
                  int otheruserIndex = ChatStreamController.userchats[index]
                              ['users'][0]['_id'] ==
                          Get.find<AuthController>().currentUser['id']
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
                          backgroundColor:
                              Theme.of(context).scaffoldBackgroundColor),
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
                            style: Mystyles.listtileTitleStyle
                                .copyWith(fontWeight: FontWeight.w500),
                          ),
                          subtitle: Text(
                            ChatStreamController
                                    .userchats[index]['messages'].isEmpty
                                ? 'start a conversation'
                                : ChatStreamController.userchats[index]
                                    ['messages'][0]['text'],
                            style: Mystyles.listtileTitleStyle
                                .copyWith(fontSize: 14.sp),
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: Text(
                              "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}"),
                        ),
                      ),
                    );
                  } else if (user.contains(
                      searchController.text.toLowerCase().toString())) {
                    return Padding(
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
                          style: Mystyles.listtileTitleStyle
                              .copyWith(fontWeight: FontWeight.w500),
                        ),
                        subtitle: Text(
                          ChatStreamController
                                  .userchats[index]['messages'].isEmpty
                              ? 'start a conversation'
                              : ChatStreamController.userchats[index]
                                  ['messages'][0]['text'],
                          style: Mystyles.listtileTitleStyle
                              .copyWith(fontSize: 14.sp),
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: Text(
                            "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}"),
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
