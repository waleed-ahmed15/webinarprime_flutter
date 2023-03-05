import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:mime_type/mime_type.dart';
import 'package:webinarprime/utils/app_constants.dart';
// import 'package:get/get.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile;
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webinarprime/routes/routes.dart';
import 'package:webinarprime/screens/home_screen/home_screen.dart';
import 'package:webinarprime/widgets/snackbar.dart';
import 'package:dio/dio.dart';
// import 'package:get/get.dart' hide Response, FormData, MultipartFile;
import 'package:http_parser/http_parser.dart';

class AuthController extends GetxController {
  final SharedPreferences sharedPreferences = Get.find();
  Map<String, dynamic> currentUser = {};
  String? current_email;
  String token = '';
  List<dynamic> searchedUsers = [];
  List<dynamic> currentUserInvitations = [];

  @override
  void onInit() async {
    // TODO: implement onInit
    // SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // await authenticateUser(sharedPreferences.containsKey('token'));
    // print('on init');
    // print(currentUser);
    await initialRoute();
    print('innit called');
    // Timer.periodic(const Duration(seconds: 4), (timer) {
    // getInvitations(currentUser['id'] ?? '');
    // });
    super.onInit();
  }

  String dateformatter(String date) {
    var now = DateTime.now();
    var formatter = DateFormat.yMMMMd('en_US');
    String formattedDate = formatter.format(now);
    print(formattedDate);
    return formattedDate; // 2016-01-25
  }

  Future<void> deleteAccout() async {
    try {
      Uri url = Uri.parse("${AppConstants.baseURL}/user/delete");
      print(currentUser);
      var response = await http.post(
        url,
        body: {
          "email": currentUser['email'],
        },
      );
      print(jsonDecode(response.body));
      logout();
    } catch (e) {
      print(e);
    }
  }

  Future<void> signUpUser(
      {required String email,
      required String password,
      required String username}) async {
    print('signup user called');

    try {
      Uri url = Uri.parse("${AppConstants.baseURL}/user/register");

      final response = await http.post(url, body: {
        "email": email,
        "password": password,
        "name": username,
        // "birthdate": dateformatter(DateTime.now().toString())
      });

      var data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        authenticateUser(false);
        ShowCustomSnackBar('User Registered Successfully',
            title: 'Success', isError: false);
        signIn(email, password, false);
      } else {
        ShowCustomSnackBar((data['message']),
            title: 'Sign Up failed', isError: true);
      }
      print(response.statusCode.toString());
      print(jsonDecode(response.body));
    } catch (e) {
      print(e);
    }
  }

  Future<void> authenticateUser(bool rememberMe) async {
    try {
      print('authenticate user called');

      final sharedPreferences = Get.find<SharedPreferences>();
      sharedPreferences.setString(
          'tempToken', '${sharedPreferences.getString('token')}');

      print(sharedPreferences.getString('token'));
      final response = await http.get(headers: {
        'content-type': 'application/json; charset=UTF-8',
        'Authorization': sharedPreferences.getString('token')!,
      }, Uri.parse('${AppConstants.baseURL}/user/authenticate'));

      if (response.statusCode == 200) {
        final data = await jsonDecode(response.body);
        print("data");
        print(data);
        print(data['user']['name']);
        currentUser = data['user'];
        print(currentUser);
        if (!rememberMe) {
          sharedPreferences.remove('token');
        }
      } else {
        print('invalid token');
        // Get.offAllNamed(RoutesHelper.signInRoute);
        print(response.body.toString());
      }
      update();
    } catch (e) {
      print(e);
    }
  }

  Future<void> getUserById(String id) async {
    final response =
        await http.get(Uri.parse('${AppConstants.baseURL}/user/$id'));
    if (response.statusCode == 200) {
      final data = await jsonDecode(response.body);
      print(data);
      currentUser = data['user'];
      print(currentUser);
    }
  }

  Future uploadCompleteData(
      String userEmail, File file, String date, String regno) async {
    String mimeType = mime(file.path) ?? 'image/jpg';
    String mimee = mimeType.split('/')[0];
    String type = mimeType.split('/')[1];
    print(mimee);
    print(type);
    Dio dio = Dio();
    String fileName = file.path.split('/').last;
    FormData formData = FormData.fromMap({
      "profile_image": await MultipartFile.fromFile(
        filename: fileName,
        file.path,
        // filename: "some.jpg",
        contentType: MediaType(mimee, type),
      ),
      "email": userEmail,
      "birthdate": date,
      "registrationNumber": regno,
    });

    var response = await dio.post(
        "${AppConstants.baseURL}/user/completeprofile",
        data: formData,
        options: Options(headers: {'Content-Type': 'multipart/form-data'}));

    print(response.toString());

    await getUserById(currentUser['id']);
    print('new user data is');
    print(currentUser);
    update();
  }

  Future uploadDataWithoutImage(
      String UserEmail, String date, String regno) async {
    Dio dio = Dio();

    FormData formData = FormData.fromMap({
      "email": UserEmail,
      "birthdate": date,
      "registrationNumber": regno,
    });

    var response = await dio.post(
        "${AppConstants.baseURL}/user/completeprofile",
        data: formData,
        options: Options(headers: {'Content-Type': 'multipart/form-data'}));

    print(response.toString());
  }

  Future<void> signIn(String email, String password, bool rememberMe) async {
    try {
      print('login called start');
      Uri url = Uri.parse("${AppConstants.baseURL}/user/login");
      print("email is{$email}");
      print("password is{$password}");
      Map body = {"email": email.toString(), "password": password.toString()};
      var response = await http.post(url, body: body);
      var data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        sharedPreferences.setString('tempToken', data['token'].split(' ')[1]);
        print(data['token']);
        // final SharedPreferences sharedPreferences = Get.find();

        sharedPreferences.setString("token", data['token']);
        token = data['token'];
        // token = sharedPreferences.getString('token')!;
        await authenticateUser(rememberMe);
        ShowCustomSnackBar('login successful',
            isError: false, title: 'Welcome');
        print(currentUser);
        print("regno:");
        print(currentUser['registration_number']);
        if (currentUser.containsKey('birthdate')) {
          Get.offAll(() => const HomeScreen());
          getInvitations(currentUser['id']);
        } else {
          Get.toNamed(RoutesHelper.uploadProfileRoute);
        }

        // authenticateUser();
      } else {
        print(data.toString());
        ShowCustomSnackBar(data['message'],
            isError: true, title: "login failed");
      }
    } catch (e) {
      print(e);
      print(e);
    }
  }

  Future<void> initialRoute() async {
    print(1);
    if (sharedPreferences.getString('token') != null) {
      await authenticateUser(true);
      print(2);
      print(currentUser.isEmpty);

      if (currentUser.isEmpty) {
        Get.toNamed(RoutesHelper.signInRoute);
      } else if (currentUser.containsKey('birthdate')) {
        getInvitations(currentUser['id']);
        Get.toNamed(RoutesHelper.homeScreenRoute);
      } else {
        Get.toNamed(RoutesHelper.uploadProfileRoute);
      }
    } else {
      // Get.toNamed(RoutesHelper.signInRoute);
      print('token is null');
    }
  }

  Future<void> logout() async {
    print(sharedPreferences.getString('token'));
    await sharedPreferences.remove('token');
    // currentUser = null;
    print('token removed and logging out');
    print(sharedPreferences.getString('token'));

    Get.offAllNamed('/sign-in');
  }

  Future<void> resetpassword(String email) async {
    try {
      Uri url = Uri.parse("${AppConstants.baseURL}/user/forgotpassword");
      print("email is{$email}");
      Map body = {"email": email.toString()};
      var response = await http.post(url, body: body);
      var data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        print(data['token']);
        // final SharedPreferences sharedPreferences = Get.find();
        // sharedPreferences.setString("token", data['token']);
        // authenticateUser();
        ShowCustomSnackBar('Password reset link sent to your email',
            isError: false, title: 'Success');
        Get.offAllNamed('/sign-in');
        // authenticateUser();
      } else {
        print(data.toString());
        ShowCustomSnackBar(data['message'],
            isError: true, title: "Password Reset Failed");
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> addInterests(List<String> pickedInerests) async {
    try {
      Uri url = Uri.parse("${AppConstants.baseURL}/user/addinterests");

      // List<String> l = ["636e83c88c013d72c0d48ff1", "636e83c88c013d72c0d48ff0"];
      // print(l);
      AuthController authController = Get.find();
      // print(authController.currentUser['email']);
      var body = {
        'email': authController.currentUser['email'],
        "interests": pickedInerests,
      };
      print(json.encode(body));
      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );
      ShowCustomSnackBar(
          title: "interests added sucessfully", isError: false, "");
      // authenticateUser(sharedPreferences.getString('token') != null);
      Get.offAllNamed(RoutesHelper.homeScreenRoute);
      // Get.to(RoutesHelper.homeScreenRoute);
    } catch (e) {
      print(e);
    }
  }

  //serach user via keywords new method

  Future<bool> searchUserNew(
    String keyword,
    String searchType,
    String webinarId,
  ) async {
    try {
      Uri url = Uri.parse(
          "${AppConstants.baseURL}/user/search/$keyword/$searchType/$webinarId");
      print("keyword is{$keyword}");
      Map body = {"keyword": keyword.toString()};
      var response = await http.get(url);
      var data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        print(data);
        searchedUsers = data['users'];
      } else {
        print(data.toString());
      }
    } catch (e) {
      print(e);
    }
    update();
    return false;
  }

  // get invitations for user
  Future<void> getInvitations(String userid) async {
    print('get invitations called');
    try {
      Uri url = Uri.parse("${AppConstants.baseURL}/user/$userid/invitations");
      var response = await http.get(url);
      var data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        print(data);
        currentUserInvitations = data['invitations'];
      } else {
        print(data.toString());
      }
    } catch (e) {
      print(e);
    }
    update();
  }

  //accept invitation for the webinar
  Future<void> acceptInvitation(String invitationId) async {
    print('accept invitation called');
    try {
      Uri url = Uri.parse("${AppConstants.baseURL}/user/accept-invitation");
      var response = await http.put(
        url,
        body: {"invitationId": invitationId},
      );
      var data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        print(data);
        ShowCustomSnackBar(title: "Invitation accepted", isError: false, "");
        getInvitations(currentUser['id']);
      } else {
        print(data.toString());
      }
    } catch (e) {
      print(e);
    }
  }

  // search all users avaible for creating new conversation

  Future<void> searchUserAll(String keyword) async {
    try {
      Uri url = Uri.parse("${AppConstants.baseURL}/user/search/$keyword");
      Map body = {"keyword": keyword.toString()};
      var response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': Get.find<SharedPreferences>().getString('tempToken')!
        },
      );
      var data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        print(data);
        searchedUsers.clear();
        searchedUsers = data['users'];
        update();
      } else {
        print(data.toString());
      }
    } catch (e) {
      print(e);
    }
  }
}
