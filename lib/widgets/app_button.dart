import 'package:flutter/material.dart';
import 'package:webinarprime/utils/dimension.dart';

class AppButton extends StatelessWidget {
  const AppButton({super.key, this.formKey, this.onPress});

  final dynamic? formKey;
  final VoidCallback? onPress;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        if (formKey.currentState!.validate()) {
          print('valid data ');
          // print(emailController.text);
          // print(passController.text.trim());
          // print(rememberMeValue);
        }
      },
      style: TextButton.styleFrom(
        shape: StadiumBorder(),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      child: Container(
        width: double.maxFinite,
        child: Text(
          "Sign Up",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Montserrat',
            color: Colors.white,
            fontSize: AppLayout.getHeight(25),
          ),
        ),
      ),
    );
  }
}
