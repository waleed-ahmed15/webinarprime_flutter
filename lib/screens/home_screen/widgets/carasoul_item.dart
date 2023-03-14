import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:webinarprime/controllers/webinar_management_controller.dart';
import 'package:webinarprime/screens/webinar_management/view_webinar_screen/webinar_details_screen.dart';
import 'package:webinarprime/utils/app_constants.dart';
import 'package:webinarprime/utils/styles.dart';

class CaresoulItem extends StatelessWidget {
  Map<String, dynamic> webinar;
  CaresoulItem({required this.webinar, super.key});

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
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              height: 140,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.r),
                    topRight: Radius.circular(10.r)),
                image: DecorationImage(
                  onError: (exception, stackTrace) {
                    const Text('Error loading image');
                  },
                  image: NetworkImage(
                      AppConstants.baseURL + webinar['bannerImage']),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            // top: 10.h,
            // left: 110.w,
            child: Container(
              width: 90.w,
              height: 110.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(3, 3),
                    blurRadius: 4,
                    color: Theme.of(context)
                        .colorScheme
                        .secondary
                        .withOpacity(0.1),
                  ),
                  BoxShadow(
                    offset: const Offset(-3, -3),
                    blurRadius: 4,
                    color: Theme.of(context)
                        .colorScheme
                        .secondary
                        .withOpacity(0.1),
                  )
                ],
                image: DecorationImage(
                  image: NetworkImage(
                    AppConstants.baseURL + webinar['coverImage'],
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
                padding: EdgeInsets.only(
                  left: 10.w,
                  right: 10.w,
                ),
                height: 40.h,
                width: 1.sw,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10.r),
                      bottomRight: Radius.circular(10.r)),
                ),
                child: Column(
                  children: [
                    AutoSizeText(
                      webinar['name'],
                      style: Mystyles.listtileTitleStyle.copyWith(
                          height: 1,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          overflow: TextOverflow.ellipsis),
                      maxLines: 1,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        AutoSizeText(
                          webinar['datetime'],
                          style: Mystyles.listtileTitleStyle.copyWith(
                              fontSize: 10.sp, fontWeight: FontWeight.w300),
                          maxLines: 1,
                        ),
                        const Spacer(),
                        Text(
                          'Created by',
                          style: Mystyles.listtileTitleStyle
                              .copyWith(fontSize: 10.sp),
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
                )),
          ),
        ],
      ),
    );
  }
}
