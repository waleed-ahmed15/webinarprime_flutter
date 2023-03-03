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

      print(Response.body);
      String livekitToken = jsonDecode(Response.body)['token'];
      if (Response.statusCode == 200) {
        print('Webinar-Stream Joined');
        await connectToRoom(context, livekitToken, WebinarId);
      } else {
        print('Webinar-Stream joining Failed');
      }
    } catch (e) {
      print(e);
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

  ///
//
}
