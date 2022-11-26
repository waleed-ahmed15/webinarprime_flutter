import 'package:flutter/material.dart';
import 'package:webinarprime/utils/dimension.dart';

class TitleText extends StatelessWidget {
  const TitleText({super.key, this.text});
  final String? text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text!,
      style: TextStyle(
        fontSize: AppLayout.getHeight(30),
        color: Theme.of(context).accentColor,
        fontFamily: 'Montserrat-Black',
      ),
      textAlign: TextAlign.center,
    );
  }
}
