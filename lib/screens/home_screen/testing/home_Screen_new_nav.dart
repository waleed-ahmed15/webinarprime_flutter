import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:webinarprime/screens/chat/chat_pages.dart';
import 'package:webinarprime/screens/chat/chatpage_c.dart';
import 'package:webinarprime/screens/home_screen/home_screen.dart';
import 'package:webinarprime/screens/home_screen/widgets/home_screen_drawer_widget.dart';
import 'package:webinarprime/screens/webinar_management/add_webinar_screens/add_webinar_screen1.dart';
import 'package:webinarprime/utils/styles.dart';

class HomeScreenNew extends StatefulWidget {
  const HomeScreenNew({super.key});

  @override
  State<HomeScreenNew> createState() => _HomeScreenNewState();
}

final controller = PersistentTabController(initialIndex: 0);

List<Widget> _buildScreen() {
  return [
    HomeScreen(currIndex: 0),
    const Text('Home2'),
    const AddWebinarScreen1(),
    const Text('Home4'),
    const ChatPages(),
  ];
}

List<PersistentBottomNavBarItem> _navbarItems() {
  return [
    PersistentBottomNavBarItem(
      icon: const Icon(Icons.home),
      title: ('Home'),
      activeColorPrimary: Colors.purple,
      inactiveColorPrimary: Colors.grey,
    ),
    PersistentBottomNavBarItem(
      icon: const Icon(Icons.search),
      title: ('Search'),
      activeColorPrimary: Colors.pink,
      inactiveColorPrimary: Colors.grey,
    ),
    PersistentBottomNavBarItem(
      icon: const Icon(
        Icons.add,
        color: Colors.black,
      ),
      activeColorPrimary: Colors.blue,
      inactiveColorPrimary: Colors.grey,
    ),
    PersistentBottomNavBarItem(
      icon: const Icon(Icons.favorite),
      title: ('Favourite'),
      activeColorPrimary: Colors.red,
      inactiveColorPrimary: Colors.grey,
    ),
    PersistentBottomNavBarItem(
      icon: const Icon(Icons.person),
      title: ('Profile'),
      activeColorPrimary: Colors.yellow,
      inactiveColorPrimary: Colors.grey,
    ),
  ];
}

class _HomeScreenNewState extends State<HomeScreenNew> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const HomeScreenDrawer(),
      body: PersistentTabView(
        context,
        onItemSelected: (value) {
          print(value);
          if (value == 4) {
            globalPageControllerForchat.animateTo(
                globalPageControllerForchat.positions.last.minScrollExtent,
                duration: const Duration(milliseconds: 1),
                curve: Curves.easeOut);
          }
        },
        navBarHeight: 60,
        screens: _buildScreen(),
        items: _navbarItems(),
        controller: controller,
        navBarStyle: NavBarStyle.style16,
        backgroundColor: myappbarcolor,

        handleAndroidBackButtonPress: true,

        resizeToAvoidBottomInset:
            true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
        stateManagement: true, // Default is true.
        hideNavigationBarWhenKeyboardShows:
            true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
        decoration: NavBarDecoration(
          borderRadius: BorderRadius.circular(10.0),
          colorBehindNavBar: Colors.white,
        ),
        popAllScreensOnTapOfSelectedTab: true,
        popActionScreens: PopActionScreensType.all,
        itemAnimationProperties: const ItemAnimationProperties(
          // Navigation Bar's items animation properties.
          duration: Duration(milliseconds: 200),
          curve: Curves.ease,
        ),
        screenTransitionAnimation: const ScreenTransitionAnimation(
          // Screen transition animation on change of selected tab.
          animateTabTransition: true,
          curve: Curves.ease,
          duration: Duration(milliseconds: 200),
        ),
      ),
    );
  }
}
