import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:webinarprime/controllers/auth_controller.dart';

import '../../../utils/styles.dart';

class NotficationsTab extends StatelessWidget {
  const NotficationsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text(
            'Notifications',
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(fontSize: 20.sp),
          ),
        ),
        body: Container(
          child: Center(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 10.h),
              itemCount: AuthController.userNotifications.length,
              itemBuilder: (BuildContext context, int index) {
                String formmattedDateTime = DateFormat('dd/MM/yy, hh:mm')
                    .format(DateTime.parse(AuthController
                        .userNotifications[index]['createdAt']
                        .toString()));
                return Container(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AuthController.userNotifications[index]['title'],
                        style: Theme.of(context)
                            .textTheme
                            .displayMedium!
                            .copyWith(fontSize: 19.sp),
                      ),
                      if (AuthController.userNotifications[index]
                              ['description'] !=
                          null)
                        ExpandableText(
                            AuthController.userNotifications[index]
                                ['description'],
                            maxLines: 4,
                            expandOnTextTap: true,
                            collapseOnTextTap: true,
                            textAlign: TextAlign.justify,
                            style: Theme.of(context).textTheme.displaySmall,
                            expandText: ''),
                      Gap(10.h),
                      Text(
                        formmattedDateTime,
                        style: onelineStyle.copyWith(fontSize: 15.sp),
                      ),
                      const Divider(
                        color: Colors.grey,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ));
  }
}
