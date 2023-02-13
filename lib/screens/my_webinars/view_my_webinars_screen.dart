import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webinarprime/controllers/webinar_management_controller.dart';
import 'package:webinarprime/screens/user_search/user_search_screen.dart';
import 'package:webinarprime/utils/app_constants.dart';
import 'package:webinarprime/utils/colors.dart';
import 'package:webinarprime/utils/dimension.dart';

class View_my_Webinar_Screen extends StatelessWidget {
  const View_my_Webinar_Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
         
          centerTitle: true,
          backgroundColor: AppColors.LTprimaryColor,
          title: const Text("My Webinars"),
        ),
        body: GetBuilder<WebinarManagementController>(
          builder: (controller) {
            return ListView.builder(
              itemCount: WebinarManagementController.webinarsList.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
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
                          offset: const Offset(7, 7),
                          blurRadius: 7,
                          color: Theme.of(context)
                              .colorScheme
                              .secondary
                              .withOpacity(0.1),
                        ),
                        BoxShadow(
                          offset: const Offset(-7, -7),
                          blurRadius: 7,
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
                                onTap: () {
                                  print("Edit");
                                },
                                child: const Text(
                                  "Edit",
                                  style: TextStyle(
                                      fontFamily: 'Montserrat-Regular',
                                      fontSize: 14),
                                ),
                              ),
                              PopupMenuItem(
                                onTap: () {
                                  print("Post Notification");
                                },
                                child: const Text(
                                  "Post Notification",
                                  style: TextStyle(
                                      fontFamily: 'Montserrat-Regular',
                                      fontSize: 14),
                                ),
                              ),
                              PopupMenuItem(
                                onTap: () {
                                  print("add webinar event schedule");
                                },
                                child: const Text(
                                  "Event Schedule",
                                  style: TextStyle(
                                      fontFamily: 'Montserrat-Regular',
                                      fontSize: 14),
                                ),
                              ),
                              PopupMenuItem(
                                onTap: () async {
                                  await Future.delayed(
                                      const Duration(seconds: 1));

                                  Get.to(() => UserSearchScreen(
                                      usersType: 1,
                                      webinarId: WebinarManagementController
                                          .webinarsList[index]['_id']));
                                  print("add organizers to webinar pressed");
                                },
                                child: const Text(
                                  "add organizers",
                                  style: TextStyle(
                                      fontFamily: 'Montserrat-Regular',
                                      fontSize: 14),
                                ),
                              ),
                              PopupMenuItem(
                                onTap: () {
                                  print("Join requests tapped");
                                },
                                child: const Text(
                                  "Join Requests",
                                  style: TextStyle(
                                      fontFamily: 'Montserrat-Regular',
                                      fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                          title: Text(
                            WebinarManagementController.webinarsList[index]
                                ['name'],
                            style: TextStyle(
                              fontSize: AppLayout.getHeight(20),
                              fontFamily: 'Montserrat-Regular',
                            ),
                          ),
                          subtitle: Text(
                            WebinarManagementController.webinarsList[index]
                                ['tagline'],
                            style: TextStyle(
                                fontFamily: 'Montserrat-Regular',
                                fontSize: 14,
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
                              color: Theme.of(context).scaffoldBackgroundColor,
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
                              borderRadius:
                                  BorderRadius.circular(AppLayout.getHeight(5)),
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
                                    color: AppColors.LTprimaryColor.withOpacity(
                                        0.9),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(5)),
                                  ),
                                  child: const Text('Add Guests/Speakers',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          fontFamily: 'Montserrat-Regular'))),
                            ),
                            InkWell(
                              onTap: () {
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
                                    color: AppColors.LTprimaryColor.withOpacity(
                                        0.9),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(5)),
                                  ),
                                  child: const Text('Add/Remove attendees',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          fontFamily: 'Montserrat-Regular'))),
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
  }
}
