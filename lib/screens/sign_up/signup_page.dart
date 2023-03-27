import 'package:flutter/gestures.dart';
import 'package:get/get.dart';
import 'package:webinarprime/controllers/auth_controller.dart';
import 'package:webinarprime/screens/login/login_page.dart';
import 'package:webinarprime/utils/colors.dart';
import '../../utils/dimension.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final formKey = GlobalKey<FormState>(); //key for form
  bool hidePassword = true;
  var passController = TextEditingController();
  var emailController = TextEditingController();
  var nameController = TextEditingController();
  var confirmemailController = TextEditingController();
  var regNoController = TextEditingController();
  // var dateController = TextEditingController();
  var reg_year_value = 'FA19';
  var reg_year = [
    'FA19',
    'SP19',
    'FA18',
    'SP18',
  ];
  var department_value = 'BCS';
  var departments = [
    'BCS',
    "CSE",
    'SE',
  ];
  AuthController authController = Get.find();
  _signUp() {
    String regno = reg_year_value + department_value + regNoController.text;
    print(regno);
    authController.signUpUser(
        email: emailController.text.trim(),
        password: passController.text.trim(),
        username: nameController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
        key: scaffoldKey,
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(
                left: AppLayout.getWidth(40), right: AppLayout.getWidth(40)),
            child: Form(
              key: formKey, //key for form
              child: SizedBox(
                height: AppLayout.getScreenHeight(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'Enter Username',
                          labelStyle: TextStyle(
                              color: Color.fromARGB(255, 134, 163, 160)),
                          suffixIcon: Icon(
                            Icons.person_outline,
                            color: Color.fromARGB(255, 134, 163, 160),
                          )),
                      validator: (value) {
                        if (value!.isEmpty ||
                            !RegExp(r"^[A-Za-z][A-Za-z0-9_]{4,29}$")
                                .hasMatch(value)) {
                          return "invalid username(5-30 characters must start with a letter)";
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: AppLayout.getHeight(20),
                    ),
                    TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'Enter Email',
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
                      height: AppLayout.getHeight(20),
                    ),
                    TextFormField(
                      controller: confirmemailController,
                      decoration: const InputDecoration(
                          labelText: 'Confirm Email',
                          labelStyle: TextStyle(
                              color: Color.fromARGB(255, 134, 163, 160)),
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
                        } else if (emailController.text.trim().toString() !=
                            confirmemailController.text.trim().toString()) {
                          return "please enter the email as above";
                        }
                        return null;
                      },
                    ),

                    SizedBox(
                      height: AppLayout.getHeight(20),
                    ),

                    TextFormField(
                      controller: passController,
                      obscureText: hidePassword,
                      decoration: InputDecoration(
                        border: const UnderlineInputBorder(),
                        suffixIcon: IconButton(
                            onPressed: () {
                              hidePassword = !hidePassword;
                              setState(() {});
                            },
                            icon: Icon(
                                hidePassword
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color:
                                    const Color.fromARGB(255, 134, 163, 160))),
                        labelText: 'Enter Password',
                        labelStyle: const TextStyle(
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
                      height: AppLayout.getHeight(20),
                    ),
                    TextButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          print('valid data ');
                          print(emailController.text);
                          print(passController.text.trim());
                          print(nameController.text.trim());
                          _signUp();
                        }
                      },
                      style: TextButton.styleFrom(
                        shape: const StadiumBorder(),
                        backgroundColor: Get.isDarkMode
                            ? AppColors.LTsecondaryColor
                            : AppColors.LTprimaryColor,
                      ),
                      child: SizedBox(
                        width: double.maxFinite,
                        child: Text(
                          "Sign Up",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'josfinSans bold',
                            color: Colors.white,
                            fontSize: AppLayout.getHeight(25),
                          ),
                        ),
                      ),
                    ),
                    // AppButton(formKey: formKey),
                    SizedBox(
                      height: AppLayout.getHeight(20),
                    ),

                    RichText(
                      text: TextSpan(
                        text: "Already have account ?  ",
                        style: TextStyle(
                          fontFamily: 'josefinSans',
                          color: Get.isDarkMode
                              ? Colors.white
                              : Colors.black.withOpacity(0.7),
                          fontSize: AppLayout.getHeight(20),
                        ),
                        children: [
                          TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap =
                                  () => Get.offAll(() => const LoginPage()),
                            text: 'Sign In',
                            style: TextStyle(
                              fontFamily: 'josefinSans Bold',
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
