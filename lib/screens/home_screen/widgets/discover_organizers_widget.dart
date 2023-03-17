import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class DiscoverOrganizerList extends StatefulWidget {
  const DiscoverOrganizerList({super.key});

  @override
  State<DiscoverOrganizerList> createState() => _DiscoverOrganizerListState();
}

class _DiscoverOrganizerListState extends State<DiscoverOrganizerList> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Gap(10.h),
        Padding(
          padding: EdgeInsets.only(left: 10.w),
          child: Text(
            'Discover Organizers',
            style: Theme.of(context)
                .textTheme
                .displayMedium!
                .copyWith(fontSize: 18.h, fontWeight: FontWeight.w400),
          ),
        ),
        Container(
          width: 1.sw,
          margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
          height: 175.h,
          child: ListView.builder(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemCount: 10,
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                decoration: BoxDecoration(
                    color: Get.isDarkMode ? Colors.black : Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                margin: EdgeInsets.only(left: 10.w),
                height: 10.h,
                width: 150.w,
                child: Column(children: [
                  Gap(10.h),
                  CircleAvatar(
                    radius: 40.r,
                    backgroundImage: const NetworkImage(
                        'https://images.unsplash.com/photo-1529665253569-6d01c0eaf7b6?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NHx8cHJvZmlsZXxlbnwwfHwwfHw%3D&w=1000&q=80'),
                  ),
                  Gap(3.h),
                  Text(
                    'waleed Ahmed',
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .displayMedium!
                        .copyWith(fontSize: 14.sp, fontWeight: FontWeight.w200),
                  ),
                  Gap(2.h),
                  ElevatedButton(
                    onPressed: () {},
                    child: Text('Follow',
                        style: Theme.of(context)
                            .textTheme
                            .displayMedium!
                            .copyWith(color: Colors.white, fontSize: 14.sp)),
                  ),
                ]),
              );
            },
          ),
        ),
      ],
    );
  }
}
