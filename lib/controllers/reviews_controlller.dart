import 'dart:convert';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webinarprime/controllers/auth_controller.dart';
import 'package:webinarprime/controllers/webinar_management_controller.dart';
import 'package:webinarprime/utils/app_constants.dart';
// import http package;
import 'package:http/http.dart' as http;

class ReviewController extends GetxController {
  static List reviewsOfCurrentWebiar = [];
  static Map<String, dynamic> currentUserreview = {};

  // get reviewsOfCurrentWebiar => _reviewsOfCurrentWebiar;

  Future<void> getReviewsOfCurrentWebinar(String webinarId) async {
    print('fetching reviews of current webinar');
    try {
      Uri url = Uri.parse("${AppConstants.baseURL}/review/webinar/$webinarId");
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': Get.find<SharedPreferences>().getString('tempToken')!
        },
      );
      if (response.statusCode == 200) {
        print('reviews of current webinar fetched');
        print(response.body);

        reviewsOfCurrentWebiar.clear();
        reviewsOfCurrentWebiar = jsonDecode(response.body)['reviews'];
        // print(reviewsOfCurrentWebiar);

        await usersReviewOfCurrentWebinar();
      }
    } catch (e) {
      print(e);
    }
  }

  // add review to current webinar
  Future<void> addReviewToWebinar(
      String webinarId, String userId, String comment, int rating) async {
    try {
      Uri url = Uri.parse("${AppConstants.baseURL}/review/$webinarId/$userId");
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': Get.find<SharedPreferences>().getString('tempToken')!
        },
        body: jsonEncode(
          {
            'user': userId,
            'webinar': webinarId,
            'comment': comment,
            'rating': rating,
          },
        ),
      );
      if (response.statusCode == 200) {
        print('review posted');
        print(response.body);
        await getReviewsOfCurrentWebinar(webinarId);
        update(['reviewsList']);
      }
    } catch (e) {
      print(e);
    }
  }

  // get current user review
  Future<void> usersReviewOfCurrentWebinar() async {
    print(' fetching current user review ');

    String webinarId = WebinarManagementController.currentWebinar['_id'];
    String userId = Get.find<AuthController>().currentUser['_id'];
    try {
      Uri url =
          Uri.parse("${AppConstants.baseURL}/review/user/$webinarId/$userId");

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': Get.find<SharedPreferences>().getString('tempToken')!
        },
      );
      if (response.statusCode == 200) {
        print('current user review fetched');
        print(response.body);
        currentUserreview = jsonDecode(response.body)['review'];
        print(currentUserreview);
      } else {
        currentUserreview.clear();
        print(response.body);
        print(currentUserreview.isEmpty);
        update();
      }
    } catch (e) {
      print(e);
    }
  }
}
