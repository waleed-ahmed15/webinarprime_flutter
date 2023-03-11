import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:webinarprime/controllers/webinar_management_controller.dart';
import 'package:webinarprime/screens/user_search/user_search_screen.dart';
import 'package:webinarprime/screens/webinar_management/edit_webinar/edit_webinar_screen.dart';
import 'package:webinarprime/utils/app_constants.dart';
import 'package:webinarprime/utils/app_fonts.dart';
import 'package:webinarprime/utils/colors.dart';
import 'package:webinarprime/utils/dimension.dart';
import 'package:webinarprime/utils/styles.dart';
import 'package:webinarprime/widgets/snackbar.dart';

import '../webinar_management/view_webinar_screen/webinar_details_screen.dart';

class View_my_Webinar_Screen extends StatefulWidget {
  const View_my_Webinar_Screen({super.key});

  @override
  State<View_my_Webinar_Screen> createState() => _View_my_Webinar_ScreenState();
}

class _View_my_Webinar_ScreenState extends State<View_my_Webinar_Screen> {
  final formKey2 = GlobalKey<FormState>(); //key for form
  var titleController = TextEditingController();
  var descriptionController = TextEditingController();
  void showDialogBoxForPostNotification(String webinarId) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(60.r),
            ), //this right here
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(20.r),
              ),
              height: 430.h,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                    key: formKey2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(
                          child: Text("Post Notification",
                              style: Mystyles.categoriesHeadingStyle.copyWith(
                                  color: Get.isDarkMode
                                      ? Colors.white70
                                      : Colors.black38)),
                        ),
                        TextFormField(
                          controller: titleController,
                          style: Mystyles.onelineStyle,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                            ),
                            labelText: "Title",
                            hintText: "Enter Title",
                          ),
                          validator: (val) {
                            // print("val$val");
                            if (val == '') {
                              return 'please enter Title';
                            }
                            return null;
                          },
                        ),
                        // Gap(10.h),
                        TextFormField(
                          style: Mystyles.myParagraphStyle,
                          maxLines: 7,
                          controller: descriptionController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.r)),
                            ),
                            hintText: 'Webinar desceiption.....',
                          ),
                          validator: (val) {
                            // print("val$val");
                            if (val == '') {
                              return 'please enter description';
                            } else if (val!.length < 50) {
                              return 'add description of atleast 50 characters';
                            }
                            return null;
                          },
                        ),
                        Gap(10.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                style: ElevatedButton.styleFrom(
                                  animationDuration: const Duration(seconds: 3),
                                  backgroundColor: Colors.red,
                                ),
                                child: Text(
                                  'cancel',
                                  style: TextStyle(
                                      fontSize: AppLayout.getHeight(13),
                                      fontFamily: 'JosefinSans Bold',
                                      letterSpacing: 1),
                                )),

                            // this is where update  is handled
                            SizedBox(width: 20.w),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueAccent,
                              ),
                              child: Text(
                                'Post',
                                style: TextStyle(
                                    fontSize: 13.sp,
                                    fontFamily: 'JosefinSans Bold',
                                    letterSpacing: 1),
                              ),
                              onPressed: () async {
                                // Do something with the edited text
                                if (formKey2.currentState!.validate()) {
                                  // print(
                                  // "titleController.text${titleController.text}");
                                  // print(
                                  // "descriptionController.text${descriptionController.text}");
                                  // print(
                                  // "WebinarManagementController.currentWebinar['_id']${WebinarManagementController.currentWebinar['_id']}");

                                  await WebinarManagementController()
                                      .postNotification(
                                          webinarId,
                                          titleController.text,
                                          descriptionController.text);
                                  Navigator.of(context).pop();
                                  ShowCustomSnackBar(
                                      title: "",
                                      "Notification posted successfully",
                                      isError: false);
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    )),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WebinarManagementController>(builder: (co) {
      return SafeArea(
        child: Scaffold(
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
                      decoration: MyBoxDecorations.listtileDecoration,
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
                                      style: Mystyles.popupHeadingStyle),
                                ),
                                PopupMenuItem(
                                  onTap: () async {
                                    await Future.delayed(
                                        const Duration(seconds: 1));
                                    showDialogBoxForPostNotification(
                                        WebinarManagementController
                                            .webinarsList[index]['_id']);
                                    print("Post Notification tapped");
                                  },
                                  child: Text("Post Notification",
                                      style: Mystyles.popupHeadingStyle),
                                ),
                                PopupMenuItem(
                                  onTap: () async {
                                    print("add webinar event schedule");
                                  },
                                  child: Text("Event Schedule",
                                      style: Mystyles.popupHeadingStyle),
                                ),
                                PopupMenuItem(
                                  onTap: () async {
                                    await Future.delayed(
                                        const Duration(seconds: 1));

                                    // t
                                    await WebinarManagementController()
                                        .getwebinarById(
                                            WebinarManagementController
                                                .webinarsList[index]['_id']);
                                    // method will get all organizers for the webinar tapped
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
                                      style: Mystyles.popupHeadingStyle),
                                ),
                                PopupMenuItem(
                                  onTap: () {
                                    print("Join requests tapped");
                                  },
                                  child: Text("Join Requests",
                                      style: Mystyles.popupHeadingStyle),
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
                                onTap: () async {
                                  print("Add Guests/Speakers");
                                  await WebinarManagementController()
                                      .getwebinarById(
                                          WebinarManagementController
                                              .webinarsList[index]['_id']);

                                  await WebinarManagementController()
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
                                      .getwebinarById(
                                          WebinarManagementController
                                              .webinarsList[index]['_id']);
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
