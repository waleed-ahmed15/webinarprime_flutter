import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:webinarprime/utils/styles.dart';

class MyReviewWidget extends StatelessWidget {
  String review, Name, Date, profileImage;

  MyReviewWidget(
      {super.key,
      this.review = ' some rewview',
      this.Name = 'ken adams',
      this.Date = '2018-22-10',
      this.profileImage = 'https'});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: MyBoxDecorations.listtileDecoration,
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              radius: 25,
              backgroundImage: NetworkImage(profileImage),
            ),
            title: Text(Name, style: Mystyles.listtileTitleStyle),
            subtitle: Text(
              DateTime.now().toString(),
              style: Mystyles.listtileSubtitleStyle,
            ),
          ),
          ExpandableText(
            expandText: 'Read more',
            collapseText: 'Read less',
            maxLines: 4,
            review,
            style: Mystyles.myParagraphStyle,
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }
}
