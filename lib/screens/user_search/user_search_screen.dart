import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:webinarprime/controllers/auth_controller.dart';
import 'package:webinarprime/controllers/webinar_management_controller.dart';
import 'package:webinarprime/utils/app_constants.dart';
import 'package:webinarprime/utils/colors.dart';
import 'package:webinarprime/utils/dimension.dart';
import 'package:webinarprime/utils/styles.dart';

class UserSearchScreen extends StatefulWidget {
  final int usersType;
  final String webinarId;
  const UserSearchScreen(
      {super.key, required this.usersType, required this.webinarId});
  @override
  State<UserSearchScreen> createState() => _UserSearchScreenState();
}

class _UserSearchScreenState extends State<UserSearchScreen>
    with SingleTickerProviderStateMixin {
  // Map currentWebinardata = WebinarManagementController().getwebinarById(widget.webinarId);
  TextEditingController serachcontroller = TextEditingController();
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        print("After clicking the Android Back Button");
        Navigator.of(context).pop();
        Get.find<AuthController>().searchedUsers.clear();
        return false;
      },
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Get.isDarkMode
                ? Get.changeThemeMode(ThemeMode.light)
                : Get.changeThemeMode(ThemeMode.dark);
            setState(() {});
          },
          child: const Icon(Icons.close),
        ),
        appBar: AppBar(
          backgroundColor: myappbarcolor,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: serachcontroller,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search_sharp),
                  color: iconColor,
                  iconSize: AppLayout.getHeight(30),
                  onPressed: () {
                    if (serachcontroller.text.trim().isEmpty) {
                      return;
                    }
                    AuthController authController = Get.find();
                    authController.searchUserNew(
                        serachcontroller.text.trim(), 'www', widget.webinarId);
                    Get.find<WebinarManagementController>()
                        .getwebinarById(widget.webinarId);
                  },
                ),
                hintText: 'Search. . .',
                hintStyle: myhintTextstyle,
                border: InputBorder.none,
              ),
              // style: const TextStyle(color: Colors.white),
            ),
          ),
          bottom: TabBar(
            // isScrollable: true,
            indicatorWeight: 2.0,
            indicatorColor: AppColors.LTprimaryColor,
            unselectedLabelStyle: TextStyle(
              fontSize: AppLayout.getHeight(10),
              fontFamily: 'JosefinSans Bold',
              fontWeight: FontWeight.w300,
            ),
            tabs: [
              Tab(
                child: Text(
                  'Results',
                  style: tabTextstyle,
                ),
              ),
              Tab(
                child: Text('Pending', style: tabTextstyle),
              ),
              Tab(
                child: Text('Joined', style: tabTextstyle),
              ),
            ],
            controller: _tabController,
          ),
        ),
        body: SafeArea(
          child: TabBarView(
            physics: const BouncingScrollPhysics(),
            controller: _tabController,
            children: [
              //Results Tab
              GetBuilder<AuthController>(builder: ((controller) {
                if (controller.searchedUsers.isEmpty) {
                  return Center(
                      child: Text("No Users Found",
                          style: AppConstants.secondaryHeadingStyle));
                } else {
                  return ListView.builder(
                    itemCount: controller.searchedUsers.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        margin:
                            EdgeInsets.only(top: 10.h, left: 10.w, right: 10.w),
                        decoration: listtileDecoration,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(AppConstants.baseURL +
                                controller.searchedUsers[index]
                                    ['profile_image']),
                          ),
                          title: Text(
                            controller.searchedUsers[index]['name'],
                            style: TextStyle(
                                fontFamily: 'JosefinSans SemiBold',
                                fontWeight: FontWeight.w500,
                                letterSpacing: 1,
                                fontSize: AppLayout.getHeight(19)),
                          ),
                          subtitle:
                              Text(controller.searchedUsers[index]['email']),
                          trailing: GetBuilder<WebinarManagementController>(
                              builder: (controller2) {
                            if (widget.usersType == 2) {
                              if (WebinarManagementController
                                  .currentWebinar['guests']
                                  .any((map) =>
                                      map['_id'] ==
                                      controller.searchedUsers[index]['_id'])) {
                                return IconButton(
                                  icon: const Icon(Icons.remove_circle_outline,
                                      color: Colors.red, size: 30),
                                  onPressed: () {
                                    // controller2.removeGuestFromWebinarById(
                                    // widget.webinarId,
                                    // controller.searchedUsers[index]['_id']);
                                  },
                                );
                              } else {
                                return IconButton(
                                  icon: const Icon(Icons.add_circle_outline,
                                      color: Colors.green, size: 30),
                                  onPressed: () async {
                                    // print(controller.searchedUsers[index]['_id']);
                                    // print(
                                    // controller.searchedUsers[index]['name']);
                                    await controller2.addmemberTowebinar(
                                        widget.webinarId,
                                        controller.searchedUsers[index]['_id'],
                                        'guest');

                                    print(controller.searchedUsers[index]);
                                    controller.searchedUsers.removeWhere(
                                        (element) =>
                                            element['_id'] ==
                                            controller.searchedUsers[index]
                                                ['_id']);

                                    await WebinarManagementController()
                                        .getGuestsForWebinar(widget.webinarId);

                                    setState(() {});
                                  },
                                );
                              }
                            } else if (widget.usersType == 1) {
                              if (WebinarManagementController
                                  .currentWebinar['organizers']
                                  .any((map) =>
                                      map['_id'] ==
                                      controller.searchedUsers[index]['_id'])) {
                                return IconButton(
                                  icon: const Icon(
                                    Icons.remove_circle_outline,
                                    color: Colors.red,
                                    size: 30,
                                  ),
                                  onPressed: () {
                                    // controller2.removeOrganizerFromWebinarById(
                                    // widget.webinarId,
                                    // controller.searchedUsers[index]['_id']);
                                  },
                                );
                              } else {
                                return IconButton(
                                  icon: const Icon(
                                    Icons.add_circle_outline,
                                    color: Colors.green,
                                    size: 30,
                                  ),
                                  onPressed: () async {
                                    await controller2.addmemberTowebinar(
                                        widget.webinarId,
                                        controller.searchedUsers[index]['_id'],
                                        'organizer');

                                    print(controller.searchedUsers[index]);
                                    controller.searchedUsers.removeWhere(
                                        (element) =>
                                            element['_id'] ==
                                            controller.searchedUsers[index]
                                                ['_id']);
                                    await controller2.getOrganizersForWebinar(
                                        widget.webinarId);
                                    // print(
                                    // "WebinarManagementController.currentwebinarOrganizers======");
                                    // print(WebinarManagementController
                                    // .currentwebinarPendingMembers);
                                    // print(
                                    // "==========WebinarManagementController.currentwebinarOrganizers");

                                    setState(() {});
                                  },
                                );
                              }
                            } else {
                              // if (WebinarManagementController
                              //     .currentWebinar['attendees']
                              //     .any((map) =>
                              //         map['_id'] ==
                              //         controller.searchedUsers[index]['_id'])) {
                              //   return IconButton(
                              //     icon: const Icon(
                              //       Icons.remove_circle_outline,
                              //       color: Colors.red,
                              //       size: 30,
                              //     ),
                              //     onPressed: () {
                              //       // controller2.removeAttendeeFromWebinarById(
                              //       // widget.webinarId,
                              //       // controller.searchedUsers[index]['_id']);
                              //     },
                              //   );
                              // } else
                              // {
                              return IconButton(
                                icon: const Icon(
                                  Icons.add_circle_outline,
                                  color: Colors.green,
                                  size: 30,
                                ),
                                onPressed: () async {
                                  await controller2.addmemberTowebinar(
                                      widget.webinarId,
                                      controller.searchedUsers[index]['_id'],
                                      'attendee');

                                  print(controller.searchedUsers[index]);
                                  controller.searchedUsers.removeWhere(
                                      (element) =>
                                          element['_id'] ==
                                          controller.searchedUsers[index]
                                              ['_id']);
                                  await WebinarManagementController()
                                      .getAttendeesForWebinar(widget.webinarId);

                                  setState(() {});
                                },
                              );
                              // }
                            }
                          }),
                        ),
                      );
                    },
                  );
                }
              })),

              //-------------------------------this is for pending tab view---------------------------------
              GetBuilder<WebinarManagementController>(builder: (controller) {
                if (WebinarManagementController
                    .currentwebinarPendingMembers.isEmpty) {
                  if (widget.usersType == 1) {
                    return Center(
                        child: Text("No pending Organizers Found",
                            style: myhintTextstyle));
                  } else if (widget.usersType == 2) {
                    return Center(
                        child: Text("No pending  Guests Found",
                            style: myhintTextstyle));
                  } else {
                    return Center(
                        child: Text("No pending Attendees Found",
                            style: myhintTextstyle));
                  }
                } else {
                  return ListView.builder(
                    itemCount: WebinarManagementController
                        .currentwebinarPendingMembers.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        margin:
                            EdgeInsets.only(top: 10.h, left: 10.w, right: 10.w),
                        decoration: listtileDecoration,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(AppConstants.baseURL +
                                WebinarManagementController
                                        .currentwebinarPendingMembers[index]
                                    ['user']['profile_image']),
                          ),
                          title: Text(
                            WebinarManagementController
                                    .currentwebinarPendingMembers[index]['user']
                                ['name'],
                            style: TextStyle(
                                fontFamily: 'JosefinSans SemiBold',
                                fontWeight: FontWeight.w500,
                                letterSpacing: 1,
                                fontSize: 19.sp),
                          ),
                          subtitle: Text(WebinarManagementController
                                  .currentwebinarPendingMembers[index]['user']
                              ['email']),
                          // trailing: TextButton(
                          //   child: Text(
                          //     'cancel',
                          //     style: TextStyle(
                          //         fontFamily: 'JosefinSans SemiBold',
                          //         fontWeight: FontWeight.w500,
                          //         letterSpacing: 1,
                          //         color: Colors.red,
                          //         fontSize: AppLayout.getHeight(19)),
                          //   ),
                          // onPressed: () {
                          //   // controller.removeOrganizerFromWebinarById(
                          //   // widget.webinarId,
                          //   // WebinarManagementController
                          //   // .currentWebinarOrganizers[index]['_id']);
                          //   print('cancel pressed ');
                          // },
                          // ),
                        ),
                      );
                    },
                  );
                }
              }),

              //-------------------------------this is for joined tab view---------------------------------
              GetBuilder<WebinarManagementController>(builder: (controller) {
                String membersType = 'organizers';
                if (widget.usersType == 1) {
                  membersType = 'organizers';
                } else if (widget.usersType == 2) {
                  membersType = 'guests';
                } else {
                  membersType = 'attendees';
                }
                if (WebinarManagementController
                    .currentWebinar[membersType].isEmpty) {
                  if (widget.usersType == 1) {
                    return Center(
                        child: Text("No Organizers Joined yet",
                            style: myhintTextstyle));
                  } else if (widget.usersType == 2) {
                    return Center(
                        child: Text("No Guests Joined yet",
                            style: myhintTextstyle));
                  } else {
                    return Center(
                        child: Text("No Attendees Joined yet",
                            style: myhintTextstyle));
                  }
                } else {
                  return ListView.builder(
                    itemCount: WebinarManagementController
                        .currentwebinarAcceptedMembers.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        margin:
                            EdgeInsets.only(top: 10.h, left: 10.w, right: 10.w),
                        decoration: listtileDecoration,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(AppConstants.baseURL +
                                WebinarManagementController
                                        .currentwebinarAcceptedMembers[index]
                                    ['user']['profile_image']),
                          ),
                          title: Text(
                            WebinarManagementController
                                    .currentwebinarAcceptedMembers[index]
                                ['user']['name'],
                            style: TextStyle(
                                fontFamily: 'JosefinSans SemiBold',
                                fontWeight: FontWeight.w500,
                                letterSpacing: 1,
                                fontSize: AppLayout.getHeight(19)),
                          ),
                          subtitle: Text(WebinarManagementController
                                  .currentwebinarAcceptedMembers[index]['user']
                              ['email']),
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.remove_circle_outline,
                              color: Colors.red,
                              size: 30,
                            ),
                            onPressed: () async {
                              bool removed =
                                  await controller.removeWebinarMember(
                                memeberId: WebinarManagementController
                                        .currentwebinarAcceptedMembers[index]
                                    ['_id'],
                              );

                              print(WebinarManagementController
                                      .currentwebinarAcceptedMembers[index]
                                  ['user']['email']);

                              if (removed) {
                                WebinarManagementController
                                    .currentwebinarAcceptedMembers
                                    .removeWhere((element) =>
                                        element['_id'] ==
                                        WebinarManagementController
                                                .currentwebinarAcceptedMembers[
                                            index]['_id']);
                                WebinarManagementController().update();
                              }
                              Get.showSnackbar(GetBar(
                                message: 'Member Removed',
                                duration: const Duration(seconds: 2),
                              ));
                              print('remove pressed ');
                            },
                          ),
                        ),
                      );
                    },
                  );
                }
              }),
            ],
          ),
        ),
      ),
    );
  }
}
