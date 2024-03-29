import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:webinarprime/controllers/auth_controller.dart';
import 'package:webinarprime/controllers/webinar_management_controller.dart';
import 'package:webinarprime/utils/colors.dart';
import 'package:webinarprime/utils/dimension.dart';
import 'package:webinarprime/utils/styles.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 1, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
          elevation: 0,
          backgroundColor: Colors.transparent,
          bottom: TabBar(
              indicatorColor: AppColors.LTprimaryColor,
              controller: _tabController,
              // labelStyle:  tabTextstyle,
              tabs: [
                // Tab(
                // child: Text(
                // 'Notifications',
                // style: Theme.of(context).textTheme.headlineMedium,
                // ),
                // ),
                Tab(
                  child: Text(
                    'Invitations',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
              ]),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            // const Center(child: Text('notifications')),
            GetBuilder<AuthController>(builder: (controller) {
              print('tab2');
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: controller.currentUserInvitations
                      .map((e) => Container(
                            margin: const EdgeInsets.all(10),
                            decoration: listtileDecoration,
                            child: Column(
                              children: [
                                ListTile(
                                  title: Text(
                                    e['webinar']['name'] + '',
                                    style: listtileSubtitleStyle,
                                  ),
                                  subtitle: Text(
                                    "Role: " + e['role'],
                                    style: listtileSubtitleStyle,
                                  ),
                                  trailing: Text(
                                    e['status'],
                                    style: listtileSubtitleStyle,
                                  ),
                                ),
                                Gap(AppLayout.getHeight(10)),
                                Row(
                                  // mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Gap(AppLayout.getWidth(10)),
                                    ElevatedButton(
                                      onPressed: () {
                                        print('accept pressed');
                                        controller.acceptInvitation(e['_id']);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green,
                                      ),
                                      child: Text(
                                        'Accept',
                                        style: TextStyle(
                                            fontSize: AppLayout.getHeight(13),
                                            fontFamily: 'JosefinSans Bold',
                                            letterSpacing: 1),
                                      ),
                                    ),
                                    Gap(AppLayout.getWidth(10)),
                                    ElevatedButton(
                                        onPressed: () async {
                                          print('decline pressed');
                                          bool removed = await Get.find<
                                                  WebinarManagementController>()
                                              .removeWebinarMember(
                                                  memeberId: e['_id']);
                                          if (removed) {
                                            controller.currentUserInvitations
                                                .remove(e);
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          animationDuration:
                                              const Duration(seconds: 3),
                                          backgroundColor: Colors.red,
                                        ),
                                        child: Text(
                                          'Decline',
                                          style: TextStyle(
                                              fontSize: AppLayout.getHeight(13),
                                              fontFamily: 'JosefinSans Bold',
                                              letterSpacing: 1),
                                        )),
                                  ],
                                ),
                              ],
                            ),
                          ))
                      .toList(),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
