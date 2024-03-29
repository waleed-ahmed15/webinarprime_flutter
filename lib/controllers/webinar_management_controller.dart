import 'dart:convert';
import 'dart:io';
import 'package:http_parser/http_parser.dart';

import 'package:dio/dio.dart';
// import 'package:get/get.dart';
import 'package:mime_type/mime_type.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webinarprime/controllers/auth_controller.dart';
import 'package:webinarprime/controllers/reviews_controlller.dart';
import 'package:webinarprime/controllers/webinar_stream_controller.dart';
import 'package:webinarprime/widgets/snackbar.dart';
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
  static List webinaranalytics = [];
  static List coverWebinars = [];
  static List recommendedWebinars = [];
  static List<dynamic> unapprovedWebinars = [];
  static List<dynamic> similarWebinars = [];
  static List<dynamic> searchedWebinars = [].obs;
  static List<dynamic> webinarSchedule = [].obs;
  static List<dynamic> popularWebinars = [].obs;
  // RxList<dynamic> todos = RxList<dynamic>.empty(growable: true).obs;
  // RxList<dynamic> todos1 = RxList<dynamic>.empty(growable: true).obs;

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
            'creatorId': Get.find<AuthController>().currentUser['_id'],
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
      // addOrganizerToWebinarById(
      //     id, Get.find<AuthController>().currentUser['_id']);
      getAllwebinars();
      Get.find<AuthController>().getFavoriteWebinars();
      update();

      print(response1.toString());
    } catch (e) {
      print(e);
    }
  }

  Future<bool> getAllwebinars() async {
    print('get webinar called');
    webinarsList.clear();

    try {
      Uri url = Uri.parse("${AppConstants.baseURL}/webinar/get/home");
      final response =
          await http.get(url, headers: {'Content-Type': 'application/json'});
      var data = jsonDecode(response.body);

      print('=------------------------webianrs------------------------');
      // print(data);
      // print(data['webinars']);
      webinarsList.addAll(data['webinars']);
      update();
      return true;
    } catch (e) {
      print(e);
      return false;
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
      currentWebinar.clear();
      currentWebinar = data['webinar'];
      await Get.find<ReviewController>().getReviewsOfCurrentWebinar(id);
      await getSimilarWebinars(id);
      await getWebinarSchedules(id);
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
      final response = await http.put(url, headers: {
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
      final response = await http.put(url, headers: {
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
      final response = await http.put(url, headers: {
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
      currentwebinarAcceptedMembers.clear();
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
      Uri url =
          Uri.parse("${AppConstants.baseURL}/webinar/removemember/$memeberId");
      http.Response response = await http.put(url, headers: {
        'Content-Type': 'application/json',
      });
      print(response.statusCode);
      if (response.statusCode == 200) {
        print(jsonDecode(response.body));
        getwebinarById(currentWebinar['_id']);
        // update();
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
      Uri url = Uri.parse("${AppConstants.baseURL}/notification/webinar/$id");
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

  //end webinar stream=========================================================================
  Future<void> endWebinarStream(String id) async {
    print('end webinar stream called');
    try {
      Uri url = Uri.parse("${AppConstants.baseURL}/webinar/$id/end");
      final response = await http.put(url, headers: {
        'Content-Type': 'application/json',
        'Authorization': Get.find<SharedPreferences>().getString('tempToken')!
      });
      var data = jsonDecode(response.body);
      print(data);
      await getAllwebinars();
      await getwebinarById(id);
      await Get.find<WebinarStreamController>().webianrStreamStatus(id);
      update();
      Get.find<WebinarManagementController>().update();
    } catch (e) {
      print(e);
    }
  }

  // add webinar to favourites
  Future<void> addWebinarToFavs(String webinarId, String userId) async {
    try {
      Uri url = Uri.parse("${AppConstants.baseURL}/user/add-favorite");
      final response = await http.put(url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization':
                Get.find<SharedPreferences>().getString('tempToken')!
          },
          body: jsonEncode({
            "userId": userId,
            "webinarId": webinarId,
          }));
      if (response.statusCode == 200) {
        print('added to favs');
        Get.find<AuthController>().currentUser['favorites'].add(webinarId);
        // print(currentUser['favorites']);
        // print(currentUser['favorites'] == null);
        update();
      }
    } catch (e) {
      print('could not add to favs');

      print(e);
    }
  }

  // remove webinar from favourites
  Future<void> removeWebinarfromFavs(String webinarId, String userId) async {
    try {
      Uri url = Uri.parse("${AppConstants.baseURL}/user/remove-favorite");
      final response = await http.put(url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization':
                Get.find<SharedPreferences>().getString('tempToken')!
          },
          body: jsonEncode({
            "userId": userId,
            "webinarId": webinarId,
          }));
      if (response.statusCode == 200) {
        print('removed from favs');
        Get.find<AuthController>().currentUser['favorites'].remove(webinarId);
        // print(currentUser['favorites']);
        // print(currentUser['favorites'] == null);
        update();
      }
    } catch (e) {
      print('could not remove from  favs');

      print(e);
    }
  }

  //register webianr user=========================================================================
  Future<void> registerForwebinar(String webinarid) async {
    print('register for webinar called');
    try {
      Uri url = Uri.parse("${AppConstants.baseURL}/webinar/$webinarid/join");
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': Get.find<SharedPreferences>().getString('tempToken')!
        },
      );
      if (response.statusCode == 200) {
        print('registered for webinar');
        Map<String, dynamic> data = jsonDecode(response.body);
        print(data);
        if (data.containsKey('sessionUrl')) {
          await launchUrl(Uri.parse(data['sessionUrl']));
          await getwebinarById(webinarid);
        } else {
          ShowCustomSnackBar(
              title: 'Resgistered', 'Resgisterd successfully', isError: false);
          await getwebinarById(webinarid);
        }
        print(data);

        update();
      } else {
        print('could not register for webinar');
        ShowCustomSnackBar(
            title: 'Sorry', 'Could not Register now try later', isError: true);

        print(response.statusCode);
        print(response.body);
      }
    } catch (e) {
      print('error in registering for webinar');
      print(e);
      print(e);
    }
  }

  // analytics and tickets and revenue=========================================================================

  // get webinar analytics
  Future<void> getUserWebinarAnalytics() async {
    try {
      Uri url = Uri.parse(
          "${AppConstants.baseURL}/webinar//analysis/ticketsandrevenue");
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Authorization': Get.find<SharedPreferences>().getString('tempToken')!
      });
      webinaranalytics.clear();
      if (response.statusCode == 200) {
        webinaranalytics = jsonDecode(response.body)['data'];
        print('----------------analytics fetched----------------');
        // log(data[0].toString());
        print(webinaranalytics[0]['_id'][0]['name']);
        print('-----------------analytics fetched---------------');
      } else {
        print('could not fetch analytics');
      }
    } catch (e) {
      print('error in fetching analytics');
      print(e);
    }
  }

  // get cover webinars for slider
  Future<void> getCoverWebinars() async {
    try {
      Uri url = Uri.parse("${AppConstants.baseURL}/webinar/get/cover");
      var response = await http.get(url);
      // print(response.statusCode);
      if (response.statusCode == 200) {
        coverWebinars = jsonDecode(response.body)['webinars'];
        print(
            '----------------cover webinars for slider  fetched----------------');
        // log(data[0].toString());
        // print(coverWebinars[0]['name']);
        // print('-----------------cover webinars fetched---------------');
      } else {
        print('could not fetch cover webinars');
      }
    } catch (e) {
      print(e);
    }
  }

  // get recommendations for user
  Future<void> getRecommnedations() async {
    try {
      String userId = Get.find<AuthController>().currentUser['_id'];

      Uri url = Uri.parse(
          "${AppConstants.baseURL}/recommendation/collaborative-recommendations/$userId");
      var response = await http.get(url);
      // print(response.statusCode);
      if (response.statusCode == 200) {
        recommendedWebinars = jsonDecode(response.body)['webinars'];
        print(
            '----------------recommendations for user fetched----------------');
        // log(data[0].toString());
        // print(recommendations[0]['name']);
        // print('-----------------recommendations fetched---------------');
      } else {
        print('could not fetch recommendations');
      }
    } catch (e) {
      print(e);
    }
  }

  //get unapproved webinars
  Future<void> getUnapprovedWebinars() async {
    try {
      Uri url =
          Uri.parse("${AppConstants.baseURL}/webinar/get/created/unapproved");
      var response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Authorization': Get.find<SharedPreferences>().getString('tempToken')!
      });
      if (response.statusCode == 200) {
        unapprovedWebinars = jsonDecode(response.body)['webinars'];
        print('----------------unapproved webinars fetched----------------');
      } else {
        print('could not fetch unapproved webinars');
      }
    } catch (e) {
      print(e);
    }
  }

  // get similar webinars recommendations
  Future<void> getSimilarWebinars(String webinarId) async {
    try {
      print(webinarId);
      Uri url = Uri.parse(
          "${AppConstants.baseURL}/recommendation/content-based-recommendations/$webinarId");
      var response = await http.get(url);
      // print(response.statusCode);
      if (response.statusCode == 200) {
        similarWebinars.clear();
        similarWebinars = jsonDecode(response.body)['webinars'];
        print(
            '----------------similar webinars recommendations fetched----------------');
        // print(similarWebinars[0]);
        // log(data[0].toString());
        // print(recommendations[0]['name']);
        // print('-----------------recommendations fetched---------------');
        update(['similarWebinarsUpdated']);
      } else {
        print('could not fetch similar webinars recommendations');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> getsearchedWebinars(String query) async {
    try {
      Uri url = Uri.parse("${AppConstants.baseURL}/webinar/search/$query");
      var response = await http.get(url);
      if (response.statusCode == 200) {
        searchedWebinars.clear();
        searchedWebinars = jsonDecode(response.body)['webinars'];
        print('----------------searched webinars fetched----------------');
        // print(searchedWebinars[0]['name']);
        // print(searchedWebinars[0]);
        print(searchedWebinars.length);
        print('-----------------searched webinars fetched---------------');
        update(['searchedWebinars']);
      } else {
        print('could not fetch searched webinars');
      }
    } catch (e) {
      print(e);
    }
  }

  //get webinarSchedule by id.
  Future<void> getWebinarSchedules(String webinarId) async {
    try {
      Uri url =
          Uri.parse("${AppConstants.baseURL}/webinar/$webinarId/getschedules");
      var response = await http.get(url);
      if (response.statusCode == 200) {
        webinarSchedule.clear();
        webinarSchedule = jsonDecode(response.body)['schedules'];
        print('----------------webinarSchedule fetched----------------');
        update();
      } else {
        print('could not fetch webinarSchedule');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> addwebinarSchedule(
      String webinarId, String title, String duartion) async {
    try {
      Uri url =
          Uri.parse("${AppConstants.baseURL}/webinar/$webinarId/addschedule");
      var response = await http.post(url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization':
                Get.find<SharedPreferences>().getString('tempToken')!
          },
          body: jsonEncode({
            'title': title,
            'duration': duartion,
            'webinar': webinarId,
          }));
      if (response.statusCode == 200) {
        print('----------------webinarSchedule added----------------');
        // update(['webinarSchedule']);
        getWebinarSchedules(webinarId);
      } else {
        print('could not add webinarSchedule');
      }
    } catch (e) {
      print(e);
    }
  }

  //update webinarSchedule by id.
  Future<void> updatewebinarSchedule(String ScheduleID, String title,
      String duartion, String webinarId) async {
    print(title);
    print(duartion);
    print(webinarId);
    print(ScheduleID);
    try {
      Uri url = Uri.parse(
          "${AppConstants.baseURL}/webinar/updateschedule/$ScheduleID");
      var response = await http.put(url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization':
                Get.find<SharedPreferences>().getString('tempToken')!
          },
          body: jsonEncode({
            'title': title,
            'duration': duartion,
          }));
      print(response.body);
      if (response.statusCode == 200) {
        print('----------------webinarSchedule updated----------------');
        // update(['webinarSchedule']);
        getWebinarSchedules(webinarId);
      } else {
        print('could not update webinarSchedule');
      }
    } catch (e) {
      print(e);
    }
  }

  //remove webinarSchedule by id.
  Future<void> removeWebinarSchedlue(String scheduleId) async {
    try {
      Uri url = Uri.parse(
          "${AppConstants.baseURL}/webinar//removeschedule/$scheduleId");
      var response = await http.put(url, headers: {
        'Content-Type': 'application/json',
        'Authorization': Get.find<SharedPreferences>().getString('tempToken')!
      });
      if (response.statusCode == 200) {
        print('----------------webinarSchedule removed----------------');
        // update(['webinarSchedule']);
        getWebinarSchedules(currentWebinar['_id']);
      } else {
        print('could not remove webinarSchedule');
      }
    } catch (e) {
      print(e);
    }
  }

  // search by category
  Future<void> searchbyCategory(String categoryId) async {
    try {
      Uri url = Uri.parse(
          "${AppConstants.baseURL}/webinar/search/category/$categoryId");
      var response = await http.get(url);
      if (response.statusCode == 200) {
        searchedWebinars.clear();
        searchedWebinars = jsonDecode(response.body)['webinars'];
        print('----------------searched webinars fetched----------------');
        // print(searchedWebinars[0]['name']);
        // print(searchedWebinars[0]);
        print(searchedWebinars.length);
        update();
        print('-----------------searched webinars fetched---------------');
      } else {
        print('could not fetch searched webinars');
      }
    } catch (e) {
      print(e);
    }
  }

  // report a webinar or a user or a chat
  Future<void> reportSomething(
      {String webinarId = '',
      String reportedId = '',
      String description = '',
      String reason = '',
      String type = ''}) async {
    try {
      Uri url = Uri.parse("${AppConstants.baseURL}/report/post-report");
      var reportBody = {
        'description': description,
        'reporter': Get.find<AuthController>().currentUser['_id'],
        'reason': reason,
        'type': type
      };
      if (type == 'chat') {
        reportBody.addIf(true, 'reported', reportedId);
      } else if (type == 'webinar') {
        reportBody.addIf(true, 'webinar', webinarId);
      } else if (type == 'user') {
        reportBody.addIf(true, 'reported', reportedId);
      }
      var response =
          await http.post(url, body: jsonEncode(reportBody), headers: {
        'Content-Type': 'application/json',
        'Authorization': Get.find<SharedPreferences>().getString('tempToken')!
      });
      if (response.statusCode == 200) {
        print('----------------$type reported----------------');
        print(response.body);
      } else {
        print('could not report $type');
      }
    } catch (e) {
      print(e);
    }
  }

  //webinar onclick function
  Future<void> webinar_click_count(String webinarId) async {
    try {
      Uri url = Uri.parse("${AppConstants.baseURL}/webinar/$webinarId/click");
      var response = await http.post(url,
          body: jsonEncode(
              {"userId": Get.find<AuthController>().currentUser['_id']}));
      if (response.statusCode == 200) {
        print('----------------webinar clicked added----------------');
        print(response.body.toString());
      } else {
        print('could not increment click webinar');
      }
    } catch (e) {
      print(e);
    }
  }

  //get popular webinars
  Future<void> getPopularWebinars() async {
    try {
      Uri url = Uri.parse("${AppConstants.baseURL}/webinar/get/popular");
      var response = await http.get(url);
      if (response.statusCode == 200) {
        popularWebinars.clear();
        popularWebinars = jsonDecode(response.body)['webinars'];

        print('----------------popular webinars fetched----------------');
        print(popularWebinars[0]);
        update();
      } else {
        print('could not fetch popular webinars');
      }
    } catch (e) {
      print(e);
    }
  }
}
