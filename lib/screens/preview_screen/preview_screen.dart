import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:webinarprime/controllers/webinar_management_controller.dart';
import 'package:webinarprime/screens/home_screen/widgets/carasoul_slider_home.dart';
import 'package:webinarprime/screens/login/login_page.dart';
import 'package:webinarprime/utils/app_constants.dart';
import 'package:webinarprime/utils/styles.dart';

import '../../utils/colors.dart';

class PreLoginScreen extends StatefulWidget {
  const PreLoginScreen({super.key});

  @override
  State<PreLoginScreen> createState() => _PreLoginScreenState();
}

class _PreLoginScreenState extends State<PreLoginScreen> {
  bool isloading = true;
  @override
  void initState() {
    super.initState();
    WebinarManagementController().getAllwebinars().then((value) {
      WebinarManagementController().getCoverWebinars().then((value) {
        setState(() {
          isloading = false;
        });
      });
    });
  }

  void loginDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Please Login First'),
          actions: [
            TextButton(
              onPressed: () {
                // handle Login button press
                Get.to(() => const LoginPage());
              },
              child: const Text('Login'),
            ),
            TextButton(
              onPressed: () {
                // handle Cancel button press
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.transparent,
          title: Text(
            'Webinar Prime',
            style: Theme.of(context).textTheme.displayMedium!.copyWith(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ),
        body: GestureDetector(
          onTap: () {
            print("Tapped");

            //show dialog box for login or  sign up
            loginDialog();
          },
          child: isloading
              ? const CircularProgressIndicator()
              : Column(
                  children: [
                    GestureDetector(
                        onTap: () {
                          print('');
                        },
                        child: Stack(
                          children: [
                            CaresoulSliderHome(
                                webinarList:
                                    WebinarManagementController.coverWebinars),
                            GestureDetector(
                              onTap: () {
                                print('Tapped');
                                loginDialog();
                              },
                              child: Container(
                                color: Colors.transparent,
                                width: 1.sw,
                                height: 0.3.sh,
                              ),
                            ),
                          ],
                        )),
                    Gap(10.h),
                    Expanded(
                      child: ListView.builder(
                        itemCount:
                            WebinarManagementController.webinarsList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            margin: EdgeInsets.only(
                                top: 10.h, left: 10.w, right: 10.w),
                            decoration: listtileDecoration.copyWith(
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
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
                                          borderRadius:
                                              BorderRadius.circular(10.r),
                                          image: DecorationImage(
                                              image: NetworkImage(AppConstants
                                                      .baseURL +
                                                  WebinarManagementController
                                                          .webinarsList[index]
                                                      ['coverImage']),
                                              fit: BoxFit.cover)),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(
                                          top: 20.h, left: 10.w),
                                      width: 180.w,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            WebinarManagementController
                                                .webinarsList[index]['name'],
                                            style: Theme.of(context)
                                                .textTheme
                                                .displayLarge!
                                                .copyWith(
                                                    fontSize: 16.sp,
                                                    overflow:
                                                        TextOverflow.ellipsis),
                                            maxLines: 2,
                                          ),
                                          Gap(10.h),
                                          Text(
                                            WebinarManagementController
                                                .webinarsList[index]['tags']
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
                                                WebinarManagementController
                                                            .webinarsList[index]
                                                        ['duration'] +
                                                    ' mins',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .displayLarge!
                                                    .copyWith(fontSize: 16.sp),
                                              ),
                                              AutoSizeText(
                                                  WebinarManagementController
                                                          .webinarsList[index]
                                                              ['price']
                                                          .toString() +
                                                      ' \$'.toString(),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .displayLarge!
                                                      .copyWith(
                                                          color: Get.isDarkMode
                                                              ? AppColors
                                                                  .LTsecondaryColor
                                                              : AppColors
                                                                  .LTprimaryColor,
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
                                      right: 10.w,
                                      left: 10.w,
                                      top: 10.h,
                                      bottom: 10.h),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      AutoSizeText(
                                        WebinarManagementController
                                            .webinarsList[index]['datetime']
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
                      ),
                    ),
                  ],
                ),
        ));
  }
}
