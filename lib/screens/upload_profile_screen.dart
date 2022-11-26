import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webinarprime/controllers/auth_controller.dart';
import 'package:webinarprime/controllers/categoryController.dart';
import 'package:webinarprime/routes/routes.dart';
import 'package:webinarprime/utils/colors.dart';
import 'package:webinarprime/utils/dimension.dart';
import 'package:date_time_picker/date_time_picker.dart';

class UploadProfileScreen extends StatefulWidget {
  const UploadProfileScreen({super.key});

  @override
  State<UploadProfileScreen> createState() => _UploadProfileScreenState();
}

class _UploadProfileScreenState extends State<UploadProfileScreen> {
  final formKey = GlobalKey<FormState>(); //key for form

  final ImagePicker imagePicker = ImagePicker();
  File? _imagefile;
  Uint8List? imagebyte;
  String? base64img;
  var regNoController = TextEditingController();
  var dateController = TextEditingController();
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

  void _pickBase64Image() async {
    final XFile? image =
        await imagePicker.pickImage(source: ImageSource.gallery);
    // uploadImage(File(image!.path));
    if (image != null) {
      _imagefile = File(image.path);
      // print('No image selected.');
      imagebyte = await image.readAsBytes();

      setState(() {});
      return;
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
              child: Container(
            margin: EdgeInsets.symmetric(
                vertical: AppLayout.getHeight(20),
                horizontal: AppLayout.getWidth(20)),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              boxShadow: [
                BoxShadow(
                  offset: const Offset(0, 5),
                  blurRadius: 7,
                  color:
                      Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                ),
                BoxShadow(
                  offset: const Offset(0, -5),
                  blurRadius: 7,
                  color:
                      Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                )
              ],
            ),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: AppLayout.getHeight(50),
                  ),
                  Container(
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(50)),
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.circular(AppLayout.getHeight(200)),
                      child: imagebyte != null
                          ? Image.memory(
                              imagebyte!,
                              // base64Decode(base64img!),
                              fit: BoxFit.cover,
                              width: AppLayout.getWidth(250),
                              height: AppLayout.getWidth(250),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(
                                  AppLayout.getHeight(200)),
                              child: Container(
                                height: AppLayout.getHeight(300),
                                width: AppLayout.getWidth(300),
                                color: Colors.grey,
                                child: const Text('adasdsadsa'),
                              ),
                            ),
                    ),
                  ),
                  SizedBox(
                    height: AppLayout.getHeight(20),
                  ),
                  GestureDetector(
                    onTap: () {
                      _pickBase64Image();
                      setState(() {});
                    },
                    child: Container(
                      width: double.maxFinite,
                      margin: EdgeInsets.symmetric(
                          horizontal: AppLayout.getWidth(20)),
                      padding: EdgeInsets.symmetric(
                          vertical: AppLayout.getHeight(10),
                          horizontal: AppLayout.getWidth(10)),
                      decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(AppLayout.getHeight(5))),
                      child: Center(
                        child: Text(
                          "Upload picture",
                          style: TextStyle(
                              fontFamily: 'Montserrat-Regular',
                              fontWeight: FontWeight.w400,
                              color: Theme.of(context).colorScheme.secondary,
                              fontSize: AppLayout.getHeight(20)),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: AppLayout.getHeight(30),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: AppLayout.getWidth(20)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DateTimePicker(
                          // initialValue: DateTime.now().toString(),
                          decoration: const InputDecoration(
                              suffixIcon: Icon(Icons.calendar_month_outlined),
                              hintText: "Select Birthday"),
                          firstDate: DateTime(1900),
                          initialDate: DateTime(1990, 1),
                          lastDate: DateTime.now(),
                          dateLabelText: 'Select your Birthday',
                          controller: dateController,
                          // initialValue: "qqq",
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
                        SizedBox(
                          height: AppLayout.getHeight(20),
                        ),
                        Row(
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
                            SizedBox(
                              width: AppLayout.getWidth(10),
                            ),
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
                            SizedBox(width: AppLayout.getWidth(10)),
                            SizedBox(
                              width: AppLayout.getWidth(150),
                              child: TextFormField(
                                  controller: regNoController,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: AppLayout.getHeight(0),
                                        horizontal: AppLayout.getWidth(0)),
                                    hintText: 'Registration Number',
                                    border: InputBorder.none,
                                    labelStyle: TextStyle(
                                        fontFamily: "Montserrat-Regular",
                                        fontSize: AppLayout.getHeight(15)),
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty ||
                                        !RegExp(r'^[0-9]+$').hasMatch(value)) {
                                      return "enter valid red no,";
                                    }
                                    return null;
                                  }),
                            )
                          ],
                        ),
                        SizedBox(
                          height: AppLayout.getHeight(15),
                        ),
                        GestureDetector(
                          onTap: () {
                            AuthController authController = Get.find();
                            print('save was tapped');
                            print(authController.currentUser);
                            if (formKey.currentState!.validate()) {
                              print('form is valid');
                              if (_imagefile != null) {
                                authController.uploadCompleteData(
                                  authController.currentUser['email'],
                                  _imagefile!,
                                  dateController.text.toString(),
                                  "$reg_year_value-$department_value-${regNoController.text}",
                                );
                              } else {
                                // print("no image");
                                // print(authController.currentUser['email']);

                                authController.uploadDataWithoutImage(
                                    authController.currentUser['email'],
                                    dateController.text.toString(),
                                    "$reg_year_value-$department_value-${regNoController.text}");
                              }
                              Get.find<CategoryContorller>()
                                  .getCategoriesList();
                              Get.toNamed(RoutesHelper.selectInterestRoute);
                            }
                          },
                          child: Container(
                            width: double.maxFinite,
                            margin: EdgeInsets.symmetric(
                                horizontal: AppLayout.getWidth(20)),
                            padding: EdgeInsets.symmetric(
                                vertical: AppLayout.getHeight(10),
                                horizontal: AppLayout.getWidth(10)),
                            decoration: BoxDecoration(
                                color: AppColors.LTprimaryColor,
                                borderRadius: BorderRadius.circular(
                                    AppLayout.getHeight(5))),
                            child: Center(
                              child: Text(
                                "Save",
                                style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    color: Colors.white,
                                    fontSize: AppLayout.getHeight(20)),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: AppLayout.getHeight(30),
                        )
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.offAllNamed(RoutesHelper.signInRoute);
                      SharedPreferences sharedPreferences = Get.find();
                      sharedPreferences.remove('token');
                    },
                    child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: AppLayout.getWidth(20)),
                        width: double.maxFinite,
                        child: const Text(
                          'Go back to Login',
                          style: TextStyle(
                              fontFamily: 'Montserrat-Black',
                              fontWeight: FontWeight.w300,
                              fontSize: 16),
                          textAlign: TextAlign.end,
                        )),
                  ),
                  SizedBox(
                    height: AppLayout.getHeight(20),
                  )
                ],
              ),
            ),
          )),
        ),
      ),
    );
  }
}
