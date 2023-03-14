import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:webinarprime/controllers/webinar_management_controller.dart';
import 'package:webinarprime/screens/home_screen/widgets/carasoul_slider_home.dart';
import 'package:webinarprime/screens/home_screen/widgets/discover_organizers_widget.dart';
import 'package:webinarprime/screens/home_screen/widgets/webinar_dynamic_tile.dart';
import 'package:webinarprime/utils/styles.dart';

class HomeScreenHomeTab extends StatefulWidget {
  const HomeScreenHomeTab({super.key});

  @override
  State<HomeScreenHomeTab> createState() => _HomeScreenHomeTabState();
}

class _HomeScreenHomeTabState extends State<HomeScreenHomeTab> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          Gap(10.h),
          const CaresoulSliderHome(),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: WebinarManagementController.webinarsList.length,
            itemBuilder: (BuildContext context, int index) {
              if (index == 2) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const DiscoverOrganizerList(),
                    WebinarDynamicInfoTile(
                        webinar:
                            WebinarManagementController.webinarsList[index]),
                  ],
                );
              } else if (index == 4) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Gap(5.h),
                    Container(
                      margin: EdgeInsets.only(left: 10.h),
                      width: 0.6.sw,
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: Colors.grey.shade300, width: 1.w))),
                      child: Row(
                        children: [
                          Text(
                            'See What\'s Treanding',
                            style: Mystyles.listtileTitleStyle.copyWith(
                                fontSize: 18.sp, fontWeight: FontWeight.w400),
                          ),
                          Icon(
                            Icons.trending_up,
                            size: 30.h,
                            color: Colors.green,
                          ),
                        ],
                      ),
                    ),
                    WebinarDynamicInfoTile(
                        webinar:
                            WebinarManagementController.webinarsList[index])
                  ],
                );
              }
              return WebinarDynamicInfoTile(
                  webinar: WebinarManagementController.webinarsList[index]);
            },
          ),
        ],
      ),
    ));
  }
}
