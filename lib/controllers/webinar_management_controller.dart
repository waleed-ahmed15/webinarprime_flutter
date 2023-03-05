import 'dart:convert';
import 'dart:io';
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
  static List<dynamic> currentwebinarPendingMembers = [];
  static List<dynamic> currentwebinarAcceptedMembers = [];
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
            "datetime": webinardata['date'] + "T" + webinardata['time'],
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
    webinarsList.clear();

    try {
      Uri url = Uri.parse("${AppConstants.baseURL}/webinar/home");
      final response =
          await http.get(url, headers: {'Content-Type': 'application/json'});
      var data = jsonDecode(response.body);

      // print(data['webinars']);
      webinarsList.addAll(data['webinars']);
      update();
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
      // print(currentWebinar);
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
      print('===============response from add organizer to webinar by id');

      print(data);
      print('response from add organizer to webinar by id================');

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

  /// get organizers for a webinar by webinarId
  /// this function is used to get the organizers for a webinar

  Future<void> getOrganizersForWebinar(String id) async {
    print('get organizers for webinar called');
    try {
      Uri url = Uri.parse("${AppConstants.baseURL}/webinar/$id/organizers");
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
      });
      var data = jsonDecode(response.body);
      // print(data);
      // print('=======================organizers====================');
      print(data['organizers']);
      // print('=======================organizers====================');
      currentwebinarPendingMembers.clear();
      currentwebinarPendingMembers = data['organizers'].where((element) {
        return element['status'] == 'pending';
      }).toList();

      print('======================pending=organizers====================');
      print(currentwebinarPendingMembers);
      print('======================pending=organizers====================');

      print('======================accepted=organizers====================');
      currentwebinarAcceptedMembers = data['organizers'].where((element) {
        return element['status'] == 'joined';
      }).toList();
      print('=======================accepted organizers====================');

      update();
    } catch (e) {
      print(e);
    }
  }

  // get attendees for a webinar by webinarId
  Future<void> getAttendeesForWebinar(String id) async {
    print('get attendees for webinar called');
    try {
      Uri url = Uri.parse("${AppConstants.baseURL}/webinar/$id/attendees");
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
      });
      var data = jsonDecode(response.body);
      // print(data);
      // print('=======================attendees====================');
      print(data['attendees']);
      // print('=======================attendees====================');
      currentwebinarPendingMembers.clear();
      currentwebinarPendingMembers = data['attendees'].where((element) {
        return element['status'] == 'pending';
      }).toList();

      currentwebinarAcceptedMembers.clear();
      currentwebinarAcceptedMembers = data['attendees'].where((element) {
        return element['status'] == 'joined';
      }).toList();

      print('======================pending=attendees====================');
      print(currentwebinarPendingMembers);
      print('======================pending=attendees====================');

      print('======================accepted=attendees====================');
      print(currentwebinarAcceptedMembers);
      print('=======================accepted attendees====================');

      update();
    } catch (e) {
      print(e);
    }
  }

  // get guests for a webinar by webinarId
  Future<void> getGuestsForWebinar(String id) async {
    print('get guests for webinar called');
    try {
      Uri url = Uri.parse("${AppConstants.baseURL}/webinar/$id/guests");
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
      });
      var data = jsonDecode(response.body);
      print(data);

      currentwebinarPendingMembers.clear();
      currentwebinarPendingMembers = data['guests'].where((element) {
        return element['status'] == 'pending';
      }).toList();

      currentwebinarAcceptedMembers.clear();
      currentwebinarAcceptedMembers = data['guests'].where((element) {
        return element['status'] == 'joined';
      }).toList();

      print('======================pending=guests====================');
      print(currentwebinarPendingMembers);
      print('======================pending=guests====================');
      print('======================accepted=guests====================');
      print(currentwebinarAcceptedMembers);
      print('=======================accepted guests====================');

      update();
    } catch (e) {
      print(e);
    }
  }

  // this is the method to add member to webinar
  Future<bool> addmemberTowebinar(
      String webinarId, String memberid, String role) async {
    print('add member to webinar called');
    try {
      Uri url = Uri.parse("${AppConstants.baseURL}/webinar/addmember");
      final response = await http.post(url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            "webinarId": webinarId,
            "userId": memberid,
            "role": role,
          }));
      var data = jsonDecode(response.body);
      print(data);
      if (data['success'] == true) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  // remove from webinar===============================================================

  Future<bool> removeWebinarMember({required String memeberId}) async {
    try {
      Uri url = Uri.parse("${AppConstants.baseURL}/webinar/member/$memeberId");
      http.Response response = await http.delete(url, headers: {
        'Content-Type': 'application/json',
      });
      print(response.statusCode);
      if (response.statusCode == 200) {
        print(jsonDecode(response.body));
        update();
        print('member removed from webinar');
        return true;
      } else {
        print('member not found');

        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  // ================================================these are edit functions for the webinar details===============================================================================

  // edit webinar title
  Future<void> editWebinarName(String id, String name) async {
    print('edit webinar title called');
    try {
      Uri url = Uri.parse("${AppConstants.baseURL}/webinar/$id/name");
      final response = await http.put(url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            "name": name,
          }));
      var data = jsonDecode(response.body);
      // print(data);
      getwebinarById(id);
      // update();
    } catch (e) {
      print(e);
    }
  }
  // edit categories for the webinar

  Future<bool> editWebinarCategories(String id, List<String> categories) async {
    print('edit webinar categories called');
    try {
      Uri url = Uri.parse("${AppConstants.baseURL}/webinar/$id/categories");
      final response = await http.put(url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            "categories": categories,
          }));
      var data = jsonDecode(response.body);
      print(data);
      if (response.statusCode == 200) {
        await getwebinarById(id);
        update();
        return true;
      } else {
        return false;
      }
      // getwebinarById(id);
    } catch (e) {
      print(e);
      return false;
    }
  }

  // edit tagline=============
  Future<void> editWebinarTagline(String id, String tagline) async {
    print('edit webinar tagline called');
    try {
      Uri url = Uri.parse("${AppConstants.baseURL}/webinar/$id/tagline");
      final response = await http.put(url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            "tagline": tagline,
          }));
      var data = jsonDecode(response.body);
      // print(data);
      getwebinarById(id);
      // update();
    } catch (e) {
      print(e);
    }
  }

  //edit webinar description
  Future<void> editWebinarDescription(String id, String description) async {
    print('edit webinar description called');
    try {
      Uri url = Uri.parse("${AppConstants.baseURL}/webinar/$id/description");
      final response = await http.put(url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            "description": description,
          }));
      var data = jsonDecode(response.body);
      // print(data);
      getwebinarById(id);
      // update();
    } catch (e) {
      print(e);
    }
  }

  //edit webinar datetime
  Future<void> editWebinarDateTime(String id, String dateTime) async {
    print('edit webinar datetime called');
    try {
      Uri url = Uri.parse("${AppConstants.baseURL}/webinar/$id/datetime");
      final response = await http.put(url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            "datetime": dateTime,
          }));
      var data = jsonDecode(response.body);
      // print(data);
      getwebinarById(id);
      // update();
    } catch (e) {
      print(e);
    }
  }

  //edit duration
  Future<void> editWebinarDuration(String id, String duration) async {
    print('edit webinar duration called');
    try {
      Uri url = Uri.parse("${AppConstants.baseURL}/webinar/$id/duration");
      final response = await http.put(url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            "duration": duration,
          }));
      var data = jsonDecode(response.body);
      // print(data);
      getwebinarById(id);
      // update();
    } catch (e) {
      print(e);
    }
  }

  // edit tags of webinar
  Future<void> editWebinarTags(String id, List<String> tags) async {
    print('edit webinar tags called');
    try {
      Uri url = Uri.parse("${AppConstants.baseURL}/webinar/$id/tags");
      final response = await http.put(url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            "tags": tags,
          }));
      var data = jsonDecode(response.body);
      print(data);
      getwebinarById(id);
      update();
    } catch (e) {
      print(e);
    }
  }

  // edit cover image of webinar=========================================================================
  Future<String> editWebinarCoverImage(String id, File coverImage) async {
    print('edit webinar cover image called');
    try {
      String mimeType = mime(coverImage.path) ?? 'image/jpg';
      String mimee = mimeType.split('/')[0];
      String type = mimeType.split('/')[1];
      print(mimee);
      print(type);
      Dio dio = Dio();
      String bannerfileName = coverImage.path.split('/').last;
      String coverfileName = coverImage.path.split('/').last;

      // print(bannerfileName); 
      // print(coverfileName);
      FormData formData = FormData.fromMap(
        {
          "coverImage": await MultipartFile.fromFile(
            filename: coverfileName,
            coverImage.path,
            // filename: "some.jpg",
            contentType: MediaType(mimee, type),
          ),
        },
      );
      Response response1 = await dio.put(
          "${AppConstants.baseURL}/webinar/$id/coverimage",
          data: formData,
          options: Options(headers: {'Content-Type': 'multipart/form-data'}));
      print(response1.data['coverPath']);
      getwebinarById(id);
      print('edit cover updated added sucessfully');
      update();
      getAllwebinars();

      return response1.data['coverPath'];
    } catch (e) {
      print(e);
      return 'error';
    }
  }

  // edit banner image of webinar=========================================================================
  Future<String> editWebinarBannerImage(String id, File bannerImage) async {
    print('edit webinar banner image called');
    try {
      String mimeType = mime(bannerImage.path) ?? 'image/jpg';
      String mimee = mimeType.split('/')[0];
      String type = mimeType.split('/')[1];
      print(mimee);
      print(type);
      Dio dio = Dio();
      String bannerfileName = bannerImage.path.split('/').last;
      String coverfileName = bannerImage.path.split('/').last;

      // print(bannerfileName);
      // print(coverfileName);
      FormData formData = FormData.fromMap(
        {
          "bannerImage": await MultipartFile.fromFile(
            filename: bannerfileName,
            bannerImage.path,
            // filename: "some.jpg",
            contentType: MediaType(mimee, type),
          ),
        },
      );
      Response response1 = await dio.put(
          "${AppConstants.baseURL}/webinar/$id/bannerimage",
          data: formData,
          options: Options(headers: {'Content-Type': 'multipart/form-data'}));
      print(response1.data['bannerPath']);
      getwebinarById(id);
      print('edit banner updated added sucessfully');
      update();
      getAllwebinars();
      return response1.data['bannerPath'];
    } catch (e) {
      print(e);
      return 'error';
    }
  }

  // post notification of webinar=========================================================================
  Future<void> postNotification(String id, String title, String body) async {
    print('post notification called');
    try {
      Uri url = Uri.parse("${AppConstants.baseURL}/webinar/$id/notification");
      final response = await http.post(url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            "title": title,
            "description": body,
          }));
      var data = jsonDecode(response.body);
      print(data);
      await getAllwebinars();
      await getwebinarById(id);
      update();
    } catch (e) {
      print(e);
    }
  }
}
