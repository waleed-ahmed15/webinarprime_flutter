import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webinarprime/controllers/auth_controller.dart';
import 'package:webinarprime/controllers/chat_controlller.dart';
import 'package:webinarprime/controllers/pages_nav_controller.dart';
import 'package:webinarprime/controllers/webinar_management_controller.dart';
import 'package:webinarprime/controllers/webinar_stream_controller.dart';
import 'package:webinarprime/screens/chat/chat_pages.dart';
import 'package:webinarprime/screens/chat/chatpage_c.dart';
import 'package:webinarprime/screens/chatbot/chatbot_screen.dart';
import 'package:webinarprime/screens/home_screen/nav_tabs/home_screen_home_tab.dart';
import 'package:webinarprime/screens/home_screen/nav_tabs/notifications_tab.dart';
import 'package:webinarprime/screens/home_screen/widgets/home_screen_drawer_widget.dart';
import 'package:webinarprime/screens/profile_view/favourites_screen.dart';
import 'package:webinarprime/screens/profile_view/user_profile_view.dart';
import 'package:webinarprime/screens/search_screen/search_screen_tab.dart';
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
  // final IO.Socket socket = Get.find();
  bool loading = true;
  // working on presistent navbar item

  @override
  void initState() {
    // TODO: implement initState
    // connecteSocket();
    //get fav list
    WebinarManagementController().getAllwebinars();
    preload().then((value) => setState(() {
          Get.find<IO.Socket>().emit('join', {
            Get.find<AuthController>().currentUser['_id'],
          });
          Get.find<IO.Socket>().emit(
            'notificationGlobal',
          );
        }));
    Get.find<IO.Socket>().on('notificationGlobal', (data) {
      if (data['user'] == Get.find<AuthController>().currentUser['_id']) {
        Get.find<AuthController>().show_user_notfications(data);
        Get.find<AuthController>()
            .GetuserNotifications()
            .then((value) => print('done'));

        print('notification Global:=>>>>>>>>>>>>>>> $data');
      }
    });
    super.initState();
    // print("height: ${AppLayout.getScreenHeight()}");
    // print('width :${AppLayout.getScreenWidth()}');
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Future preload() async {
    // print('=-------------------------------------------');
    // await Get.find<WebinarManagementController>().getAllwebinars();
    // await Get.find<AuthController>().getFavoriteWebinars();
    print('preloading data===============>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
    await Get.find<AuthController>()
        .otherUserProfileDetails(Get.find<AuthController>().currentUser['_id']);
    await Get.find<WebinarManagementController>().getRecommnedations();

    // print(Get.find<AuthController>().currentUser);
    Get.find<IO.Socket>().emit('join', {
      Get.find<AuthController>().currentUser['_id'],
    });
    Get.find<IO.Socket>().on('conversationChatMessage', (data) {
      if (Get.currentRoute != '/ChatScreen') {
        WebinarStreamController().showMessageNotifications(data, '');
      }
    });
    Get.find<IO.Socket>().on(
        'notification', (data) => print('notification:=>>>>>>>>>>>>>>> $data'));

    await Get.find<ChatStreamController>()
        .getConversations(Get.find<AuthController>().currentUser['_id']);
    await Get.find<WebinarManagementController>().getCoverWebinars();
    await Get.find<AuthController>().GetuserNotifications();
    loading = false;
    // setState(() {});
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
    // const View_my_Webinar_Screen(),
    const HomeScreenHomeTab(),
    const SearchScreenTab(),
    const FavoriteWebinars(),
    // const ChatListScreen(),
    const ChatPages(),
    const UserProfileView(),
    const NotficationsTab(),
  ];
  @override
  Widget build(BuildContext context) {
    SharedPreferences sharedPreferences = Get.find();
    AuthController authController = Get.find();

    return SafeArea(
      child: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : WillPopScope(
              onWillPop: () async {
                print('homescreen');
                return false;
              },
              child: Scaffold(
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.endDocked,
                floatingActionButton: widget.currIndex == 0
                    ? Get.find<AuthController>().currentUser['accountType'] ==
                            'organizer'
                        ? Container(
                            margin: EdgeInsets.only(bottom: 60.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Get.to(() => const ChatBotScreen(),
                                        transition: Transition.rightToLeft);
                                  },
                                  child: Container(
                                    width: 50.w,
                                    height: 50.h,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      // color: Get.isDarkMode
                                      // ? myappbarcolor
                                      // : AppColors.LTprimaryColor,
                                      image: const DecorationImage(
                                        image: AssetImage(
                                            'assets/image/chatbot4.png'),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    margin: EdgeInsets.only(left: 40.w),
                                  ),
                                ),
                                const Spacer(),
                                FloatingActionButton(
                                  backgroundColor: Get.isDarkMode
                                      ? myappbarcolor
                                      : AppColors.LTprimaryColor,
                                  heroTag: null,
                                  onPressed: () {
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
                        : Container(
                            margin: EdgeInsets.only(bottom: 60.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Get.to(() => const ChatBotScreen(),
                                        transition: Transition.rightToLeft);
                                  },
                                  child: Container(
                                    width: 50.w,
                                    height: 50.h,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      // color: Get.isDarkMode
                                      // ? myappbarcolor
                                      // : AppColors.LTprimaryColor,
                                      image: const DecorationImage(
                                        image: AssetImage(
                                            'assets/image/chatbot4.png'),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    margin: EdgeInsets.only(left: 40.w),
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
                // bottomNavigationBar: Container(
                //   height: 60.h,
                //   decoration: BoxDecoration(
                //     color: Theme.of(context).appBarTheme.backgroundColor!,
                //     borderRadius: BorderRadius.only(
                //         topLeft: Radius.circular(15.r),
                //         topRight: Radius.circular(15.r)),
                //   ),
                //   child: Row(children: const [
                //     Badge(
                //       textColor: Colors.white,
                //       child: Icon(Icons.home),
                //     ),
                //   ]),
                // ),
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
                      color: myappbarcolor,
                    ),
                    child: GNav(
                      backgroundColor:
                          Theme.of(context).appBarTheme.backgroundColor!,
                      curve: Curves.easeInOut,
                      gap: 1,
                      activeColor: Get.isDarkMode
                          ? Colors.cyan
                          : AppColors.LTprimaryColor,
                      // iconSize: 25,
                      padding:
                          EdgeInsets.symmetric(horizontal: 14.w, vertical: 1),
                      duration: const Duration(microseconds: 1),
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
                        GButton(
                          onPressed: () {
                            print('object');
                          },
                          icon: widget.currIndex == 5
                              ? Icons.notifications
                              : Icons.notifications_outlined,
                          iconSize: 30.h,
                          text: '',
                        ),
                      ],
                      selectedIndex: widget.currIndex!,
                      onTabChange: (index) async {
                        if (index == 2) {
                          await Get.find<AuthController>()
                              .getFavoriteWebinars();
                          widget.currIndex = index;
                        }
                        if (index == 4) {
                          await Get.find<AuthController>()
                              .otherUserProfileDetails(
                                  Get.find<AuthController>()
                                      .currentUser['_id']);
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
