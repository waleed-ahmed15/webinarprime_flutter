import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:webinarprime/controllers/auth_controller.dart';
import 'package:webinarprime/utils/colors.dart';
import 'package:webinarprime/utils/styles.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final formKey = GlobalKey<FormState>(); //key for form
  var oldpass = TextEditingController();
  var newpass = TextEditingController();
  var confirmpass = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        centerTitle: true,
        title: Text(
          "Change Password",
          style: mediumHeadingStyle,
        ),
      ),
      body: Container(
        width: double.maxFinite,
        height: double.maxFinite,
        // margin: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          // boxShadow: [
          //   BoxShadow(
          //     offset: const Offset(0, 5),
          //     blurRadius: 7,
          //     color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
          //   ),
          //   BoxShadow(
          //     offset: const Offset(0, -5),
          //     blurRadius: 7,
          //     color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
          //   )
          // ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Form(
              key: formKey,
              child: SizedBox(
                width: 0.9.sw,
                child: Column(
                  children: [
                    TextFormField(
                      obscureText: true,
                      controller: oldpass,
                      decoration: InputDecoration(
                          hintText: "Old Password",
                          hintStyle: listtileSubtitleStyle,
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Color.fromARGB(255, 134, 163, 160),
                            ),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColors.LTsecondaryColor,
                            ),
                          ),
                          border: const UnderlineInputBorder(),
                          suffixIcon: Icon(
                            Icons.lock_outline,
                            color: iconColor,
                          )),
                      validator: (value) {
                        if (value!.isEmpty || value.length <= 7) {
                          return "Password must be at least 8 characters";
                        }
                        return null;
                      },
                    ),
                    Gap(10.h),
                    TextFormField(
                      controller: newpass,
                      obscureText: true,
                      decoration: InputDecoration(
                          hintText: "New Password",
                          hintStyle: listtileSubtitleStyle,
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Color.fromARGB(255, 134, 163, 160),
                            ),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColors.LTsecondaryColor,
                            ),
                          ),
                          border: const UnderlineInputBorder(),
                          suffixIcon: Icon(
                            Icons.lock_outline,
                            color: iconColor,
                          )),
                      validator: (value) {
                        if (value!.isEmpty || value.length <= 7) {
                          return "Password must be at least 8 characters";
                        } else if (newpass.text != confirmpass.text) {
                          return "Password does not match";
                        }
                        return null;
                      },
                    ),
                    Gap(10.h),
                    TextFormField(
                      obscureText: true,
                      controller: confirmpass,
                      decoration: InputDecoration(
                          hintText: "Confirm Password",
                          hintStyle: listtileSubtitleStyle,
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Color.fromARGB(255, 134, 163, 160),
                            ),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColors.LTsecondaryColor,
                            ),
                          ),
                          border: const UnderlineInputBorder(),
                          suffixIcon: Icon(
                            Icons.lock_outline,
                            color: iconColor,
                          )),
                      validator: (value) {
                        if (value!.isEmpty || value.length <= 7) {
                          return "Password must be at least 8 characters";
                        } else if (newpass.text != confirmpass.text) {
                          return "Password does not match";
                        }
                        return null;
                      },
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            ElevatedButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  print('valid');
                  print(oldpass.text.runtimeType);
                  print(newpass.text);
                  bool updated = await Get.find<AuthController>()
                      .changePassword(oldpass.text.trim(), newpass.text.trim());
                  if (updated) {
                    print('updated');
                    Get.back(closeOverlays: true);
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                fixedSize: Size(0.9.sw, 30.h),
                backgroundColor: Get.isDarkMode
                    ? AppColors.LTsecondaryColor.withOpacity(0.7)
                    : AppColors.LTprimaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.r),
                ),
              ),
              child: Text(
                'Change Password',
                style: Theme.of(context)
                    .textTheme
                    .displayMedium!
                    .copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
