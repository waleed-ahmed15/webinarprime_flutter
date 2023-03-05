// import 'dart:convert';
// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:gap/gap.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:webinarprime/controllers/chat_controlller.dart';
// import 'package:webinarprime/screens/chat/chat_field_widget.dart';
// import 'package:webinarprime/screens/chat/file_message_view_widget.dart';
// import 'package:webinarprime/screens/chat/image_Viewer_widget.dart';
// import 'package:webinarprime/utils/app_constants.dart';
// import 'package:webinarprime/utils/styles.dart';

// class ChatScreen extends StatefulWidget {
//   final Map<String, dynamic> receiever;
//   final String ConversationId;
//   const ChatScreen(this.ConversationId, this.receiever, {super.key});

//   @override
//   State<ChatScreen> createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   final ScrollController _scrollController = ScrollController();
//   late String? currentDate;
//   bool fullScreen = false;

//   List<Map<String, dynamic>> messages = [
//     {
//       "message":
//           'how are you ad aksod kszld ksl kdzsl kzsl kzls kdzsl ks;l kz;l ss?',
//       "user": "receiever",
//       "time": '12:00'
//     },
//     {"message": 'how are you?', "user": "receiever", "time": '12:00'},
//     {"message": 'how are you?', "user": "receiever", "time": '12:00'},
//     {"message": 'hello', "user": "sender", "time": '12:00'},
//     {"message": 'hi', "user": "receiever", "time": '12:00'},
//     {"message": 'how are you?', "user": "receiever", "time": '12:01'},
//     {"message": 'i am good nad you?', "user": "sender", "time": '12:01'},
//     {"message": 'how are you?', "user": "receiever", "time": '12:01'},
//     {"message": 'i am good nad you?', "user": "sender", "time": '12:01'},
//     {
//       'image':
//           'https://sportklub.rs/wp-content/uploads/2021/09/28/1632824160-Lionel-Messi-750x500.jpg',
//       "time": '12:01',
//       "user": "receiever"
//     },
//     {"message": 'how are you?', "user": "receiever", "time": '12:02'},
//     {
//       'file':
//           'https://drive.google.com/file/d/1yVUiohyRhrvE_NjrQ-ikMKxCwX3ffP0C/view?usp=share_link',
//       'name': 'file.pdf',
//       "time": '12:02',
//       "user": "receiever"
//     },
//     {"message": 'how are you?', "user": "receiever", "time": '12:02'},
//     {"message": 'i am good nad you?', "user": "sender", "time": '12:02'},
//     {"message": 'how are you?', "user": "receiever", "time": '12:02'},
//     {"message": 'i am good nad you?', "user": "sender", "time": '12:03'},
//     {"message": 'how are you?', "user": "receiever", "time": '12:03'},
//     {
//       'image':
//           'https://sportklub.rs/wp-content/uploads/2021/09/28/1632824160-Lionel-Messi-750x500.jpg',
//       "time": '12:03',
//       "user": "sender"
//     },
//     {
//       'image':
//           'https://sportklub.rs/wp-content/uploads/2021/09/28/1632824160-Lionel-Messi-750x500.jpg',
//       "time": '12:03',
//       "user": "sender"
//     },
//     {
//       'image':
//           'https://sportklub.rs/wp-content/uploads/2021/09/28/1632824160-Lionel-Messi-750x500.jpg',
//       "time": '12:03',
//       "user": "sender"
//     },
//     {
//       'image':
//           'https://sportklub.rs/wp-content/uploads/2021/09/28/1632824160-Lionel-Messi-750x500.jpg',
//       "time": '12:03',
//       "user": "sender"
//     },
//     {
//       'image':
//           'https://sportklub.rs/wp-content/uploads/2021/09/28/1632824160-Lionel-Messi-750x500.jpg',
//       "time": '12:03',
//       "user": "sender"
//     },
//     {
//       'image':
//           'https://sportklub.rs/wp-content/uploads/2021/09/28/1632824160-Lionel-Messi-750x500.jpg',
//       "time": '12:03',
//       "user": "sender"
//     },
//     {"message": 'i am good nad you?', "user": "sender", "time": '12:04'},
//     {"message": 'i am good nad you?', "user": "sender", "time": '12:04'},
//     {
//       'file':
//           'https://drive.google.com/file/d/1yVUiohyRhrvE_NjrQ-ikMKxCwX3ffP0C/view?usp=share_link',
//       'name': 'file.pdf',
//       "time": '12:04',
//       "user": "sender"
//     },
//   ];

//   bool messageEmpty = true;
//   @override
//   void initState() {
//     // WidgetsBinding.instance.addPostFrameCallback((_) {
//     //   _scrollController.animateTo(
//     //     _scrollController.position.maxScrollExtent,
//     //     duration: const Duration(milliseconds: 300),
//     //     curve: Curves.easeOut,
//     //   );
//     // });

//     // Get.find<ChatStreamController>().GetmessagesForAconversation(
//     // widget.ConversationId, widget.receiever['_id']);
//     // TODO: implement initState
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     print(widget.receiever);
//     print(widget.ConversationId);
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor:
//             Get.isDarkMode ? Colors.black : const Color(0xffffffff),
//         appBar: AppBar(
//           automaticallyImplyLeading: true,
//           title: Text(
//             widget.receiever['name'],
//             style: Mystyles.listtileTitleStyle.copyWith(fontSize: 20.sp),
//           ),
//           centerTitle: false,
//           // backgroundColor: Mycolors.myappbarcolor,
//           backgroundColor:
//               Get.isDarkMode ? Colors.black : const Color(0xffffffff),
//           elevation: 0,
//           leading: Row(
//             children: [
//               Gap(10.w),
//               CircleAvatar(
//                 backgroundColor: Colors.transparent,
//                 radius: 20.r,
//                 backgroundImage: NetworkImage(
//                     AppConstants.baseURL + widget.receiever['profile_image']),
//               ),
//             ],
//           ),
//           actions: [
//             IconButton(
//               onPressed: () {},
//               icon: const Icon(
//                 Icons.delete,
//                 color: Colors.red,
//               ),
//             ),
//             IconButton(
//               onPressed: () {},
//               icon: Icon(
//                 Icons.block,
//                 color: Get.isDarkMode ? Colors.white : Colors.black,
//               ),
//             ),
//           ],
//         ),
//         body: Column(
//           children: [
//             Gap(10.h),
//             Expanded(

//             child: ListView.builder(
//               padding: EdgeInsets.only(
//                 bottom: 50.h,
//               ),
//               // controller: _scrollController,
//               // physics: const BouncingScrollPhysics(),

//               itemCount: ChatStreamController
//                   .userChatmessages[widget.ConversationId],
//               itemBuilder: (context, index) {
//                 bool insertDate = false;
//                 print(index);
//                 if (index == 0) {
//                   insertDate = true;
//                 } else if (currentDate != messages[index]['time']) {
//                   insertDate = true;
//                 }
//                 index = index + messages.length - 10;

//                 bool sender = messages[index]['user'] == 'sender';

//                 currentDate = messages[index]['time'];

//                 return Container(
//                   margin: EdgeInsets.only(
//                     top: 1.h,
//                     left: 10.w,
//                     right: 10.w,
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       insertDate
//                           ? Padding(
//                               padding: EdgeInsets.only(
//                                 bottom: 5.h,
//                               ),
//                               child: Center(
//                                   child: Text(messages[index]['time']!,
//                                       style: Mystyles.popupHeadingStyle)),
//                             )
//                           : const SizedBox(),
//                       Row(
//                         mainAxisAlignment: sender
//                             ? MainAxisAlignment.end
//                             : MainAxisAlignment.start,
//                         children: [
//                           messages[index].containsKey('message')
//                               ? Container(
//                                   padding: EdgeInsets.symmetric(
//                                       horizontal: 10.w, vertical: 5.h),
//                                   decoration: BoxDecoration(
//                                     color: sender
//                                         ? const Color(0xff4c51d9)
//                                         : receiverChatBubbleColor,
//                                     borderRadius: BorderRadius.only(
//                                       topLeft: Radius.circular(10.w),
//                                       topRight: Radius.circular(10.w),
//                                       bottomLeft: Radius.circular(10.w),
//                                       bottomRight: Radius.circular(10.w),
//                                     ),
//                                   ),
//                                   child: Column(
//                                     children: [
//                                       Container(
//                                         margin: EdgeInsets.zero,
//                                         padding: EdgeInsets.zero,
//                                         constraints: BoxConstraints(
//                                           maxWidth: 0.5.sw,
//                                         ),
//                                         child: ExpandableText(
//                                           maxLines: 6,
//                                           linkColor: Colors.blue,
//                                           expandText: 'more',
//                                           expandOnTextTap: true,
//                                           collapseOnTextTap: true,
//                                           collapseText: 'less',
//                                           messages[index]['message']!,
//                                           style: Mystyles.listtileTitleStyle
//                                               .copyWith(
//                                             color: sender
//                                                 ? Colors.white
//                                                 : Mystyles
//                                                     .bigTitleStyle.color,
//                                             fontSize: 16.sp,
//                                           ),
//                                           textAlign: TextAlign.start,
//                                         ),
//                                       ),
//                                       SizedBox(
//                                         height: 5.h,
//                                       ),
//                                     ],
//                                   ),
//                                 )
//                               : messages[index].containsKey('file')
//                                   ? MyFileMessage(
//                                       sender: sender,
//                                       fileName: messages[index]['name'],
//                                       fileUrl: messages[index]['file'],
//                                     )
//                                   : ImageMessageContainer(
//                                       imageUrl: messages[index]['image'],
//                                     ),
//                         ],
//                       ),
//                       Gap(2.w),
//                     ],
//                   ),
//                 );
//               },
//             ),

//             ChatFieldWidget(
//               onSend: sendPressed,
//               oncameraPressed: _handleImageSelection,
//             )
//           ],
//         ),
//       ),
//     );
//   }

//   void sendPressed(String message) {
//     print('message $message');
//     _scrollController.animateTo(
//       _scrollController.position.maxScrollExtent,
//       duration: const Duration(milliseconds: 100),
//       curve: Curves.easeOut,
//     );
//     messages.add({
//       'image':
//           'https://media.istockphoto.com/photos/abstract-wavy-object-picture-id1198271727?b=1&k=20&m=1198271727&s=612x612&w=0&h=TmG2MD0VRU-6rtToiYnXKhzgeYuTr4lCFuZ_SRmkZFQ=',
//       "time": '12:05',
//       "user": "sender"
//     });
//     setState(() {});
//     // messages.add({
//     //   "message": 'i am good nad you?',
//     //   "user": "sender",
//     //   "time": '12:04',
//     // });
//     print('send pressed');
//   }

//   bool isBase64(String str) {
//     RegExp base64 =
//         RegExp(r'^([A-Za-z0-9+/]{4})*([A-Za-z0-9+/]{2}==|[A-Za-z0-9+/]{3}=)?$');
//     return base64.hasMatch(str);
//   }

//   void _handleImageSelection() async {
//     final result = await ImagePicker().pickImage(
//       imageQuality: 70,
//       maxWidth: 1440,
//       source: ImageSource.gallery,
//     );
//     if (result != null) {
//       print(result.path);
//       final bytes = await result.readAsBytes();
//       final image = await decodeImageFromList(bytes);
//       print(bytes);
//       File imageFile = File(result.path);
//       List<int> imageBytes = await imageFile.readAsBytes();
//       String base64Image = base64Encode(imageBytes);
//       print(base64Image);
//       messages.add({
//         "message": base64Image,
//         "user": "sender",
//         "time": '12:04',
//       });
//       setState(() {});
//     }
//   }
// }
