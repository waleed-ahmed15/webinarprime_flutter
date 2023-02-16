import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webinarprime/controllers/auth_controller.dart';
import 'package:webinarprime/screens/sign_up/signup_page.dart';
import 'package:webinarprime/utils/dimension.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPage createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  final formKey = GlobalKey<FormState>(); //key for form
  bool rememberMeValue = false;
  var passController = TextEditingController();
  var emailController = TextEditingController();

  void Login() {
    AuthController authController = Get.find();
    authController.signIn(emailController.text.trim(),
        passController.text.trim(), rememberMeValue);
  }

  @override
  Widget build(BuildContext context) {
    // final double height = MediaQuery.of(context).size.height;
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
        key: scaffoldKey,
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.only(left: 40, right: 40),
            child: Form(
              key: formKey, //key for form
              child: SizedBox(
                height: AppLayout.getScreenHeight(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Container(
                    //   height: Get.height * 0.25,
                    //   child: Center(
                    //     child: CircleAvatar(
                    //       backgroundColor: Colors.white,
                    //       radius: AppLayout.getHeight(80),
                    //       backgroundImage:
                    //           AssetImage('assets/image/logo part 1.png'),
                    //     ),
                    //   ),
                    // ),

                    TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'Enter email',
                          labelStyle: TextStyle(
                              color: Color.fromARGB(255, 134, 163, 160)),
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
                        return null;
                      },
                    ),
                    SizedBox(
                      height: AppLayout.getHeight(50),
                    ),
                    TextFormField(
                      controller: passController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        suffixIcon: Icon(
                          Icons.lock_outline,
                          color: Colors.grey,
                        ),
                        labelText: 'Enter Password',
                        labelStyle: TextStyle(
                            color: Color.fromARGB(255, 134, 163, 160)),
                      ),
                      validator: (value) {
                        if (value!.isEmpty || value.length <= 7) {
                          return "enter password of lengther greater than 7";
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: AppLayout.getHeight(15),
                    ),
                    Row(
                      children: [
                        Checkbox(
                          checkColor: Colors.black,
                          activeColor: Colors.white,
                          value: rememberMeValue,
                          onChanged: (value) {
                            setState(() {
                              rememberMeValue = value!;
                              print(rememberMeValue);
                            });
                          },
                        ),
                        Text(
                          "Remember Me",
                          style: TextStyle(
                              fontSize: AppLayout.getHeight(15),
                              fontFamily: "Montserrat-Bold",
                              color: Colors.red.shade600),
                          textAlign: TextAlign.right,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: AppLayout.getHeight(15),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.toNamed('/forgot-password');
                      },
                      child: Container(
                        width: double.maxFinite,
                        padding: EdgeInsets.only(right: AppLayout.getHeight(0)),
                        child: Text(
                          "Forgot Password?",
                          style: TextStyle(
                              fontSize: AppLayout.getHeight(15),
                              fontFamily: "Montserrat-Bold",
                              color: Colors.red.shade600),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: AppLayout.getHeight(25),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (formKey.currentState!.validate()) {
                          Login();
                          print('valid data ');
                          print(emailController.text);
                          print(passController.text.trim());
                          print(rememberMeValue);
                        }
                      },
                      child: Container(
                        width: double.maxFinite,
                        padding: EdgeInsets.symmetric(
                            vertical: AppLayout.getHeight(10),
                            horizontal: AppLayout.getWidth(10)),
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius:
                                BorderRadius.circular(AppLayout.getHeight(5))),
                        child: Center(
                          child: Text(
                            "Sign in",
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                color: Colors.white,
                                fontSize: AppLayout.getHeight(25)),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: AppLayout.getHeight(20),
                    ),

                    RichText(
                      text: TextSpan(
                        text: "Don't have an account? ",
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          color: Theme.of(context)
                              .colorScheme
                              .secondary
                              .withOpacity(0.8),
                          fontSize: AppLayout.getHeight(20),
                        ),
                        children: [
                          TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap =
                                  () => Get.to(() => const SignUpScreen()),
                            text: 'Create',
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              fontFamily: 'Montserrat-Bold',
                              color: Theme.of(context).primaryColor,
                              fontSize: AppLayout.getHeight(20),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
