import 'package:get/get.dart';
import 'package:webinarprime/screens/forgot_password_screen.dart';
import 'package:webinarprime/screens/home_screen.dart';
import 'package:webinarprime/screens/login/login_page.dart';
import 'package:webinarprime/screens/select_interests/select_interest_screen.dart';
import 'package:webinarprime/screens/sign_up/signup_page.dart';
import 'package:webinarprime/screens/upload_profile_screen.dart';

class RoutesHelper {
  static const String signInRoute = '/sign-in';
  static const String signUpRoute = '/sign-up';
  static const String intialRoute = '/';
  static const String uploadProfileRoute = '/upload-profile';
  static const String homeScreenRoute = '/home';
  static const String selectInterestRoute = '/select-interest';
  static const String forgotPasswordRoute = '/forgot-password';

  static List<GetPage> routes = [
    GetPage(
      name: forgotPasswordRoute,
      page: () => ForgotPasswordScreen(),
    ),
    GetPage(
      name: selectInterestRoute,
      page: () => SelectInterstScreen(),
    ),
    GetPage(
      name: signInRoute,
      page: () => LoginPage(),
    ),
    GetPage(
      name: homeScreenRoute,
      page: () => HomeScreen(),
    ),
    GetPage(
      name: signUpRoute,
      page: () => SignUpScreen(),
    ),
    GetPage(
      name: uploadProfileRoute,
      page: () => UploadProfileScreen(),
    )
  ];
}
