import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:webinarprime/controllers/auth_controller.dart';
import 'package:webinarprime/controllers/webinar_management_controller.dart';
import 'package:webinarprime/routes/routes.dart';
import 'package:webinarprime/screens/analytics_screen/bar_charts.dart';
import 'package:webinarprime/screens/create_banner_screens/select_banner_screen.dart';
import 'package:webinarprime/screens/my_webinars/unapproved_webinar_screen.dart';
import 'package:webinarprime/screens/profile_view/user_profile_view.dart';
import 'package:webinarprime/screens/webinar_marketing/created_webinars_screen.dart';
import 'package:webinarprime/utils/app_constants.dart';
import 'package:webinarprime/utils/styles.dart';

class HomeScreenDrawer extends StatefulWidget {
  const HomeScreenDrawer({super.key});

  @override
  State<HomeScreenDrawer> createState() => _HomeScreenDrawerState();
}

class _HomeScreenDrawerState extends State<HomeScreenDrawer> {
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 0.7.sw,
      backgroundColor:
          Get.isDarkMode ? const Color(0xff0A2647) : const Color(0xffFDFDF6),
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const Gap(20),
          UnconstrainedBox(
            child: Container(
              margin: const EdgeInsets.all(10),
              height: 150.h,
              width: 150.h,
              decoration: listtileDecoration.copyWith(
                  borderRadius: BorderRadius.circular(300.r),
                  image: DecorationImage(
                      image: NetworkImage(
                        Get.find<AuthController>().currentUser['profile_image']
                                    [0] ==
                                'h'
                            ? Get.find<AuthController>()
                                .currentUser['profile_image']
                            : AppConstants.baseURL +
                                Get.find<AuthController>()
                                    .currentUser['profile_image'],
                      ),
                      fit: BoxFit.cover)),
            ),
          ),
          Gap(10.h),
          loading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    ListTile(
                      onTap: () async {
                        setState(() {
                          loading = true;
                        });
                        await Future.delayed(
                            const Duration(seconds: 3), () => print('delayed'));

                        AuthController.otherUserProfile.clear();

                        bool fetched = await Get.find<AuthController>()
                            .otherUserProfileDetails(
                                Get.find<AuthController>().currentUser['_id']);
                        if (fetched) {
                          loading = false;
                          setState(() {});
                          Get.to(() => const UserProfileView());
                        }
                      },
                      leading: const Icon(Icons.person),
                      title: Text(
                        'Profile',
                        style: Theme.of(context)
                            .textTheme
                            .displayMedium!
                            .copyWith(height: 1.5.h, fontSize: 18.sp),
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.insert_invitation),
                      title: Text(
                        'Invitations',
                        style: Theme.of(context)
                            .textTheme
                            .displayMedium!
                            .copyWith(height: 1.5, fontSize: 18.sp),
                      ),
                      onTap: () {
                        // Update the state of the app.
                        Get.toNamed(RoutesHelper.notificationScreenRoute);
                      },
                    ),
                    // if (Get.find<AuthController>().currentUser['accountType'] ==
                    //     'organizer')
                    ListTile(
                      leading: const Icon(Icons.analytics),
                      title: Text(
                        'Analytics And Reports',
                        style: Theme.of(context)
                            .textTheme
                            .displayMedium!
                            .copyWith(height: 1.5, fontSize: 18.sp),
                      ),
                      onTap: () async {
                        print(Get.find<AuthController>().currentUser);
                        // Update the state of the app.
                        await Get.find<WebinarManagementController>()
                            .getUserWebinarAnalytics();
                        // Get.to(const BarChartSample2());
                        Get.to(() => WebinarStats());
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.settings),
                      title: Text('Webinar Marketing',
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium!
                              .copyWith(height: 1.5, fontSize: 18.sp)),
                      onTap: () async {
                        // Update the state of the app.
                        // await ChatStreamController().chatbot();
                        await Get.find<AuthController>()
                            .otherUserProfileDetails(
                                Get.find<AuthController>().currentUser['_id']);
                        Get.to(() => const CreatedWebinarList());
                        print('Webinar Marketing');
                        // ...
                      },
                    ),
                    if (Get.find<AuthController>().currentUser['accountType'] ==
                        'organizer')
                      ListTile(
                        leading: const Icon(Icons.create),
                        title: Text('Create Banner',
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium!
                                .copyWith(height: 1.5, fontSize: 18.sp)),
                        onTap: () async {
                          await Get.find<AuthController>()
                              .otherUserProfileDetails(
                                  Get.find<AuthController>()
                                      .currentUser['_id']);
                          Get.to(() => const SelectWebinarForBanner());

                          // Get.to(() => const BannerTemplates());
                        },
                      ),
                    // pending webinars
                    if (Get.find<AuthController>().currentUser['accountType'] ==
                        'organizer')
                      ListTile(
                        leading: const Icon(Icons.pending_outlined),
                        title: Text('Pending Webinars',
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium!
                                .copyWith(height: 1.5, fontSize: 18.sp)),
                        onTap: () async {
                          // Update the state of the app.
                          // ...
                          await Get.find<WebinarManagementController>()
                              .getUnapprovedWebinars();
                          Get.to(() => const UnApprovedWebinarsScreen());
                          print('Pending Webinars');
                        },
                      ),
                    ListTile(
                      leading: const Icon(Icons.logout),
                      title: Text('Logout',
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium!
                              .copyWith(height: 1.5, fontSize: 18.sp)),
                      onTap: () {
                        // Update the state of the app.
                        // ...
                        print('logout');
                        Get.find<AuthController>().logout();
                      },
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}
