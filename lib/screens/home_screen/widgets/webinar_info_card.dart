import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:webinarprime/utils/app_constants.dart';

class WebinarInfoCardItem extends StatelessWidget {
  Map<String, dynamic> webinar;
  WebinarInfoCardItem({required this.webinar, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      foregroundDecoration: const BoxDecoration(
          // borderRadius: BorderRadius.circular(10.r),
          // gradient: const LinearGradient(
          //   begin: Alignment.topCenter,
          //   end: Alignment.bottomCenter,
          //   colors: [
          //     Colors.transparent,
          //     Colors.black38,
          //     Colors.black,
          //   ],
          // ),
          ),
      width: 0.6.sw,
      margin: EdgeInsets.only(right: 15.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        image: DecorationImage(
          onError: (exception, stackTrace) {
            const Text('Error loading image');
          },
          image: NetworkImage(AppConstants.baseURL + webinar['coverImage']),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
          height: 100.h,
          padding: EdgeInsets.only(
            left: 10.w,
            right: 10.w,
          ),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10)),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, Colors.black38, Colors.black],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              AutoSizeText(
                webinar['name'],
                style: Theme.of(context).textTheme.displayMedium!.copyWith(
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
                    style: Theme.of(context).textTheme.displayMedium!.copyWith(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w300,
                        color: Colors.white),
                    maxLines: 1,
                  ),
                  const Spacer(),
                ],
              ),
              const Gap(3),
            ],
          )),
    );
  }
}
