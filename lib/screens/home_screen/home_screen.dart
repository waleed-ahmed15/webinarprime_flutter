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
import 'package:webinarprime/utils/app_constants.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
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

  @override
  void initState() {
    // TODO: implement initState
    // connecteSocket();
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
    const Text(
      'Search',
      style: optionStyle,
    ),
    // const ChatListScreen(),
    const ChatPages(),
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
          key: scaffoldKey,
          drawer: const HomeScreenDrawer(),
          body: Center(
            child: _widgetOptions.elementAt(widget.currIndex!),
          ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(color: Mycolors.myappbarcolor),
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
                  tabs: [
                    GButton(
                      icon: Icons.home,
                      iconSize: 30.h,
                      text: 'Home',
                    ),
                    GButton(
                      icon: Icons.favorite,
                      iconSize: 30.h,
                      text: 'Likes',
                    ),
                    GButton(
                      icon: Icons.search,
                      iconSize: 30.h,
                      text: 'Search',
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
                          // globalPageControllerForchat.position.minScrollExtent;
                          // globalPageControllerForchat
                          // .jumpToPage(PagesNav.chatPagesindex);
                        }
                      },
                      icon: Icons.chat_bubble,
                      iconSize: 30.h,
                      text: 'Chat',
                    ),
                  ],
                  selectedIndex: widget.currIndex!,
                  onTabChange: (index) {
                    setState(() {
                      widget.currIndex = index;
                    });
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
