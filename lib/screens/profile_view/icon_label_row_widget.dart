import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:webinarprime/utils/styles.dart';

class IconLabelRow extends StatelessWidget {
  String label;
  IconData icon;
  VoidCallback? callbackAction;
  IconLabelRow(
      {required this.label,
      required this.icon,
      required this.callbackAction,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: TextStyle(
            letterSpacing: 1,
            fontSize: 20.sp,
            color: iconColor,
            fontWeight: FontWeight.w700,
            fontFamily: 'JosefinSans Bold',
          ),
        ),
        Gap(
            // AppLayout.getWidth(10),
            10.w),
        IconButton(
            padding: const EdgeInsets.only(bottom: 6),
            onPressed: () {
              callbackAction!();
            },
            icon: Icon(color: iconColor, icon)),
      ],
    );
  }
}
