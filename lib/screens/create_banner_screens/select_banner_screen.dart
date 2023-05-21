import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:webinarprime/controllers/auth_controller.dart';
import 'package:webinarprime/controllers/webinar_management_controller.dart';
import 'package:webinarprime/screens/create_banner_screens/banner_templates_slider.dart';
import 'package:webinarprime/screens/profile_view/webinar_info_tile.dart';
import 'package:webinarprime/utils/colors.dart';

class SelectWebinarForBanner extends StatelessWidget {
  const SelectWebinarForBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Column(
        children: [
          Gap(10.h),
          ElevatedButton(
            onPressed: () {
              WebinarManagementController.currentWebinar.clear();
              Get.to(() => BannerTemplates(
                    customBanner: true,
                  ));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.LTprimaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(7),
              ),
            ),
            child: const Text(
              "Custom Banner",
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
          if (AuthController.otherUserProfile['created_webinars'].isEmpty)
            Expanded(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.only(left: 10.w),
                  child: Center(
                    child: Text(
                      'No Webinars Created Yet',
                      style:
                          Theme.of(context).textTheme.displayMedium!.copyWith(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w500,
                              ),
                    ),
                  ),
                ),
              ),
            ),
          if (AuthController.otherUserProfile['created_webinars'].isNotEmpty)
            Expanded(
              child: ListView.builder(
                itemCount:
                    AuthController.otherUserProfile['created_webinars'].length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () async {
                      WebinarManagementController.currentWebinar.clear();
                      await WebinarManagementController().getwebinarById(
                          AuthController.otherUserProfile['created_webinars']
                              [index]['_id']);
                      Get.to(() => BannerTemplates(
                            customBanner: false,
                          ));
                    },
                    child: WebinarInfoTile(
                      'created_webinars',
                      index,
                    ),
                  );
                },
              ),
            )
        ],
      )),
    );
  }
}
