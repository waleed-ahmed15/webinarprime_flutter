import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:webinarprime/controllers/webinar_management_controller.dart';
import 'package:webinarprime/screens/webinar_management/view_webinar_screen/webinar_details_screen.dart';
import 'package:webinarprime/utils/app_constants.dart';
import 'package:webinarprime/utils/colors.dart';
import 'package:webinarprime/utils/styles.dart';
import 'package:flutter/material.dart';

class WebinarDynamicInfoTile extends StatelessWidget {
  Map<String, dynamic> webinar;
  WebinarDynamicInfoTile({required this.webinar, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await Get.find<WebinarManagementController>()
            .getwebinarById(webinar['_id']);

        Get.to(() => WebinarDetailsScreen(
              webinarDetails: webinar,
            ));
      },
      child: Container(
        margin: EdgeInsets.only(top: 10.h, left: 10.w, right: 10.w),
        decoration: listtileDecoration.copyWith(
            color: Theme.of(context).scaffoldBackgroundColor,
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  offset: const Offset(0, 0),
                  blurRadius: 5,
                  spreadRadius: 1),
              BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  offset: const Offset(0, 0),
                  blurRadius: 5,
                  spreadRadius: 1)
            ]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 10.h, top: 10.h, bottom: 10.h),
                  width: 0.40.sw,
                  height: 150.h,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      image: DecorationImage(
                          image: NetworkImage(
                              AppConstants.baseURL + webinar['coverImage']),
                          fit: BoxFit.cover)),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20.h, left: 10.w),
                  width: 180.w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AutoSizeText(
                        webinar['name'],
                        style: Theme.of(context)
                            .textTheme
                            .displayLarge!
                            .copyWith(
                                fontSize: 20.sp,
                                overflow: TextOverflow.ellipsis),
                        maxLines: 2,
                      ),
                      Gap(10.h),
                      AutoSizeText(
                        webinar['tags'].toString(),
                        style: Theme.of(context)
                            .textTheme
                            .displaySmall!
                            .copyWith(
                                fontWeight: FontWeight.w300, fontSize: 14.sp),
                      ),
                      Gap(25.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AutoSizeText(
                            webinar['duration'] + ' mins',
                            style: bigTitleStyle.copyWith(
                                color: Theme.of(context)
                                    .textTheme
                                    .displayLarge!
                                    .color,
                                fontSize: 16.sp),
                          ),
                          AutoSizeText(
                              webinar['price'].toString() + ' \$'.toString(),
                              style: bigTitleStyle.copyWith(
                                  color: Get.isDarkMode
                                      ? AppColors.LTsecondaryColor
                                      : AppColors.LTprimaryColor,
                                  fontSize: 16.sp)),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
            Container(
              margin: EdgeInsets.only(
                  right: 10.w, left: 10.w, top: 10.h, bottom: 10.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AutoSizeText(
                    webinar['datetime'].toString(),
                    style: Theme.of(context).textTheme.displayMedium!.copyWith(
                        color: Theme.of(context).textTheme.displaySmall!.color,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w300),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Created by',
                        style: Theme.of(context)
                            .textTheme
                            .displayMedium!
                            .copyWith(
                                color: Theme.of(context)
                                    .textTheme
                                    .displayMedium!
                                    .color,
                                fontSize: 14.sp),
                      ),
                      Gap(5.w),
                      CircleAvatar(
                        radius: 10.r,
                        backgroundImage: const NetworkImage(
                            'https://images.unsplash.com/photo-1529665253569-6d01c0eaf7b6?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NHx8cHJvZmlsZXxlbnwwfHwwfHw%3D&w=1000&q=80'),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
