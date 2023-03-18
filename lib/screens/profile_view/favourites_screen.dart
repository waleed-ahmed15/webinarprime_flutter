import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:webinarprime/controllers/auth_controller.dart';
import 'package:webinarprime/utils/app_constants.dart';
import 'package:webinarprime/utils/colors.dart';
import 'package:webinarprime/utils/styles.dart';

class FavoriteWebinars extends StatefulWidget {
  const FavoriteWebinars({super.key});

  @override
  State<FavoriteWebinars> createState() => _FavoriteWebinarsState();
}

class _FavoriteWebinarsState extends State<FavoriteWebinars> {
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
            Icon(
              Icons.favorite,
              color: Colors.red[500],
            ),
            Text(
              ' Webinars',
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
      body: GetBuilder<AuthController>(
          assignId: true,
          id: 'favoriteWebinars',
          builder: (context) {
            print('favoriteWebinars updated');
            return ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: AuthController.favoriteWebinars.length,
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
                            margin: EdgeInsets.only(
                                left: 10.h, top: 10.h, bottom: 10.h),
                            width: 0.40.sw,
                            height: 150.h,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.r),
                                image: DecorationImage(
                                    image: NetworkImage(AppConstants.baseURL +
                                        AuthController.favoriteWebinars[index]
                                            ['coverImage']),
                                    fit: BoxFit.cover)),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 20.h, left: 10.w),
                            width: 180.w,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AutoSizeText(
                                  AuthController.favoriteWebinars[index]
                                      ['name'],
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
                                  AuthController.favoriteWebinars[index]['tags']
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    AutoSizeText(
                                      AuthController.favoriteWebinars[index]
                                              ['duration'] +
                                          ' mins',
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayLarge!
                                          .copyWith(fontSize: 16.sp),
                                    ),
                                    AutoSizeText(
                                        AuthController.favoriteWebinars[index]
                                                    ['price']
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
                              AuthController.favoriteWebinars[index]['datetime']
                                  .toString()
                                  .split('T')[0]
                                  .toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .displayMedium!
                                  .copyWith(
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w300),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }),
    );
  }
}
