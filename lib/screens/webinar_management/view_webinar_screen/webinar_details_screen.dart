import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:webinarprime/utils/app_constants.dart';
import 'package:webinarprime/utils/dimension.dart';
import 'package:webinarprime/widgets/expandable_text.dart';

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
      backgroundColor:
          Get.isDarkMode ? const Color(0xff191919) : const Color(0xffF7F8F8),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print('hrreer');
          print(widget.webinarDetails['datetime']);
          Get.isDarkMode
              ? Get.changeThemeMode(ThemeMode.light)
              : Get.changeThemeMode(ThemeMode.dark);
        },
        child: const Icon(Icons.play_arrow),
      ),
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
                            fontFamily: 'JosefinSans',
                            fontWeight: FontWeight.w400,
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
                      top: 50.0,
                      left: 100.0,
                      child: Container(
                        width: 180,
                        height: 220,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
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
                      bottom: 190.0,
                      left: 50,
                      child: SizedBox(
                        width: 300,
                        height: 35,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                '${widget.webinarDetails['datetime']} -- ${widget.webinarDetails['duration']} Mins',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'JosefinSans',
                                  fontWeight: FontWeight.w500,
                                  color: Color.fromRGBO(122, 121, 121, 1),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                        bottom: 80,
                        child: SizedBox(
                          // color: Colors.red,
                          height: 100,
                          width: 400,
                          child: AutoSizeText(
                            '${widget.webinarDetails['name']}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 40,
                              fontFamily: 'JosefinSans',
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
                              fontFamily: 'JosefinSans',
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
                  indicator: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.blue, width: 2.0),
                    ),
                  ),
                  controller: _tabController,
                  tabs: [
                    Tab(
                      child: Text(
                        "About",
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'JosefinSans ',
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
                            fontSize: 14,
                            fontFamily: 'JosefinSans ',
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
                          fontSize: 14,
                          fontFamily: 'JosefinSans ',
                          fontWeight: FontWeight.w600,
                          color: Get.isDarkMode
                              ? Colors.white.withOpacity(0.8)
                              : Colors.black.withOpacity(0.9),
                        ),
                      ),
                    ),
                    Tab(
                      child: Text(
                        "Guests 2",
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'JosefinSans ',
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
              padding: const EdgeInsets.symmetric(horizontal: 20),
              physics: const NeverScrollableScrollPhysics(),
              children: [
                Gap(
                  AppLayout.getHeight(20),
                ),
                Text(
                  widget.webinarDetails['tagline'],
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      color: Get.isDarkMode
                          ? const Color(0xffA1a1aa)
                          : const Color(0xff475569),
                      fontSize: 20,
                      fontFamily: 'JosefinSans'),
                ),
                Gap(
                  AppLayout.getHeight(20),
                ),
                // Wrap(
                //     children: List.generate(
                //         widget.webinarDetails['tags'].length, (index) {
                //   return Container(
                //     margin: const EdgeInsets.only(right: 10),
                //     padding: EdgeInsets.symmetric(
                //         horizontal: AppLayout.getWidth(10),
                //         vertical: AppLayout.getHeight(5)),
                //     decoration: BoxDecoration(
                //         borderRadius: BorderRadius.circular(5),
                //         color: Colors.deepOrange.withOpacity(0.88)),
                //     child: Text(
                //       widget.webinarDetails['tags'][index],
                //       style: const TextStyle(
                //           fontFamily: 'JosefinSans ',
                //           color: Colors.white,
                //           fontSize: 12),
                //     ),
                //   );
                // })),
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
                        fontSize: AppLayout.getHeight(16),
                        color: Get.isDarkMode
                            ? Colors.white.withOpacity(0.9)
                            : Colors.black.withOpacity(0.9),
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1,
                        fontFamily: 'JosefinSans',
                      ),
                    ),
                    subtitle: Text(
                      widget.webinarDetails['createdBy']['email'],
                      style: TextStyle(
                        letterSpacing: 1,
                        fontSize: AppLayout.getHeight(14),
                        color: Get.isDarkMode
                            ? Colors.white.withOpacity(0.9)
                            : Colors.black.withOpacity(0.9),
                        fontWeight: FontWeight.w500,
                        fontFamily: 'JosefinSans',
                      ),
                    ),
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
                ExpandableText(text: widget.webinarDetails['description']),
              ],
            ),
            // The content for the second tab goes here
            const Center(
              child: Text("Content for Tab 2"),
            ),
            // The content for the third tab goes here
            const Center(
              child: Text("Content for Tab 3"),
            ),
            // The content for the fourth tab goes here
            const Center(
              child: Text("Content for Tab 4"),
            ),
          ],
        ),
        // controller: _scrollController,
      ),
    );
  }
}
