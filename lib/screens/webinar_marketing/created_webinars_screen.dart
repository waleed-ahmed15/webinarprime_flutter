import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:webinarprime/controllers/auth_controller.dart';
import 'package:webinarprime/controllers/webinar_management_controller.dart';
import 'package:webinarprime/screens/profile_view/webinar_info_tile.dart';
import 'package:webinarprime/screens/webinar_management/view_webinar_screen/webinar_details_screen.dart';
import 'package:webinarprime/screens/webinar_marketing/webinar_marketing_screen.dart';

class CreatedWebinarList extends StatelessWidget {
  const CreatedWebinarList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        centerTitle: true,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Transform.rotate(
              angle: -10 * 3.14 / 180,
              child: Image.network(
                'https://loading.io/s/icon/g4pp5q.png',
                width: 40,
                height: 40,
              ),
            ),
            Gap(10.w),
            Text(
              'Market Your Webinars',
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(fontSize: 18.sp),
            ),
            Gap(10.w),
            Transform.rotate(
              angle: 230 * 3.14 / 180,
              child: Image.network(
                'https://loading.io/s/icon/g4pp5q.png',
                errorBuilder: (BuildContext context, Object exception,
                    StackTrace? stackTrace) {
                  return const SizedBox();
                },
                width: 40,
                height: 40,
              ),
            )
          ],
        ),
      ),
      body: AuthController.otherUserProfile['created_webinars'].length == 0
          ? const Center(
              child: Text('No Webinars Created'),
            )
          : ListView.builder(
              itemCount:
                  AuthController.otherUserProfile['created_webinars'].length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () async {
                    WebinarManagementController.currentWebinar.clear();

                    await WebinarManagementController().getwebinarById(
                        AuthController.otherUserProfile['created_webinars']
                            [index]['_id']);

                    Get.to(() => const WebinarMarketingScreen(
                        // webinarDetails:
                        // WebinarManagementController.currentWebinar,
                        ));
                  },
                  child: WebinarInfoTile(
                    'created_webinars',
                    index,
                  ),
                );
              },
            ),
    );
  }
}
