import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:webinarprime/controllers/webinar_management_controller.dart';

import '../../utils/app_constants.dart';
import '../../utils/colors.dart';
import '../../utils/styles.dart';

class UnApprovedWebinarsScreen extends StatelessWidget {
  const UnApprovedWebinarsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Get.isDarkMode ? Colors.black : const Color(0xffffffff),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Pending Webinars',
              style: Theme.of(context)
                  .textTheme
                  .displayLarge!
                  .copyWith(fontSize: 20.sp, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        centerTitle: true,
      )
      // body: const Text("Favorite Webinars"),
      ,
      body: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: WebinarManagementController.unapprovedWebinars.length,
        itemBuilder: (context, index) {
          return Container(
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
                      margin:
                          EdgeInsets.only(left: 10.h, top: 10.h, bottom: 10.h),
                      width: 0.40.sw,
                      height: 150.h,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.r),
                          image: DecorationImage(
                              image: NetworkImage(AppConstants.baseURL +
                                  WebinarManagementController
                                      .unapprovedWebinars[index]['coverImage']),
                              fit: BoxFit.cover)),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20.h, left: 10.w),
                      width: 180.w,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            WebinarManagementController
                                .unapprovedWebinars[index]['name'],
                            style: Theme.of(context)
                                .textTheme
                                .displayLarge!
                                .copyWith(
                                    fontSize: 16.sp,
                                    overflow: TextOverflow.ellipsis),
                            maxLines: 2,
                          ),
                          Gap(10.h),
                          Text(
                            WebinarManagementController
                                .unapprovedWebinars[index]['tags']
                                .toString(),
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium!
                                .copyWith(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 14.sp),
                          ),
                          Gap(25.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AutoSizeText(
                                WebinarManagementController
                                        .unapprovedWebinars[index]['duration'] +
                                    ' mins',
                                style: Theme.of(context)
                                    .textTheme
                                    .displayLarge!
                                    .copyWith(fontSize: 16.sp),
                              ),
                              AutoSizeText(
                                  WebinarManagementController
                                          .unapprovedWebinars[index]['price']
                                          .toString() +
                                      ' \$'.toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayLarge!
                                      .copyWith(
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
                        WebinarManagementController.unapprovedWebinars[index]
                                ['datetime']
                            .toString()
                            .split('T')[0]
                            .toString(),
                        style: Theme.of(context)
                            .textTheme
                            .displayMedium!
                            .copyWith(
                                fontSize: 10.sp, fontWeight: FontWeight.w300),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
