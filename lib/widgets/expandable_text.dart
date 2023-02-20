import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webinarprime/controllers/webinar_management_controller.dart';
import 'package:webinarprime/utils/dimension.dart';
import 'package:webinarprime/widgets/small_text.dart';

class CustomExpandableText extends StatefulWidget {
  final String text;
  const CustomExpandableText({Key? key, required this.text}) : super(key: key);

  @override
  State<CustomExpandableText> createState() => _CustomExpandableTextState();
}

class _CustomExpandableTextState extends State<CustomExpandableText> {
  late String firsthalf;
  late String secondHalf;
  bool hiddenText = true;
  double textHeight = AppLayout.getHeight(100);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.text.length > textHeight) {
      firsthalf = widget.text.substring(0, textHeight.toInt());
      secondHalf = widget.text.substring(
        textHeight.toInt() + 1,
        widget.text.length,
      );
    } else {
      firsthalf = widget.text;
      secondHalf = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WebinarManagementController>(builder: (controller) {
      return Container(
        child: secondHalf.isEmpty
            ? SmallText(
                text: firsthalf,
                size: AppLayout.getHeight(16),
              )
            : Column(
                children: [
                  InkWell(
                    onTap: (() {
                      setState(() {
                        hiddenText = !hiddenText;
                      });
                    }),
                    child: SmallText(
                      color: Get.isDarkMode
                          ? const Color(0xffa1a1aa)
                          : const Color(0xff475569),
                      num_line: hiddenText ? 3 : 300,
                      size: AppLayout.getHeight(16),
                      text: hiddenText
                          ? "$firsthalf...."
                          : firsthalf + secondHalf,
                    ),
                  ),
                ],
              ),
      );
    });
  }
}
