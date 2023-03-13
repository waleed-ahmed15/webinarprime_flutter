import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webinarprime/controllers/auth_controller.dart';
import 'package:webinarprime/controllers/chat_controlller.dart';
import 'package:webinarprime/controllers/pages_nav_controller.dart';
import 'package:webinarprime/screens/chat/chat_pages.dart';
import 'package:webinarprime/screens/chat/chatpage_c.dart';
import 'package:webinarprime/screens/home_screen/home_screen_drawer_widget.dart';
import 'package:webinarprime/screens/my_webinars/view_my_webinars_screen.dart';
import 'package:webinarprime/screens/profile_view/favourites_screen.dart';
import 'package:webinarprime/screens/profile_view/user_profile_view.dart';
import 'package:webinarprime/screens/webinar_management/add_webinar_screens/add_webinar_screen1.dart';
import 'package:webinarprime/utils/app_constants.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:webinarprime/utils/colors.dart';
import 'package:webinarprime/utils/styles.dart';

class HomeScreen extends StatefulWidget {
  int? currIndex;
  HomeScreen({required this.currIndex, super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final IO.Socket _socket = IO.io(AppConstants.baseURL,
      IO.OptionBuilder().setTransports(['websocket']).build());
  final IO.Socket socket = Get.find();
  bool loading = false;
  // working on presistent navbar item

  @override
  void initState() {
    // TODO: implement initState
    // connecteSocket();
    //get fav list
    Get.find<AuthController>().getFavoriteWebinars();
    Get.find<AuthController>()
        .otherUserProfileDetails(Get.find<AuthController>().currentUser['_id']);
    preload();
    super.initState();
    // print("height: ${AppLayout.getScreenHeight()}");
    // print('width :${AppLayout.getScreenWidth()}');
  }

  Future preload() async {
    print('=-------------------------------------------');
    print(Get.find<AuthController>().currentUser);
    await Get.find<ChatStreamController>()
        .getConversations(Get.find<AuthController>().currentUser['_id']);
    socket.onConnect((data) => print(' socket stream chat connected'));
    print('current user is=-------------------------------------------');
    print(Get.find<AuthController>().currentUser);
    // print(Get.find<AuthController>().currentUser['_id']);s
    socket.emit('join', {
      Get.find<AuthController>().currentUser['_id'],
    });
  }

  final scaffoldKey = GlobalKey<ScaffoldState>();
  // int _selectedIndex = widget.currIndex!;
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
    const View_my_Webinar_Screen(),
    // Column(
    //   children: [
    //     Text(' Priramy heading11', style: AppConstants.PrimarayheadingStyle),
    //     const Gap(10),
    //     const Text(
    //       'Secondary Heading11',
    //       style: TextStyle(
    //           fontFamily: AppFont.secondaryHeading1,
    //           fontSize: 20,
    //           fontWeight: FontWeight.w500

    //           //
    //           //fontSize: AppLayout.getHeight(30),
    //           ),
    //     ),
    //     Text(
    //       'how to be more Productive',
    //       style: Mystyles.bigTitleStyle,
    //     )
    //   ],
    // ),
    const Text(
      'Likes',
      style: optionStyle,
    ),
    const FavoriteWebinars(),
    // const ChatListScreen(),
    const ChatPages(),
    const UserProfileView(),
  ];
  @override
  Widget build(BuildContext context) {
    SharedPreferences sharedPreferences = Get.find();
    AuthController authController = Get.find();

    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          print('homescreen');
          return false;
        },
        child: Scaffold(
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: widget.currIndex == 0
              ? Container(
                  margin: EdgeInsets.only(bottom: 50.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FloatingActionButton(
                        backgroundColor: Get.isDarkMode
                            ? Mycolors.myappbarcolor
                            : AppColors.LTprimaryColor,
                        heroTag: null,
                        onPressed: () {
                          // Get.toNamed('/create_webinar');
                          // Get.to(() => const HomeScreenNew());
                          Get.to(() => const AddWebinarScreen1());
                        },
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                )
              : null,
          key: scaffoldKey,
          drawer: const HomeScreenDrawer(),
          body: Center(
            child: _widgetOptions.elementAt(widget.currIndex!),
          ),
          bottomNavigationBar: ClipRRect(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15.r),
                topRight: Radius.circular(15.r)),
            child: Container(
              constraints: BoxConstraints(
                maxHeight: 60.h,
                minHeight: 60.h,
              ),
              decoration: BoxDecoration(
                color: Mycolors.myappbarcolor,
              ),
              child: GNav(
                backgroundColor: Mycolors.myappbarcolor,
                // curve: Curves.ease,
                curve: Curves.easeInOut,

                // rippleColor: Colors.grey[300]!,
                gap: 1,
                activeColor:
                    Get.isDarkMode ? Colors.cyan : AppColors.LTprimaryColor,
                iconSize: 24,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                duration: const Duration(microseconds: 1),
                // tabBackgroundColor: Colors.grey[100]!,
                // color: Colors.black,
                tabs: [
                  GButton(
                    icon: widget.currIndex == 0
                        ? Icons.home
                        : Icons.home_outlined,
                    iconSize: 30.h,
                    text: '',
                  ),
                  GButton(
                    icon: widget.currIndex == 2
                        ? Icons.search
                        : Icons.search_outlined,
                    iconSize: 30.h,
                    text: '',
                  ),
                  GButton(
                    icon: widget.currIndex == 2
                        ? Icons.favorite
                        : Icons.favorite_outline,
                    iconSize: 30.h,
                    text: '',
                  ),
                  GButton(
                    onPressed: () async {
                      print('tapping chat');

                      if (PagesNav.chatPagesindex != 0) {
                        await Get.find<PagesNav>().updateChat(0);
                        globalPageControllerForchat.animateTo(
                            globalPageControllerForchat
                                .positions.last.minScrollExtent,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOut);
                      }
                    },
                    icon: widget.currIndex == 3
                        ? Icons.chat_bubble
                        : Icons.chat_bubble_outline,
                    iconSize: 30.h,
                  ),
                  GButton(
                    onPressed: () async {},
                    icon: widget.currIndex == 4
                        ? Icons.person
                        : Icons.person_2_outlined,
                    iconSize: 30.h,
                    text: '',
                  ),
                ],
                selectedIndex: widget.currIndex!,
                onTabChange: (index) async {
                  if (index == 2) {
                    await Get.find<AuthController>().getFavoriteWebinars();
                    widget.currIndex = index;
                  }
                  if (index == 4) {
                    await Get.find<AuthController>().otherUserProfileDetails(
                        Get.find<AuthController>().currentUser['_id']);
                    widget.currIndex = index;
                  }
                  setState(() {
                    widget.currIndex = index;
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
