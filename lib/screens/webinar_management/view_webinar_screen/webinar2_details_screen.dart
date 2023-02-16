import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:webinarprime/utils/app_constants.dart';
import 'package:webinarprime/utils/dimension.dart';

class WebinarDetailsScreen2 extends StatelessWidget {
  final Map<String, dynamic> webinarDetails;

  const WebinarDetailsScreen2({super.key, required this.webinarDetails});

  @override
  Widget build(BuildContext context) {
    print('webinarDetails: $webinarDetails');

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.isDarkMode
              ? Get.changeThemeMode(ThemeMode.light)
              : Get.changeThemeMode(ThemeMode.dark);
        },
        child: const Icon(Icons.play_arrow),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: Colors.red,
            iconTheme: IconThemeData(
                color: Get.isDarkMode ? Colors.white : Colors.black),
            centerTitle: true,
            // backgroundColor: Get.isDarkMode
            //     ? const Color(0xff222b32)
            //     : const Color(0xffe7f0f7),

            expandedHeight: 200,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                '${webinarDetails['name']}',
                textAlign: TextAlign.start,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: AppLayout.getHeight(20),
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w400,
                    color: Get.isDarkMode
                        ? Colors.white.withOpacity(0.98)
                        : const Color(0xff181b1f)),
              ),
              background: Image.network(
                AppConstants.baseURL + webinarDetails['bannerImage'],
                fit: BoxFit.cover,
              ),
            ),
            // floating: true,
            pinned: true,
            snap: false,
          ),
          SliverToBoxAdapter(
            child: Container(
              color: Get.isDarkMode ? const Color(0xff181c1f) : Colors.white,
              padding: EdgeInsets.only(
                left: AppLayout.getWidth(10),
                right: AppLayout.getWidth(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: AppLayout.getHeight(10),
                  ),
                  SizedBox(
                    height: AppLayout.getHeight(35),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: webinarDetails['categories'].length,
                      itemBuilder: (context, index) {
                        return Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: Colors.blueGrey),
                          child: Text(
                            webinarDetails['categories'][index]['name'],
                            overflow: TextOverflow.visible,
                            style: const TextStyle(
                              color: Colors.white,
                              fontFamily: 'JosefinSans',
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Gap(
                    AppLayout.getHeight(14),
                  ),
                  Text(
                    overflow: TextOverflow.fade,
                    '${webinarDetails['name']}',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontFamily: 'JosefinSans SemiBold',
                      fontSize: AppLayout.getHeight(25),
                    ),
                  ),
                  Gap(
                    AppLayout.getHeight(10),
                  ),
                  Text(
                    webinarDetails['tagline'],
                    textAlign: TextAlign.start,
                    textDirection: TextDirection.ltr,
                    style: TextStyle(
                        color: Get.isDarkMode
                            ? Colors.white.withOpacity(0.9)
                            : Colors.grey[600],
                        fontSize: 14,
                        fontFamily: 'JosefinSans'),
                  ),
                  Gap(
                    AppLayout.getHeight(20),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Icon(
                            Icons.calendar_month_outlined,
                            size: 25,
                            color: Get.isDarkMode
                                ? Colors.white.withOpacity(0.8)
                                : Colors.black54,
                          ),
                          const Gap(5),
                          Text(
                            'Date: 12/12/2021',
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'JosefinSans SemiBold',
                              fontWeight: FontWeight.w500,
                              color: Get.isDarkMode
                                  ? Colors.white.withOpacity(0.8)
                                  : Colors.black54,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 25,
                            color: Get.isDarkMode
                                ? Colors.white.withOpacity(0.8)
                                : Colors.black54,
                          ),
                          Gap(AppLayout.getWidth(5)),
                          Text(
                            webinarDetails['duration'] + ' mins',
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'JosefinSans SemiBold',
                              fontWeight: FontWeight.w500,
                              color: Get.isDarkMode
                                  ? Colors.white.withOpacity(0.8)
                                  : Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Gap(
                    AppLayout.getHeight(20),
                  ),
                  Row(
                    children: const [],
                  ),
                  Text(
                    "Organizers",
                    style: TextStyle(
                      letterSpacing: 2,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'JosefinSans',
                      fontSize: AppLayout.getHeight(18),
                    ),
                  ),
                  Gap(
                    AppLayout.getHeight(10),
                  ),
                  SizedBox(
                    width: 200,
                    height: 100,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: webinarDetails['organizers']
                          .map<Widget>((organizer) => Column(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(right: 10),
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                        image: NetworkImage(
                                          AppConstants.baseURL +
                                              organizer['profile_image'],
                                        ),
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                  Gap(
                                    AppLayout.getHeight(10),
                                  ),
                                ],
                              ))
                          .toList(),
                    ),
                  ),
                  Gap(
                    AppLayout.getHeight(10),
                  ),
                  Text(
                    "Guests",
                    style: TextStyle(
                      letterSpacing: 2,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'JosefinSans',
                      fontSize: AppLayout.getHeight(18),
                    ),
                  ),
                  1 + 1 == 12
                      ? const Text('data')
                      : SizedBox(
                          width: 200,
                          height: 100,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: webinarDetails['organizers']
                                .map<Widget>((organizer) => Column(
                                      children: [
                                        Container(
                                          margin:
                                              const EdgeInsets.only(right: 10),
                                          width: 80,
                                          height: 80,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            image: DecorationImage(
                                              image: NetworkImage(
                                                AppConstants.baseURL +
                                                    organizer['profile_image'],
                                              ),
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ),
                                        Gap(
                                          AppLayout.getHeight(10),
                                        ),
                                      ],
                                    ))
                                .toList(),
                          ),
                        ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return ListTile(
                  title: Text('Item $index'),
                );
              },
              childCount: 50,
            ),
          ),
        ],
      ),
    );
  }
}
