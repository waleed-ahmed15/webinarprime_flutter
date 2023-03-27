import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile;

// import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mime_type/mime_type.dart';

import '../utils/app_constants.dart';

class MarketingController extends GetxController {
  Future<int> emailMarketing_without_image(
      String webinarid, String age, String message) async {
    try {
      Uri url = Uri.parse(
          "${AppConstants.baseURL}/marketing/market-on-email-existing");
      http.Response response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(
          {"webinarId": webinarid, "age": age, "message": message},
        ),
      );
      if (response.statusCode == 200) {
        print('email marketing without image success');
        print(response.body);
        return response.statusCode;
      } else {
        print('email marketing without image failed');
        print(response.body);
        return response.statusCode;
      }
    } catch (e) {
      print(e);
      return 0;
    }
  }

  // upload with image
  Future<int> emailMarketing_with_image(
      String webinarid, String age, String message, File bannerImage) async {
    try {
      String mimeType = mime(bannerImage.path) ?? 'image/jpg';
      String mimee = mimeType.split('/')[0];
      String type = mimeType.split('/')[1];
      // print(mimee);
      // print(type);
      Dio dio = Dio();
      String bannerfileName = bannerImage.path.split('/').last;
      // String coverfileName = bannerImage.path.split('/').last;

      // print(bannerfileName);
      // print(coverfileName);
      FormData formData = FormData.fromMap(
        {
          "image": await MultipartFile.fromFile(
            filename: bannerfileName,
            bannerImage.path,
            // filename: "some.jpg",
            // contentType: MediaType(mimee, type),
          ),
          "webinarId": webinarid,
          "age": age,
          "message": message,
        },
      );
      Response response1 = await dio.post(
          "${AppConstants.baseURL}/marketing/market-on-email-new",
          data: formData,
          options: Options(headers: {'Content-Type': 'multipart/form-data'}));
      // print(response1.data['bannerPath']);
      // getwebinarById(id);
      // print('edit banner updated added sucessfully');
      // update();
      // getAllwebinars();
      if (response1.statusCode == 200) {
        print('email marketing with image success');
        print(response1.data);
        return response1.statusCode!;
        // return response1.data['bannerPath'];
      } else {
        print('email marketing with image failed');
        print(response1.data);
        return response1.statusCode!;
        // return response1.data['bannerPath'];
      }
      // print(response1.data);
      // return response1.data['bannerPath'];
    } catch (e) {
      print(e);
      return 0;
      // return 'error';
    }
  }

  // facebook marketing without Image
  Future<int> facebookMarketing_without_image(
      String webinarid, String message) async {
    try {
      Uri url = Uri.parse(
          "${AppConstants.baseURL}/marketing/market-on-facebook-existing");
      http.Response response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(
          {"webinarId": webinarid, "message": message},
        ),
      );
      if (response.statusCode == 200) {
        print('facebook marketing without image success');
        print(response.body);
        return response.statusCode;
      } else {
        print('facebook marketing without image failed');
        print(response.body);
        return response.statusCode;
      }
    } catch (e) {
      print(e);
      return 0;
    }
  }
  // facebook marketing with Image
  Future<int> facebookMarketing_with_image(
      String webinarid, String message, File bannerImage) async {
    // print('edit webinar banner image called');
    try {
      String mimeType = mime(bannerImage.path) ?? 'image/jpg';
      String mimee = mimeType.split('/')[0];
      String type = mimeType.split('/')[1];
     
      Dio dio = Dio();
      String bannerfileName = bannerImage.path.split('/').last;
   

      FormData formData = FormData.fromMap(
        {
          "image": await MultipartFile.fromFile(
            filename: bannerfileName,
            bannerImage.path,
            // filename: "some.jpg",
            // contentType: MediaType(mimee, type),
          ),
          "webinarId": webinarid,
          "message": message,
        },
      );
      Response response1 = await dio.post(
          "${AppConstants.baseURL}/marketing/market-on-facebook-new",
          data: formData,
          options: Options(headers: {'Content-Type': 'multipart/form-data'}));
      if (response1.statusCode == 200) {
        print('facebook marketing with image success');
        print(response1.data);
        return response1.statusCode!;
        // return response1.data['bannerPath'];
      } else {
        print('facebook marketing with image failed');
        print(response1.data);
        return response1.statusCode!;
      }
    } catch (e) {
      print(e);
      return 0;
    }
  }
}
