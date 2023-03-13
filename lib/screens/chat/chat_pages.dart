import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:webinarprime/controllers/auth_controller.dart';
import 'package:webinarprime/controllers/pages_nav_controller.dart';
import 'package:webinarprime/screens/chat/chatpage_c.dart';
import 'package:webinarprime/utils/colors.dart';

class ChatPages extends StatefulWidget {
  const ChatPages({super.key});

  @override
  State<ChatPages> createState() => _ChatPagesState();
}

class _ChatPagesState extends State<ChatPages> with TickerProviderStateMixin {
  late final PageController _pageController = PageController(
    initialPage: PagesNav.chatPagesindex,
  );

  late Animation<double> _animation;
  late AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );

    final curvedAnimation =
        CurvedAnimation(curve: Curves.easeInOut, parent: _animationController);
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose

    _pageController.dispose();
    _animationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        print('object');
        _pageController.jumpTo(PagesNav.chatPagesindex.toDouble());

        return false;
      },
      child: Scaffold(
        floatingActionButton: FloatingActionBubble(
          // Menu items
          items: <Bubble>[
            // Floating action menu item
            Bubble(
              title: "Banned Chats",
              iconColor: Colors.white,
              bubbleColor: Colors.blue,
              icon: Icons.person_off_rounded,
              titleStyle: const TextStyle(fontSize: 16, color: Colors.white),
              onPress: () async {
                await Get.find<AuthController>().getbannedchats();
                globalPageControllerForchat.positions.last.animateTo(2.sw,
                    duration: const Duration(milliseconds: 1),
                    curve: Curves.easeOut);
                // globalPageControllerForchat.positions.last.jumpTo(1.3);
                _animationController.reverse();
              },
            ),
            // Floating action menu item
            Bubble(
              title: "New",
              iconColor: Colors.white,
              bubbleColor: Colors.blue,
              icon: Icons.add,
              titleStyle: const TextStyle(fontSize: 16, color: Colors.white),
              onPress: () async {
                globalPageControllerForchat.animateTo(1.sw,
                    duration: const Duration(microseconds: 1),
                    curve: Curves.fastLinearToSlowEaseIn);

                _animationController.reverse();
              },
            ),
            //Floating action menu item
          ],

          // animation controller
          animation: _animation,

          // On pressed change animation state
          onPress: () => _animationController.isCompleted
              ? _animationController.reverse()
              : _animationController.forward(),

          // Floating Action button Icon color
          iconColor: Colors.white,

          // Flaoting Action button Icon
          animatedIconData: AnimatedIcons.menu_close,

          // iconData: Icons.edit,
          backGroundColor:
              Get.isDarkMode ? Colors.cyan : AppColors.LTprimaryColor,
        ),
        body: PageView(
          physics: const NeverScrollableScrollPhysics(),
          onPageChanged: (index) async {
            await Get.find<PagesNav>().updateChat(index);
            print(PagesNav.chatPagesindex);
          },
          scrollDirection: Axis.horizontal,

          controller: globalPageControllerForchat,
          // physics: const PageScrollPhysics(),

          children: chatpages,
        ),
      ),
    );
  }
}
