import 'dart:convert';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webinarprime/controllers/auth_controller.dart';
import 'package:webinarprime/controllers/chat_controlller.dart';
import 'package:webinarprime/controllers/webinar_stream_controller.dart';
import 'package:webinarprime/routes/routes.dart';
import 'package:webinarprime/screens/home_screen/home_screen.dart';
import 'package:webinarprime/screens/notifications/notifications_screen.dart';
import 'package:webinarprime/screens/webinar_management/view_webinar_screen/webinar_details_screen.dart';
import 'package:webinarprime/utils/themes.dart';
import 'controllers/webinar_management_controller.dart';
import 'dependencies/dependencies.dart' as dep;

FlutterLocalNotificationsPlugin notificationsPlugin =
    FlutterLocalNotificationsPlugin();

// final IO.Socket socket = IO.io(AppConstants.baseURL,
// IO.OptionBuilder().setTransports(['websocket']).build());
void main() async {
  // await RoutesHelper.startForegroundService();
  FlutterBackgroundService();
  WidgetsFlutterBinding.ensureInitialized();
  await dep.innit();
  // Stripe.publishableKey =
  //     'pk_test_51M8Q6lG4Misz9p7QWf1WC2sn5TGgl7fJT2WmkRJQ0ecSxj5Kj3SapRQuqV7ANpIt5XlKtxc69NWbIYQAFPb1LgT500fwPV1oqD';
  AndroidInitializationSettings androidSettings =
      const AndroidInitializationSettings('@mipmap/ic_launcher');
  DarwinInitializationSettings iosSettings = const DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
    defaultPresentAlert: true,
    requestCriticalPermission: true,
  );
  InitializationSettings settings = InitializationSettings(
    android: androidSettings,
    iOS: iosSettings,
    // macOS: darwinSettings,
  );
  bool? initialized = await notificationsPlugin.initialize(
    settings,
    onDidReceiveNotificationResponse: (details) async {
      Map<String, dynamic> map = jsonDecode(details.payload!);
      print('map type is ' + map['type']);
      // print('map link is ' + map['link']);
      if (map['type'] == 'webinar') {
        Get.find<WebinarManagementController>().getwebinarById(map['link']);
        Get.to(WebinarDetailsScreen(webinarDetails: map['webinarId']));
      } else if (map['type'] == 'message') {
        print('message notification RR');
        await Get.find<ChatStreamController>()
            .getConversations(Get.find<AuthController>().currentUser['_id']);
        Get.to(() => HomeScreen(
              currIndex: 3,
            ));
      } else if (map['type'] == 'account-upgrade') {
        print('account upgrade notification RR');
        Get.to(() => HomeScreen(
              currIndex: 5,
            ));
      } else if (map['type'] == 'webinar-invitation') {
        Get.find<AuthController>()
            .getInvitations(Get.find<AuthController>().currentUser['_id']);
        Get.to(const NotificationScreen());
      } else if (map['type'] == 'stream-started') {
        Get.find<WebinarStreamController>()
            .joinStream(map['link'], Get.context!);
      }
    },
  );
  print('notification initialized:$initialized');
  runApp(
    Phoenix(child: const MyApp()),
  );
  // runApp(
  //   ChangeNotifierProvider(
  //     create: (_) => ThemeProvider(),
  //     child: const MyApp(),
  //   ),
  // );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        builder: (context, child) {
          return GetMaterialApp(
            key: const Key('main'),
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            navigatorKey: Get.key,
            // initialRoute: RoutesHelper.signInRoute,
            // initialRoute: RoutesHelper.signInRoute,
            initialRoute: RoutesHelper.preLoginScreenRoute,
            // initialRoute: Get.to(()=>ConnectPage()),
            // initialRoute: RoutesHelper.liveKitConnectPage,
            // initialRoute: RoutesHelper.addWebinarScreen1route,
            getPages: RoutesHelper.routes,
            theme: lightTheme,
            darkTheme: darkTheme,

            // themeMode: ThemeMode.system,
            // themeMode: ThemeMode.light,
            themeMode:
                Get.find<SharedPreferences>().getString('theme') == 'light'
                    ? ThemeMode.light
                    : ThemeMode.dark,

            // themeMode: context.watch<ThemeProvider>().themeMode,
          );
        },
        designSize: const Size(392.7, 803));
  }
}
