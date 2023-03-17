import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:webinarprime/controllers/webinar_management_controller.dart';
import 'package:webinarprime/screens/webinar_management/view_webinar_screen/webinar_details_screen.dart';
import 'package:webinarprime/utils/app_constants.dart';

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
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
              image: DecorationImage(
                onError: (exception, stackTrace) {
                  const Text('Error loading image');
                },
                image:
                    NetworkImage(AppConstants.baseURL + webinar['coverImage']),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              children: [
                const Spacer(),
                Container(
                    height: 100.h,
                    padding: EdgeInsets.only(
                      left: 10.w,
                      right: 10.w,
                    ),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10)),
                      boxShadow: [],
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black38,
                          Colors.black
                        ],
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        AutoSizeText(
                          webinar['name'],
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium!
                              .copyWith(
                                  decorationColor: Colors.white,
                                  wordSpacing: 5,
                                  shadows: [
                                    Shadow(
                                      offset: const Offset(3, 3),
                                      blurRadius: 4,
                                      color: Colors.black.withOpacity(1),
                                    ),
                                  ],
                                  height: 1,
                                  fontSize: 18.sp,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  overflow: TextOverflow.ellipsis),
                          maxLines: 1,
                        ),
                        Gap(10.h),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            AutoSizeText(
                              webinar['datetime'].split('T')[0],
                              style: Theme.of(context)
                                  .textTheme
                                  .displayMedium!
                                  .copyWith(
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w300,
                                      color: Colors.white),
                              maxLines: 1,
                            ),
                            const Spacer(),
                          ],
                        )
                      ],
                    )),
              ],
            ),
          ),
          // Align(
          //   alignment: Alignment.center,
          //   // top: 10.h,
          //   // left: 110.w,
          //   child: Container(
          //     width: 90.w,
          //     height: 110.h,
          //     decoration: BoxDecoration(
          //       borderRadius: BorderRadius.circular(10.r),
          //       boxShadow: [
          //         BoxShadow(
          //           offset: const Offset(3, 3),
          //           blurRadius: 4,
          //           color: Theme.of(context)
          //               .colorScheme
          //               .secondary
          //               .withOpacity(0.1),
          //         ),
          //         BoxShadow(
          //           offset: const Offset(-3, -3),
          //           blurRadius: 4,
          //           color: Theme.of(context)
          //               .colorScheme
          //               .secondary
          //               .withOpacity(0.1),
          //         )
          //       ],
          //       image: DecorationImage(
          //         image: NetworkImage(
          //           AppConstants.baseURL + webinar['coverImage'],
          //         ),
          //         fit: BoxFit.cover,
          //       ),
          //     ),
          //   ),
          // ),

          // Align(
          //   alignment: Alignment.bottomCenter,
          //   child: Container(
          //       padding: EdgeInsets.only(
          //         left: 10.w,
          //         right: 10.w,
          //       ),
          //       height: 40.h,
          //       width: 1.sw,
          //       decoration: BoxDecoration(
          //         borderRadius: BorderRadius.only(
          //             bottomLeft: Radius.circular(10.r),
          //             bottomRight: Radius.circular(10.r)),
          //       ),
          //       child: Column(
          //         children: [
          //           AutoSizeText(
          //             webinar['name'],
          //             style:  Theme.of(context)
          // .textTheme
          // .displayMedium!
          // .copyWith(
          //                 height: 1,
          //                 fontSize: 18.sp,
          //                 color: Colors.white,
          //                 fontWeight: FontWeight.w500,
          //                 overflow: TextOverflow.ellipsis),
          //             maxLines: 1,
          //           ),
          //           Row(
          //             crossAxisAlignment: CrossAxisAlignment.end,
          //             children: [
          //               AutoSizeText(
          //                 webinar['datetime'],
          //                 style:  Theme.of(context)
          // .textTheme
          // .displayMedium!
          // .copyWith(
          //                     fontSize: 10.sp, fontWeight: FontWeight.w300),
          //                 maxLines: 1,
          //               ),
          //               const Spacer(),
          //               Text(
          //                 'Created by',
          //                 style:  Theme.of(context)
          // .textTheme
          // .displayMedium!

          //                     .copyWith(fontSize: 10.sp),
          //               ),
          //               Gap(5.w),
          //               CircleAvatar(
          //                 radius: 10.r,
          //                 backgroundImage: const NetworkImage(
          //                     'https://images.unsplash.com/photo-1529665253569-6d01c0eaf7b6?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NHx8cHJvZmlsZXxlbnwwfHwwfHw%3D&w=1000&q=80'),
          //               ),
          //             ],
          //           )
          //         ],
          //       )),
        ],
      ),
    );
  }
}
