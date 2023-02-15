import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:webinarprime/utils/app_constants.dart';
import 'package:webinarprime/utils/colors.dart';
import 'package:webinarprime/utils/dimension.dart';

class ProfileScreenTextFieldWidget extends StatelessWidget {
  String label;
  String initialValue;
  IconData? editIcon;
  AsyncCallback? onEditIconPressed;
  IconData? prefixIcon;

  ProfileScreenTextFieldWidget({
    this.prefixIcon,
    this.editIcon,
    required this.initialValue,
    required this.label,
    super.key,
    this.onEditIconPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(AppLayout.getHeight(5))),
      padding: EdgeInsets.symmetric(
        horizontal: AppLayout.getHeight(10),
        vertical: AppLayout.getHeight(20),
      ),
      // color: Colors.red,
      width: double.maxFinite,
      // height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Icon(
                prefixIcon,
                color: AppColors.LTprimaryColor,
                size: 20,
              ),
              const Gap(5),
              Text("$label : ", style: AppConstants.paragraphStyle),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(
                // color: Colors.red,
                width: AppLayout.getWidth(180),
                child: Text(
                    textAlign: TextAlign.right,
                    initialValue,
                    overflow: TextOverflow.ellipsis,
                    style: AppConstants.paragraphStyle),
              ),
              Gap(AppLayout.getWidth(4)),
              GestureDetector(
                onTap: onEditIconPressed,
                child: Icon(
                  editIcon,
                  size: AppLayout.getWidth(20),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
