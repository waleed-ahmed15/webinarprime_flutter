import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:webinarprime/controllers/auth_controller.dart';
import 'package:webinarprime/controllers/chat_controlller.dart';
import 'package:webinarprime/controllers/pages_nav_controller.dart';
import 'package:webinarprime/controllers/webinar_stream_controller.dart';
import 'package:webinarprime/screens/chat/chat_field_widget.dart';
import 'package:webinarprime/screens/chat/file_message_view_widget.dart';
import 'package:webinarprime/screens/chat/image_Viewer_widget.dart';
import 'package:webinarprime/screens/home_screen/home_screen.dart';
import 'package:webinarprime/screens/report%20screen/report_screen.dart';
import 'package:webinarprime/utils/app_constants.dart';
import 'package:webinarprime/utils/styles.dart';

class ChatScreen extends StatefulWidget {
  final Map<String, dynamic> receiever;
  final String ConversationId;
  const ChatScreen(this.ConversationId, this.receiever, {super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ScrollController _scrollController = ScrollController();
  late String? currentDate;
  bool fullScreen = false;
  // final IO.Socket socket = Get.find<IO.Socket>();

  bool messageEmpty = true;

  Future<void> _showSimpleDialogForDeleteConversation() async {
    await showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.h),
              width: 0.6.sw,
              height: 140.h,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Are you sure you want to delete this conversation?',
                    style: Theme.of(context).textTheme.displayMedium!,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      SimpleDialogOption(
                        onPressed: () async {
                          Navigator.of(context).pop();
                          await Get.find<ChatStreamController>()
                              .deleteConversation(widget.ConversationId);
                          Get.to(() => HomeScreen(
                                currIndex: 3,
                              ));
                          ChatStreamController.userchats.removeWhere(
                              (element) =>
                                  element['_id'] == widget.ConversationId);
                          ChatStreamController.userChatmessages
                              .remove(widget.ConversationId);

                          Get.find<ChatStreamController>().update();

                          Get.find<ChatStreamController>().getConversations(
                              Get.find<AuthController>().currentUser['_id']);
                        },
                        child: Text(
                          'Delete',
                          style:
                              listtileSubtitleStyle.copyWith(color: Colors.red),
                        ),
                      ),
                      SimpleDialogOption(
                        onPressed: () {
                          Get.back();
                        },
                        child: Text('Cancel', style: listtileSubtitleStyle),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });

    Get.find<IO.Socket>().on('conversationChatMessage', (data) async {
      if (data['conversation']['_id'] != widget.ConversationId &&
          data['user'] == Get.find<AuthController>().currentUser['_id']) {
        // ShowCustomSnackBar(widget.ConversationId,
        // title: data['conversation']['_id'], isError: true);
        await Get.find<WebinarStreamController>()
            .showMessageNotifications(data, widget.ConversationId);
      }

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    });

    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    // socket.dispose();

    _scrollController.dispose();
    // Get.find<IO.Socket>().off('conversationChatMessage');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // print(widget.receiever);
    // print(widget.ConversationId);
    return WillPopScope(
      onWillPop: () async {
        Get.find<PagesNav>().updateChat(0);

        // PersistentNavBarNavigator.pushNewScreen(context, screen: HomeScreen)
        Get.offAll(() => HomeScreen(
              currIndex: 3,
            ));
        // Get.back();

        return false;
        // return true;
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor:
              Get.isDarkMode ? Colors.black : const Color(0xffffffff),
          appBar: AppBar(
            automaticallyImplyLeading: true,
            title: AutoSizeText(
              widget.receiever['name'].split(' ')[0],
              style: Theme.of(context)
                  .textTheme
                  .displayMedium!
                  .copyWith(fontSize: 20.sp),
            ),
            centerTitle: false,
            // backgroundColor:  myappbarcolor,
            backgroundColor:
                Get.isDarkMode ? Colors.black : const Color(0xffffffff),
            elevation: 0,
            leading: Row(
              children: [
                Gap(10.w),
                CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: 20.r,
                  backgroundImage: NetworkImage(
                      AppConstants.baseURL + widget.receiever['profile_image']),
                ),
              ],
            ),
            actions: [
              //report user button
              IconButton(
                onPressed: () async {
                  Get.to(() => ReportScreen(
                        reportType: 'chat',
                        reportedUserId: widget.receiever['_id'],
                      ));
                  // print('wanna report');
                  // await Get.find<ChatStreamController>().reportUser(
                  // widget.receiever['_id'],
                  // );
                },
                icon: const Icon(
                  Icons.report,
                  color: Colors.red,
                ),
              ),
              IconButton(
                onPressed: () async {
                  // print('wanna delete');
                  await _showSimpleDialogForDeleteConversation();
                },
                icon: const Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
              ),
              GetBuilder<ChatStreamController>(builder: (controller) {
                if (Get.find<AuthController>()
                    .currentUser['bannedChats']
                    .contains(
                      widget.receiever['_id'],
                    )) {
                  return IconButton(
                    onPressed: () async {
                      await Get.find<ChatStreamController>().unbanUser(
                        widget.receiever['_id'],
                        widget.ConversationId,
                      );
                    },
                    icon: Icon(
                      Icons.person,
                      color: Get.isDarkMode ? Colors.white : Colors.black,
                    ),
                  );
                }
                return IconButton(
                  onPressed: () async {
                    // print('ban user');
                    // print(widget.receiever['_id']);
                    // print(widget.receiever['name']);
                    await Get.find<ChatStreamController>().banUser(
                        widget.receiever['_id'], widget.ConversationId);
                  },
                  icon: Icon(
                    Icons.block,
                    color: Get.isDarkMode ? Colors.white : Colors.black,
                  ),
                );
              }),
            ],
          ),
          body: Column(
            children: [
              Gap(10.h),
              Expanded(child:
                  GetBuilder<ChatStreamController>(builder: (controllerChat) {
                String mycurrentDate = '';
                return ListView.builder(
                  controller: _scrollController,
                  physics: const BouncingScrollPhysics(),
                  itemCount: ChatStreamController.userChatmessages
                          .containsKey(widget.ConversationId)
                      ? ChatStreamController
                          .userChatmessages[widget.ConversationId].length
                      : 0,
                  itemBuilder: (BuildContext context, int index) {
                    // all logic for formmating goes Here

                    bool addDate = false;
                    DateTime date = DateTime.parse(ChatStreamController
                            .userChatmessages[widget.ConversationId][index]
                        ['createdAt']);
                    String formmattedDateTime =
                        DateFormat('dd/MM/yy, hh:mm').format(date);
                    // print(ChatStreamController
                    //         .userChatmessages[widget.ConversationId][index]
                    //     ['from']['_id']);
                    // print(Get.find<AuthController>().currentUser['_id']);
                    bool issender = false;
                    if (ChatStreamController
                                .userChatmessages[widget.ConversationId][index]
                            ['from']['_id'] ==
                        Get.find<AuthController>().currentUser['_id']) {
                      issender = true;
                      // print('sender');
                    }
                    if (index == 0) {
                      addDate = true;
                    } else if (mycurrentDate != formmattedDateTime) {
                      addDate = true;
                    }
                    mycurrentDate = formmattedDateTime;

                    // print(formmattedDateTime);

                    // print(date);
                    return Container(
                      margin: EdgeInsets.only(
                        top: 1.h,
                        left: 10.w,
                        right: 10.w,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          addDate
                              ? Padding(
                                  padding: EdgeInsets.only(
                                    bottom: 5.h,
                                  ),
                                  child: Center(
                                      child: Text(formmattedDateTime,
                                          style: popupHeadingStyle)),
                                )
                              : const SizedBox(),
                          Row(
                            mainAxisAlignment: issender
                                ? MainAxisAlignment.end
                                : MainAxisAlignment.start,
                            children: [
                              // Text(ChatStreamController
                              //     .userChatmessages[widget.ConversationId][index]
                              //         ['text']
                              //     .toString()),

                              Container(
                                margin: EdgeInsets.only(top: 2.h, bottom: 2.h),
                                // padding: EdgeInsets.symmetric(
                                //     horizontal: 7.w, vertical: 3.h),
                                decoration: BoxDecoration(
                                  color: issender
                                      ? const Color(0xff4c51d9)
                                      : receiverChatBubbleColor,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10.w),
                                    topRight: Radius.circular(10.w),
                                    bottomLeft: Radius.circular(10.w),
                                    bottomRight: Radius.circular(10.w),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    ChatStreamController.userChatmessages[
                                                    widget.ConversationId]
                                                [index]['file'] !=
                                            null
                                        ? ChatStreamController.userChatmessages[
                                                    widget.ConversationId]
                                                    [index]['file']['mimetype']
                                                .contains('image')
                                            ? ImageMessageContainer(
                                                imageUrl: AppConstants.baseURL +
                                                    ChatStreamController
                                                                .userChatmessages[
                                                            widget
                                                                .ConversationId]
                                                        [index]['file']['path'],
                                              )
                                            : MyFileMessage(
                                                sender: true,
                                                fileName: ChatStreamController
                                                            .userChatmessages[
                                                        widget.ConversationId]
                                                    [index]['file']['filename'],
                                                fileUrl: AppConstants.baseURL +
                                                    ChatStreamController
                                                                .userChatmessages[
                                                            widget
                                                                .ConversationId]
                                                        [index]['file']['path'],
                                              )
                                        : Container(
                                            margin: EdgeInsets.zero,
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 7.w, vertical: 3.h),
                                            constraints: BoxConstraints(
                                              maxWidth: 0.5.sw,
                                            ),
                                            child: ExpandableText(
                                              maxLines: 6,
                                              linkColor: Colors.blue,
                                              expandText: '',
                                              expandOnTextTap: true,
                                              collapseOnTextTap: true,
                                              collapseText: '',
                                              ChatStreamController
                                                  .userChatmessages[
                                                      widget.ConversationId]
                                                      [index]['text']
                                                  .toString(),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .displayMedium!
                                                  .copyWith(
                                                    color: issender //sender
                                                        ? Colors.white
                                                        : Theme.of(context)
                                                            .textTheme
                                                            .displayLarge!
                                                            .color,
                                                    fontSize: 16.sp,
                                                  ),
                                              textAlign: TextAlign.start,
                                            ),
                                          ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
              })),
              GetBuilder<ChatStreamController>(builder: (controller) {
                if (Get.find<AuthController>()
                    .currentUser['bannedChats']
                    .contains(
                      widget.receiever['_id'],
                    )) {
                  return const SizedBox(
                      child: Text('you Have  blocked this user'));
                }
                if (widget.receiever['bannedChats']
                    .contains(Get.find<AuthController>().currentUser['_id'])) {
                  return const SizedBox(child: Text('you have been blocked'));
                }
                return ChatFieldWidget(
                  onSend: sendPressed,
                  oncameraPressed: _handleImageSelection,
                  onAttachPressed: handlefileAttachment,
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  void sendPressed(String message) async {
    if (message.isNotEmpty) {
      // print(message);
      // print(Get.find<AuthController>().currentUser['_id']);
      Map<String, dynamic> messageMap = {
        "message": {
          "from": Get.find<AuthController>().currentUser['_id'],
          "text": message,
        }
      };
      await Get.find<ChatStreamController>()
          .sendMessage(widget.ConversationId, messageMap);
    }

    print('send pressed');
  }

  void _handleImageSelection() async {
    final result = await ImagePicker().pickImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: ImageSource.gallery,
    );

    if (result != null) {
      print(result.path);
      // final bytes = await result.readAsBytes();
      // final image = await decodeImageFromList(bytes);
      // print(bytes);
      File imageFile = File(result.path);
      // print(imageFile.path);
      await ChatStreamController().sendFileMessage(widget.ConversationId,
          File(result.path), Get.find<AuthController>().currentUser['_id'], '');
      // List<int> imageBytes = await imageFile.readAsBytes();
      // String base64Image = base64Encode(imageBytes);
      // print(base64Image);
    }
  }

  void handlefileAttachment() async {
    FilePickerResult? result2 = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: false,
      allowedExtensions: ['jpg', 'pdf', 'doc'],
    );
    print(result2!.files.single.path);
    File file = File(result2.files.single.path!);
    await ChatStreamController().sendFileMessage(
        widget.ConversationId,
        file,
        Get.find<AuthController>().currentUser['_id'],
        result2.files.single.name);
  }
}
