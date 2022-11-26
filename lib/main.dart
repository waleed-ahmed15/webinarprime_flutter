import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webinarprime/routes/routes.dart';
import 'package:webinarprime/utils/themes.dart';
import 'dependencies/dependencies.dart' as dep;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dep.innit();
  // AuthController authController = AuthController();
  // bool rememberme = Get.find<SharedPreferences>().containsKey('token');
  // print('remeber me $rememberme');
  // await authController.authenticateUser(rememberme);
  // print(authController.currentUser);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    print('herere'); 

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      initialRoute: RoutesHelper.signInRoute,
      getPages: RoutesHelper.routes,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.light,
    );
  }
}
