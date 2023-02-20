import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webinarprime/controllers/webinar_management_controller.dart';
import 'package:webinarprime/screens/user_search/user_search_screen.dart';
import 'package:webinarprime/screens/webinar_management/edit_webinar/edit_webinar_screen.dart';
import 'package:webinarprime/utils/app_constants.dart';
import 'package:webinarprime/utils/app_fonts.dart';
import 'package:webinarprime/utils/colors.dart';
import 'package:webinarprime/utils/dimension.dart';

import '../webinar_management/view_webinar_screen/webinar_details_screen.dart';

class View_my_Webinar_Screen extends StatelessWidget {
  const View_my_Webinar_Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WebinarManagementController>(builder: (co) {
      return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios,
                  color: Theme.of(context).colorScheme.secondary),
              onPressed: () {
                Get.back();
              },
            ),
            actions: const [
              // TextButton(
              //     onPressed: () {},
              //     child: Text('Save', style: AppConstants.secondaryHeadingStyle)),
            ],
            elevation: 0,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            centerTitle: true,
            title: Text(
              "My Webinars",
              style: AppConstants.paragraphStyle.copyWith(
                  color: Theme.of(context).colorScheme.secondary,
                  letterSpacing: 2,
                  fontSize: AppLayout.getHeight(20)),
            ),
          ),
          body: GetBuilder<WebinarManagementController>(
            builder: (controller) {
              return ListView.builder(
                itemCount: WebinarManagementController.webinarsList.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () async {
                      await WebinarManagementController().getwebinarById(
                          WebinarManagementController.webinarsList[index]
                              ['_id']);
                      Get.to(() => WebinarDetailsScreen(
                            webinarDetails:
                                WebinarManagementController.currentWebinar,
                          ));
                      print('view my webinars detials screen');
                    },
                    child: Container(
                      height: AppLayout.getHeight(310),
                      margin: EdgeInsets.symmetric(
                          horizontal: AppLayout.getWidth(10),
                          vertical: AppLayout.getHeight(10)),
                      // padding: EdgeInsets.symmetric(horizontal: AppLayout.getWidth(10)),
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(AppLayout.getHeight(10)),
                        color: Theme.of(context).scaffoldBackgroundColor,
                        boxShadow: [
                          BoxShadow(
                            offset: const Offset(3, 3),
                            blurRadius: 4,
                            color: Theme.of(context)
                                .colorScheme
                                .secondary
                                .withOpacity(0.1),
                          ),
                          BoxShadow(
                            offset: const Offset(-3, -3),
                            blurRadius: 4,
                            color: Theme.of(context)
                                .colorScheme
                                .secondary
                                .withOpacity(0.1),
                          )
                        ],
                      ),
                      child: Column(
                        children: [
                          ListTile(
                            trailing: PopupMenuButton(
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                  onTap: () async {
                                    print("Edit");
                                    await WebinarManagementController()
                                        .getwebinarById(
                                            WebinarManagementController
                                                .webinarsList[index]['_id']);

                                    await Future.delayed(
                                        const Duration(seconds: 1));
                                    Get.to(() => EditWebinarScreen(
                                          webinarDetails:
                                              WebinarManagementController
                                                  .currentWebinar,
                                        ));
                                  },
                                  child: Text("Edit",
                                      style: AppConstants.popmenuitemStyle),
                                ),
                                PopupMenuItem(
                                  onTap: () {
                                    print("Post Notification");
                                  },
                                  child: Text("Post Notification",
                                      style: AppConstants.popmenuitemStyle),
                                ),
                                PopupMenuItem(
                                  onTap: () {
                                    print("add webinar event schedule");
                                  },
                                  child: Text("Event Schedule",
                                      style: AppConstants.popmenuitemStyle),
                                ),
                                PopupMenuItem(
                                  onTap: () async {
                                    await Future.delayed(
                                        const Duration(seconds: 1));

                                    // method will get organizers for the webinar tapped
                                    await WebinarManagementController()
                                        .getOrganizersForWebinar(
                                            WebinarManagementController
                                                .webinarsList[index]['_id']);

                                    Get.to(() => UserSearchScreen(
                                        usersType: 1,
                                        webinarId: WebinarManagementController
                                            .webinarsList[index]['_id']));

                                    print("add organizers to webinar pressed");
                                  },
                                  child: Text("Add Organizers",
                                      style: AppConstants.popmenuitemStyle),
                                ),
                                PopupMenuItem(
                                  onTap: () {
                                    print("Join requests tapped");
                                  },
                                  child: Text("Join Requests",
                                      style: AppConstants.popmenuitemStyle),
                                ),
                              ],
                            ),
                            title: Text(
                              WebinarManagementController.webinarsList[index]
                                  ['name'],
                              style: AppConstants.paragraphStyle.copyWith(
                                overflow: TextOverflow.ellipsis,
                                fontSize: AppLayout.getHeight(20),
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1,
                              ),
                            ),
                            subtitle: Text(
                              WebinarManagementController.webinarsList[index]
                                  ['tagline'],
                              style: TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  fontFamily: AppFont.primaryText,
                                  fontSize: 15,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .secondary
                                      .withOpacity(0.6)),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: AppLayout.getWidth(10),
                                vertical: AppLayout.getHeight(10)),
                            child: Container(
                              decoration: BoxDecoration(
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                                boxShadow: [
                                  BoxShadow(
                                    offset: const Offset(2, 2),
                                    blurRadius: 7,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary
                                        .withOpacity(0.1),
                                  ),
                                  BoxShadow(
                                    offset: const Offset(-2, -2),
                                    blurRadius: 7,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary
                                        .withOpacity(0.1),
                                  )
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(
                                    AppLayout.getHeight(5)),
                                child: Image(
                                  width: double.maxFinite,
                                  height: 160,
                                  image: NetworkImage(
                                    AppConstants.baseURL +
                                        WebinarManagementController
                                            .webinarsList[index]['bannerImage'],
                                  ),
                                  // "https://thumbs.dreamstime.com/b/open-book-hardback-books-wooden-table-education-background-back-to-school-copy-space-text-76106466.jpg",

                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: AppLayout.getHeight(10),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  print("Add Guests/Speakers");

                                  WebinarManagementController()
                                      .getGuestsForWebinar(
                                          WebinarManagementController
                                              .webinarsList[index]['_id']);
                                  Get.to(() => UserSearchScreen(
                                      usersType: 2,
                                      webinarId: WebinarManagementController
                                          .webinarsList[index]['_id']));
                                },
                                child: Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: AppLayout.getHeight(10),
                                        horizontal: AppLayout.getWidth(10)),
                                    decoration: BoxDecoration(
                                      color:
                                          AppColors.LTprimaryColor.withOpacity(
                                              0.9),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(5)),
                                    ),
                                    child: const Text('Add Guests/Speakers',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            fontFamily: AppFont.jsRegular))),
                              ),
                              InkWell(
                                onTap: () async {
                                  await WebinarManagementController()
                                      .getAttendeesForWebinar(
                                          WebinarManagementController
                                              .webinarsList[index]['_id']);
                                  Get.to(() => UserSearchScreen(
                                      usersType: 3,
                                      webinarId: WebinarManagementController
                                          .webinarsList[index]['_id']));
                                  print("Add/remove attendees pressed");
                                  // WebinarManagementController()
                                  // .getwebinarById('638bd08d558465d9dedcf5eb');
                                },
                                child: Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: AppLayout.getHeight(10),
                                        horizontal: AppLayout.getWidth(10)),
                                    decoration: BoxDecoration(
                                      color:
                                          AppColors.LTprimaryColor.withOpacity(
                                              0.9),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(5)),
                                    ),
                                    child: const Text('Add/Remove attendees',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            fontFamily: AppFont.jsRegular))),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: AppLayout.getHeight(10),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      );
    });
  }
}
