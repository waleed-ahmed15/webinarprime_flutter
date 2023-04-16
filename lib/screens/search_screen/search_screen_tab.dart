import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:webinarprime/controllers/webinar_management_controller.dart';
import 'package:webinarprime/screens/home_screen/widgets/webinar_dynamic_tile.dart';
import 'package:webinarprime/screens/search_screen/search_field.dart';
import 'package:webinarprime/screens/webinar_management/view_webinar_screen/all_webinars_and_filters/all_webinars_and_filters_screen.dart';

class SearchScreenTab extends StatefulWidget {
  const SearchScreenTab({super.key});

  @override
  State<SearchScreenTab> createState() => _SearchScreenTabState();
}

class _SearchScreenTabState extends State<SearchScreenTab> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    List<String> suggestons = [
      "USA",
      "UK",
      "Uganda",
      "Uruguay",
      "United Arab Emirates"
    ];
    return Scaffold(
        key: scaffoldKey,
        // endDrawer: const Drawer(),
        body: Column(
          children: [
            const SearchFieldForSearchScreen(),
            Gap(5.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    // scaffoldKey.currentState!.openEndDrawer();
                    Get.to(() => const ShowAllWebinarScreen());
                  },
                  child: Text(
                    'View all',
                    style: Theme.of(context).textTheme.displayMedium!.copyWith(
                          color: Colors.blueAccent,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ),
                Gap(5.w),
                // TextButton(
                //   onPressed: () {},
                //   child: Text(
                //     'View all',
                //     style: Theme.of(context).textTheme.displayMedium!.copyWith(
                //           color: Colors.blueAccent,
                //           fontSize: 15.sp,
                //           fontWeight: FontWeight.w500,
                //         ),
                //   ),
                // ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    'Recommendations for you',
                    style: Theme.of(context).textTheme.displayMedium!.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ),
                // view all webinars text

                // SizedBox(
                //   height: 30,
                //   child: IconButton(
                //       onPressed: () {
                //         Scaffold.of(context).openEndDrawer();
                //       },
                //       icon: const Icon(Icons.filter_list)),
                // ),
              ],
            ),
            // Gap(10.h),

            Expanded(
              child: ListView.builder(
                  itemCount: WebinarManagementController.webinarsList.length > 4
                      ? 4
                      : WebinarManagementController.webinarsList.length,
                  itemBuilder: (context, index) {
                    return WebinarDynamicInfoTile(
                        webinar: WebinarManagementController.webinarsList[index]
                        // title: Text(suggestons[index]),
                        );
                  }),
            )
          ],
        ));
  }
}
