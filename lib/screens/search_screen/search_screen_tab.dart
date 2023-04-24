import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:webinarprime/controllers/webinar_management_controller.dart';
import 'package:webinarprime/screens/home_screen/widgets/webinar_dynamic_tile.dart';
import 'package:webinarprime/screens/search_screen/categories_list.dart';
import 'package:webinarprime/utils/colors.dart';

class SearchScreenTab extends StatefulWidget {
  const SearchScreenTab({super.key});

  @override
  State<SearchScreenTab> createState() => _SearchScreenTabState();
}

class _SearchScreenTabState extends State<SearchScreenTab> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  //controller for search field
  TextEditingController searchController = TextEditingController();
  String _sortOption = 'A-Z';
  bool _isAscending = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [Container()],
          titleSpacing: 0,
          automaticallyImplyLeading: false,
          title: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: TextFormField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Search...',
                  hintStyle: Theme.of(context)
                      .textTheme
                      .displayMedium!
                      .copyWith(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 3),
                  suffixIcon: IconButton(
                      onPressed: () async {
                        if (searchController.text.trim().isEmpty) {
                          return;
                        }
                        await Get.find<WebinarManagementController>()
                            .getsearchedWebinars(searchController.text.trim());
                        setState(() {});
                      },
                      icon: Icon(
                        Icons.search,
                        color: Theme.of(context).textTheme.bodyLarge!.color,
                      )),
                )),
          ),
        ),
        key: scaffoldKey,
        // endDrawer: const Drawer(),
        // endDrawerEnableOpenDragGesture: false,
        endDrawer: Drawer(
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          width: 0.7.sw,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // SizedBox(
              //   height: 100.h,
              //   child: const DrawerHeader(
              //     decoration: BoxDecoration(
              //       color: Colors.transparent,
              //     ),
              //     child: Center(
              //       child: Text(
              //         '',
              //         style: TextStyle(
              //           fontSize: 18,
              //           color: Colors.white,
              //         ),
              //       ),
              //     ),
              //   ),
              // ),

              ListTile(
                title: const Text('A-Z'),
                leading: Radio(
                  value: 'A-Z',
                  groupValue: _sortOption,
                  activeColor: Get.isDarkMode
                      ? AppColors.LTsecondaryColor
                      : AppColors.LTprimaryColor,
                  onChanged: (value) {
                    _isAscending = true;
                    setState(() {
                      _sortOption = value.toString();
                      WebinarManagementController.searchedWebinars
                          .sort((a, b) => a['name'].compareTo(b['name']));
                    });
                    // widget.onSortOptionSelected(value.toString());
                  },
                ),
              ),
              ListTile(
                title: const Text('Date'),
                leading: Radio(
                  value: 'Date',
                  groupValue: _sortOption,
                  activeColor: Get.isDarkMode
                      ? AppColors.LTsecondaryColor
                      : AppColors.LTprimaryColor,
                  onChanged: (value) {
                    setState(() {
                      _sortOption = value.toString();
                      _isAscending = false;

                      if (value == 'Date') {
                        WebinarManagementController.searchedWebinars.sort(
                            (a, b) => DateTime.parse(a['datetime'])
                                .compareTo(DateTime.parse(b['datetime'])));
                        if (!_isAscending) {
                          WebinarManagementController.searchedWebinars =
                              WebinarManagementController
                                  .searchedWebinars.reversed
                                  .toList();
                          //  =
                          // WebinarManagementController.searchedWebinars.reversed
                          // .toList();
                        }
                        // setState(() {});
                      }
                    });
                    // widget.onSortOptionSelected(value.toString(), _isAscending);
                  },
                ),
              ),
              ListTile(
                title: const Text('Price'),
                leading: Radio(
                  value: 'Price',
                  activeColor: Get.isDarkMode
                      ? AppColors.LTsecondaryColor
                      : AppColors.LTprimaryColor,
                  groupValue: _sortOption,
                  onChanged: (value) {
                    setState(() {
                      _sortOption = value.toString();
                      _isAscending = true;

                      WebinarManagementController.searchedWebinars
                          .sort((a, b) => a['price'].compareTo(b['price']));
                      //     setState(() {});
                    });
                    // widget.onSortOptionSelected(value.toString());
                  },
                ),
              ),
              ListTile(
                title: const Text('Duration'),
                leading: Radio(
                  value: 'Duration',
                  groupValue: _sortOption,
                  activeColor: Get.isDarkMode
                      ? AppColors.LTsecondaryColor
                      : AppColors.LTprimaryColor,
                  onChanged: (value) {
                    _sortOption = value.toString();
                    _isAscending = true;

                    WebinarManagementController.searchedWebinars.sort((a, b) =>
                        int.parse(a['duration'])
                            .compareTo(int.parse(b['duration'])));
                    if (!_isAscending) {
                      WebinarManagementController.searchedWebinars.reversed
                          .toList();
                      //  =
                      // WebinarManagementController.searchedWebinars.reversed
                      // .toList();
                    }
                    setState(() {});

                    // widget.onSortOptionSelected(value.toString());
                  },
                ),
              ),
              const Divider(),
              Gap(40.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Gap(10.w),
                  const Text("Acsending Order"),
                  const Spacer(),
                  Switch(
                    splashRadius: 0,
                    dragStartBehavior: DragStartBehavior.start,
                    activeColor: Get.isDarkMode
                        ? AppColors.LTsecondaryColor.withOpacity(0.7)
                        : AppColors.LTprimaryColor.withOpacity(0.7),
                    value: _isAscending,
                    onChanged: (value) async {
                      setState(() {
                        _isAscending = value;
                        print(_isAscending);
                        WebinarManagementController.searchedWebinars =
                            WebinarManagementController
                                .searchedWebinars.reversed
                                .toList();
                      });
                    },
                  ),
                ],
              )
            ],
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            IconButton(
              onPressed: () {
                scaffoldKey.currentState!.openEndDrawer();
              },
              icon: const Icon(Icons.filter_list),
            ),
            // categoryList in horizontal scroll
            SizedBox(height: 40.h, child: const TextBoxList()),
            GetBuilder<WebinarManagementController>(builder: (ww) {
              return Expanded(
                child: WebinarManagementController.searchedWebinars.isEmpty
                    ? Center(
                        child: Text('Search for webinars',
                            style: Theme.of(context).textTheme.bodyLarge),
                      )
                    : Column(
                        children: [
                          // const SearchFieldForSearchScreen(),

                          // Gap(5.h),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.end,
                          //   children: [
                          //     GestureDetector(
                          //       onTap: () {
                          //         // scaffoldKey.currentState!.openEndDrawer();
                          //         Get.to(() => const ShowAllWebinarScreen());
                          //       },
                          //       child: Text(
                          //         'View all',
                          //         style: Theme.of(context)
                          //             .textTheme
                          //             .displayMedium!
                          //             .copyWith(
                          //               color: Colors.blueAccent,
                          //               fontSize: 15.sp,
                          //               fontWeight: FontWeight.w500,
                          //             ),
                          //       ),
                          //     ),
                          //     Gap(5.w),
                          //   ],
                          // ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Text(
                                  'Search Results',
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayMedium!
                                      .copyWith(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),
                                ),
                              ),
                            ],
                          ),

                          Expanded(
                            child: ListView.builder(
                                itemCount: WebinarManagementController
                                    .searchedWebinars.length,
                                itemBuilder: (context, index) {
                                  return WebinarDynamicInfoTile(
                                      webinar: WebinarManagementController
                                          .searchedWebinars[index]);
                                }),
                          )
                        ],
                      ),
              );
            }),
          ],
        ));
  }
}
