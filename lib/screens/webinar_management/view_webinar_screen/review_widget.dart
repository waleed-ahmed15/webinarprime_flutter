import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:webinarprime/utils/app_constants.dart';
import 'package:webinarprime/utils/colors.dart';
import 'package:webinarprime/utils/styles.dart';

class MyReviewWidget extends StatelessWidget {
  String review, Name, Date, profileImage;
  bool editable;
  int rating;
  VoidCallback? callbackAction;

  MyReviewWidget(
      {super.key,
      this.callbackAction,
      this.rating = 5,
      this.editable = false,
      this.review = ' some rewview',
      this.Name = 'ken adams',
      this.Date = '2018-22-10',
      this.profileImage = ''});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          EdgeInsets.only(left: 10.h, right: 10.h, top: 10.h, bottom: 10.h),
      decoration: listtileDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(
              radius: 25,
              backgroundImage:
                  NetworkImage(AppConstants.baseURL + profileImage),
            ),
            title:
                Text(Name, style: Theme.of(context).textTheme.displayMedium!),
            subtitle: Text(
              DateFormat('dd/MM/yy, hh:mm').format(DateTime.parse(Date)),
              style: listtileSubtitleStyle,
            ),
          ),
          Gap(2.h),
          Padding(
            padding: EdgeInsets.only(left: 10.h),
            child: ExpandableText(
              expandText: '...more',
              collapseText: '...less',
              maxLines: 4,
              expandOnTextTap: true,
              collapseOnTextTap: true,
              review,
              style: myParagraphStyle,
              textAlign: TextAlign.justify,
            ),
          ),
          Gap(3.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RatingBar.builder(
                ignoreGestures: true,
                onRatingUpdate: (rating) {},
                initialRating: rating.toDouble(),
                itemSize: 24.h,
                direction: Axis.horizontal,
                itemCount: 5,
                itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: AppColors.LTsecondaryColor,
                ),
              ),
              editable
                  ? IconButton(
                      onPressed: () {
                        callbackAction!();
                      },
                      icon: Icon(
                        Icons.edit,
                        size: 18.sp,
                      ),
                    )
                  : const SizedBox()
            ],
          ),
        ],
      ),
    );
  }
}
