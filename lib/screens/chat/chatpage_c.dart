import 'package:flutter/material.dart';
import 'package:webinarprime/screens/chat/banned_chats.dart';
import 'package:webinarprime/screens/chat/chat_list_screen.dart';
import 'package:webinarprime/screens/chat/create_new_chat.dart';

final PageController globalPageControllerForchat =
    PageController(initialPage: 0);
final List<Widget> chatpages = [
  const ChatListScreen(),
  const CreateNewChat(),
  const BannedChats(),
  Container(color: Colors.blue),
];
