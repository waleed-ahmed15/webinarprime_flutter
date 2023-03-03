import 'package:auto_size_text/auto_size_text.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:webinarprime/controllers/webinar_stream_controller.dart';
import 'package:webinarprime/screens/webinar_management/view_webinar_screen/review_widget.dart';
import 'package:webinarprime/utils/app_constants.dart';
import 'package:webinarprime/utils/colors.dart';
import 'package:webinarprime/utils/dimension.dart';
import 'package:webinarprime/utils/styles.dart';

class WebinarDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> webinarDetails;

  const WebinarDetailsScreen({super.key, required this.webinarDetails});

  @override
  State<WebinarDetailsScreen> createState() => _WebinarDetailsScreenState();
}

class _WebinarDetailsScreenState extends State<WebinarDetailsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late ScrollController _scrollController;
  bool _showTitle = false;
  var reviewController = TextEditingController();

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    _tabController = TabController(length: 4, vsync: this);

    super.initState();
  }

  void _scrollListener() {
    if (_scrollController.offset >= 400 && !_showTitle) {
      setState(() {
        _showTitle = true;
      });
    } else if (_scrollController.offset < 400 && _showTitle) {
      setState(() {
        _showTitle = false;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('webinarDetails: ${widget.webinarDetails}');
    return Scaffold(
      floatingActionButton: ElevatedButton(
          onPressed: () {
            print('start stream pressed');
            print('id: ${widget.webinarDetails['_id']}');
            Get.find<WebinarStreamController>()
                .startWebinarStream(widget.webinarDetails['_id'], context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.LTprimaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.r),
            ),
          ),
          child: Text(
            'Start Stream',
            style: TextStyle(
                color: Colors.white.withOpacity(.98),
                fontWeight: FontWeight.w600,
                fontSize: 15.sp,
                fontFamily: 'JosefinSans Bold'),
          )),
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              leading: IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
              ),
              iconTheme: IconThemeData(
                size: AppLayout.getHeight(30),
                color: Get.isDarkMode
                    ? Colors.white.withOpacity(0.98)
                    : const Color(0xff181b1f),
              ),
              collapsedHeight: AppLayout.getHeight(80),
              backgroundColor: Get.isDarkMode
                  ? const Color(0xff191919)
                  : const Color(0xffF7F8F8),
              expandedHeight: AppLayout.getHeight(480),
              flexibleSpace: FlexibleSpaceBar(
                title: _showTitle
                    ? Padding(
                        padding:
                            EdgeInsets.only(bottom: AppLayout.getHeight(40)),
                        child: Text(
                          '${widget.webinarDetails['name']}',
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: AppLayout.getHeight(20),
                            fontFamily: 'JosefinSans Regular',
                            fontWeight: FontWeight.w500,
                            color: Get.isDarkMode
                                ? Colors.white.withOpacity(0.98)
                                : const Color(0xff181b1f),
                          ),
                        ),
                      )
                    : null,
                background: Stack(
                  children: [
                    // The back ground image goes here
                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        height: AppLayout.getHeight(200),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(
                              AppConstants.baseURL +
                                  widget.webinarDetails['bannerImage'],
                            ),
                            fit: BoxFit.cover,
                          ),
                          color: Theme.of(context).scaffoldBackgroundColor,
                          boxShadow: [
                            BoxShadow(
                              offset: const Offset(0, 5),
                              blurRadius: 7,
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondary
                                  .withOpacity(0.1),
                            ),
                            BoxShadow(
                              offset: const Offset(0, -5),
                              blurRadius: 7,
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondary
                                  .withOpacity(0.1),
                            )
                          ],
                        ),
                        // child: Image.network(
                        //   AppConstants.baseURL +
                        //       widget.webinarDetails['bannerImage'],
                        //   fit: BoxFit.cover,
                        //   height: AppLayout.getHeight(250),
                        //   width: double.infinity,
                        // ),
                      ),
                    ),
                    Positioned(
                      top: AppLayout.getHeight(50.0),
                      left: AppLayout.getWidth(110.0),
                      child: Container(
                        width: AppLayout.getWidth(180),
                        height: AppLayout.getHeight(220),
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(AppLayout.getHeight(10)),
                          boxShadow: [
                            BoxShadow(
                              offset: const Offset(3, 3),
                              blurRadius: 4,
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondary
                                  .withOpacity(0.1),
                            ),
                            BoxShadow(
                              offset: const Offset(-3, -3),
                              blurRadius: 4,
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondary
                                  .withOpacity(0.1),
                            )
                          ],
                          image: DecorationImage(
                            image: NetworkImage(
                              AppConstants.baseURL +
                                  widget.webinarDetails['coverImage'],
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: AppLayout.getHeight(190.0),
                      left: AppLayout.getWidth(50),
                      child: SizedBox(
                        width: AppLayout.getWidth(300),
                        height: AppLayout.getHeight(35),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                '${widget.webinarDetails['datetime']} - ${widget.webinarDetails['duration']} Mins',
                                style: TextStyle(
                                  fontSize: AppLayout.getHeight(20),
                                  fontFamily: 'JosefinSans Bold',
                                  letterSpacing: 0.2,
                                  fontWeight: FontWeight.w500,
                                  color: const Color.fromRGBO(122, 121, 121, 1),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                        bottom: AppLayout.getHeight(80),
                        child: SizedBox(
                          // color: Colors.red,
                          height: AppLayout.getHeight(100),
                          width: AppLayout.getWidth(400),
                          child: AutoSizeText(
                            '${widget.webinarDetails['name']}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: AppLayout.getHeight(40),
                              fontFamily: 'JosefinSans Bold',
                              fontWeight: FontWeight.w700,
                              color: Get.isDarkMode
                                  ? Colors.white.withOpacity(0.98)
                                  : const Color(0xff181b1f),
                              overflow: TextOverflow.visible,
                            ),
                          ),
                        )),
                    Positioned(
                      bottom: AppLayout.getHeight(50),
                      child: SizedBox(
                        width: AppLayout.getScreenWidth(),
                        // color: Colors.yellow,
                        child: Center(
                          child: Text(
                            '${widget.webinarDetails['attendees'].length} people attending',
                            style: TextStyle(
                              fontSize: AppLayout.getHeight(16),
                              fontFamily: 'JosefinSans Bold',
                              fontWeight: FontWeight.w500,
                              color: Get.isDarkMode
                                  ? const Color.fromRGBO(74, 229, 239, 1)
                                  : const Color.fromRGBO(248, 79, 57, 1),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              pinned: true,
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(10.0),
                child: TabBar(
                  controller: _tabController,
                  indicatorWeight: 2.0,
                  indicatorColor: AppColors.LTprimaryColor,
                  unselectedLabelStyle: TextStyle(
                    fontSize: AppLayout.getHeight(10),
                    fontFamily: 'JosefinSans Bold',
                    fontWeight: FontWeight.w300,
                    color: Get.isDarkMode
                        ? Colors.white.withOpacity(0.8)
                        : Colors.black.withOpacity(0.9),
                  ),
                  tabs: [
                    Tab(
                      child: Text(
                        "About",
                        style: TextStyle(
                          letterSpacing: 1,
                          height: 1.5,
                          fontSize: AppLayout.getHeight(12),
                          fontFamily: 'JosefinSans Bold',
                          fontWeight: FontWeight.w600,
                          color: Get.isDarkMode
                              ? Colors.white.withOpacity(0.8)
                              : Colors.black.withOpacity(0.9),
                        ),
                      ),
                    ),
                    Tab(
                      child: FittedBox(
                        child: Text(
                          "Organizers",
                          style: TextStyle(
                            height: 1.5,
                            letterSpacing: 1,
                            fontSize: AppLayout.getHeight(12),
                            fontFamily: 'JosefinSans Bold',
                            fontWeight: FontWeight.w600,
                            color: Get.isDarkMode
                                ? Colors.white.withOpacity(0.8)
                                : Colors.black.withOpacity(0.9),
                          ),
                        ),
                      ),
                    ),
                    Tab(
                      child: Text(
                        "Guests",
                        style: TextStyle(
                          height: 1.5,
                          letterSpacing: 1,
                          fontSize: AppLayout.getHeight(12),
                          fontFamily: 'JosefinSans Bold',
                          fontWeight: FontWeight.w600,
                          color: Get.isDarkMode
                              ? Colors.white.withOpacity(0.8)
                              : Colors.black.withOpacity(0.9),
                        ),
                      ),
                    ),
                    Tab(
                      child: Text(
                        "Reviews",
                        style: TextStyle(
                          height: 1.5,
                          letterSpacing: 1,
                          fontSize: AppLayout.getHeight(12),
                          fontFamily: 'JosefinSans Bold',
                          fontWeight: FontWeight.w600,
                          color: Get.isDarkMode
                              ? Colors.white.withOpacity(0.8)
                              : Colors.black.withOpacity(0.9),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            // The content for the first tab goes here
            ListView(
              padding: EdgeInsets.symmetric(horizontal: AppLayout.getWidth(20)),
              physics: const NeverScrollableScrollPhysics(),
              children: [
                Gap(
                  AppLayout.getHeight(20),
                ),
                Text(
                  widget.webinarDetails['tagline'],
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      height: 1.5,
                      color: Get.isDarkMode
                          ? const Color(0xffA1a1aa)
                          : const Color(0xff475569),
                      fontSize: AppLayout.getHeight(20),
                      fontFamily: 'JosefinSans Regular'),
                ),
                Gap(
                  AppLayout.getHeight(20),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: AppLayout.getWidth(130),
                          height: AppLayout.getHeight(25),
                          child: AutoSizeText(
                            "\$ ${widget.webinarDetails['price']}",
                            maxLines: 1,
                            style: TextStyle(
                                fontFamily: 'JosefinSans Bold',
                                letterSpacing: 1,
                                fontWeight: FontWeight.w500,
                                color: Get.isDarkMode
                                    ? const Color.fromRGBO(212, 212, 216, 1)
                                    : const Color(0xff475569),
                                fontSize: AppLayout.getHeight(20)),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Gap(
                          AppLayout.getHeight(10),
                        ),
                        GestureDetector(
                          onTap: () async {
                            print('join now pressed');
                            await Get.find<WebinarStreamController>()
                                .joinStream(
                                    widget.webinarDetails['_id'], context);
                            print('join now pressed');
                          },
                          child: Container(
                            width: AppLayout.getWidth(130),
                            padding: EdgeInsets.symmetric(
                                horizontal: AppLayout.getWidth(5),
                                vertical: AppLayout.getHeight(10)),
                            decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    offset: const Offset(2, 2),
                                    blurRadius: 6,
                                    spreadRadius: 3,
                                  ),
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    offset: const Offset(-2, -2),
                                    blurRadius: 10,
                                    spreadRadius: 3,
                                  ),
                                ],
                                border: Border.all(
                                  color: Get.isDarkMode
                                      ? Colors.white.withOpacity(0.1)
                                      : Colors.black.withOpacity(0.1),
                                ),
                                borderRadius: BorderRadius.circular(10),
                                color: AppColors.LTprimaryColor),
                            child: Text(
                              widget.webinarDetails['price'] == 0
                                  ? 'Free'
                                  : 'join now',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white.withOpacity(.98),
                                  fontWeight: FontWeight.w600,
                                  fontSize: AppLayout.getHeight(20),
                                  fontFamily: 'JosefinSans Bold'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Gap(
                  AppLayout.getHeight(20),
                ),

                Gap(AppLayout.getHeight(20)),
                Text(
                  'Created By',
                  style: TextStyle(
                    letterSpacing: 1,
                    fontSize: AppLayout.getHeight(14),
                    color: Get.isDarkMode
                        ? const Color.fromRGBO(122, 121, 121, 1)
                        : const Color.fromRGBO(176, 179, 190, 1),
                    fontWeight: FontWeight.w700,
                    fontFamily: 'JosefinSans Bold',
                  ),
                ),
                Gap(AppLayout.getHeight(10)),
                Container(
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(AppLayout.getHeight(10)),
                    border: Border.all(
                      color: Get.isDarkMode
                          ? Colors.white.withOpacity(0.1)
                          : Colors.black.withOpacity(0.1),
                    ),
                    color: Get.isDarkMode ? Colors.black54 : Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        offset: const Offset(2, 2),
                        blurRadius: 6,
                        spreadRadius: 0,
                      ),
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.01),
                        offset: const Offset(-2, -2),
                        blurRadius: 7,
                      ),
                    ],
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: AppLayout.getHeight(30),
                      backgroundImage: NetworkImage(AppConstants.baseURL +
                          widget.webinarDetails['createdBy']['profile_image']),
                    ),
                    title: Text(
                      widget.webinarDetails['createdBy']['name'],
                      style: TextStyle(
                        height: 1.5,
                        fontSize: AppLayout.getHeight(16),
                        color: Get.isDarkMode
                            ? Colors.white.withOpacity(0.9)
                            : Colors.black.withOpacity(0.9),
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1,
                        fontFamily: 'JosefinSans Regular',
                      ),
                    ),
                    subtitle: Text(
                      widget.webinarDetails['createdBy']['email'],
                      style: TextStyle(
                        letterSpacing: 1,
                        fontSize: AppLayout.getHeight(14),
                        fontWeight: FontWeight.w500,
                        fontFamily: 'JosefinSans Medium',
                      ),
                    ),
                  ),
                ),
                Gap(AppLayout.getHeight(28)),
                Text(
                  'Catergories',
                  style: TextStyle(
                    letterSpacing: 1,
                    fontSize: AppLayout.getHeight(14),
                    color: Get.isDarkMode
                        ? const Color.fromRGBO(122, 121, 121, 1)
                        : const Color.fromRGBO(176, 179, 190, 1),
                    fontWeight: FontWeight.w700,
                    fontFamily: 'JosefinSans Bold',
                  ),
                ),
                Gap(AppLayout.getHeight(10)),
                // this is where the categories are handled and displayed
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Wrap(
                        children: List.generate(
                            widget.webinarDetails['categories'].length,
                            (index) {
                      return Container(
                        width: 120,
                        height: 60,
                        margin: const EdgeInsets.only(right: 30, bottom: 30),
                        padding: EdgeInsets.symmetric(
                            horizontal: AppLayout.getWidth(10),
                            vertical: AppLayout.getHeight(5)),
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              offset: const Offset(0, 2),
                              blurRadius: 4,
                              spreadRadius: 0,
                            ),
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              offset: const Offset(0, -2),
                              blurRadius: 4,
                            ),
                          ],
                          color: Get.isDarkMode
                              ? const Color.fromRGBO(38, 38, 38, 1)
                              : const Color.fromRGBO(243, 243, 244, 1),
                          border: Border.all(
                            color: Get.isDarkMode
                                ? Colors.white.withOpacity(0.1)
                                : Colors.black.withOpacity(0.1),
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: AutoSizeText(
                            widget.webinarDetails['categories'][index]['name'],
                            style: TextStyle(
                                fontFamily: 'JosefinSans Bold',
                                fontWeight: FontWeight.w500,
                                color: Get.isDarkMode
                                    ? const Color.fromRGBO(212, 212, 216, 1)
                                    : const Color(0xff475569),
                                fontSize: AppLayout.getHeight(17)),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    })),
                  ),
                ),
                Gap(AppLayout.getHeight(28)),
                Text(
                  'Description',
                  style: TextStyle(
                    letterSpacing: 1,
                    fontSize: AppLayout.getHeight(14),
                    color: Get.isDarkMode
                        ? const Color.fromRGBO(122, 121, 121, 1)
                        : const Color.fromRGBO(176, 179, 190, 1),
                    fontWeight: FontWeight.w700,
                    fontFamily: 'JosefinSans Bold',
                  ),
                ),
                Gap(AppLayout.getHeight(16)),
                ExpandableText(
                  widget.webinarDetails['description'],
                  expandText: 'Show more',
                  collapseText: 'Show less',
                  maxLines: 5,
                  linkColor: Colors.blue,
                  style: TextStyle(
                      height: 1.5,
                      fontFamily: 'JosefinSans Regular',
                      fontWeight: FontWeight.w500,
                      color: Get.isDarkMode
                          ? const Color(0xffa1a1aa)
                          : const Color(0xff475569),
                      fontSize: AppLayout.getHeight(17)),
                ),

                Gap(AppLayout.getHeight(28)),
                Text(
                  'Tags',
                  style: TextStyle(
                    letterSpacing: 1,
                    fontSize: AppLayout.getHeight(14),
                    color: Get.isDarkMode
                        ? const Color.fromRGBO(122, 121, 121, 1)
                        : const Color.fromRGBO(176, 179, 190, 1),
                    fontWeight: FontWeight.w700,
                    fontFamily: 'JosefinSans Bold',
                  ),
                ),

                Gap(AppLayout.getHeight(28)),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Wrap(
                        spacing: 10,
                        runSpacing: 15,
                        children: List.generate(
                            widget.webinarDetails['tags'].length, (index) {
                          return Container(
                            width: 90,
                            height: 50,
                            padding: EdgeInsets.symmetric(
                                horizontal: AppLayout.getWidth(10),
                                vertical: AppLayout.getHeight(5)),
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  offset: const Offset(0, 2),
                                  blurRadius: 4,
                                  spreadRadius: 0,
                                ),
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  offset: const Offset(0, -2),
                                  blurRadius: 4,
                                ),
                              ],
                              color: Get.isDarkMode
                                  ? const Color.fromRGBO(38, 38, 38, 1)
                                  : const Color.fromRGBO(243, 243, 244, 1),
                              border: Border.all(
                                color: Get.isDarkMode
                                    ? Colors.white.withOpacity(0.1)
                                    : Colors.black.withOpacity(0.1),
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: AutoSizeText(
                                widget.webinarDetails['tags'][index],
                                maxLines: 1,
                                style: TextStyle(
                                    fontFamily: 'JosefinSans Bold',
                                    fontWeight: FontWeight.w500,
                                    color: Get.isDarkMode
                                        ? const Color.fromRGBO(212, 212, 216, 1)
                                        : const Color(0xff475569),
                                    fontSize: AppLayout.getHeight(17)),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          );
                        })),
                  ),
                ),
              ],
            ),
            // The content for the second tab goes here==========================================
            ListView(
              padding: EdgeInsets.symmetric(horizontal: AppLayout.getWidth(20)),
              physics: const NeverScrollableScrollPhysics(),
              children: List.generate(
                widget.webinarDetails['organizers'].length,
                (index) => Container(
                  margin:
                      EdgeInsets.symmetric(vertical: AppLayout.getHeight(20)),
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(AppLayout.getHeight(10)),
                    border: Border.all(
                      color: Get.isDarkMode
                          ? Colors.white.withOpacity(0.1)
                          : Colors.black.withOpacity(0.1),
                    ),
                    color: Get.isDarkMode ? Colors.black54 : Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        offset: const Offset(2, 2),
                        blurRadius: 6,
                        spreadRadius: 0,
                      ),
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.01),
                        offset: const Offset(-2, -2),
                        blurRadius: 7,
                      ),
                    ],
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: AppLayout.getHeight(30),
                      backgroundImage: NetworkImage(AppConstants.baseURL +
                          widget.webinarDetails['organizers'][index]
                              ['profile_image']),
                    ),
                    title: Text(
                      widget.webinarDetails['organizers'][index]['name'],
                      style: TextStyle(
                        fontSize: AppLayout.getHeight(16),
                        color: Get.isDarkMode
                            ? Colors.white.withOpacity(0.9)
                            : Colors.black.withOpacity(0.9),
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1,
                        fontFamily: 'JosefinSans Regular',
                      ),
                    ),
                    subtitle: Text(
                      widget.webinarDetails['organizers'][index]['email'],
                      style: TextStyle(
                        letterSpacing: 1,
                        fontSize: AppLayout.getHeight(14),
                        fontWeight: FontWeight.w500,
                        fontFamily: 'JosefinSans Regular',
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // The content for the third tab goes here================================
            ListView(
              padding: EdgeInsets.symmetric(horizontal: AppLayout.getWidth(20)),
              physics: const NeverScrollableScrollPhysics(),
              children: List.generate(
                widget.webinarDetails['guests'].length,
                (index) => Container(
                  margin:
                      EdgeInsets.symmetric(vertical: AppLayout.getHeight(20)),
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(AppLayout.getHeight(10)),
                    border: Border.all(
                      color: Get.isDarkMode
                          ? Colors.white.withOpacity(0.1)
                          : Colors.black.withOpacity(0.1),
                    ),
                    color: Get.isDarkMode ? Colors.black54 : Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        offset: const Offset(2, 2),
                        blurRadius: 6,
                        spreadRadius: 0,
                      ),
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.01),
                        offset: const Offset(-2, -2),
                        blurRadius: 7,
                      ),
                    ],
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: AppLayout.getHeight(30),
                      backgroundImage: NetworkImage(AppConstants.baseURL +
                          widget.webinarDetails['guests'][index]
                              ['profile_image']),
                    ),
                    title: Text(
                      widget.webinarDetails['guests'][index]['name'],
                      style: TextStyle(
                        fontSize: AppLayout.getHeight(16),
                        color: Get.isDarkMode
                            ? Colors.white.withOpacity(0.9)
                            : Colors.black.withOpacity(0.9),
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1,
                        fontFamily: 'JosefinSans Regular',
                      ),
                    ),
                    subtitle: Text(
                      widget.webinarDetails['guests'][index]['email'],
                      style: TextStyle(
                        letterSpacing: 1,
                        fontSize: AppLayout.getHeight(14),
                        fontWeight: FontWeight.w500,
                        fontFamily: 'JosefinSans Regular',
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // The content for the ReviewsTab goes here
            ListView(
              physics: const ClampingScrollPhysics(),
              padding: EdgeInsets.symmetric(vertical: 20.w, horizontal: 20.h),
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextFormField(
                      style: Mystyles.onelineStyle,
                      onChanged: (value) {
                        setState(() {});
                      },
                      controller: reviewController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: 'Write a review. . .',
                        hintStyle: Mystyles.onelineStyle,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    Gap(10.h),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          fixedSize: Size(double.maxFinite, 10.h),
                        ),
                        onPressed: reviewController.text.toString() == ""
                            ? null
                            : () {},
                        child: const Text('Submit')),
                  ],
                ),
                Gap(20.h),
                Divider(
                  color: Mystyles.onelineStyle.color,
                  thickness: 1,
                ),
                Gap(10.h),
                MyReviewWidget(),
              ],
            )
          ],
        ),
      ),
    );
  }
}
