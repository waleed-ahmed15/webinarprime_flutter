import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:webinarprime/controllers/auth_controller.dart';
import 'package:webinarprime/utils/app_constants.dart';
import 'package:webinarprime/utils/colors.dart';
import 'package:webinarprime/utils/styles.dart';

class WebinarInfoTile extends StatelessWidget {
  final int index;
  String webinarListType = '';
  WebinarInfoTile(this.webinarListType, this.index, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: 10.h,
        left: 10.w,
        right: 10.w,
      ),
      decoration: MyBoxDecorations.listtileDecoration.copyWith(
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
                        image: NetworkImage(webinarListType ==
                                'created_webinars'
                            ? AppConstants.baseURL +
                                AuthController
                                        .otherUserProfile['created_webinars']
                                    [index]['coverImage']
                            : AppConstants.baseURL +
                                AuthController.otherUserProfile[webinarListType]
                                    [index]['webinar']['coverImage']),
                        fit: BoxFit.cover)),
              ),
              Container(
                margin: EdgeInsets.only(top: 20.h, left: 10.w),
                width: 180.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoSizeText(
                      webinarListType == 'created_webinars'
                          ? AuthController.otherUserProfile['created_webinars']
                              [index]['name']
                          : AuthController.otherUserProfile[webinarListType]
                              [index]['webinar']['name'],
                      style: Mystyles.bigTitleStyle.copyWith(
                          fontSize: 20.sp, overflow: TextOverflow.ellipsis),
                      maxLines: 2,
                    ),
                    Gap(10.h),
                    AutoSizeText(
                      webinarListType == 'created_webinars'
                          ? AuthController.otherUserProfile['created_webinars']
                                  [index]['tags']
                              .toString()
                          : AuthController.otherUserProfile[webinarListType]
                                  [index]['webinar']['tags']
                              .toString(),
                      style: Mystyles.listtileTitleStyle.copyWith(
                          fontWeight: FontWeight.w300, fontSize: 14.sp),
                    ),
                    Gap(25.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AutoSizeText(
                          webinarListType == 'created_webinars'
                              ? "${AuthController.otherUserProfile['created_webinars'][index]['duration']} mins"
                              : "${AuthController.otherUserProfile[webinarListType][index]['webinar']['duration']} mins",
                          style:
                              Mystyles.bigTitleStyle.copyWith(fontSize: 16.sp),
                        ),
                        AutoSizeText(
                            webinarListType == 'created_webinars'
                                ? '${AuthController.otherUserProfile['created_webinars'][index]['price']} \$'
                                : "${AuthController.otherUserProfile[webinarListType][index]['webinar']['price']} \$",
                            style: Mystyles.bigTitleStyle.copyWith(
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
                  webinarListType == 'created_webinars'
                      ? AuthController.otherUserProfile['created_webinars']
                              [index]['datetime']
                          .toString()
                      : AuthController.otherUserProfile[webinarListType][index]
                              ['webinar']['datetime']
                          .toString(),
                  style: Mystyles.listtileTitleStyle
                      .copyWith(fontSize: 10.sp, fontWeight: FontWeight.w300),
                ),
                // RatingBar.builder(
                //   itemBuilder: (context, index) {
                //     return const Icon(
                //       Icons.star,
                //       color: Colors.amber,
                //     );
                //   },
                //   itemSize: 15.r,
                //   updateOnDrag: false,
                //   initialRating: 3,
                //   // minRating: 1,
                //   direction: Axis.horizontal,
                //   // allowHalfRating: false,
                //   ignoreGestures: true,
                //   itemCount: 5,
                //   // itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                //   onRatingUpdate: (rating) {
                //     print(rating);
                //   },
                // ),

                // const ListTile(),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Created by',
                      style:
                          Mystyles.listtileTitleStyle.copyWith(fontSize: 14.sp),
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
    );
  }
}
