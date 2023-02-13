import 'package:get/get.dart';
import 'package:webinarprime/screens/forgot_password_screen.dart';
import 'package:webinarprime/screens/home_screen.dart';
import 'package:webinarprime/screens/login/login_page.dart';
import 'package:webinarprime/screens/my_webinars/view_my_webinars_screen.dart';
import 'package:webinarprime/screens/payment/paymnet_screen.dart';
import 'package:webinarprime/screens/select_interests/select_interest_screen.dart';
import 'package:webinarprime/screens/sign_up/signup_page.dart';
import 'package:webinarprime/screens/upload_profile_screen.dart';
import 'package:webinarprime/screens/webinar_management/add_webinar_screens/add_webinar_screen1.dart';

import '../screens/webinar_management/add_webinar_screens/add_webinar_screen2.dart';
import '../screens/webinar_management/add_webinar_screens/add_webinar_screen3.dart';

class RoutesHelper {
  static const String signInRoute = '/sign-in';
  static const String signUpRoute = '/sign-up';
  static const String intialRoute = '/';
  static const String uploadProfileRoute = '/upload-profile';
  static const String homeScreenRoute = '/home';
  static const String selectInterestRoute = '/select-interest';
  static const String forgotPasswordRoute = '/forgot-password';
  static const String paymentpage = '/payment';
  static const String addWebinarScreen1route = '/add-webinar-screen1';
  static const String addWebinarScreen2route = '/add-webinar-screen2';
  static const String addWebinarScreen3route = '/add-webinar-screen3';
  static const String viewMyWebinarsRoute = '/view-my-webinars';
  static const String searchUsersRoute = '/search-users';

  static List<GetPage> routes = [
    GetPage(
      name: addWebinarScreen1route,
      page: () => const AddWebinarScreen1(),
    ),
    GetPage(
      name: addWebinarScreen2route,
      page: () => AddWebinarScreen2(),
    ),
    GetPage(name: addWebinarScreen3route, page: () => AddWebinarScreen3()),
    GetPage(name: paymentpage, page: () => const PaymentScreen()),
    GetPage(
      name: forgotPasswordRoute,
      page: () => const ForgotPasswordScreen(),
    ),
    GetPage(
      name: selectInterestRoute,
      page: () => const SelectInterstScreen(),
    ),
    GetPage(
      name: signInRoute,
      page: () => LoginPage(),
    ),
    GetPage(
      name: homeScreenRoute,
      page: () => const HomeScreen(),
    ),
    GetPage(
      name: signUpRoute,
      page: () => const SignUpScreen(),
    ),
    GetPage(
      name: uploadProfileRoute,
      page: () => const UploadProfileScreen(),
    ),
    GetPage(
      name: viewMyWebinarsRoute,
      page: () => const View_my_Webinar_Screen(),
    ),
  ];
}
