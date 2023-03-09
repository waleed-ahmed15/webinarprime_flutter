import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:webinarprime/controllers/auth_controller.dart';
import 'package:webinarprime/utils/app_constants.dart';
import 'package:webinarprime/utils/styles.dart';

class WebinarInfoTile extends StatelessWidget {
  final int index;
  String webinarListType = '';
  WebinarInfoTile(this.webinarListType, this.index, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 10.h, left: 10.w, right: 10.w),
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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(left: 10.h, top: 10.h, bottom: 10.h),
              width: 150.h,
              height: 150.h,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  image: DecorationImage(
                      image: NetworkImage(webinarListType == 'created_webinars'
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
                    style: Mystyles.bigTitleStyle.copyWith(fontSize: 20.sp),
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
                    style: Mystyles.bigTitleStyle
                        .copyWith(fontWeight: FontWeight.w300, fontSize: 14.sp),
                  ),
                  Gap(40.h),
                  AutoSizeText(
                    webinarListType == 'created_webinars'
                        ? '${AuthController.otherUserProfile['created_webinars'][index]['price']} \$'
                        : "${AuthController.otherUserProfile[webinarListType][index]['webinar']['price']} \$",
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
