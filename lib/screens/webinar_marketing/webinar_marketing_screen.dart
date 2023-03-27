import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:webinarprime/controllers/webinar_management_controller.dart';
import 'package:webinarprime/screens/webinar_marketing/email_marketing_tab.dart';
import 'package:webinarprime/screens/webinar_marketing/social_tab.dart';
import 'package:webinarprime/utils/app_constants.dart';
import 'package:webinarprime/utils/colors.dart';

class WebinarMarketingScreen extends StatefulWidget {
  const WebinarMarketingScreen({super.key});

  @override
  State<WebinarMarketingScreen> createState() => _WebinarMarketingScreenState();
}

class _WebinarMarketingScreenState extends State<WebinarMarketingScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late ScrollController _scrollController;
  bool _showTitle = false;

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    _tabController = TabController(length: 2, vsync: this);
    // TODO: implement initState

    super.initState();
  }

  void _scrollListener() {
    if (_scrollController.offset >= 100 && !_showTitle) {
      setState(() {
        _showTitle = true;
      });
    } else if (_scrollController.offset < 100 && _showTitle) {
      setState(() {
        _showTitle = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: NestedScrollView(
            physics: const BouncingScrollPhysics(),
            controller: _scrollController,
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  automaticallyImplyLeading: false,
                  iconTheme: IconThemeData(
                    size: 30.h,
                    color: Get.isDarkMode
                        ? Colors.white.withOpacity(0.98)
                        : const Color(0xff181b1f),
                  ),
                  collapsedHeight: 70.h,
                  toolbarHeight: 70.h,
                  backgroundColor: Get.isDarkMode
                      ? const Color(0xff191919)
                      : const Color(0xffF7F8F8),
                  pinned: true,
                  expandedHeight: 340.h,
                  centerTitle: true,
                  title: _showTitle
                      ? Text(WebinarManagementController.currentWebinar['name'],
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium!
                              .copyWith(
                                  overflow: TextOverflow.ellipsis,
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white))
                      : null,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Stack(
                      children: [
                        Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 10.h),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.r),
                              // color: Colors.transparent,
                              gradient: const LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black38,
                                  Colors.black
                                ],
                              ),
                            ),
                            height: 220.h,
                            width: 200.w,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10.r),
                              child: Image.network(
                                AppConstants.baseURL +
                                    WebinarManagementController
                                        .currentWebinar['coverImage'],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Align(
                            alignment: Alignment.bottomCenter,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  WebinarManagementController
                                      .currentWebinar['name'],
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayLarge!
                                      .copyWith(
                                        height: 1.4,
                                        fontSize: 17.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  WebinarManagementController
                                      .currentWebinar['datetime'],
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayMedium!
                                      .copyWith(
                                        height: 1.4,
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w400,
                                      ),
                                ),
                                Gap(30.h),
                              ],
                            )),
                      ],
                    ),
                  ),
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(10.0),
                    child: TabBar(
                      tabs: [
                        Text(
                          ' Email Marketing',
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium!
                              .copyWith(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        Text('Social  Marketing',
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium!
                                .copyWith(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w600,
                                ))
                      ],
                      controller: _tabController,
                      indicatorColor: AppColors.LTprimaryColor,
                    ),
                  ),
                ),
              ];
            },
            body: TabBarView(controller: _tabController, children: const [
              EmailMarketingTab(),
              SocialMediaMarketingTab()
            ])),
      ),
    );
  }
}
