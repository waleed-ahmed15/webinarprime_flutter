import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:webinarprime/utils/colors.dart';
import 'package:webinarprime/utils/dimension.dart';

class TabBarForProfileView extends StatefulWidget {
  final TabController tabController;
  const TabBarForProfileView(this.tabController, {super.key});

  @override
  State<TabBarForProfileView> createState() => _TabBarForProfileViewState();
}

class _TabBarForProfileViewState extends State<TabBarForProfileView> {
  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: widget.tabController,
      indicatorWeight: 2.0,
      indicatorColor: AppColors.LTprimaryColor,
      unselectedLabelStyle: TextStyle(
          fontSize: AppLayout.getHeight(12.sp),
          fontFamily: 'JosefinSans Bold',
          fontWeight: FontWeight.w300,
          color: Colors.white),
      tabs: [
        Tab(
          child: Text(
            "Created",
            style: TextStyle(
              letterSpacing: 1,
              height: 1.5,
              fontSize: AppLayout.getHeight(12.sp),
              fontFamily: 'JosefinSans Bold',
              fontWeight: FontWeight.w600,
              color: Colors.white.withOpacity(1),
            ),
          ),
        ),
        Tab(
          child: FittedBox(
            child: Text(
              "Organized",
              style: TextStyle(
                height: 1.5,
                letterSpacing: 1,
                fontSize: AppLayout.getHeight(12.sp),
                fontFamily: 'JosefinSans Bold',
                fontWeight: FontWeight.w600,
                color: Colors.white.withOpacity(1),
              ),
            ),
          ),
        ),
        Tab(
          child: Text(
            "Guest",
            style: TextStyle(
              height: 1.5,
              letterSpacing: 1,
              fontSize: AppLayout.getHeight(12.sp),
              fontFamily: 'JosefinSans Bold',
              fontWeight: FontWeight.w600,
              color: Colors.white.withOpacity(1),
            ),
          ),
        ),
        Tab(
          child: Text(
            "Attended",
            style: TextStyle(
              height: 1.5,
              letterSpacing: 1,
              fontSize: AppLayout.getHeight(12.sp),
              fontFamily: 'JosefinSans Bold',
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
