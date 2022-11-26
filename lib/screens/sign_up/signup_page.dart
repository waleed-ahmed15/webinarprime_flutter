import 'package:flutter/gestures.dart';
import 'package:get/get.dart';
import 'package:webinarprime/controllers/auth_controller.dart';
import 'package:webinarprime/screens/login/login_page.dart';
import 'package:webinarprime/screens/sign_up/widgets/title_text.dart';
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
            padding: const EdgeInsets.only(left: 40, right: 40),
            child: Form(
              key: formKey, //key for form
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: Get.height * 0.25,
                    child: Center(
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: AppLayout.getHeight(80),
                        backgroundImage:
                            const AssetImage('assets/image/logo part 1.png'),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: AppLayout.getHeight(20),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: AppLayout.getWidth(20)),
                    width: double.maxFinite,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        TitleText(text: "WEBINAR-"),
                        TitleText(text: "PRIME"),
                      ],
                    ),
                  ),
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Enter username',
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
                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Enter email',
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
                  TextFormField(
                    controller: confirmemailController,
                    decoration: const InputDecoration(
                        labelText: 'Confirm email',
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
                    height: AppLayout.getHeight(10),
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
                            )),
                        labelText: 'Enter Password'),
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
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    child: SizedBox(
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
                  ),
                  // AppButton(formKey: formKey),
                  SizedBox(
                    height: AppLayout.getHeight(20),
                  ),
                  SizedBox(
                    height: AppLayout.getHeight(80),
                  ),
                  RichText(
                    text: TextSpan(
                      text: "Already have account? ",
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
                            ..onTap = () => Get.to(() => LoginPage()),
                          text: 'Sign In',
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
        ));
  }
}
