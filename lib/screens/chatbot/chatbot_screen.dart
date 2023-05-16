import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:webinarprime/controllers/auth_controller.dart';
import 'package:webinarprime/controllers/chat_controlller.dart';
import 'package:webinarprime/screens/analytics_screen/bar_charts.dart';
import 'package:webinarprime/screens/chatbot/chatbot_Textfield.dart';
import 'package:webinarprime/screens/home_screen/home_screen.dart';
import 'package:webinarprime/screens/profile_view/edit_profile.dart';
import 'package:webinarprime/screens/profile_view/favourites_screen.dart';
import 'package:webinarprime/screens/webinar_management/add_webinar_screens/add_webinar_screen1.dart';
import 'package:webinarprime/screens/webinar_marketing/created_webinars_screen.dart';
import 'package:webinarprime/utils/colors.dart';
import 'package:webinarprime/utils/styles.dart';

import '../../controllers/webinar_management_controller.dart';
import '../../routes/routes.dart';
import '../my_webinars/unapproved_webinar_screen.dart';

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
                                        ['screen'] !=
                                    'no-screen' &&
                                ChatStreamController.chatbotconversation[index]
                                        ['type'] ==
                                    'chatbot')
                              InkWell(
                                onTap: () async {
                                  String screen = ChatStreamController
                                      .chatbotconversation[index]['screen'];
                                  print('screen is $screen');
                                  if (screen == 'create-new-webinar') {
                                    if (Get.find<AuthController>()
                                            .currentUser['accountType'] ==
                                        'organizer') {
                                      Get.to(() => const AddWebinarScreen1());
                                    } else {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: Text(
                                            'You are not authorized to create a webinar',
                                            style: myParagraphStyle,
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Get.back();
                                              },
                                              child: const Text('Ok'),
                                            )
                                          ],
                                        ),
                                      );
                                    }
                                  } else if (screen == 'graphs-screen') {
                                    if (Get.find<AuthController>()
                                            .currentUser['accountType'] ==
                                        'organizer') {
                                      await Get.find<
                                              WebinarManagementController>()
                                          .getUserWebinarAnalytics();
                                      Get.to(() => WebinarStats());
                                    } else {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: Text(
                                            'You are not authorized to view webinar stats',
                                            style: myParagraphStyle,
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Get.back();
                                              },
                                              child: const Text('Ok'),
                                            )
                                          ],
                                        ),
                                      );
                                    }
                                  } else if (screen == 'profile-screen') {
                                    Get.to(() => const EditProfileScreen());
                                  } else if (screen == 'invitation-screen') {
                                    Get.toNamed(
                                        RoutesHelper.notificationScreenRoute);
                                  } else if (screen ==
                                      'pendingwebinar-screen') {
                                    if (Get.find<AuthController>()
                                            .currentUser['accountType'] ==
                                        'organizer') {
                                      await Get.find<
                                              WebinarManagementController>()
                                          .getUnapprovedWebinars();
                                      Get.to(() =>
                                          const UnApprovedWebinarsScreen());
                                    } else {
                                      print('not authorized');
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: Text(
                                            'You are not authorized to view pending webinars',
                                            style: myParagraphStyle,
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Get.back();
                                              },
                                              child: const Text('Ok'),
                                            )
                                          ],
                                        ),
                                      );
                                    }
                                  } else if (screen == 'search-screen') {
                                    Get.to(() => HomeScreen(
                                          currIndex: 1,
                                        ));
                                  } else if (screen == 'marketing-screen') {
                                    Get.to(() => const CreatedWebinarList());
                                  } else if (screen == 'favorite-screen') {
                                    Get.to(() => const FavoriteWebinars());
                                  }
                                },
                                child: Text(
                                  'Tap here to Navigate',
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayMedium!
                                      .copyWith(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.blue,
                                          decoration: TextDecoration.underline),
                                ),
                              ),
                            const Gap(10),
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
