import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webinarprime/livekit/pages/room.dart';
import 'package:webinarprime/utils/app_constants.dart';
import 'package:http/http.dart' as http;

class WebinarStreamController extends GetxController {
  static RxMap roomChatmessages = {}.obs;
  static String webinarStreamStaus = '';
  static List currentStreamBlockParticipants = [];
  Future<void> startWebinarStream(
      String webianrId, BuildContext context) async {
    try {
      Uri url = Uri.parse("${AppConstants.baseURL}/stream/start/$webianrId");
      // print(AuthController.headersMap);
      print('object33');

      print(Get.find<SharedPreferences>().getString('tempToken')!);
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': Get.find<SharedPreferences>().getString('tempToken')!
        },
      );
      print(jsonDecode(response.body));

      if (response.statusCode == 200) {
        print('Webinar-Stream Started');
        getBlockedusersForWebinar(webianrId);
        joinStream(webianrId, context);
      } else {
        print('Webinar-Stream Failed');
      }
    } catch (e) {
      print(e);
    }
  }

  // method for joining room
  Future<void> joinStream(String WebinarId, BuildContext context) async {
    try {
      Uri url = Uri.parse(
        "${AppConstants.baseURL}/stream/join/$WebinarId",
      );

      // print('object33343');
      // print(Get.find<SharedPreferences>().getString('tempToken')!);
      final Response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': Get.find<SharedPreferences>().getString('tempToken')!
        },
      );
      // print('object');

      print('join stream response------------------------------------');
      print(Response.body);

      String livekitToken = jsonDecode(Response.body)['token'];
      if (Response.statusCode == 200) {
        print('Webinar-Stream Joined');
        getBlockedusersForWebinar(WebinarId);
        update();
        await connectToRoom(context, livekitToken, WebinarId);
      } else {
        print('Webinar-Stream joining Failed');
      }
    } catch (e) {
      print(e);
    }
  }
  // webinar stream status

  Future<Map<String, dynamic>> webianrStreamStatus(String webinarId) async {
    try {
      Uri url = Uri.parse(
        "${AppConstants.baseURL}/stream/status/$webinarId",
      );
      var response = await http.get(url, headers: {
        'Content-Type': 'application/json',
      });
      print(response.body);

      if (response.statusCode == 200) {
        print('Webinar-Stream Status Success');
        return jsonDecode(response.body);
      } else {
        print('Webinar-Stream Status Failed');
        return jsonDecode(response.body);
      }
    } catch (e) {
      print(e);
      return {};
    }
  }

  Future<void> connectToRoom(
      BuildContext context, String liveKittoken, String roomid) async {
    final room = Room();

    // Create a Listener before connecting
    final listener = room.createListener();
    await room.connect(
      // _uriCtrl.text,
      AppConstants.liveKitUrl,
      // _tokenCtrl.text,
      liveKittoken,

      roomOptions: const RoomOptions(
        adaptiveStream: false,
        dynacast: true,
        defaultVideoPublishOptions: VideoPublishOptions(
          simulcast: true,
        ),
        defaultScreenShareCaptureOptions:
            ScreenShareCaptureOptions(useiOSBroadcastExtension: true),
      ),
      fastConnectOptions: false
          ? FastConnectOptions(
              microphone: const TrackOption(enabled: true),
              camera: const TrackOption(enabled: true),
            )
          : null,
    );
    await Navigator.push<void>(
      context,
      MaterialPageRoute(builder: (_) => RoomPage(room, listener, roomid)),
    );
  }

  /// send message to roomChat()

  Future<void> sendMessageToRoomChat(
      String rooomId, Map<String, dynamic> message) async {
    try {
      Uri url = Uri.parse("${AppConstants.baseURL}/stream/chat/$rooomId");
      final response = await http.post(url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization':
                Get.find<SharedPreferences>().getString('tempToken')!
          },
          body: jsonEncode(message));

      if (response.statusCode == 200) {
        print('Message Sent successfully');
      } else {
        print('Message Sending Failed');
      }
    } catch (e) {
      print(e);
    }
  }

  //post a question to room chat
  Future<void> postQuestionToWebinarStream(
      String roomID, Map<String, dynamic> question) async {
    try {
      Uri url = Uri.parse("${AppConstants.baseURL}/stream/question/$roomID");
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': Get.find<SharedPreferences>().getString('tempToken')!
        },
        body: jsonEncode(question),
      );

      if (response.statusCode == 200) {
        print('question Sent successfully');
      } else {
        print('question Sending Failed');
      }
    } catch (e) {
      print(e);
    }
  }

  /// post answer to room chat
  Future<void> postAnswerToQuestion(
      String roomId, Map<String, dynamic> Asnwer) async {
    try {
      Uri url = Uri.parse("${AppConstants.baseURL}/stream/answer/$roomId");
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': Get.find<SharedPreferences>().getString('tempToken')!
        },
        body: jsonEncode(Asnwer),
      );
      if (response.statusCode == 200) {
        print('Answer Sent successfully');
        update();
      } else {
        print('Answer Sending Failed');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<bool> updateStreamcontroller() async {
    update();
    return true;
  }

  // block user for webinar stream
  Future<bool> kickparticipantFromWebinar(
      String participantId, String webinarId) async {
    try {
      Uri url = Uri.parse("${AppConstants.baseURL}/stream/blockuser");
      final response = await http.post(url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization':
                Get.find<SharedPreferences>().getString('tempToken')!
          },
          body: jsonEncode({'userId': participantId, 'webinarId': webinarId}));

      if (response.statusCode == 200) {
        print('User kicked successfully');
        getBlockedusersForWebinar(webinarId);

        return true;
      } else {
        print(response.body);
        print('User kicking  Failed');
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  //get list of blocked users in room
  Future<void> getBlockedusersForWebinar(String webinarId) async {
    try {
      Uri url =
          Uri.parse("${AppConstants.baseURL}/stream/blockedusers/$webinarId");
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Authorization': Get.find<SharedPreferences>().getString('tempToken')!
      });

      if (response.statusCode == 200) {
        print('list of blocked users fetched successfully');
        currentStreamBlockParticipants.clear();
        currentStreamBlockParticipants =
            jsonDecode(response.body)['blockedUsers'];
        print(currentStreamBlockParticipants);

        update();
      } else {
        print('list of blocked users fetching  Failed');
        print(response.body);
      }
    } catch (e) {
      print(e);
    }
  }

  // unblock user for webinar stream
  Future<bool> unblockparticipantFromWebinar(
      String participantId, String webinarId) async {
    try {
      Uri url = Uri.parse("${AppConstants.baseURL}/stream/unblockuser");
      final response = await http.post(url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization':
                Get.find<SharedPreferences>().getString('tempToken')!
          },
          body: jsonEncode({'userId': participantId, 'webinarId': webinarId}));

      if (response.statusCode == 200) {
        print('User unblocked successfully');
        update();
        return true;
      } else {
        print(response.body);
        print('User unblocking  Failed');
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }
}
