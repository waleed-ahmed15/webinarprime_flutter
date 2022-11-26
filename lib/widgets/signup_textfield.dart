import 'package:flutter/material.dart';
import 'package:webinarprime/utils/dimension.dart';

class SignUpTextField extends StatelessWidget {
  final String hintTExt;
  bool isObsecure;
  final IconData iconName;
  final TextEditingController textEditingController;
  final Color IconColor;

  SignUpTextField(
      {super.key,
      this.isObsecure = false,
      required this.hintTExt,
      required this.iconName,
      required this.textEditingController,
      required this.IconColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppLayout.getWidth(20)),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            AppLayout.getHeight(10),
          ),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              offset: Offset(1, 1),
              blurRadius: 3,
              spreadRadius: 1,
              color: Colors.grey.withOpacity(0.2),
            ),
          ]),
      child: TextField(
        obscureText: isObsecure,
        controller: textEditingController,
        style: TextStyle(color: Colors.black),
        decoration: InputDecoration(
          hintText: hintTExt,
          hintStyle: TextStyle(color: Colors.grey),
          prefixIcon: Icon(
            iconName,
            color: IconColor,
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 1,
              color: Colors.white,
            ),
            borderRadius: BorderRadius.circular(
              AppLayout.getHeight(10),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 1,
              color: Colors.white,
            ),
            borderRadius: BorderRadius.circular(
              AppLayout.getHeight(10),
            ),
          ),
        ),
      ),
    );
  }
}
