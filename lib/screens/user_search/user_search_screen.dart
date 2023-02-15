import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webinarprime/controllers/auth_controller.dart';
import 'package:webinarprime/controllers/webinar_management_controller.dart';
import 'package:webinarprime/utils/app_constants.dart';
import 'package:webinarprime/utils/app_fonts.dart';
import 'package:webinarprime/utils/dimension.dart';

class UserSearchScreen extends StatefulWidget {
  final int usersType;
  final String webinarId;
  const UserSearchScreen(
      {super.key, required this.usersType, required this.webinarId});
  @override
  State<UserSearchScreen> createState() => _UserSearchScreenState();
}

class _UserSearchScreenState extends State<UserSearchScreen> {
  // Map currentWebinardata = WebinarManagementController().getwebinarById(widget.webinarId);
  TextEditingController serachcontroller = TextEditingController();
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
        appBar: AppBar(
          actions: const [
            // TextButton(
            //     onPressed: () {},
            //     child: Text('Save', style: AppConstants.secondaryHeadingStyle)),
          ],
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          centerTitle: true,
          title: Text(
              widget.usersType == 1
                  ? "Add Organizers"
                  : widget.usersType == 2
                      ? "Add Guests"
                      : "Add Attdendees",
              style: AppConstants.paragraphStyle.copyWith(
                fontSize: AppLayout.getHeight(20),
              )),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios,
                color: Theme.of(context).colorScheme.secondary),
            onPressed: () {
              Navigator.of(context).pop();
              Get.find<AuthController>().searchedUsers.clear();
            },
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(5),
                child: TextFormField(
                  controller: serachcontroller,
                  onChanged: (value) => setState(() {}),
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        AuthController authController = Get.find();
                        authController.searchUserNew(
                            serachcontroller.text.trim(),
                            'www',
                            widget.webinarId);
                        Get.find<WebinarManagementController>()
                            .getwebinarById(widget.webinarId);
                      },
                    ),
                    suffixIconColor: Colors.black.withOpacity(0.4),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                    fillColor: Colors.white10,
                    filled: true,
                    hintText: "Search...",
                    hintStyle: AppConstants.paragraphStyle
                        .copyWith(color: Colors.black.withOpacity(0.4)),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          const BorderSide(width: 1, color: Colors.orange),
                    ),
                  ),
                ),
              ),
              GetBuilder<AuthController>(builder: ((controller) {
                if (controller.searchedUsers.isEmpty) {
                  return Expanded(
                      child: Center(
                          child: Text("No Users Found",
                              style: AppConstants.secondaryHeadingStyle)));
                } else {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: controller.searchedUsers.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(AppConstants.baseURL +
                                controller.searchedUsers[index]
                                    ['profile_image']),
                          ),
                          title: Text(
                            controller.searchedUsers[index]['name'],
                            style: TextStyle(
                                fontFamily: AppFont.primaryText,
                                letterSpacing: 2,
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
                                    controller2.removeGuestFromWebinarById(
                                        widget.webinarId,
                                        controller.searchedUsers[index]['_id']);
                                  },
                                );
                              } else {
                                return IconButton(
                                  icon: const Icon(Icons.add_circle_outline,
                                      color: Colors.green, size: 30),
                                  onPressed: () {
                                    controller2.addGuestToWebinarById(
                                        widget.webinarId,
                                        controller.searchedUsers[index]['_id']);
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
                                    controller2.removeOrganizerFromWebinarById(
                                        widget.webinarId,
                                        controller.searchedUsers[index]['_id']);
                                  },
                                );
                              } else {
                                return IconButton(
                                  icon: const Icon(
                                    Icons.add_circle_outline,
                                    color: Colors.green,
                                    size: 30,
                                  ),
                                  onPressed: () {
                                    controller2.addOrganizerToWebinarById(
                                        widget.webinarId,
                                        controller.searchedUsers[index]['_id']);
                                  },
                                );
                              }
                            } else {
                              if (WebinarManagementController
                                  .currentWebinar['attendees']
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
                                    controller2.removeAttendeeFromWebinarById(
                                        widget.webinarId,
                                        controller.searchedUsers[index]['_id']);
                                  },
                                );
                              } else {
                                return IconButton(
                                  icon: const Icon(
                                    Icons.add_circle_outline,
                                    color: Colors.green,
                                    size: 30,
                                  ),
                                  onPressed: () {
                                    controller2.addAttendeeToWebinarById(
                                        widget.webinarId,
                                        controller.searchedUsers[index]['_id']);
                                  },
                                );
                              }
                            }
                          }),
                        );
                      },
                    ),
                  );
                }
              })),
            ],
          ),
        ),
      ),
    );
  }
}
