import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:webinarprime/controllers/chat_controlller.dart';
import 'package:webinarprime/screens/chatbot/chatbot_Textfield.dart';
import 'package:webinarprime/utils/colors.dart';

class ChatBotScreen extends StatefulWidget {
  const ChatBotScreen({super.key});

  @override
  State<ChatBotScreen> createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    var isloading = true.obs;
    return Scaffold(
      backgroundColor: Get.isDarkMode ? Colors.black : const Color(0xffffffff),
      appBar: AppBar(
        elevation: 0,
        leading: Row(
          children: [
            Gap(10.w),
            CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: 20.r,
              backgroundImage: const AssetImage('assets/image/chatbot4.png'),
            ),
          ],
        ),
        title: Text(
          'ChatterBot',
          style: Theme.of(context).textTheme.displayMedium!.copyWith(
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
                color: Get.isDarkMode
                    ? Colors.white.withOpacity(0.9)
                    : Colors.black.withOpacity(0.9),
              ),
        ),
      ),
      body: Column(
        children: [
          GetX<ChatStreamController>(builder: (context) {
            return Expanded(
              child: ListView.builder(
                padding: EdgeInsets.only(
                  bottom: 50.h,
                ),
                controller: _scrollController,
                itemCount: ChatStreamController.chatbotconversation.length,
                itemBuilder: (context, index) {
                  return Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 4.h,
                    ),
                    child: Row(
                      mainAxisAlignment: ChatStreamController
                                  .chatbotconversation[index]['type'] !=
                              'chatbot'
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 5.w,
                                vertical: 5.h,
                              ),
                              decoration: BoxDecoration(
                                color: ChatStreamController
                                                .chatbotconversation[index]
                                            ['type'] ==
                                        'chatbot'
                                    ? AppColors.LTprimaryColor.withOpacity(0.9)
                                    : const Color(0xff4c51d9),
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              child: Container(
                                constraints: BoxConstraints(
                                  minWidth: 0.05.sw,
                                  maxWidth: 0.7.sw,
                                ),
                                // width: 0.5.sw,
                                child: ExpandableText(
                                  maxLines: 4,
                                  linkColor: Colors.blue,
                                  expandText: '',
                                  expandOnTextTap: true,
                                  collapseOnTextTap: true,
                                  collapseText: '',
                                  ChatStreamController
                                      .chatbotconversation[index]['text'],
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayMedium!
                                      .copyWith(
                                          fontSize: 14.sp, color: Colors.white),
                                ),
                              ),
                            ),
                            Gap(5.h),
                            if (ChatStreamController.chatbotconversation[index]
                                    ['type'] ==
                                'chatbot')
                              Container(
                                width: 17.w,
                                height: 17.h,
                                decoration: const BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage(
                                            'assets/image/chatbot4.png'))),
                              ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          }),
          ChatBotTextField(_scrollController),
        ],
      ),
    );
  }
}
