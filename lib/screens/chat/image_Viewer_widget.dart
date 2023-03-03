import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:webinarprime/screens/chat/chat_image_viewer.dart';

class ImageMessageContainer extends StatelessWidget {
  String imageUrl;
  ImageMessageContainer({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        print('image tapped');
        Get.to(() => ImageViewerChat(imageUrl: imageUrl));
      },
      child: Container(
        height: 0.5.sw,
        width: 0.5.sw,
        decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.contain, image: NetworkImage(imageUrl)),
        ),
      ),
    );
  }
}
