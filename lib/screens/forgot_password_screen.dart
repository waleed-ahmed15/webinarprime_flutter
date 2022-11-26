import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webinarprime/controllers/auth_controller.dart';

import '../utils/colors.dart';
import '../utils/dimension.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final formKey = GlobalKey<FormState>(); //key for form
  var emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        centerTitle: true,
        title: Text(
          "RESET PASSWORD",
          style: TextStyle(fontFamily: 'Montserrat'),
        ),
      ),
      body: Container(
        width: double.maxFinite,
        height: double.maxFinite,
        margin: EdgeInsets.symmetric(
            vertical: AppLayout.getHeight(20),
            horizontal: AppLayout.getWidth(20)),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 5),
              blurRadius: 7,
              color: Theme.of(context).accentColor.withOpacity(0.1),
            ),
            BoxShadow(
              offset: Offset(0, -5),
              blurRadius: 7,
              color: Theme.of(context).accentColor.withOpacity(0.1),
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(
              key: formKey,
              child: SizedBox(
                width: AppLayout.getWidth(300),
                child: TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                      hintText: "Enter your email",
                      hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: AppLayout.getHeight(20),
                          fontFamily: 'Montserrat-Black',
                          fontWeight: FontWeight.w300),
                      border: UnderlineInputBorder(),
                      suffixIcon: Icon(
                        Icons.email_outlined,
                        color: Color.fromARGB(255, 134, 163, 160),
                      )),
                  validator: (value) {
                    if (value!.isEmpty ||
                        !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(value)) {
                      return "Enter correct email,";
                    }
                  },
                ),
              ),
            ),
            SizedBox(
              height: AppLayout.getHeight(20),
            ),
            GestureDetector(
              onTap: () {
                print('save was tapped');
                if (formKey.currentState!.validate()) {
                  AuthController authController = Get.find();
                  authController.resetpassword(emailController.text);

                  print('email is valid');

                  // print(base64img);
                  // print('form is valid');
                }
              },
              child: Container(
                width: double.maxFinite,
                margin:
                    EdgeInsets.symmetric(horizontal: AppLayout.getWidth(20)),
                padding: EdgeInsets.symmetric(
                    vertical: AppLayout.getHeight(10),
                    horizontal: AppLayout.getWidth(10)),
                decoration: BoxDecoration(
                    color: AppColors.LTprimaryColor,
                    borderRadius:
                        BorderRadius.circular(AppLayout.getHeight(5))),
                child: Center(
                  child: Text(
                    "send",
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: Colors.white,
                        fontSize: AppLayout.getHeight(20)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
