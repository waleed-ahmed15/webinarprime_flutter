import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
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
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:webinarprime/utils/dimension.dart';
import 'package:webinarprime/utils/styles.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final IO.Socket _socket = IO.io(AppConstants.baseURL,
      IO.OptionBuilder().setTransports(['websocket']).build());

  connecteSocket() async {
    _socket.onConnect((data) => print(' connected'));

    _socket.onConnectError((data) => print('$data'));
    _socket.emit('join', Get.find<AuthController>().currentUser);
    _socket.emit('notification',
        {'user_id': '60e8f1b3b8b5e8a0c8e1b1d1', 'message': 'hello'});
    _socket.on('notification', (data) => print('$data'));
  }

  @override
  void initState() {
    // TODO: implement initState
    connecteSocket();
    super.initState();
    print("height: ${AppLayout.getScreenHeight()}");
    print('width :${AppLayout.getScreenWidth()}');
  }

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
    Column(
      children: [
        Text(' Priramy heading11', style: AppConstants.PrimarayheadingStyle),
        const Gap(10),
        const Text(
          'Secondary Heading11',
          style: TextStyle(
              fontFamily: AppFont.secondaryHeading1,
              fontSize: 20,
              fontWeight: FontWeight.w500

              //
              //fontSize: AppLayout.getHeight(30),
              ),
        ),
        Text(
          'how to be more Productive',
          style: Mystyles.bigTitleStyle,
        )
      ],
    ),
    // decoration: const BoxDecoration(
    //     image: DecorationImage(
    //         image: NetworkImage(
    //             'http://10.0.2.2:5000/webinar/bannerImage-1670108609744WIN_20220307_11_33_38_Pro.jpg'),
    //         fit: BoxFit.fitWidth)),

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
              SizedBox(
                height: 130,
                child: DrawerHeader(
                  padding: EdgeInsets.zero,
                  decoration: BoxDecoration(
                      color: AppColors.LTprimaryColor.withOpacity(0.8)),
                  child: GetBuilder<AuthController>(builder: (controller) {
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(
                        radius: 40,
                        backgroundImage: NetworkImage(Get.find<AuthController>()
                                    .currentUser['profile_image'][0] ==
                                'h'
                            ? Get.find<AuthController>()
                                .currentUser['profile_image']
                            : AppConstants.baseURL +
                                Get.find<AuthController>()
                                    .currentUser['profile_image']),
                      ),
                      title: Text(
                        Get.find<AuthController>().currentUser['name'],
                        style: AppConstants.paragraphStyle
                            .copyWith(letterSpacing: 2),
                      ),
                      subtitle: Text(
                        Get.find<AuthController>().currentUser['email'],
                        style: AppConstants.secondaryHeadingStyle.copyWith(
                          letterSpacing: 1,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    );
                  }),
                ),
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
                      Get.toNamed(RoutesHelper.notificationScreenRoute);
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
            icon: const Icon(
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
