import 'package:auto_size_text/auto_size_text.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:webinarprime/controllers/auth_controller.dart';
import 'package:webinarprime/controllers/reviews_controlller.dart';
import 'package:webinarprime/controllers/webinar_management_controller.dart';
import 'package:webinarprime/controllers/webinar_stream_controller.dart';
import 'package:webinarprime/screens/home_screen/widgets/carasoul_slider_home.dart';
import 'package:webinarprime/screens/profile_view/user_profile_view.dart';
import 'package:webinarprime/screens/report%20screen/report_screen.dart';
import 'package:webinarprime/screens/user_search/user_search_screen.dart';
import 'package:webinarprime/screens/webinar_management/edit_webinar/edit_webinar_screen.dart';
import 'package:webinarprime/screens/webinar_management/view_webinar_screen/attendees_list_screen.dart';
import 'package:webinarprime/screens/webinar_management/view_webinar_screen/review_widget.dart';
import 'package:webinarprime/utils/app_constants.dart';
import 'package:webinarprime/utils/colors.dart';
import 'package:webinarprime/utils/dimension.dart';
import 'package:webinarprime/utils/styles.dart';
import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:webinarprime/utils/themes.dart';
import 'package:webinarprime/widgets/snackbar.dart';

class WebinarDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> webinarDetails;

  const WebinarDetailsScreen({super.key, required this.webinarDetails});

  @override
  State<WebinarDetailsScreen> createState() => _WebinarDetailsScreenState();
}

class _WebinarDetailsScreenState extends State<WebinarDetailsScreen>
    with TickerProviderStateMixin {
  final detailsscaffoldKey = GlobalKey<ScaffoldState>();

  late TabController _tabController;
  late ScrollController _scrollController;
  bool _showTitle = false;
  var reviewController = TextEditingController();
  Animation<double>? _animation;
  AnimationController? _animationController;
  RxString webinarStreamStatus = ''.obs;
  bool canStream = false;
  // this is for posting notifications
  final formKey2 = GlobalKey<FormState>(); //key for form
  var titleController = TextEditingController();
  var descriptionController = TextEditingController();

  String showFloatingButtonFor = '';
  bool showfloatingButton = false;
  int reviewRating = 4;
  bool loading = true;

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    _tabController = TabController(length: 4, vsync: this);
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );
    final curvedAnimation =
        CurvedAnimation(curve: Curves.easeInOut, parent: _animationController!);
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);

    floatingActionbuttonDecider();

    CanuserStream();
    super.initState();
  }

  Future<void> fetchSimilarWebinars() async {
    WebinarManagementController()
        .getSimilarWebinars(WebinarManagementController.currentWebinar['_id'])
        .then((value) => {
              setState(() {
                loading = false;
              })
            });
  }

  bool canpostreview() {
    bool canpost = false;
    WebinarManagementController.currentWebinar['attendees'].forEach((element) {
      if (element['_id'] == Get.find<AuthController>().currentUser['_id']) {
        canpost = true;
        return;
      }
    });
    return canpost;
  }

  bool alreadyRegistered() {
    bool registerd = false;
    WebinarManagementController.currentWebinar['attendees'].forEach((element) {
      if (element['_id'] == Get.find<AuthController>().currentUser['_id']) {
        // Get.snackbar('Already Registered',
        // 'You have already registered for this webinar');
        registerd = true;
        return;
      }
    });
    return registerd;
  }

  void _scrollListener() {
    if (_scrollController.offset >= 400 && !_showTitle) {
      setState(() {
        _showTitle = true;
      });
    } else if (_scrollController.offset < 400 && _showTitle) {
      setState(() {
        _showTitle = false;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _animationController!.dispose();
    super.dispose();
  }

  /// this is for post notification-------------------
  void showDialogBoxForPostNotification(String webinarId) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(60.r),
            ), //this right here
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(20.r),
              ),
              height: 430.h,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                    key: formKey2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(
                          child: Text("Post Notification",
                              style: categoriesHeadingStyle.copyWith(
                                  color: Get.isDarkMode
                                      ? Colors.white70
                                      : Colors.black38)),
                        ),
                        TextFormField(
                          controller: titleController,
                          style: onelineStyle,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                            ),
                            labelText: "Title",
                            hintText: "Enter Title",
                          ),
                          validator: (val) {
                            // print("val$val");
                            if (val == '') {
                              return 'please enter Title';
                            }
                            return null;
                          },
                        ),
                        // Gap(10.h),
                        TextFormField(
                          style: myParagraphStyle,
                          maxLines: 7,
                          controller: descriptionController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.r)),
                            ),
                            hintText: 'Webinar desceiption.....',
                          ),
                          validator: (val) {
                            // print("val$val");
                            if (val == '') {
                              return 'please enter description';
                            }
                            return null;
                          },
                        ),
                        Gap(10.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                style: ElevatedButton.styleFrom(
                                  animationDuration: const Duration(seconds: 3),
                                  backgroundColor: Colors.red,
                                ),
                                child: Text(
                                  'cancel',
                                  style: TextStyle(
                                      fontSize: AppLayout.getHeight(13),
                                      fontFamily: 'JosefinSans Bold',
                                      letterSpacing: 1),
                                )),

                            // this is where update  is handled
                            SizedBox(width: 20.w),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueAccent,
                              ),
                              child: Text(
                                'Post',
                                style: TextStyle(
                                    fontSize: 13.sp,
                                    fontFamily: 'JosefinSans Bold',
                                    letterSpacing: 1),
                              ),
                              onPressed: () async {
                                // Do something with the edited text
                                if (formKey2.currentState!.validate()) {
                                  // print(
                                  // "titleController.text${titleController.text}");
                                  // print(
                                  // "descriptionController.text${descriptionController.text}");
                                  // print(
                                  // "WebinarManagementController.currentWebinar['_id']${WebinarManagementController.currentWebinar['_id']}");

                                  await WebinarManagementController()
                                      .postNotification(
                                          webinarId,
                                          titleController.text,
                                          descriptionController.text);
                                  Navigator.of(context).pop();
                                  ShowCustomSnackBar(
                                      title: "",
                                      "Notification posted successfully",
                                      isError: false);
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    )),
              ),
            ),
          );
        });
  }

  /// this is for post notification-------------------^^^^^------
  void CanuserStream() async {
    bool found = false;
    WebinarManagementController.currentWebinar['organizers'].forEach((element) {
      print(element);
      if (element['_id'] == Get.find<AuthController>().currentUser['_id']) {
        canStream = true;
        found = true;
        return;
      }
    });
    if (!found) {
      WebinarManagementController.currentWebinar['guests'].forEach((element) {
        print(element);
        if (element['_id'] == Get.find<AuthController>().currentUser['_id']) {
          canStream = true;
          found = true;
          return;
        }
      });
    }

    if (!found) {
      WebinarManagementController.currentWebinar['attendees']
          .forEach((element) {
        // print(element);
        if (element['_id'] == Get.find<AuthController>().currentUser['_id']) {
          canStream = true;
          found = true;
          return;
        }
      });
    }

    if (WebinarManagementController.currentWebinar['createdBy']['_id'] ==
        Get.find<AuthController>().currentUser['_id']) {
      canStream = true;
    }
    Map<String, dynamic> res = await Get.find<WebinarStreamController>()
        .webianrStreamStatus(WebinarManagementController.currentWebinar['_id']);
    print(res);
    print('object===============================');
    webinarStreamStatus.value =
        res['success'] == false ? "ended" : res['status'];
    setState(() {});
    print(webinarStreamStatus.value);
  }

  void floatingActionbuttonDecider() {
    if (WebinarManagementController.currentWebinar['createdBy']['_id'] ==
        Get.find<AuthController>().currentUser['_id']) {
      showFloatingButtonFor = 'creator';
      showfloatingButton = true;
      return;
    }
    WebinarManagementController.currentWebinar['organizers'].forEach((element) {
      print(element);
      if (element['_id'] == Get.find<AuthController>().currentUser['_id']) {
        showFloatingButtonFor = 'organizer';
        showfloatingButton = true;
        return;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GetBuilder<WebinarManagementController>(builder: (wp) {
        return Scaffold(
          endDrawer: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              // elevation: 0,
              automaticallyImplyLeading: false,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Notifications",
                    style: Theme.of(context)
                        .textTheme
                        .displayLarge!
                        .copyWith(fontSize: 20.sp),
                  ),
                  Gap(3.w),
                  Icon(
                    Icons.notifications,
                    color: Theme.of(context).textTheme.displayLarge!.color!,
                  ),
                ],
              ),
            ),
            body: loading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Builder(builder: (context) {
                    print(Get.isDarkMode);
                    print(darkTheme);
                    if (WebinarManagementController
                        .currentWebinar['notifications'].isEmpty) {
                      return Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Transform.rotate(
                                angle: -70 / 180,
                                child: const Icon(Icons.notifications_active)),
                            Row(),
                            Gap(10.h),
                            Text(
                              "No notificatione Yet",
                              style: bigTitleStyle.copyWith(
                                  fontSize: 20.sp,
                                  color: Get.isDarkMode
                                      ? Colors.white.withOpacity(1)
                                      : Colors.grey[400]),
                            ),
                          ],
                        ),
                      );
                    }
                    return ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.symmetric(horizontal: 10.h),
                      itemCount: WebinarManagementController
                          .currentWebinar['notifications'].length,
                      itemBuilder: (BuildContext context, int index) {
                        String formmattedDateTime =
                            DateFormat('dd/MM/yy, hh:mm').format(DateTime.parse(
                                WebinarManagementController
                                    .currentWebinar['notifications'][index]
                                        ['createdAt']
                                    .toString()));
                        return Container(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                WebinarManagementController
                                        .currentWebinar['notifications'][index]
                                    ['title'],
                                style: Theme.of(context)
                                    .textTheme
                                    .displayMedium!
                                    .copyWith(fontSize: 19.sp),
                              ),
                              ExpandableText(
                                  WebinarManagementController
                                          .currentWebinar['notifications']
                                      [index]['description'],
                                  maxLines: 4,
                                  expandOnTextTap: true,
                                  collapseOnTextTap: true,
                                  textAlign: TextAlign.justify,
                                  style:
                                      Theme.of(context).textTheme.displaySmall,
                                  expandText: ''),
                              Gap(10.h),
                              Text(
                                formmattedDateTime,
                                style: onelineStyle.copyWith(fontSize: 15.sp),
                              ),
                              const Divider(
                                color: Colors.grey,
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }),
          ),
          key: detailsscaffoldKey,
          floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
          floatingActionButton: showfloatingButton
              ? showFloatingButtonFor == 'creator'
                  ? GetBuilder<WebinarStreamController>(
                      builder: (streamcontroller) {
                      return FloatingActionBubble(
                        items: [
                          // Floating action menu item
                          widget.webinarDetails.containsKey('ended')
                              ? Bubble(
                                  title: "Webinar Ended",
                                  iconColor: Colors.white,
                                  bubbleColor: Colors.red,
                                  icon: Icons.stop_rounded,
                                  titleStyle: const TextStyle(
                                      fontSize: 16, color: Colors.white),
                                  onPress: () {
                                    _animationController!.reverse();
                                  },
                                )
                              : Bubble(
                                  title: webinarStreamStatus.value == 'live'
                                      ? 'Join'
                                      : "Start Stream",
                                  iconColor: Colors.white,
                                  bubbleColor: Get.isDarkMode
                                      ? myappbarcolor
                                      : AppColors.LTprimaryColor,
                                  icon: Icons.stream_outlined,
                                  titleStyle: const TextStyle(
                                      fontSize: 16, color: Colors.white),
                                  onPress: () async {
                                    webinarStreamStatus.value == 'live'
                                        ? Get.find<WebinarStreamController>()
                                            .joinStream(
                                                WebinarManagementController
                                                    .currentWebinar['_id'],
                                                context)
                                        : Get.find<WebinarStreamController>()
                                            .startWebinarStream(
                                                WebinarManagementController
                                                    .currentWebinar['_id'],
                                                context);
                                    _animationController!.reverse();
                                  },
                                ),
                          Bubble(
                            title: "End Webinar",
                            iconColor: Colors.white,
                            bubbleColor: webinarStreamStatus.value == 'live'
                                ? Get.isDarkMode
                                    ? myappbarcolor
                                    : AppColors.LTprimaryColor
                                : Colors.grey,
                            icon: Icons.stop,
                            titleStyle: const TextStyle(
                                fontSize: 16, color: Colors.white),
                            onPress: webinarStreamStatus.value == 'live'
                                ? () async {
                                    await Get.find<
                                            WebinarManagementController>()
                                        .endWebinarStream(
                                            WebinarManagementController
                                                .currentWebinar['_id']);
                                    _animationController!.reverse();

                                    setState(() {
                                      webinarStreamStatus.value = 'ended';
                                    });
                                  }
                                : () {
                                    print('end stream grey');
                                  },
                          ),
                          // Floating action menu item

                          Bubble(
                            title: "Post Notification",
                            iconColor: Colors.white,
                            bubbleColor: Get.isDarkMode
                                ? myappbarcolor
                                : AppColors.LTprimaryColor,
                            icon: Icons.notification_add,
                            titleStyle: const TextStyle(
                                fontSize: 16, color: Colors.white),
                            onPress: () {
                              _animationController!.reverse();
                              showDialogBoxForPostNotification(
                                  WebinarManagementController
                                      .currentWebinar['_id']);
                            },
                          ),
                          Bubble(
                            title: "Edit",
                            iconColor: Colors.white,
                            bubbleColor: Get.isDarkMode
                                ? myappbarcolor
                                : AppColors.LTprimaryColor,
                            icon: Icons.edit,
                            titleStyle: const TextStyle(
                                fontSize: 16, color: Colors.white),
                            onPress: () {
                              _animationController!.reverse();
                              Get.to(() => EditWebinarScreen(
                                    webinarDetails: WebinarManagementController
                                        .currentWebinar,
                                  ));
                            },
                          ),
                          //Floating action menu item
                          Bubble(
                            title: "Organizers",
                            iconColor: Colors.white,
                            bubbleColor: Get.isDarkMode
                                ? myappbarcolor
                                : AppColors.LTprimaryColor,
                            icon: Icons.group,
                            titleStyle: const TextStyle(
                                fontSize: 16, color: Colors.white),
                            onPress: () async {
                              // Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) => Homepage()));
                              _animationController!.reverse();
                              await WebinarManagementController()
                                  .getOrganizersForWebinar(
                                      WebinarManagementController
                                          .currentWebinar['_id']);

                              Get.to(() => UserSearchScreen(
                                  usersType: 1,
                                  webinarId: WebinarManagementController
                                      .currentWebinar['_id']));
                            },
                          ),
                          Bubble(
                            title: "Guests",
                            iconColor: Colors.white,
                            bubbleColor: Get.isDarkMode
                                ? myappbarcolor
                                : AppColors.LTprimaryColor,
                            icon: Icons.group,
                            titleStyle: const TextStyle(
                                fontSize: 16, color: Colors.white),
                            onPress: () async {
                              // Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) => Homepage()));
                              _animationController!.reverse();
                              await WebinarManagementController()
                                  .getGuestsForWebinar(
                                      WebinarManagementController
                                          .currentWebinar['_id']);
                              Get.to(() => UserSearchScreen(
                                  usersType: 2,
                                  webinarId: WebinarManagementController
                                      .currentWebinar['_id']));
                            },
                          ),
                          Bubble(
                            title: "Attendees",
                            iconColor: Colors.white,
                            bubbleColor: Get.isDarkMode
                                ? myappbarcolor
                                : AppColors.LTprimaryColor,
                            icon: Icons.group,
                            titleStyle: const TextStyle(
                                fontSize: 16, color: Colors.white),
                            onPress: () async {
                              // Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) => Homepage()));
                              _animationController!.reverse();

                              await WebinarManagementController()
                                  .getAttendeesForWebinar(
                                      WebinarManagementController
                                          .currentWebinar['_id']);
                              Get.to(() => UserSearchScreen(
                                    usersType: 3,
                                    webinarId: WebinarManagementController
                                        .currentWebinar['_id'],
                                  ));
                            },
                          ),
                        ],

                        // animation controller
                        animation: _animation!,

                        // On pressed change animation state
                        onPress: () {
                          setState(() {});
                          _animationController!.isCompleted
                              ? _animationController!.reverse()
                              : _animationController!.forward();
                        },

                        // Floating Action button Icon color
                        iconColor: Colors.white,

                        // Flaoting Action button Icon
                        animatedIconData: AnimatedIcons.menu_close,
                        // iconData: Icons.menu,
                        backGroundColor: Get.isDarkMode
                            ? myappbarcolor
                            : AppColors.LTprimaryColor,
                      );
                    })
                  // this is to show for organizer
                  : FloatingActionBubble(
                      items: [
                        Bubble(
                          title: "Post Notification",
                          iconColor: Colors.white,
                          bubbleColor: Get.isDarkMode
                              ? myappbarcolor
                              : AppColors.LTprimaryColor,
                          icon: Icons.notification_add,
                          titleStyle: const TextStyle(
                              fontSize: 16, color: Colors.white),
                          onPress: () {
                            _animationController!.reverse();
                            showDialogBoxForPostNotification(
                                WebinarManagementController
                                    .currentWebinar['_id']);
                          },
                        ),
                        Bubble(
                          title: "Edit",
                          iconColor: Colors.white,
                          bubbleColor: Get.isDarkMode
                              ? myappbarcolor
                              : AppColors.LTprimaryColor,
                          icon: Icons.edit,
                          titleStyle: const TextStyle(
                              fontSize: 16, color: Colors.white),
                          onPress: () {
                            _animationController!.reverse();
                            Get.to(() => EditWebinarScreen(
                                  webinarDetails: WebinarManagementController
                                      .currentWebinar,
                                ));
                          },
                        ),
                        //Floating action menu item
                        Bubble(
                          title: "Organizers",
                          iconColor: Colors.white,
                          bubbleColor: Get.isDarkMode
                              ? myappbarcolor
                              : AppColors.LTprimaryColor,
                          icon: Icons.group,
                          titleStyle: const TextStyle(
                              fontSize: 16, color: Colors.white),
                          onPress: () async {
                            // Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) => Homepage()));
                            _animationController!.reverse();
                            await WebinarManagementController()
                                .getOrganizersForWebinar(
                                    WebinarManagementController
                                        .currentWebinar['_id']);

                            Get.to(() => UserSearchScreen(
                                usersType: 1,
                                webinarId: WebinarManagementController
                                    .currentWebinar['_id']));
                          },
                        ),
                        Bubble(
                          title: "Guests",
                          iconColor: Colors.white,
                          bubbleColor: Get.isDarkMode
                              ? myappbarcolor
                              : AppColors.LTprimaryColor,
                          icon: Icons.group,
                          titleStyle: const TextStyle(
                              fontSize: 16, color: Colors.white),
                          onPress: () async {
                            // Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) => Homepage()));
                            _animationController!.reverse();
                            await WebinarManagementController()
                                .getGuestsForWebinar(WebinarManagementController
                                    .currentWebinar['_id']);
                            Get.to(() => UserSearchScreen(
                                usersType: 2,
                                webinarId: WebinarManagementController
                                    .currentWebinar['_id']));
                          },
                        ),
                        Bubble(
                          title: "Attendees",
                          iconColor: Colors.white,
                          bubbleColor: Get.isDarkMode
                              ? myappbarcolor
                              : AppColors.LTprimaryColor,
                          icon: Icons.group,
                          titleStyle: const TextStyle(
                              fontSize: 16, color: Colors.white),
                          onPress: () async {
                            // Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) => Homepage()));
                            _animationController!.reverse();

                            await WebinarManagementController()
                                .getAttendeesForWebinar(
                                    WebinarManagementController
                                        .currentWebinar['_id']);
                            Get.to(() => UserSearchScreen(
                                  usersType: 3,
                                  webinarId: WebinarManagementController
                                      .currentWebinar['_id'],
                                ));
                          },
                        ),
                      ],

                      // animation controller
                      animation: _animation!,

                      // On pressed change animation state
                      onPress: () => _animationController!.isCompleted
                          ? _animationController!.reverse()
                          : _animationController!.forward(),

                      // Floating Action button Icon color
                      iconColor: Colors.white,

                      // Flaoting Action button Icon
                      // iconData: Icons.menu,
                      animatedIconData: AnimatedIcons.menu_close,
                      backGroundColor: Get.isDarkMode
                          ? myappbarcolor
                          : AppColors.LTprimaryColor,
                    )
              : null,
          body: NestedScrollView(
            controller: _scrollController,
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  actions: [
                    !_showTitle
                        ? Container(
                            margin: EdgeInsets.only(right: 15.w, top: 10.h),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25.r),
                                gradient: webinarInfoTileGradient),
                            child: IconButton(
                                onPressed: () {
                                  detailsscaffoldKey.currentState!
                                      .openEndDrawer();
                                },
                                icon: Icon(
                                  Icons.notifications,
                                  size: 30.h,
                                )),
                          )
                        : Container()
                  ],
                  leading: IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
                  ),
                  iconTheme: IconThemeData(
                    size: AppLayout.getHeight(30),
                    color: Get.isDarkMode
                        ? Colors.white.withOpacity(0.98)
                        : const Color(0xff181b1f),
                  ),
                  collapsedHeight: AppLayout.getHeight(80),
                  backgroundColor: Get.isDarkMode
                      ? const Color(0xff191919)
                      : const Color(0xffF7F8F8),
                  expandedHeight: AppLayout.getHeight(490),
                  flexibleSpace: FlexibleSpaceBar(
                    title: _showTitle
                        ? Padding(
                            padding: EdgeInsets.only(
                                bottom: AppLayout.getHeight(40)),
                            child: Text(
                              '${WebinarManagementController.currentWebinar['name']}',
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: AppLayout.getHeight(20),
                                fontFamily: 'JosefinSans Regular',
                                fontWeight: FontWeight.w500,
                                color: Get.isDarkMode
                                    ? Colors.white.withOpacity(0.98)
                                    : const Color(0xff181b1f),
                              ),
                            ),
                          )
                        : null,
                    background: Stack(
                      children: [
                        // The back ground image goes here
                        Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            height: AppLayout.getHeight(200),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(
                                  AppConstants.baseURL +
                                      WebinarManagementController
                                          .currentWebinar['coverImage'],
                                ),
                                fit: BoxFit.cover,
                              ),
                              color: Theme.of(context).scaffoldBackgroundColor,
                              boxShadow: [
                                BoxShadow(
                                  offset: const Offset(0, 5),
                                  blurRadius: 7,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .secondary
                                      .withOpacity(0.1),
                                ),
                                BoxShadow(
                                  offset: const Offset(0, -5),
                                  blurRadius: 7,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .secondary
                                      .withOpacity(0.1),
                                )
                              ],
                            ),
                            // child: Image.network(
                            //   AppConstants.baseURL +
                            //       WebinarManagementController.currentWebinar['bannerImage'],
                            //   fit: BoxFit.cover,
                            //   height: AppLayout.getHeight(250),
                            //   width: double.infinity,
                            // ),
                          ),
                        ),

                        Positioned(
                          top: AppLayout.getHeight(50.0),
                          left: AppLayout.getWidth(110.0),
                          child: Container(
                            width: AppLayout.getWidth(180),
                            height: AppLayout.getHeight(220),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  AppLayout.getHeight(10)),
                              boxShadow: [
                                BoxShadow(
                                  offset: const Offset(3, 3),
                                  blurRadius: 4,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .secondary
                                      .withOpacity(0.1),
                                ),
                                BoxShadow(
                                  offset: const Offset(-3, -3),
                                  blurRadius: 4,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .secondary
                                      .withOpacity(0.1),
                                )
                              ],
                              image: DecorationImage(
                                image: NetworkImage(
                                  AppConstants.baseURL +
                                      WebinarManagementController
                                          .currentWebinar['bannerImage'],
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: AppLayout.getHeight(180.0),
                          left: AppLayout.getWidth(50),
                          child: SizedBox(
                            width: AppLayout.getWidth(300),
                            height: AppLayout.getHeight(35),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Gap(8.h),
                                  Text(
                                    '${WebinarManagementController.currentWebinar['datetime']} - ${WebinarManagementController.currentWebinar['duration']} Mins',
                                    style: TextStyle(
                                      fontSize: AppLayout.getHeight(16),
                                      fontFamily: 'JosefinSans Bold',
                                      letterSpacing: 0.2,
                                      fontWeight: FontWeight.w500,
                                      color: const Color.fromRGBO(
                                          122, 121, 121, 1),
                                    ),
                                  ),
                                  Gap(6.h),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                            bottom: AppLayout.getHeight(60),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: AppLayout.getWidth(20)),
                              // color: Colors.red,
                              height: AppLayout.getHeight(120),
                              width: AppLayout.getWidth(400),
                              child: AutoSizeText(
                                '${WebinarManagementController.currentWebinar['name']}',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  height: 1.2,
                                  fontSize: 25.sp,
                                  fontFamily: 'JosefinSans Bold',
                                  fontWeight: FontWeight.w700,
                                  color: Get.isDarkMode
                                      ? Colors.white.withOpacity(0.98)
                                      : const Color(0xff181b1f),
                                  overflow: TextOverflow.visible,
                                ),
                              ),
                            )),
                        Positioned(
                          bottom: AppLayout.getHeight(60),
                          child: SizedBox(
                            width: AppLayout.getScreenWidth(),
                            // color: Colors.yellow,
                            child: Center(
                              child: GetBuilder<WebinarManagementController>(
                                  builder: (context) {
                                return GestureDetector(
                                  onTap: () {
                                    Get.to(
                                      () => AttendessList(
                                        attendeesList:
                                            WebinarManagementController
                                                .currentWebinar['attendees'],
                                      ),
                                      transition: Transition.rightToLeft,
                                    );
                                  },
                                  child: Text(
                                    '${WebinarManagementController.currentWebinar['attendees'].length} people attending',
                                    style: TextStyle(
                                      fontSize: AppLayout.getHeight(16),
                                      fontFamily: 'JosefinSans Bold',
                                      fontWeight: FontWeight.w500,
                                      color: Get.isDarkMode
                                          ? const Color.fromRGBO(
                                              74, 229, 239, 1)
                                          : const Color.fromRGBO(
                                              248, 79, 57, 1),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  pinned: true,
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(10.0),
                    child: TabBar(
                      controller: _tabController,
                      indicatorWeight: 2.0,
                      indicatorColor: AppColors.LTprimaryColor,
                      unselectedLabelStyle: TextStyle(
                        fontSize: AppLayout.getHeight(10),
                        fontFamily: 'JosefinSans Bold',
                        fontWeight: FontWeight.w300,
                        color: Get.isDarkMode
                            ? Colors.white.withOpacity(0.8)
                            : Colors.black.withOpacity(0.9),
                      ),
                      tabs: [
                        Tab(
                          child: Text(
                            "About",
                            style: TextStyle(
                              letterSpacing: 1,
                              height: 1.5,
                              fontSize: AppLayout.getHeight(12),
                              fontFamily: 'JosefinSans Bold',
                              fontWeight: FontWeight.w600,
                              color: Get.isDarkMode
                                  ? Colors.white.withOpacity(0.8)
                                  : Colors.black.withOpacity(0.9),
                            ),
                          ),
                        ),
                        Tab(
                          child: FittedBox(
                            child: Text(
                              "Organizers",
                              style: TextStyle(
                                height: 1.5,
                                letterSpacing: 1,
                                fontSize: AppLayout.getHeight(12),
                                fontFamily: 'JosefinSans Bold',
                                fontWeight: FontWeight.w600,
                                color: Get.isDarkMode
                                    ? Colors.white.withOpacity(0.8)
                                    : Colors.black.withOpacity(0.9),
                              ),
                            ),
                          ),
                        ),
                        Tab(
                          child: Text(
                            "Guests",
                            style: TextStyle(
                              height: 1.5,
                              letterSpacing: 1,
                              fontSize: AppLayout.getHeight(12),
                              fontFamily: 'JosefinSans Bold',
                              fontWeight: FontWeight.w600,
                              color: Get.isDarkMode
                                  ? Colors.white.withOpacity(0.8)
                                  : Colors.black.withOpacity(0.9),
                            ),
                          ),
                        ),
                        Tab(
                          child: Text(
                            "Reviews",
                            style: TextStyle(
                              height: 1.5,
                              letterSpacing: 1,
                              fontSize: AppLayout.getHeight(12),
                              fontFamily: 'JosefinSans Bold',
                              fontWeight: FontWeight.w600,
                              color: Get.isDarkMode
                                  ? Colors.white.withOpacity(0.8)
                                  : Colors.black.withOpacity(0.9),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ];
            },
            body:
                GetBuilder<WebinarManagementController>(builder: (controller) {
              return TabBarView(
                controller: _tabController,
                children: [
                  // The content for the first tab goes here
                  ListView(
                    padding: EdgeInsets.symmetric(
                        horizontal: AppLayout.getWidth(20)),
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      Gap(
                        AppLayout.getHeight(20),
                      ),
                      Text(
                        WebinarManagementController.currentWebinar['tagline'],
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            height: 1.5,
                            color: Get.isDarkMode
                                ? const Color(0xffA1a1aa)
                                : const Color(0xff475569),
                            fontSize: AppLayout.getHeight(20),
                            fontFamily: 'JosefinSans Regular'),
                      ),
                      Gap(
                        AppLayout.getHeight(20),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Get.find<AuthController>()
                                  .currentUser['favorites']
                                  .contains(WebinarManagementController
                                      .currentWebinar['_id'])
                              ? IconButton(
                                  onPressed: () async {
                                    await Get.find<
                                            WebinarManagementController>()
                                        .removeWebinarfromFavs(
                                            WebinarManagementController
                                                .currentWebinar['_id'],
                                            Get.find<AuthController>()
                                                .currentUser['_id']);
                                  },
                                  icon: Icon(
                                    Icons.favorite,
                                    size: 40.h,
                                    color: AppColors.LTprimaryColor,
                                  ),
                                )
                              : IconButton(
                                  onPressed: () async {
                                    await Get.find<
                                            WebinarManagementController>()
                                        .addWebinarToFavs(
                                            WebinarManagementController
                                                .currentWebinar['_id'],
                                            Get.find<AuthController>()
                                                .currentUser['_id']);
                                  },
                                  icon: Icon(
                                    Icons.favorite_border,
                                    size: 40.h,
                                    color: AppColors.LTprimaryColor,
                                  ),
                                ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: AppLayout.getWidth(130),
                                height: AppLayout.getHeight(25),
                                child: AutoSizeText(
                                  "\$ ${WebinarManagementController.currentWebinar['price']}",
                                  maxLines: 1,
                                  style: TextStyle(
                                      fontFamily: 'JosefinSans Bold',
                                      letterSpacing: 1,
                                      fontWeight: FontWeight.w500,
                                      color: Get.isDarkMode
                                          ? const Color.fromRGBO(
                                              212, 212, 216, 1)
                                          : const Color(0xff475569),
                                      fontSize: AppLayout.getHeight(20)),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Gap(
                                AppLayout.getHeight(10),
                              ),
                              GetBuilder<WebinarManagementController>(
                                  builder: (controller) {
                                print('canStream: $canStream');
                                if (WebinarManagementController.currentWebinar
                                    .containsKey('ended')) {
                                  return const Text(' Webinar Ended');
                                }

                                if (webinarStreamStatus.value == 'ended') {
                                  return const Text('Ended');
                                } else if (canStream &&
                                    webinarStreamStatus.value == 'live') {
                                  return GestureDetector(
                                    onTap: () async {
                                      print('join now pressed');
                                      await Get.find<WebinarStreamController>()
                                          .joinStream(
                                              WebinarManagementController
                                                  .currentWebinar['_id'],
                                              context);
                                      print('join now pressed');
                                    },
                                    child: Container(
                                      width: AppLayout.getWidth(130),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: AppLayout.getWidth(5),
                                          vertical: AppLayout.getHeight(10)),
                                      decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.1),
                                              offset: const Offset(2, 2),
                                              blurRadius: 6,
                                              spreadRadius: 3,
                                            ),
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.1),
                                              offset: const Offset(-2, -2),
                                              blurRadius: 10,
                                              spreadRadius: 3,
                                            ),
                                          ],
                                          border: Border.all(
                                            color: Get.isDarkMode
                                                ? Colors.white.withOpacity(0.1)
                                                : Colors.black.withOpacity(0.1),
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: AppColors.LTprimaryColor),
                                      child: Text(
                                        'Join Now',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color:
                                                Colors.white.withOpacity(.98),
                                            fontWeight: FontWeight.w600,
                                            fontSize: AppLayout.getHeight(20),
                                            fontFamily: 'JosefinSans Bold'),
                                      ),
                                    ),
                                  );
                                } else if (WebinarManagementController
                                        .currentWebinar['createdBy']['_id'] ==
                                    Get.find<AuthController>()
                                        .currentUser['_id']) {
                                  return const Text('');
                                } else if (!alreadyRegistered()) {
                                  return GestureDetector(
                                    onTap: () async {
                                      print('Resgister now pressed');
                                      await Get.find<
                                              WebinarManagementController>()
                                          .registerForwebinar(
                                        WebinarManagementController
                                            .currentWebinar['_id'],
                                      );
                                      print('Resgister now pressed');
                                    },
                                    child: Container(
                                      width: AppLayout.getWidth(130),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: AppLayout.getWidth(5),
                                          vertical: AppLayout.getHeight(10)),
                                      decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.1),
                                              offset: const Offset(2, 2),
                                              blurRadius: 6,
                                              spreadRadius: 3,
                                            ),
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.1),
                                              offset: const Offset(-2, -2),
                                              blurRadius: 10,
                                              spreadRadius: 3,
                                            ),
                                          ],
                                          border: Border.all(
                                            color: Get.isDarkMode
                                                ? Colors.white.withOpacity(0.1)
                                                : Colors.black.withOpacity(0.1),
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: AppColors.LTprimaryColor),
                                      child: Text(
                                        'Register',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color:
                                                Colors.white.withOpacity(.98),
                                            fontWeight: FontWeight.w600,
                                            fontSize: AppLayout.getHeight(20),
                                            fontFamily: 'JosefinSans Bold'),
                                      ),
                                    ),
                                  );
                                }
                                return Text(webinarStreamStatus.value);
                              }),
                            ],
                          ),
                        ],
                      ),
                      Gap(
                        AppLayout.getHeight(20),
                      ),

                      Gap(AppLayout.getHeight(20)),
                      Text(
                        'Created By',
                        style: TextStyle(
                          letterSpacing: 1,
                          fontSize: AppLayout.getHeight(14),
                          color: Get.isDarkMode
                              ? const Color.fromRGBO(122, 121, 121, 1)
                              : const Color.fromRGBO(176, 179, 190, 1),
                          fontWeight: FontWeight.w700,
                          fontFamily: 'JosefinSans Bold',
                        ),
                      ),
                      Gap(AppLayout.getHeight(10)),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(AppLayout.getHeight(10)),
                          border: Border.all(
                            color: Get.isDarkMode
                                ? Colors.white.withOpacity(0.1)
                                : Colors.black.withOpacity(0.1),
                          ),
                          color: Get.isDarkMode ? Colors.black54 : Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              offset: const Offset(2, 2),
                              blurRadius: 6,
                              spreadRadius: 0,
                            ),
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.01),
                              offset: const Offset(-2, -2),
                              blurRadius: 7,
                            ),
                          ],
                        ),
                        child: GestureDetector(
                          onTap: () async {
                            AuthController.otherUserProfile.clear();

                            bool fetched = await Get.find<AuthController>()
                                .otherUserProfileDetails(
                                    WebinarManagementController
                                        .currentWebinar['createdBy']['_id']);
                            if (fetched) {
                              Get.to(() => const UserProfileView());
                            }
                          },
                          child: ListTile(
                            leading: CircleAvatar(
                              radius: AppLayout.getHeight(30),
                              backgroundImage: NetworkImage(
                                  AppConstants.baseURL +
                                      WebinarManagementController
                                              .currentWebinar['createdBy']
                                          ['profile_image']),
                            ),
                            title: Text(
                              WebinarManagementController
                                  .currentWebinar['createdBy']['name'],
                              style: TextStyle(
                                height: 1.5,
                                fontSize: AppLayout.getHeight(16),
                                color: Get.isDarkMode
                                    ? Colors.white.withOpacity(0.9)
                                    : Colors.black.withOpacity(0.9),
                                fontWeight: FontWeight.w500,
                                letterSpacing: 1,
                                fontFamily: 'JosefinSans Regular',
                              ),
                            ),
                            subtitle: Text(
                              WebinarManagementController
                                  .currentWebinar['createdBy']['email'],
                              style: TextStyle(
                                letterSpacing: 1,
                                fontSize: AppLayout.getHeight(14),
                                fontWeight: FontWeight.w500,
                                fontFamily: 'JosefinSans Medium',
                              ),
                            ),
                          ),
                        ),
                      ),
                      Gap(AppLayout.getHeight(28)),
                      Text(
                        'Catergories',
                        style: TextStyle(
                          letterSpacing: 1,
                          fontSize: AppLayout.getHeight(14),
                          color: Get.isDarkMode
                              ? const Color.fromRGBO(122, 121, 121, 1)
                              : const Color.fromRGBO(176, 179, 190, 1),
                          fontWeight: FontWeight.w700,
                          fontFamily: 'JosefinSans Bold',
                        ),
                      ),
                      Gap(AppLayout.getHeight(10)),
                      // this is where the categories are handled and displayed
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Wrap(
                              children: List.generate(
                                  WebinarManagementController
                                      .currentWebinar['categories']
                                      .length, (index) {
                            return Container(
                              width: 120,
                              height: 60,
                              margin:
                                  const EdgeInsets.only(right: 30, bottom: 30),
                              padding: EdgeInsets.symmetric(
                                  horizontal: AppLayout.getWidth(10),
                                  vertical: AppLayout.getHeight(5)),
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    offset: const Offset(0, 2),
                                    blurRadius: 4,
                                    spreadRadius: 0,
                                  ),
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    offset: const Offset(0, -2),
                                    blurRadius: 4,
                                  ),
                                ],
                                color: Get.isDarkMode
                                    ? const Color.fromRGBO(38, 38, 38, 1)
                                    : const Color.fromRGBO(243, 243, 244, 1),
                                border: Border.all(
                                  color: Get.isDarkMode
                                      ? Colors.white.withOpacity(0.1)
                                      : Colors.black.withOpacity(0.1),
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: AutoSizeText(
                                  WebinarManagementController
                                          .currentWebinar['categories'][index]
                                      ['name'],
                                  style: TextStyle(
                                      fontFamily: 'JosefinSans Bold',
                                      fontWeight: FontWeight.w500,
                                      color: Get.isDarkMode
                                          ? const Color.fromRGBO(
                                              212, 212, 216, 1)
                                          : const Color(0xff475569),
                                      fontSize: AppLayout.getHeight(17)),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            );
                          })),
                        ),
                      ),
                      Gap(AppLayout.getHeight(28)),
                      Text(
                        'Description',
                        style: TextStyle(
                          letterSpacing: 1,
                          fontSize: AppLayout.getHeight(14),
                          color: Get.isDarkMode
                              ? const Color.fromRGBO(122, 121, 121, 1)
                              : const Color.fromRGBO(176, 179, 190, 1),
                          fontWeight: FontWeight.w700,
                          fontFamily: 'JosefinSans Bold',
                        ),
                      ),
                      Gap(AppLayout.getHeight(16)),
                      ExpandableText(
                        WebinarManagementController
                            .currentWebinar['description'],
                        expandText: 'Show more',
                        collapseText: 'Show less',
                        maxLines: 5,
                        linkColor: Colors.blue,
                        style: TextStyle(
                            height: 1.5,
                            fontFamily: 'JosefinSans Regular',
                            fontWeight: FontWeight.w500,
                            color: Get.isDarkMode
                                ? const Color(0xffa1a1aa)
                                : const Color(0xff475569),
                            fontSize: AppLayout.getHeight(17)),
                      ),

                      Gap(AppLayout.getHeight(28)),
                      Text(
                        'Tags',
                        style: TextStyle(
                          letterSpacing: 1,
                          fontSize: AppLayout.getHeight(14),
                          color: Get.isDarkMode
                              ? const Color.fromRGBO(122, 121, 121, 1)
                              : const Color.fromRGBO(176, 179, 190, 1),
                          fontWeight: FontWeight.w700,
                          fontFamily: 'JosefinSans Bold',
                        ),
                      ),

                      Gap(AppLayout.getHeight(28)),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Wrap(
                              spacing: 10,
                              runSpacing: 15,
                              children: List.generate(
                                  WebinarManagementController
                                      .currentWebinar['tags'].length, (index) {
                                return Container(
                                  width: 90,
                                  height: 50,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: AppLayout.getWidth(10),
                                      vertical: AppLayout.getHeight(5)),
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.1),
                                        offset: const Offset(0, 2),
                                        blurRadius: 4,
                                        spreadRadius: 0,
                                      ),
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.1),
                                        offset: const Offset(0, -2),
                                        blurRadius: 4,
                                      ),
                                    ],
                                    color: Get.isDarkMode
                                        ? const Color.fromRGBO(38, 38, 38, 1)
                                        : const Color.fromRGBO(
                                            243, 243, 244, 1),
                                    border: Border.all(
                                      color: Get.isDarkMode
                                          ? Colors.white.withOpacity(0.1)
                                          : Colors.black.withOpacity(0.1),
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Center(
                                    child: AutoSizeText(
                                      WebinarManagementController
                                          .currentWebinar['tags'][index],
                                      maxLines: 1,
                                      style: TextStyle(
                                          fontFamily: 'JosefinSans Bold',
                                          fontWeight: FontWeight.w500,
                                          color: Get.isDarkMode
                                              ? const Color.fromRGBO(
                                                  212, 212, 216, 1)
                                              : const Color(0xff475569),
                                          fontSize: AppLayout.getHeight(17)),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                );
                              })),
                        ),
                      ),
                      //report button
                      Gap(AppLayout.getHeight(28)),
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            // Get.to(() => const ReportView());
                            Get.to(() => ReportScreen(
                                  reportType: 'webinar',
                                ));
                          },
                          child: Container(
                            width: AppLayout.getWidth(240),
                            height: AppLayout.getHeight(40),
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(255, 0, 0, 1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                'Report this webinar',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                        color: Colors.white, fontSize: 18.sp),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Gap(AppLayout.getHeight(28)),
                      Text(
                        'Similar Recommendations',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      Gap(10.h),
                      GetBuilder<WebinarManagementController>(
                          assignId: true,
                          id: 'similarWebinarsUpdated',
                          builder: (w) {
                            // _scrollController.jumpTo(0);
                            return CaresoulSliderHome(
                                scroll: true,
                                scrollController: _scrollController,
                                webinarList: WebinarManagementController
                                    .similarWebinars);
                          }),
                    ],
                  ),
                  // The content for the second tab goes here==========================================
                  GetBuilder<WebinarManagementController>(builder: (context) {
                    print('organizers Build');
                    return ListView(
                      padding: EdgeInsets.symmetric(
                          horizontal: AppLayout.getWidth(20)),
                      physics: const NeverScrollableScrollPhysics(),
                      children: List.generate(
                        WebinarManagementController
                            .currentWebinar['organizers'].length,
                        (index) => GestureDetector(
                          onTap: () async {
                            AuthController.otherUserProfile.clear();

                            bool fetched = await Get.find<AuthController>()
                                .otherUserProfileDetails(
                                    WebinarManagementController
                                            .currentWebinar['organizers'][index]
                                        ['_id']);
                            if (fetched) {
                              Get.to(() => const UserProfileView());
                            }
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                vertical: AppLayout.getHeight(20)),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  AppLayout.getHeight(10)),
                              border: Border.all(
                                color: Get.isDarkMode
                                    ? Colors.white.withOpacity(0.1)
                                    : Colors.black.withOpacity(0.1),
                              ),
                              color: Get.isDarkMode
                                  ? Colors.black54
                                  : Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  offset: const Offset(2, 2),
                                  blurRadius: 6,
                                  spreadRadius: 0,
                                ),
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.01),
                                  offset: const Offset(-2, -2),
                                  blurRadius: 7,
                                ),
                              ],
                            ),
                            child: ListTile(
                              leading: CircleAvatar(
                                radius: AppLayout.getHeight(30),
                                backgroundImage: NetworkImage(
                                    AppConstants.baseURL +
                                        WebinarManagementController
                                                .currentWebinar['organizers']
                                            [index]['profile_image']),
                              ),
                              title: Text(
                                WebinarManagementController
                                        .currentWebinar['organizers'][index]
                                    ['name'],
                                style: TextStyle(
                                  fontSize: AppLayout.getHeight(16),
                                  color: Get.isDarkMode
                                      ? Colors.white.withOpacity(0.9)
                                      : Colors.black.withOpacity(0.9),
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 1,
                                  fontFamily: 'JosefinSans Regular',
                                ),
                              ),
                              subtitle: Text(
                                WebinarManagementController
                                        .currentWebinar['organizers'][index]
                                    ['email'],
                                style: TextStyle(
                                  letterSpacing: 1,
                                  fontSize: AppLayout.getHeight(14),
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'JosefinSans Regular',
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                  // The content for the third tab goes here================================
                  GetBuilder<WebinarManagementController>(
                      builder: (controller) {
                    print('guests updated');
                    return ListView(
                      padding: EdgeInsets.symmetric(
                          horizontal: AppLayout.getWidth(20)),
                      physics: const NeverScrollableScrollPhysics(),
                      children: List.generate(
                        WebinarManagementController
                            .currentWebinar['guests'].length,
                        (index) => Container(
                          margin: EdgeInsets.symmetric(
                              vertical: AppLayout.getHeight(20)),
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(AppLayout.getHeight(10)),
                            border: Border.all(
                              color: Get.isDarkMode
                                  ? Colors.white.withOpacity(0.1)
                                  : Colors.black.withOpacity(0.1),
                            ),
                            color:
                                Get.isDarkMode ? Colors.black54 : Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                offset: const Offset(2, 2),
                                blurRadius: 6,
                                spreadRadius: 0,
                              ),
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.01),
                                offset: const Offset(-2, -2),
                                blurRadius: 7,
                              ),
                            ],
                          ),
                          child: GestureDetector(
                            onTap: () async {
                              AuthController.otherUserProfile.clear();
                              bool fetched = await Get.find<AuthController>()
                                  .otherUserProfileDetails(
                                      WebinarManagementController
                                              .currentWebinar['guests'][index]
                                          ['_id']);
                              if (fetched) {
                                Get.to(() => const UserProfileView());
                              }
                            },
                            child: ListTile(
                              leading: CircleAvatar(
                                radius: AppLayout.getHeight(30),
                                backgroundImage: NetworkImage(
                                    AppConstants.baseURL +
                                        WebinarManagementController
                                                .currentWebinar['guests'][index]
                                            ['profile_image']),
                              ),
                              title: Text(
                                WebinarManagementController
                                    .currentWebinar['guests'][index]['name'],
                                style: TextStyle(
                                  fontSize: AppLayout.getHeight(16),
                                  color: Get.isDarkMode
                                      ? Colors.white.withOpacity(0.9)
                                      : Colors.black.withOpacity(0.9),
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 1,
                                  fontFamily: 'JosefinSans Regular',
                                ),
                              ),
                              subtitle: Text(
                                WebinarManagementController
                                    .currentWebinar['guests'][index]['email'],
                                style: TextStyle(
                                  letterSpacing: 1,
                                  fontSize: AppLayout.getHeight(14),
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'JosefinSans Regular',
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),

                  // The content for the ReviewsTab goes here
                  WebinarManagementController.currentWebinar['ended'] == null
                      ? Center(
                          child: Text(
                            'Reviews will be available after the webinar ends',
                            style: onelineStyle,
                          ),
                        )
                      : ListView(
                          physics: const ClampingScrollPhysics(),
                          padding: EdgeInsets.symmetric(
                              vertical: 20.w, horizontal: 20.h),
                          children: [
                            canpostreview()
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      TextFormField(
                                        style: onelineStyle,
                                        onChanged: (value) {
                                          setState(() {});
                                        },
                                        controller: reviewController,
                                        maxLines: 4,
                                        decoration: InputDecoration(
                                          hintText: 'Write a review. . .',
                                          hintStyle: onelineStyle,
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                      ),
                                      Gap(10.h),
                                      RatingBar.builder(
                                        initialRating: 4,
                                        minRating: 1,
                                        itemSize: 24.h,
                                        direction: Axis.horizontal,
                                        allowHalfRating: true,
                                        itemCount: 5,
                                        itemPadding: const EdgeInsets.symmetric(
                                            horizontal: 4.0),
                                        itemBuilder: (context, _) => const Icon(
                                          Icons.star,
                                          color: AppColors.LTsecondaryColor,
                                        ),
                                        onRatingUpdate: (rating) {
                                          reviewRating = rating.toInt();
                                        },
                                      ),
                                      ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            fixedSize:
                                                Size(double.maxFinite, 10.h),
                                          ),
                                          onPressed: reviewController.text
                                                      .toString() ==
                                                  ""
                                              ? null
                                              : () async {
                                                  await Get.find<
                                                          ReviewController>()
                                                      .addReviewToWebinar(
                                                          WebinarManagementController
                                                                  .currentWebinar[
                                                              '_id'],
                                                          Get.find<AuthController>()
                                                                  .currentUser[
                                                              '_id'],
                                                          reviewController.text
                                                              .toString(),
                                                          reviewRating);
                                                  setState(() {
                                                    reviewController.text = '';
                                                    //close keyboard;
                                                    FocusScope.of(context)
                                                        .unfocus();
                                                  });
                                                },
                                          child: const Text('Submit')),
                                    ],
                                  )
                                : const SizedBox(),
                            Gap(20.h),
                            Divider(
                              color: onelineStyle.color,
                              thickness: 1,
                            ),
                            Gap(10.h),
                            ReviewController.currentUserreview.isEmpty
                                ? const SizedBox()
                                : MyReviewWidget(
                                    editable: true,
                                    callbackAction: () {
                                      setState(() {
                                        _scrollController.animateTo(
                                          0,
                                          duration:
                                              const Duration(milliseconds: 500),
                                          curve: Curves.easeOut,
                                        );
                                        reviewController.text = ReviewController
                                            .currentUserreview['comment'];
                                      });
                                    },
                                    Date: ReviewController
                                        .currentUserreview['updatedAt'],
                                    review: ReviewController
                                        .currentUserreview['comment'],
                                    Name: Get.find<AuthController>()
                                        .currentUser['name'],
                                    rating: ReviewController
                                        .currentUserreview['rating'],
                                    profileImage: Get.find<AuthController>()
                                        .currentUser['profile_image'],
                                  ),
                            GetBuilder<ReviewController>(
                                assignId: true,
                                id: 'reviewsList',
                                builder: (context) {
                                  print('reviews updated');
                                  return ListView.builder(
                                    physics: const BouncingScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: ReviewController
                                        .reviewsOfCurrentWebiar.length,
                                    itemBuilder: (context, index) {
                                      if (ReviewController
                                              .currentUserreview['_id'] ==
                                          ReviewController
                                                  .reviewsOfCurrentWebiar[index]
                                              ['_id']) {
                                        return const SizedBox();
                                      }
                                      return Container(
                                        margin: EdgeInsets.only(bottom: 20.h),
                                        child: MyReviewWidget(
                                          editable: false,
                                          Date: ReviewController
                                                  .reviewsOfCurrentWebiar[index]
                                              ['updatedAt'],
                                          profileImage: ReviewController
                                                  .reviewsOfCurrentWebiar[index]
                                              ['user']['profile_image'],
                                          review: ReviewController
                                                  .reviewsOfCurrentWebiar[index]
                                              ['comment'],
                                          Name: ReviewController
                                                  .reviewsOfCurrentWebiar[index]
                                              ['user']['name'],
                                        ),
                                      );
                                    },
                                  );
                                }),
                          ],
                        )
                ],
              );
            }),
          ),
        );
      }),
    );
  }
}
