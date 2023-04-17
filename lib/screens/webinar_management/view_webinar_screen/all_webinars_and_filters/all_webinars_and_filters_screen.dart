import 'package:flutter/material.dart';
import 'package:webinarprime/controllers/webinar_management_controller.dart';
import 'package:webinarprime/screens/home_screen/widgets/webinar_dynamic_tile.dart';
import 'package:webinarprime/screens/webinar_management/view_webinar_screen/all_webinars_and_filters/filters_drawer.dart';

class ShowAllWebinarScreen extends StatefulWidget {
  const ShowAllWebinarScreen({super.key});

  @override
  State<ShowAllWebinarScreen> createState() => _ShowAllWebinarScreenState();
}

class _ShowAllWebinarScreenState extends State<ShowAllWebinarScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      key: scaffoldKey,
      endDrawer: FilterDrawer(onSortOptionSelected: (String value) {
      
      }),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back_ios),
                  ),
                  const Center(
                    child: Text(
                      'All Webinars',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              IconButton(
                onPressed: () {
                  scaffoldKey.currentState!.openEndDrawer();
                },
                icon: const Icon(Icons.filter_list),
              ),
            ],
          ),
          const Divider(
            thickness: 1,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: WebinarManagementController.webinarsList.length,
              itemBuilder: (BuildContext context, int index) {
                return WebinarDynamicInfoTile(
                    webinar: WebinarManagementController.webinarsList[index]);
              },
            ),
          ),
        ],
      ),
    ));
  }
}
