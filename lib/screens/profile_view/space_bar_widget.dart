import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:webinarprime/controllers/auth_controller.dart';
import 'package:webinarprime/utils/app_constants.dart';
import 'package:webinarprime/utils/colors.dart';
import 'package:webinarprime/utils/styles.dart';

class SpaceBarForProfileView extends StatelessWidget {
  const SpaceBarForProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          gradient: MyBoxDecorations.webinarInfoTileGradient),
      child: FlexibleSpaceBar(
        background: Stack(
          children: [
            Positioned(
              top: 10.h,
              left: 0.04.sw,
              child: SizedBox(
                width: 0.94.sw,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Builder(builder: (context) {
                      if (AuthController.otherUserProfile['_id'] ==
                          Get.find<AuthController>().currentUser['_id']) {
                        return CircleAvatar(
                          backgroundColor: Colors.transparent,
                          radius: 100.r,
                          backgroundImage: NetworkImage(AppConstants.baseURL +
                              AuthController.otherUserProfile['profile_image']),
                        );
                      }
                      if (AuthController.otherUserProfile['accountType'] ==
                          'organizer') {
                        return CircleAvatar(
                          backgroundColor: Colors.transparent,
                          radius: 60.r,
                          backgroundImage: NetworkImage(AppConstants.baseURL +
                              AuthController.otherUserProfile['profile_image']),
                        );
                      } else {
                        return CircleAvatar(
                          backgroundColor: Colors.transparent,
                          radius: 100.r,
                          backgroundImage: NetworkImage(AppConstants.baseURL +
                              AuthController.otherUserProfile['profile_image']),
                        );
                      }
                    }),
                    Gap(10.w),
                    AutoSizeText(
                      AuthController.otherUserProfile['name'],
                      style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                    Gap(10.w),
                    AutoSizeText(
                      AuthController.otherUserProfile['registration_number'],
                      style: Mystyles.listtileSubtitleStyle.copyWith(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w300,
                          color: Colors.white),
                    ),
                    Gap(30.w),
                    GetBuilder<AuthController>(builder: (controler) {
                      if (AuthController.otherUserProfile['_id'] ==
                          Get.find<AuthController>().currentUser['_id']) {
                        return Container();
                      }
                      if (AuthController.otherUserProfile['accountType'] ==
                          'organizer') {
                        if (Get.find<AuthController>()
                            .currentUser['following']
                            .contains(AuthController.otherUserProfile['_id'])) {
                          return ElevatedButton(
                              onPressed: () async {
                                print('un followPressed');
                                Get.find<AuthController>().unfollowUser(
                                    Get.find<AuthController>()
                                        .currentUser['_id'],
                                    AuthController.otherUserProfile['_id']);
                              },
                              style: ElevatedButton.styleFrom(
                                  alignment: Alignment.center,
                                  backgroundColor:
                                      AppColors.LTsecondaryColor.withOpacity(
                                          0.8)),
                              child: Text(
                                'Unfollow',
                                style: Mystyles.listtileTitleStyle.copyWith(
                                    fontSize: 14.sp,
                                    letterSpacing: 1.6,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600),
                              ));
                        }

                        return ElevatedButton(
                            onPressed: () async {
                              print('followPressed');
                              Get.find<AuthController>().followUser(
                                  Get.find<AuthController>().currentUser['_id'],
                                  AuthController.otherUserProfile['_id']);
                            },
                            style: ElevatedButton.styleFrom(
                                alignment: Alignment.center),
                            child: Text(
                              'Follow',
                              style: Mystyles.listtileTitleStyle.copyWith(
                                  fontSize: 14.sp,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600),
                            ));
                      }
                      return Container();
                    }),
                    Gap(30.w),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
