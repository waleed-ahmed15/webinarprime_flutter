import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:webinarprime/utils/app_constants.dart';
import 'package:webinarprime/utils/styles.dart';

class AttendessList extends StatelessWidget {
  List attendeesList = [];
  AttendessList({required this.attendeesList, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Attendees',
          style: Mystyles.bigTitleStyle.copyWith(
            fontSize: 20.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: attendeesList.length,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          return Container(
            decoration:
                MyBoxDecorations.listtileDecoration.copyWith(boxShadow: []),
            margin: EdgeInsets.only(top: 10.h, left: 10.w, right: 10.w),
            child: ListTile(
              leading: CircleAvatar(
                radius: 25.r,
                backgroundImage: NetworkImage(AppConstants.baseURL +
                    attendeesList[index]['profile_image']),
              ),
              title: Text(
                attendeesList[index]['name'],
                style: Mystyles.listtileTitleStyle,
              ),
              subtitle: Text(
                attendeesList[index]['email'],
                style: Mystyles.listtileSubtitleStyle,
              ),
            ),
          );
        },
      ),
    );
  }
}
