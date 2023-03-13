import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webinarprime/controllers/auth_controller.dart';
import 'package:webinarprime/controllers/webinar_management_controller.dart';
import 'package:webinarprime/screens/profile_view/webinar_info_tile.dart';
import 'package:webinarprime/screens/webinar_management/view_webinar_screen/webinar_details_screen.dart';

class TabbarViewForProfileView extends StatefulWidget {
  final TabController tabController;
  const TabbarViewForProfileView({required this.tabController, super.key});

  @override
  State<TabbarViewForProfileView> createState() =>
      _TabbarViewForProfileViewState();
}

class _TabbarViewForProfileViewState extends State<TabbarViewForProfileView> {
  @override
  Widget build(BuildContext context) {
    return TabBarView(controller: widget.tabController, children: [
      GetBuilder<AuthController>(builder: (context) {
        if (AuthController.otherUserProfile['created_webinars'].length == 0) {
          return const Center(
            child: Text('No Webinars Created'),
          );
        }
        return ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: AuthController.otherUserProfile['created_webinars'].length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () async {
                WebinarManagementController.currentWebinar.clear();

                await WebinarManagementController().getwebinarById(
                    AuthController.otherUserProfile['created_webinars'][index]
                        ['_id']);

                Get.to(() => WebinarDetailsScreen(
                      webinarDetails:
                          WebinarManagementController.currentWebinar,
                    ));
              },
              child: WebinarInfoTile(
                'created_webinars',
                index,
              ),
            );
          },
        );
      }),
      GetBuilder<AuthController>(builder: (context) {
        if (AuthController.otherUserProfile['organized_webinars'].length == 0) {
          return const Center(
            child: Text('No Webinars Organized'),
          );
        }
        return ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount:
              AuthController.otherUserProfile['organized_webinars'].length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () async {
                print('tapped');
                WebinarManagementController.currentWebinar.clear();

                await WebinarManagementController().getwebinarById(
                    AuthController.otherUserProfile['organized_webinars'][index]
                        ['webinar']['_id']);

                print(WebinarManagementController.currentWebinar);
                Get.to(() => WebinarDetailsScreen(
                      webinarDetails:
                          WebinarManagementController.currentWebinar,
                    ));
              },
              child: WebinarInfoTile(
                'organized_webinars',
                index,
              ),
            );
          },
        );
      }),
      GetBuilder<AuthController>(builder: (context) {
        if (AuthController.otherUserProfile['guest_webinars'].length == 0) {
          return const Center(
            child: Text('No Webinars as Guest'),
          );
        }
        return ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: AuthController.otherUserProfile['guest_webinars'].length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () async {
                WebinarManagementController.currentWebinar.clear();

                await WebinarManagementController().getwebinarById(
                    AuthController.otherUserProfile['guest_webinars'][index]
                        ['webinar']['_id']);

                print(WebinarManagementController.currentWebinar);
                Get.to(() => WebinarDetailsScreen(
                      webinarDetails:
                          WebinarManagementController.currentWebinar,
                    ));
              },
              child: WebinarInfoTile(
                'guest_webinars',
                index,
              ),
            );
          },
        );
      }),
      GetBuilder<AuthController>(builder: (context) {
        if (AuthController.otherUserProfile['attended_webinars'].length == 0) {
          return const Center(
            child: Text('No Webinars Attended'),
          );
        }
        return ListView.builder(
          // padding: EdgeInsets.only(bottom: 10.h, left: 10.w, right: 10.w),
          physics: const BouncingScrollPhysics(),
          itemCount:
              AuthController.otherUserProfile['attended_webinars'].length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () async {
                WebinarManagementController.currentWebinar.clear();
                await WebinarManagementController().getwebinarById(
                    AuthController.otherUserProfile['attended_webinars'][index]
                        ['webinar']['_id']);

                print(WebinarManagementController.currentWebinar);
                Get.to(() => WebinarDetailsScreen(
                      webinarDetails:
                          WebinarManagementController.currentWebinar,
                    ));
              },
              child: WebinarInfoTile(
                'attended_webinars',
                index,
              ),
            );
          },
        );
      }),
    ]);
  }
}
