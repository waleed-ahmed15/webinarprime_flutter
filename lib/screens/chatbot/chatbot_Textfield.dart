import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:webinarprime/controllers/chat_controlller.dart';

class ChatBotTextField extends StatefulWidget {
  final ScrollController _ScrollController;
  ChatBotTextField(this._ScrollController, {super.key});

  @override
  State<ChatBotTextField> createState() => _ChatBotTextFieldState();
}

class _ChatBotTextFieldState extends State<ChatBotTextField> {
  TextEditingController messageController = TextEditingController();
  bool messageEmpty = true;
  var isloading = false.obs;
  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Get.isDarkMode
            ? Colors.black.withOpacity(0.8)
            : Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              style: Theme.of(context).textTheme.displayMedium!.copyWith(
                    fontSize: 14.sp,
                  ),
              keyboardAppearance: Brightness.dark,
              keyboardType: TextInputType.text,
              minLines: 1,
              maxLines: 3,
              controller: messageController,
              onChanged: (value) {
                setState(() {
                  messageEmpty = value.isEmpty;
                });
              },
              decoration: InputDecoration(
                fillColor: Theme.of(context).cardColor,
                filled: true,
                hintText: "Type a message",
                suffixIcon: messageEmpty
                    ? null
                    : isloading.value
                        ? const CircularProgressIndicator()
                        : IconButton(
                            icon: const Icon(Icons.send),
                            color: Colors.blue,
                            onPressed: () async {
                              isloading.value = true;
                              setState(() {});
                              await ChatStreamController().chatbot(
                                  query: messageController.text.trim());
                              isloading.value = false;

                              // await Future.delayed(const Duration(seconds: 2));
                              // isloading.value = false;
                              // isloading.refresh();
                              widget._ScrollController.animateTo(
                                widget
                                    ._ScrollController.position.maxScrollExtent,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeOut,
                              );
                              setState(() {});
                              print(ChatStreamController
                                  .chatbotconversation.length);
                              // widget.onSend(messageController.text.trim());
                              messageController.clear();
                              messageEmpty = true;
                            },
                          ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.r),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
