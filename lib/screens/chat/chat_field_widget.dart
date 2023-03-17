import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatFieldWidget extends StatefulWidget {
  final Function onSend;
  final VoidCallback oncameraPressed;
  final VoidCallback onAttachPressed;
  const ChatFieldWidget(
      {super.key,
      required this.onAttachPressed,
      required this.onSend,
      required this.oncameraPressed});

  @override
  State<ChatFieldWidget> createState() => _ChatFieldWidgetState();
}

class _ChatFieldWidgetState extends State<ChatFieldWidget> {
  TextEditingController messageController = TextEditingController();
  bool messageEmpty = true;

  @override
  Widget build(BuildContext context) {
    return Row(
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
              prefixIcon: IconButton(
                icon: const Icon(
                  Icons.camera_alt,
                  color: Colors.blue,
                ),
                iconSize: 30.h,
                tooltip: 'Send message',
                enableFeedback: true,
                onPressed: () {
                  widget.oncameraPressed();
                },
              ),
              suffixIcon: messageEmpty
                  ? IconButton(
                      icon: const Icon(Icons.attach_file),
                      color: Colors.blue,
                      onPressed: () {
                        widget.onAttachPressed();
                      },
                    )
                  : IconButton(
                      icon: const Icon(Icons.send),
                      color: Colors.blue,
                      onPressed: () {
                        widget.onSend(messageController.text.trim());
                        messageController.clear();
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
    );
  }
}
