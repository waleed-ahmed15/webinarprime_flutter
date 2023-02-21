import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:webinarprime/controllers/auth_controller.dart';
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
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    print('awdawdawdad');
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print('pressed');
          Get.find<AuthController>().getInvitations('63ea2153bb071d3c3298002d');
        },
      ),
      appBar: AppBar(
        bottom: TabBar(
            controller: _tabController,
            // labelStyle: Mystyles.tabTextstyle,
            tabs: [
              Tab(
                child: Text(
                  'Notifications',
                  style: Mystyles.tabTextstyle,
                ),
              ),
              Tab(
                child: Text(
                  'Invitations',
                  style: Mystyles.tabTextstyle,
                ),
              ),
              Tab(
                child: Text(
                  '3rd tab',
                  style: Mystyles.tabTextstyle,
                ),
              ),
            ]),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          const Center(child: Text('notifications')),
          GetBuilder<AuthController>(builder: (controller) {
            print('tab2');
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: controller.currentUserInvitations
                    .map((e) => Container(
                          margin: const EdgeInsets.all(10),
                          decoration: MyBoxDecorations.listtileDecoration,
                          child: Column(
                            children: [
                              ListTile(
                                title: Text(
                                  e['webinar']['name'] + '',
                                  style: Mystyles.listtileSubtitleStyle,
                                ),
                                subtitle: Text(
                                  "Role: " + e['role'],
                                  style: Mystyles.listtileSubtitleStyle,
                                ),
                                trailing: Text(
                                  e['status'],
                                  style: Mystyles.listtileSubtitleStyle,
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
                                      onPressed: () {},
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
          const Center(child: Text('3rd tab')),
        ],
      ),
    );
  }
}
