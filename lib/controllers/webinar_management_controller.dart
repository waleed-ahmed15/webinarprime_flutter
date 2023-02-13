import 'dart:convert';
import 'package:http_parser/http_parser.dart';

import 'package:dio/dio.dart';
// import 'package:get/get.dart';
import 'package:mime_type/mime_type.dart';
import 'package:webinarprime/controllers/auth_controller.dart';
import '../utils/app_constants.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart' hide Response, FormData, MultipartFile;

class WebinarManagementController extends GetxController {
  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
    await getAllwebinars();
  }

  static final List<dynamic> webinarsList = [];
  static Map<String, dynamic> currentWebinar = {};
  Future<void> AddWebinardata(Map<String, dynamic> webinardata) async {
    print('add webinar data called');
    print(webinardata);

    try {
      Uri url = Uri.parse("${AppConstants.baseURL}/webinar/create");
      final response = await http.post(url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            "name": webinardata['title'],
            "tagline": webinardata['tagline'],
            "description": webinardata['description'],
            "datetime": webinardata['date'] + webinardata['time'],
            "duration": webinardata['duration'],
            "price": webinardata['price'],
            "categories": webinardata['categories'],
            'tags': webinardata['tags'],
            'creatorId': Get.find<AuthController>().currentUser['id'],
          }));
      var data = jsonDecode(response.body);
      String id = data['id'];
      print(id);
      print(data);

      String mimeType = mime(webinardata['banner'].path) ?? 'image/jpg';
      String mimee = mimeType.split('/')[0];
      String type = mimeType.split('/')[1];
      print(mimee);
      print(type);
      Dio dio = Dio();
      String bannerfileName = webinardata['banner'].path.split('/').last;
      String coverfileName = webinardata['cover'].path.split('/').last;

      print(bannerfileName);
      print(coverfileName);
      FormData formData = FormData.fromMap(
        {
          "bannerImage": await MultipartFile.fromFile(
            filename: bannerfileName,
            webinardata['banner'].path,
            // filename: "some.jpg",
            contentType: MediaType(mimee, type),
          ),
          "coverImage": await MultipartFile.fromFile(
            filename: coverfileName,
            webinardata['cover'].path,
            // filename: "some.jpg",
            contentType: MediaType(mimee, type),
          ),
          "webinarId": id,
        },
      );
      Response response1 = await dio.post(
          "${AppConstants.baseURL}/webinar/addimages",
          data: formData,
          options: Options(headers: {'Content-Type': 'multipart/form-data'}));

      print('webinar added sucessfully');
      addOrganizerToWebinarById(
          id, Get.find<AuthController>().currentUser['id']);
      getAllwebinars();
      update();

      print(response1.toString());
    } catch (e) {
      print(e);
    }
  }

  Future<void> getAllwebinars() async {
    print('get webinar called');
    try {
      Uri url = Uri.parse("${AppConstants.baseURL}/webinar/home");
      final response =
          await http.get(url, headers: {'Content-Type': 'application/json'});
      var data = jsonDecode(response.body);

      // print(data['webinars']);

      webinarsList.addAll(data['webinars']);
    } catch (e) {
      print(e);
    }
  }

  Future<void> getwebinarById(String id) async {
    print('get webinar by id called');
    try {
      Uri url = Uri.parse("${AppConstants.baseURL}/webinar/$id");
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
      });
      var data = jsonDecode(response.body);
      // print(data);
      currentWebinar = data['webinar'];
      // print('=======================current webinar====================');
      // print(currentWebinar['guests']);
      // print('=======================current webinar====================');

      // print(
      // '=======================current webinar guests====================');
      update();
    } catch (e) {
      print(e);
    }
  }

  /// ========check if guest is already added to webinar or not
  bool guestalreadyAdded(String guestId) {
    if (currentWebinar['guests'].contains(guestId)) {
      print(guestId);

      return true;
    }
    return false;
  }

  // add guest to webinar by id
  Future<void> addGuestToWebinarById(String id, String guestId) async {
    print('add guest to webinar by id called');
    try {
      Uri url = Uri.parse("${AppConstants.baseURL}/webinar/$id/guests");
      final response = await http.post(url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            "guestId": guestId,
          }));
      var data = jsonDecode(response.body);
      // print(data);
      getwebinarById(id);
      // currentWebinar['guests'].add(guestId);
      // Get.find<AuthController>().updateAuthController();
      update();
    } catch (e) {
      print(e);
    }
  }

  // remove guest from webinar by id
  Future<void> removeGuestFromWebinarById(String id, String guestId) async {
    print('remove guest from webinar by id called');
    try {
      Uri url =
          Uri.parse("${AppConstants.baseURL}/webinar/$id/guests/$guestId");
      final response = await http.delete(url, headers: {
        'Content-Type': 'application/json',
      });
      var data = jsonDecode(response.body);
      // print('removing guest from webinar---------------------------------');
      // print(data);
      getwebinarById(id);
      // update();
    } catch (e) {
      print(e);
    }
  }

  // add organizer to webinar by id
  Future<void> addOrganizerToWebinarById(String id, String organizerId) async {
    print('add organizer to webinar by id called');
    try {
      Uri url = Uri.parse("${AppConstants.baseURL}/webinar/$id/organizers");
      final response = await http.post(url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            "organizerId": organizerId,
          }));
      var data = jsonDecode(response.body);
      // print(data);
      getwebinarById(id);
      // update();
    } catch (e) {
      print(e);
    }
  }

  //remove organizer from webinar by id
  Future<void> removeOrganizerFromWebinarById(
      String id, String organizerId) async {
    print('remove organizer from webinar by id called');
    try {
      Uri url = Uri.parse(
          "${AppConstants.baseURL}/webinar/$id/organizers/$organizerId");
      final response = await http.delete(url, headers: {
        'Content-Type': 'application/json',
      });
      var data = jsonDecode(response.body);
      getwebinarById(id);
      print(data);

      // update();
    } catch (e) {
      print(e);
    }
  }

  //add attedee to webinar by id
  Future<void> addAttendeeToWebinarById(String id, String attendeeId) async {
    print('add attendee to webinar by id called');
    try {
      Uri url = Uri.parse("${AppConstants.baseURL}/webinar/$id/attendees");
      final response = await http.post(url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            "attendeeId": attendeeId,
          }));
      var data = jsonDecode(response.body);
      // print(data);
      getwebinarById(id);
      // update();
    } catch (e) {
      print(e);
    }
  }

  //remove addendee from webinar by id
  Future<void> removeAttendeeFromWebinarById(
      String id, String attendeeId) async {
    print('remove attendee from webinar by id called');
    try {
      Uri url = Uri.parse(
          "${AppConstants.baseURL}/webinar/$id/attendees/$attendeeId");
      final response = await http.delete(url, headers: {
        'Content-Type': 'application/json',
      });
      var data = jsonDecode(response.body);
      // print(data);
      getwebinarById(id);
      // update();
    } catch (e) {
      print(e);
    }
  }
}
