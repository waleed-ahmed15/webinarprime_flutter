import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:webinarprime/controllers/webinar_management_controller.dart';
import 'package:webinarprime/utils/app_constants.dart';
import 'package:webinarprime/utils/styles.dart';

class CreateBannerDrawer extends StatelessWidget {
  final Function addnewTextWidget;
  final Function addnewImageWidget;
  bool customBanner;

  CreateBannerDrawer(
      {required this.customBanner,
      required this.addnewImageWidget,
      required this.addnewTextWidget,
      super.key});

  @override
  Widget build(BuildContext context) {
    print(customBanner);
    return Drawer(
      backgroundColor: const Color(0xff0A2647),
      child: ListView(
        children: customBanner
            ? [
                ListTile(
                  title: const Text('Add Text',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                  trailing: IconButton(
                    icon: const Icon(Icons.add),
                    color: Colors.white,
                    onPressed: () {
                      addnewTextWidget('Add new  text');
                      Scaffold.of(context).closeDrawer();
                    },
                  ),
                ),
                ListTile(
                  title: const Text(
                    "Add Custom Image",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.add),
                    color: Colors.white,
                    onPressed: () {
                      addnewImageWidget('', false);
                      Scaffold.of(context).closeDrawer();
                    },
                  ),
                )
              ]
            :
             [
                ListTile(
                  title: const Text('Title',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                  subtitle: Text(
                    WebinarManagementController.currentWebinar['name'],
                    style: listtileSubtitleStyle.copyWith(
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.add),
                    color: Colors.white,
                    onPressed: () {
                      print('object');
                      addnewTextWidget(
                          WebinarManagementController.currentWebinar['name']);
                      Scaffold.of(context).closeDrawer();
                    },
                  ),
                ),
                ListTile(
                  title: const Text("Date",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                  subtitle: Text(
                    WebinarManagementController.currentWebinar['datetime'],
                    style: listtileSubtitleStyle.copyWith(
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.add),
                    color: Colors.white,
                    onPressed: () {
                      addnewTextWidget(WebinarManagementController
                          .currentWebinar['datetime']);
                      Scaffold.of(context).closeDrawer();
                    },
                  ),
                ),
                ListTile(
                  title: const Text("Tagline",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                  subtitle: Text(
                    WebinarManagementController.currentWebinar['tagline'],
                    style: listtileSubtitleStyle.copyWith(
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.add),
                    color: Colors.white,
                    onPressed: () {
                      addnewTextWidget(WebinarManagementController
                          .currentWebinar['tagline']);
                      Scaffold.of(context).closeDrawer();
                    },
                  ),
                ),
                ListTile(
                  title: const Text("Description",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                  subtitle: Text(
                    WebinarManagementController.currentWebinar['description'],
                    style: listtileSubtitleStyle.copyWith(
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.add),
                    color: Colors.white,
                    onPressed: () {
                      addnewTextWidget(WebinarManagementController
                          .currentWebinar['description']);

                      //close the drawer
                      // Navigator.pop(context);
                      Scaffold.of(context).closeDrawer();
                    },
                  ),
                ),
                ListTile(
                  leading: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(AppConstants.baseURL +
                                WebinarManagementController
                                    .currentWebinar['bannerImage']),
                            fit: BoxFit.cover)),
                  ),
                  title: const Text("Banner Image",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                  trailing: IconButton(
                    icon: const Icon(Icons.add),
                    color: Colors.white,
                    onPressed: () {
                      addnewImageWidget(
                          WebinarManagementController
                              .currentWebinar['bannerImage'],
                          true);
                      Scaffold.of(context).closeDrawer();
                    },
                  ),
                ),
                const Gap(10),
                ListTile(
                  leading: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(AppConstants.baseURL +
                                WebinarManagementController
                                    .currentWebinar['coverImage']),
                            fit: BoxFit.cover)),
                  ),
                  title: const Text("Cover Image",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                  trailing: IconButton(
                    icon: const Icon(Icons.add),
                    color: Colors.white,
                    onPressed: () {
                      addnewImageWidget(
                          WebinarManagementController
                              .currentWebinar['coverImage'],
                          true);
                      Scaffold.of(context).closeDrawer();
                    },
                  ),
                ),
                ListTile(
                  title: const Text(
                    "Add Custom Image",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.add),
                    color: Colors.white,
                    onPressed: () {
                      addnewImageWidget('', false);
                      Scaffold.of(context).closeDrawer();
                    },
                  ),
                )
              ],
      
      
      ),
    );
  }
}
