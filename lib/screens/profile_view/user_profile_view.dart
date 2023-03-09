import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:webinarprime/controllers/auth_controller.dart';
import 'package:webinarprime/screens/profile_view/space_bar_widget.dart';
import 'package:webinarprime/screens/profile_view/tabBar_view_profile_view.dart';
import 'package:webinarprime/screens/profile_view/tabs_widget.dart';
import 'package:webinarprime/utils/styles.dart';

class UserProfileView extends StatefulWidget {
  const UserProfileView({super.key});

  @override
  State<UserProfileView> createState() => _UserProfileViewState();
}

class _UserProfileViewState extends State<UserProfileView>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late ScrollController _scrollController;
  bool _showTitle = false;

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    _tabController = TabController(length: 4, vsync: this);
    // TODO: implement initState

    super.initState();
  }

  void _scrollListener() {
    if (_scrollController.offset >= 200 && !_showTitle) {
      setState(() {
        _showTitle = true;
      });
    } else if (_scrollController.offset < 200 && _showTitle) {
      setState(() {
        _showTitle = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: (AuthController.otherUserProfile['_id'] ==
                Get.find<AuthController>().currentUser['_id'])
            ? FloatingActionButton(
                onPressed: () {},
                child: const Icon(Icons.edit),
              )
            : null,
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
                title: _showTitle
                    ? Text(AuthController.otherUserProfile['name'],
                        style: Mystyles.listtileTitleStyle.copyWith(
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white))
                    : null,
                flexibleSpace: const SpaceBarForProfileView(),
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(10.0),
                  child: TabBarForProfileView(_tabController),
                ),
              ),
            ];
          },
          body: TabbarViewForProfileView(tabController: _tabController),
        ),
      ),
    );
  }
}
