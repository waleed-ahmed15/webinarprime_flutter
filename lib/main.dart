import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:webinarprime/routes/routes.dart';
import 'package:webinarprime/utils/themes.dart';
import 'dependencies/dependencies.dart' as dep;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dep.innit();
  Stripe.publishableKey =
      'pk_test_51M8Q6lG4Misz9p7QWf1WC2sn5TGgl7fJT2WmkRJQ0ecSxj5Kj3SapRQuqV7ANpIt5XlKtxc69NWbIYQAFPb1LgT500fwPV1oqD';

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      key: const Key('main'),
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      // initialRoute: RoutesHelper.signInRoute,
      initialRoute: RoutesHelper.signInRoute,
      // initialRoute: RoutesHelper.addWebinarScreen1route,
      getPages: RoutesHelper.routes,
      theme: lightTheme,
      darkTheme: darkTheme,
      // themeMode: ThemeMode.system,
      themeMode: ThemeMode.light,
      // themeMode: ThemeMode.dark,
    );
  }
}