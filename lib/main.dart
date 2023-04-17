import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:webinarprime/controllers/auth_controller.dart';
import 'package:webinarprime/controllers/chat_controlller.dart';
import 'package:webinarprime/routes/routes.dart';
import 'package:webinarprime/screens/home_screen/home_screen.dart';
import 'package:webinarprime/utils/themes.dart';
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
      // print('---------------------------------------------------------');
      // print("payload is${details.payload.runtimeType!});
      // print(details.payload.runtimeType);
      Map<String, dynamic> map = jsonDecode(details.payload!);
      // print(jsonDecode(details.payload!));
      // print(map['conversationId']);
      // print(map['senderId']);
      // print(map['type']);
      // print(map['senderId']);
      // Map<String, dynamic> sender = jsonDecode(map['senderId']);
      // print(sender['name']);
      // final jsonMap = json.decode(map['senderId']);
      // final myMap = Map<String, dynamic>.from(jsonMap);
      // print(myMap['name']);
      if (map['type'] == 'webinar') {
        // Get.toNamed(RoutesHelper.webinarStreamRoute,
        // arguments: map['webinarId']);
      } else if (map['type'] == 'message') {
        await Get.find<ChatStreamController>()
            .getConversations(Get.find<AuthController>().currentUser['_id']);
        Get.to(() => HomeScreen(
              currIndex: 3,
            ));
      }
      // print('---------------------------------------------------------');
    },
  );
  print('notification initialized:$initialized');
  runApp(const MyApp());
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
            // initialRoute: RoutesHelper.signInRoute,
            initialRoute: RoutesHelper.signInRoute,
            // initialRoute: Get.to(()=>ConnectPage()),
            // initialRoute: RoutesHelper.liveKitConnectPage,
            // initialRoute: RoutesHelper.addWebinarScreen1route,
            getPages: RoutesHelper.routes,
            theme: lightTheme,
            darkTheme: darkTheme,

            // themeMode: ThemeMode.system,
            // themeMode: ThemeMode.light,
            themeMode: ThemeMode.dark,

            // themeMode: context.watch<ThemeProvider>().themeMode,
          );
        },
        designSize: const Size(392.7, 803));
  }
}
