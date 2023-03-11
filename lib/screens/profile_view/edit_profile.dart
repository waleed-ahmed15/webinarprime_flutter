import 'dart:io';
import 'package:flutter/gestures.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:webinarprime/controllers/auth_controller.dart';
import 'package:webinarprime/screens/profile_view/change_password_view.dart';
import 'package:webinarprime/screens/profile_view/icon_label_row_widget.dart';
import 'package:webinarprime/utils/app_constants.dart';
import 'package:webinarprime/utils/colors.dart';
import 'package:webinarprime/utils/styles.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final formKey33 = GlobalKey<FormState>(); //key for form
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
  var dob = '';

  /// upload image
  final ImagePicker imagePicker = ImagePicker();
  File? _imagefile;
  // Uint8List? imagebyte;
  String? base64img;
  String? coverImagePath;
  void _pickBase64Image() async {
    final XFile? image =
        await imagePicker.pickImage(source: ImageSource.gallery);
    // uploadImage(File(image!.path));
    if (image != null) {
      print('image picked');

      // if (imagetoEdit == 'coverImage') {
      await AuthController().editprofilePic(File(image.path));
      // String coverpath = await widget.webinarcontroller.editWebinarCoverImage(
      // widget.webinarDetails['_id'], File(image.path));
      // widget.webinarDetails['coverImage'] = coverpath;
      // } else {
      // String thumbnailpath = await widget.webinarcontroller
      // .editWebinarBannerImage(
      // widget.webinarDetails['_id'], File(image.path));
      // widget.webinarDetails['bannerImage'] = thumbnailpath;

      setState(() {});
    } else {
      print('No image selected.');
    }
    setState(() {});
    return;
  }

  void _onEditIconPressed(String title, String value) {
    var editingController = TextEditingController(text: value);

    Map<String, Widget> widgetsBox = {
      'name': TextFormField(
        style: Mystyles.listtileTitleStyle,
        controller: editingController,
        decoration: const InputDecoration(
            border: UnderlineInputBorder(),
            labelText: '',
            labelStyle: TextStyle(color: Color.fromARGB(255, 134, 163, 160)),
            suffixIcon: Icon(
              Icons.person_outline,
              color: Color.fromARGB(255, 134, 163, 160),
            )),
        validator: (value) {
          if (value!.isEmpty ||
              !RegExp(r"^[A-Za-z][A-Za-z0-9_]{4,29}$").hasMatch(value)) {
            return "invalid username(5-30 characters must start with a letter)";
          }
          return null;
        },
      ),
      'email': TextFormField(
        controller: editingController,
        style: Mystyles.listtileTitleStyle,
        decoration: const InputDecoration(
            border: UnderlineInputBorder(),
            labelStyle: TextStyle(color: Color.fromARGB(255, 134, 163, 160)),
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
      'date': DateTimePicker(
        // initialValue: DateTime.now().toString(),
        decoration: const InputDecoration(
            suffixIcon: Icon(Icons.calendar_month_outlined),
            hintText: "Select Birthday"),
        firstDate: DateTime(1990, 1),
        initialDate: DateTime(1990, 1),
        lastDate: DateTime(2006, 1),
        dateLabelText: 'Select your Birthday',
        controller: editingController,
        // initialValue: "qqq",
        onChanged: (val) => (dob = val),
        // onChanged: (val) => print(dateController.text = val),
        validator: (val) {
          // print("val$val");

          if (val == '') {
            return 'Please select your birthday';
          }
          return null;
        },
        onSaved: (val) => print(val),
      ),
      'registration': Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          DropdownButton(
            // Initial Value
            value: reg_year_value,

            // Down Arrow Icon
            icon: const Icon(Icons.keyboard_arrow_down),

            // Array list of items
            items: reg_year.map((String items) {
              return DropdownMenuItem(
                value: items,
                child: Text(items),
              );
            }).toList(),
            // After selecting the desired option,it will
            // change button value to selected value
            onChanged: (String? newValue) {
              setState(() {
                reg_year_value = newValue!;
                print(reg_year_value);
              });
            },
          ),
          Gap(10.w),
          DropdownButton(
            // itemHeight: 1,
            // Initial Value

            value: department_value,

            // Down Arrow Icon
            icon: const Icon(Icons.keyboard_arrow_down),

            // Array list of items
            items: departments.map((String items) {
              return DropdownMenuItem(
                value: items,
                child: Text(items),
              );
            }).toList(),
            // After selecting the desired option,it will
            // change button value to selected value
            onChanged: (String? newValue) {
              setState(() {
                department_value = newValue!;
                print(department_value);
              });
            },
          ),
          Gap(10.w),
          SizedBox(
            width: 150.w,
            child: TextFormField(
                controller: editingController,
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 0.h, horizontal: 0),
                  hintText: 'Registration Number',
                  border: InputBorder.none,
                  labelStyle: TextStyle(
                      fontFamily: "Montserrat-Regular", fontSize: 15.sp),
                ),
                validator: (value) {
                  if (value!.isEmpty || !RegExp(r'^[0-9]+$').hasMatch(value)) {
                    return "enter valid red no,";
                  }
                  return null;
                }),
          )
        ],
      )
    };
    showAnimatedDialog(
      barrierDismissible: true,
      animationType: DialogTransitionType.rotate3D,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: SizedBox(
            height: 180.h,
            child: Padding(
                padding: EdgeInsets.all(10.w),
                child: Form(
                    key: formKey33,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        widgetsBox[title]!,
                        Gap(20.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // this is where update  is handled
                            Gap(10.w),
                            TextButton(
                              style: TextButton.styleFrom(
                                fixedSize: Size(200.w, 30),
                                backgroundColor:
                                    AppColors.LTsecondaryColor.withOpacity(0.6),
                              ),
                              onPressed: () async {
                                if (formKey33.currentState!.validate()) {
                                  if (title == 'name') {
                                    // print('update name');
                                    await Get.find<AuthController>()
                                        .editusername(editingController.text);
                                    Navigator.of(context).pop();
                                  } else if (title == 'email') {
                                    // print('update email');
                                    await Get.find<AuthController>()
                                        .editemail(editingController.text);
                                    Navigator.of(context).pop();
                                  } else if (title == 'date') {
                                    // print('update date');
                                    await Get.find<AuthController>()
                                        .editBirthDate(dob.toString());
                                    print(dob);

                                    Navigator.of(context).pop();
                                  } else if (title == 'registration') {
                                    await Get.find<AuthController>().editregno(
                                        "$reg_year_value-$department_value-${editingController.text}");
                                    // print('update registration');
                                    Navigator.of(context).pop();
                                  }
                                } else {
                                  print('invalid form');
                                }
                              },
                              child: const Text(
                                'Update',
                                style: TextStyle(
                                  fontFamily: 'JosefinSans Bold',
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ))),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Gap(20.h),
              GetBuilder<AuthController>(
                  assignId: true,
                  id: 'editprofile_pic',
                  builder: (context) {
                    print('upadte pic');
                    return Container(
                      height: 200.h,
                      width: 200.h,
                      // width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(200.r),
                        image: DecorationImage(
                            image: NetworkImage(AppConstants.baseURL +
                                Get.find<AuthController>()
                                    .currentUser['profile_image']),
                            fit: BoxFit.cover),
                      ),
                      child: IconButton(
                          onPressed: () async {
                            _pickBase64Image();
                          },
                          icon: Icon(
                            Icons.camera_alt_outlined,
                            size: 80.h,
                          )),
                    );
                  }),
              Gap(20.h),
              GetBuilder<AuthController>(
                  assignId: true,
                  id: 'editprofile',
                  builder: (context) {
                    return Container(
                      decoration:
                          MyBoxDecorations.listtileDecoration.copyWith(),
                      margin: EdgeInsets.symmetric(horizontal: 10.w),
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          IconLabelRow(
                              label: 'Name',
                              icon: Icons.edit,
                              callbackAction: () {
                                print('object');
                                _onEditIconPressed(
                                    'name',
                                    Get.find<AuthController>()
                                        .currentUser['name']);
                              }),
                          Gap(10.h),
                          Text(
                            Get.find<AuthController>().currentUser['name'],
                            style: Mystyles.bigTitleStyle.copyWith(
                                fontSize: 20.h,
                                fontWeight: FontWeight.w300,
                                fontFamily: 'JosefinSans Regular',
                                letterSpacing: 1,
                                color: Mystyles.listtileTitleStyle.color),
                          ),
                          Gap(5.h),
                          const Divider(),
                          Gap(5.h),
                          IconLabelRow(
                              label: "Email",
                              icon: Icons.edit,
                              callbackAction: () {
                                _onEditIconPressed(
                                    'email',
                                    Get.find<AuthController>()
                                        .currentUser['email']);
                              }),
                          Gap(10.h),
                          Text(
                            Get.find<AuthController>().currentUser['email'],
                            style: Mystyles.listtileSubtitleStyle.copyWith(
                                fontSize: 19.h,
                                fontWeight: FontWeight.w300,
                                fontFamily: 'JosefinSans Regular',
                                letterSpacing: 1,
                                color: Mystyles.listtileTitleStyle.color),
                          ),
                          Gap(5.h),
                          const Divider(),
                          Gap(5.h),
                          IconLabelRow(
                              label: "BirthDate",
                              icon: Icons.edit,
                              callbackAction: () {
                                _onEditIconPressed(
                                    'date',
                                    Get.find<AuthController>()
                                        .currentUser['birthdate']);
                              }),
                          Gap(10.h),
                          Text(
                            Get.find<AuthController>().currentUser['birthdate'],
                            style: Mystyles.listtileSubtitleStyle.copyWith(
                                fontSize: 19.h,
                                fontWeight: FontWeight.w300,
                                fontFamily: 'JosefinSans Regular',
                                letterSpacing: 1,
                                color: Mystyles.listtileTitleStyle.color),
                          ),
                          Gap(5.h),
                          const Divider(),
                          Gap(5.h),
                          IconLabelRow(
                              label: "Registration No",
                              icon: Icons.edit,
                              callbackAction: () {
                                _onEditIconPressed(
                                    'registration',
                                    Get.find<AuthController>()
                                        .currentUser['registration_number']);
                              }),
                          Gap(10.h),
                          Text(
                            Get.find<AuthController>()
                                .currentUser['registration_number'],
                            style: Mystyles.listtileSubtitleStyle.copyWith(
                                fontSize: 19.h,
                                fontWeight: FontWeight.w300,
                                fontFamily: 'JosefinSans Regular',
                                letterSpacing: 1,
                                color: Mystyles.listtileTitleStyle.color),
                          ),
                          Gap(5.h),
                          const Divider(),
                          Gap(5.h),
                          IconLabelRow(
                              label: 'Intrests',
                              icon: Icons.add_box,
                              callbackAction: () {}),
                          Gap(5.h),
                          const Divider(),
                          Gap(5.h),
                          IconLabelRow(
                              label: 'Password',
                              icon: Icons.edit,
                              callbackAction: () {
                                Get.to(
                                    transition: Transition.rightToLeft,
                                    () => const ChangePasswordScreen());
                              }),
                          Text(
                            '***********',
                            style: Mystyles.listtileSubtitleStyle.copyWith(
                                fontSize: 19.h,
                                fontWeight: FontWeight.w300,
                                fontFamily: 'JosefinSans Regular',
                                letterSpacing: 1,
                                color: Mystyles.listtileTitleStyle.color),
                          ),
                          Gap(5.h),
                          const Divider(),
                          Gap(5.h),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Notification',
                                  style: TextStyle(
                                    letterSpacing: 1,
                                    fontSize: 20.sp,
                                    color: Mycolors.iconColor,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'JosefinSans Bold',
                                  )),
                              GetBuilder<AuthController>(
                                  assignId: true,
                                  id: 'updateNotification',
                                  builder: (context) {
                                    return Switch(
                                        splashRadius: 0,
                                        thumbIcon:
                                            MaterialStateProperty.all(Icon(
                                          Icons.notifications,
                                          color: Get.isDarkMode
                                              ? AppColors.LTsecondaryColor
                                              : AppColors.LTprimaryColor,
                                        )),
                                        dragStartBehavior:
                                            DragStartBehavior.start,
                                        activeColor: Get.isDarkMode
                                            ? AppColors.LTsecondaryColor
                                                .withOpacity(0.7)
                                            : AppColors.LTprimaryColor
                                                .withOpacity(0.7),
                                        value: Get.find<AuthController>()
                                            .currentUser['notificationsOn'],
                                        onChanged: (value) async {
                                          await Get.find<AuthController>()
                                              .notificationsToggel(
                                                  value,
                                                  Get.find<AuthController>()
                                                      .currentUser['_id']);
                                          Get.find<AuthController>()
                                                  .currentUser[
                                              'notificationsOn'] = value;
                                        });
                                  }),
                            ],
                          ),
                        ],
                      ),
                    );
                  }),
            ],
          ),
        ],
      ),
    ));
  }
}
