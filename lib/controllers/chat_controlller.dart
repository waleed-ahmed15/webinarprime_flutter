import 'dart:convert';
import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile;
import 'package:http/http.dart' as http;
import 'package:mime_type/mime_type.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webinarprime/controllers/auth_controller.dart';
import 'package:webinarprime/utils/app_constants.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatStreamController extends GetxController {
  final IO.Socket socket = Get.find();
  @override
  void onInit() async {
    // TODO: implement onInit
    // socket.onConnect((data) => print(' socket stream chat connected'));
    // print('current user is=-------------------------------------------');
    // print(Get.find<AuthController>().currentUser);

    //---------------------------------- join conversation socket---------------------------
    socket.emit('join', {
      Get.find<AuthController>().currentUser['_id'],
    });

    //------------------------------- incoming messages-------------------------------------
    print('chat stream controller');
    socket.on('conversationChatMessage', (data) {
      print(data.runtimeType);
      print(data);

      ChatStreamController.userChatmessages[data['conversation']['_id']] != null
          ? ChatStreamController.userChatmessages[data['conversation']['_id']]
              .add(data['message'])
          : ChatStreamController.userChatmessages
              .addIf(true, data['conversation']['_id'], {data['message']});

      Get.find<ChatStreamController>().update();
      Get.find<ChatStreamController>()
          .getConversations(Get.find<AuthController>().currentUser['_id']);
    });

    // -----------------------conversation deleted---------------------------

    socket.on('conversationUpdate', (data) {
      if (data['action'] == 'delete') {
        print('------------------conversation deleted------------------');
        print(data);
        print('------------------conversation deleted------------------');

        Get.back();
        userchats
            .removeWhere((element) => element['_id'] == data['conversationId']);
        userChatmessages.remove(data['conversationId']);

        Get.find<ChatStreamController>().update();

        Get.find<ChatStreamController>()
            .getConversations(Get.find<AuthController>().currentUser['_id']);
      }
    });

    super.onInit();
  }

  static List userchats = [].obs;
  static Map<dynamic, dynamic> userChatmessages = {}.obs;
  Future<void> getConversations(String userId) async {
    try {
      Uri url = Uri.parse('${AppConstants.baseURL}/chat/conversations/$userId');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': Get.find<SharedPreferences>().getString('tempToken')!
        },
      );
      if (response.statusCode == 200) {
        print('Conversations Fetched');
        // print(response.body);
        print(
            '-------------------------conversations-------------------------');
        print(jsonDecode(response.body)['conversations']);
        print(
            '-------------------------conversations-------------------------');

        userchats = jsonDecode(response.body)['conversations'];
        userchats = userchats.reversed.toList();
        print('-------------------------userchats-------------------------');
        for (var element in userchats) {
          print('---------------------------');
          print(element);
          print('---------------------------');
        }
        // print(userchats[3]['messages']);

        update();
      } else {
        print('Conversations Fetching Failed');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> createNewConversation(List<String> users) async {
    try {
      Uri url = Uri.parse('${AppConstants.baseURL}/chat/create-conversation/');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': Get.find<SharedPreferences>().getString('tempToken')!
        },
        body: jsonEncode({
          'users': users,
        }),
      );
      if (response.statusCode == 200) {
        print('Conversations created');
        print(response.body);
        print('fetching conversations');
        await getConversations(Get.find<AuthController>().currentUser['_id']);
        update();
      } else {
        print('Conversations creation Failed');
      }
    } catch (e) {
      print(e);
    }
  }
  // get messages of a conversation

  Future<void> GetmessagesForAconversation(String coversationID) async {
    try {
      Uri url =
          Uri.parse('${AppConstants.baseURL}/chat/messages/$coversationID');
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Authorization': Get.find<SharedPreferences>().getString('tempToken')!
      });
      if (response.statusCode == 200) {
        print('messages fetched for a conversation $coversationID');
        print(response.body);
        userChatmessages[coversationID] = jsonDecode(response.body)['messages'];
        update();
        print('user chat messages are---------------');
        print(userChatmessages);
        print('user chat messages are---------------');
      } else {
        print('messages fetching Failed for a conversation $coversationID');
      }
    } catch (e) {
      print(e);
    }
  }

  //send message to a conversation
  Future<void> sendMessage(
      String conversationID, Map<String, dynamic> TextMessage) async {
    try {
      Uri url = Uri.parse(
        '${AppConstants.baseURL}/chat/send-message/$conversationID',
      );
      final response = await http.post(url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization':
                Get.find<SharedPreferences>().getString('tempToken')!
          },
          body: jsonEncode(TextMessage));
      if (response.statusCode == 200) {
        print('message sent to a conversation $conversationID');
        print(response.body);

        update();
      } else {
        print('message sending Failed for a conversation $conversationID');
      }
    } catch (e) {
      print(e);
    }
  }

  //send file to a conversation
  Future<void> sendFileMessage(String ConversationId, File coverImage,
      String userid, String text) async {
    print('send file message called');
    try {
      String mimeType = mime(coverImage.path) ?? 'image/jpg';
      String mimee = mimeType.split('/')[0];
      String type = mimeType.split('/')[1];

      Dio dio = Dio();
      String coverfileName = coverImage.path.split('/').last;

      FormData formData = FormData.fromMap(
        {
          "chatFile": await MultipartFile.fromFile(
            filename: coverfileName,
            coverImage.path,
            // filename: "some.jpg",
            contentType: MediaType(mimee, type),
          ),
          "from": userid,
          "text": text,
        },
      );
      Response response1 = await dio.post(
          "${AppConstants.baseURL}/chat/send-file-message/$ConversationId",
          data: formData,
          options: Options(headers: {'Content-Type': 'multipart/form-data'}));
      print(response1.data);
      update();
    } catch (e) {
      print(e);
    }
  }

  //delete a conversation by id
  Future<void> deleteConversation(String conversationId) async {
    try {
      Uri url = Uri.parse(
        '${AppConstants.baseURL}/chat/delete-conversation/$conversationId',
      );
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': Get.find<SharedPreferences>().getString('tempToken')!
        },
      );
      if (response.statusCode == 200) {
        print('conversation deleted');

        print(response.body);
      } else {
        print('conversation deletion Failed');
      }
    } catch (e) {
      print(e);
    }
  }
  // ban a user from conversation

  Future<void> banUser(String bannedUserId) async {
    try {
      Uri url = Uri.parse('${AppConstants.baseURL}/chat/ban-user');
      var response = await http.post(url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization':
                Get.find<SharedPreferences>().getString('tempToken')!
          },
          body: jsonEncode({
            'bannedUserId': bannedUserId,
            'userId': Get.find<AuthController>().currentUser['_id'],
          }));
      if (response.statusCode == 200) {
        print('user banned successfully');
        print(response.body);
        await Get.find<AuthController>()
            .currentUser['bannedChats']
            .add(bannedUserId);
        print(Get.find<AuthController>().currentUser['bannedChats']);
        update();
      } else {
        print('user banning Failed');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> unbanUser(String bannedUserId) async {
    try {
      Uri url = Uri.parse('${AppConstants.baseURL}/chat/unban-user');
      var response = await http.post(url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization':
                Get.find<SharedPreferences>().getString('tempToken')!
          },
          body: jsonEncode({
            'bannedUserId': bannedUserId,
            'userId': Get.find<AuthController>().currentUser['_id'],
          }));
      if (response.statusCode == 200) {
        print('user unbanned successfully');
        print(response.body);
        await Get.find<AuthController>()
            .currentUser['bannedChats']
            .remove(bannedUserId);
        print(Get.find<AuthController>().currentUser['bannedChats']);
        update();
      } else {
        print('user banning Failed');
      }
    } catch (e) {
      print(e);
    }
  }
}
