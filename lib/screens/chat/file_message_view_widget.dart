import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webinarprime/utils/styles.dart';

class MyFileMessage extends StatelessWidget {
  final bool sender;
  final String fileName;
  final String fileUrl;
  const MyFileMessage(
      {super.key,
      required this.sender,
      required this.fileName,
      required this.fileUrl});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        print('image tapped');
        await launchUrl(Uri.parse(fileUrl));
        // print('image tapped3434d');
      },
      child: Container(
        margin: const EdgeInsets.only(
            // top: 3.h,
            // bottom: 3.h,
            ),
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        constraints: BoxConstraints(
          maxWidth: 0.5.sw,
        ),
        decoration: BoxDecoration(
          color: Colors.purple[600],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.w),
            topRight: Radius.circular(10.w),
            bottomLeft: Radius.circular(10.w),
            bottomRight: Radius.circular(10.w),
          ),
        ),
        child: Text(
          fileName,
          overflow: TextOverflow.visible,
          style: Theme.of(context).textTheme.displayMedium!.copyWith(
                color: Colors.white,
                fontSize: 16.sp,
              ),
        ),
      ),
    );
  }
}
