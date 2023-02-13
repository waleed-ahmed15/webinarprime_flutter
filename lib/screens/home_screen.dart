import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webinarprime/controllers/auth_controller.dart';
import 'package:webinarprime/controllers/webinar_management_controller.dart';
import 'package:webinarprime/routes/routes.dart';
import 'package:webinarprime/screens/profile_sceen/profile_screen.dart';
import 'package:webinarprime/utils/app_constants.dart';
import 'package:webinarprime/utils/app_fonts.dart';
import 'package:webinarprime/utils/colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;
  bool isOrganizer = false;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.w600);
  static TextStyle listTile_text_Style = TextStyle(
      letterSpacing: 2,
      fontFamily: 'Montserrat-Bold',
      fontWeight: FontWeight.w300,
      fontSize: 18,
      color: Theme.of(Get.context!).colorScheme.secondary);

  static final List<Widget> _widgetOptions = <Widget>[
    const Text(
      'Home11',
      style: TextStyle(
        fontFamily: AppFont.jsLight,
        fontSize: 30,
        color: Colors.red,
      ),
    ),

    const Text(
      'Likes',
      style: optionStyle,
    ),
    const Text(
      'Search',
      style: optionStyle,
    ),
    const Text(
      'Chat',
      style: optionStyle,
    ),
  ];
  @override
  Widget build(BuildContext context) {
    SharedPreferences sharedPreferences = Get.find();
    AuthController authController = Get.find();
    // authController
    // .authenticateUser(sharedPreferences.getString('token') != null);
    // print(authController.currentUser);
    // print('hereauth');

    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                    color: AppColors.LTprimaryColor.withOpacity(0.8)),
                child: GetBuilder<AuthController>(builder: (controller) {
                  return ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(Get.find<AuthController>()
                                  .currentUser['profile_image'][0] ==
                              'h'
                          ? Get.find<AuthController>()
                              .currentUser['profile_image']
                          : AppConstants.baseURL +
                              Get.find<AuthController>()
                                  .currentUser['profile_image']),
                    ),
                    title: Text(Get.find<AuthController>().currentUser['name'],
                        style: listTile_text_Style),
                    subtitle: Text(
                      Get.find<AuthController>().currentUser['email'],
                      style: listTile_text_Style,
                    ),
                  );
                }),
              ),
              Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.person),
                    title: GestureDetector(
                      onTap: () {
                        Get.to(() => const ProfileScreen());
                      },
                      child: Text(
                        'Profile',
                        style: listTile_text_Style.copyWith(
                            color: Theme.of(context).colorScheme.secondary),
                      ),
                    ),
                    onTap: () {
                      // Update the state of the app.
                      // ...
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.notifications),
                    title: Text(
                      'Notifications',
                      style: listTile_text_Style.copyWith(
                          color: Theme.of(context).colorScheme.secondary),
                    ),
                    onTap: () {
                      // Update the state of the app.
                      // ...
                    },
                  ),
                  ListTile(
                    leading:
                        authController.currentUser['accountType'] == 'organizer'
                            ? const Icon(Icons.add)
                            : const Icon(Icons.mail),
                    title: authController.currentUser['accountType'] ==
                            'organizer'
                        ? Text(
                            'Create new webinar',
                            style: listTile_text_Style.copyWith(
                                color: Theme.of(context).colorScheme.secondary),
                          )
                        : Text(
                            'Apply for organizer',
                            style: listTile_text_Style.copyWith(
                                color: Theme.of(context).colorScheme.secondary),
                          ),
                    onTap: () {
                      // Update the state of the app.
                      if (authController.currentUser['accountType'] ==
                          'organizer') {
                        Get.toNamed(RoutesHelper.addWebinarScreen1route);
                      } else {
                        print('apply for organizer');
                        // Get.toNamed(RoutesHelper.applyForOrganizerRoute);
                      }
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.web),
                    title: Text(
                      'My Webinars',
                      style: listTile_text_Style.copyWith(
                          color: Theme.of(context).colorScheme.secondary),
                    ),
                    onTap: () {
                      // Update the state of the app.
                      if (authController.currentUser['accountType'] ==
                          'organizer') {
                        // print(Get.find<AuthController>().currentUser['id']);
                        Get.put(WebinarManagementController());
                        Get.toNamed('view-my-webinars');
                        print(
                            'go to route that shows my webinars as organizer');
                        // Get.toNamed(RoutesHelper.addWebinarScreen1route);
                      } else {
                        print('apply for organizer');
                        // Get.toNamed(RoutesHelper.applyForOrganizerRoute);
                      }
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.settings),
                    title: Text(
                      'Settings',
                      style: TextStyle(
                          letterSpacing: 2,
                          fontFamily: 'Montserrat-Bold',
                          fontWeight: FontWeight.w300,
                          fontSize: 18,
                          color: Theme.of(context).colorScheme.secondary),
                    ),
                    onTap: () {
                      // Update the state of the app.
                      print('setting');
                      // ...
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.logout),
                    title: Text(
                      'Logout',
                      style: TextStyle(
                          letterSpacing: 2,
                          fontFamily: 'Montserrat-Bold',
                          fontWeight: FontWeight.w300,
                          fontSize: 18,
                          color: Theme.of(context).colorScheme.secondary),
                    ),
                    onTap: () {
                      // Update the state of the app.
                      // ...
                      print('logout');
                      Get.find<AuthController>().logout();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        // backgroundColor: Colors.white,

        appBar: AppBar(
          title: Text(
            "Home",
            style: TextStyle(color: Theme.of(context).colorScheme.secondary),
          ),
          centerTitle: true,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
          // backgroundColor: AppColors.LTprimaryColor.withOpacity(0.8),
          leading: IconButton(
            icon: Icon(
              Icons.menu_sharp,
              size: 30,
              color: AppColors.LTprimaryColor,
            ),
            onPressed: () {
              SharedPreferences sharedPreferences = Get.find();
              AuthController authController = Get.find();
              authController.authenticateUser(
                  sharedPreferences.getString('token') != null);
              print(authController.currentUser);
              print('hereauth1111');
              if (scaffoldKey.currentState!.isDrawerOpen) {
                scaffoldKey.currentState!.closeDrawer();
                //close drawer, if drawer is open
              } else {
                scaffoldKey.currentState!.openDrawer();
                //open drawer, if drawer is closed
              }
            },
          ),
        ),
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: AppColors.LTprimaryColor.withOpacity(1),
            // boxShadow: [
            //   BoxShadow(
            //     blurRadius: 20,
            //     color: Colors.black.withOpacity(.1),
            //   )
            // ],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
              child: GNav(
                rippleColor: Colors.grey[300]!,
                gap: 8,
                activeColor: Colors.black,
                iconSize: 24,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                // duration: const Duration(milliseconds: 400),
                tabBackgroundColor: Colors.grey[100]!,
                // color: Colors.black,
                tabs: const [
                  GButton(
                    icon: Icons.home,
                    text: 'Home',
                  ),
                  GButton(
                    icon: Icons.favorite,
                    text: 'Likes',
                  ),
                  GButton(
                    icon: Icons.search,
                    text: 'Search',
                  ),
                  GButton(
                    icon: Icons.chat_outlined,
                    text: 'Chat',
                  ),
                ],
                selectedIndex: _selectedIndex,
                onTabChange: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
