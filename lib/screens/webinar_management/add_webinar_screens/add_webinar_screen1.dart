import 'dart:io';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:webinarprime/screens/webinar_management/add_webinar_screens/add_webinar_screen2.dart';
import 'package:webinarprime/utils/dimension.dart';
import 'package:webinarprime/utils/styles.dart';

import '../../../utils/colors.dart';

class AddWebinarScreen1 extends StatefulWidget {
  const AddWebinarScreen1({super.key});

  @override
  State<AddWebinarScreen1> createState() => _AddWebinarScreen1State();
}

class _AddWebinarScreen1State extends State<AddWebinarScreen1> {
  var titleController = TextEditingController();
  var descriptionController = TextEditingController();
  var talglineController = TextEditingController();
  var priceController = TextEditingController();
  var durationController = TextEditingController();
  var dateController = TextEditingController();
  TextEditingController timeinput = TextEditingController();
  final Map<String, dynamic> addwebinar = {};
  final formKey1 = GlobalKey<FormState>(); //key for form
  final ImagePicker imagePicker = ImagePicker();
  File? _imagefile;
  Uint8List? imagebyte;
  String? base64img;
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
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Container(
            margin: EdgeInsets.symmetric(
                vertical: AppLayout.getHeight(20),
                horizontal: AppLayout.getWidth(20)),
            decoration: MyBoxDecorations.listtileDecoration,
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: AppLayout.getWidth(20),
                  vertical: AppLayout.getHeight(20)),
              child: Form(
                key: formKey1,
                child: Column(
                  children: [
                    Text("Create New Webinar",
                        style: Mystyles.onpageheadingsyle
                            .copyWith(fontSize: 20.h)),
                    SizedBox(
                      height: AppLayout.getHeight(50),
                    ),
                    Container(
                      width: 200.h,
                      height: 200.h,
                      decoration: MyBoxDecorations.listtileDecoration.copyWith(
                        image: imagebyte != null
                            ? DecorationImage(
                                image: MemoryImage(imagebyte!),
                                fit: BoxFit.cover)
                            : null,
                      ),
                      child: IconButton(
                          icon: const Icon(
                            Icons.camera_alt,
                            color: Colors.grey,
                          ),
                          iconSize: 50.h,
                          onPressed: () {
                            _pickBase64Image();
                            setState(() {});
                          }),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Text(
                      _imagefile == null ? 'please select image.' : "",
                      style: const TextStyle(color: Colors.red),
                    ),
                    SizedBox(
                      height: AppLayout.getHeight(20),
                    ),
                    TextFormField(
                      style: Mystyles.onpageheadingsyle
                          .copyWith(color: Mystyles.bigTitleStyle.color),
                      controller: titleController,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        hintText: 'Webinar Title',
                        suffixIcon: Icon(Icons.title),
                      ),
                      validator: (val) {
                        // print("val$val");
                        if (val!.isEmpty) {
                          return 'please enter webinar title';
                        } else if (!RegExp(r"^[A-Za-z]").hasMatch(val)) {
                          return 'enter valid title';
                        } else if (val.length > 200) {
                          return 'title cannot be greater than 200 characters';
                        } else if (val.length < 5) {
                          return 'please enter at least 5 characters';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: AppLayout.getHeight(20),
                    ),
                    DateTimePicker(
                      // initialValue: DateTime.now().toString(),
                      style: Mystyles.onpageheadingsyle
                          .copyWith(color: Mystyles.bigTitleStyle.color),
                      decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          suffixIcon: Icon(Icons.calendar_month_outlined),
                          hintText: "Select date"),
                      firstDate: DateTime.now(),
                      initialDate: DateTime.now(),
                      lastDate: DateTime(2030),
                      dateLabelText: 'Select date',
                      controller: dateController,
                      // initialValue: "qqq",
                      // onChanged: (val) => print(dateController.text = val),
                      validator: (val) {
                        // print("val$val");
                        if (val == '') {
                          return 'Please select date';
                        }
                        return null;
                      },
                      onSaved: (val) => print(val),
                    ),
                    SizedBox(
                      height: AppLayout.getHeight(20),
                    ),
                    TextFormField(
                      style: Mystyles.onpageheadingsyle
                          .copyWith(color: Mystyles.bigTitleStyle.color),
                      controller:
                          timeinput, //editing controller of this TextField
                      decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          suffixIcon: Icon(Icons.access_time),
                          // icon: Icon(Icons.timer), //icon of text field
                          labelText: "Select Time" //label text of field
                          ),
                      readOnly:
                          true, //set it true, so that user will not able to edit text
                      onTap: () async {
                        TimeOfDay? pickedTime = await showTimePicker(
                          initialTime: TimeOfDay.now(),
                          context: context,
                        );
                        if (pickedTime != null) {
                          print(pickedTime.format(context)); //output 10:51 PM
                          DateTime parsedTime = DateFormat.jm()
                              .parse(pickedTime.format(context).toString());
                          //converting to DateTime so that we can further format on different pattern.
                          print(parsedTime); //output 1970-01-01 22:53:00.000
                          String formattedTime =
                              DateFormat('HH:mm:ss').format(parsedTime);
                          print(formattedTime); //output 14:59:00
                          //DateFormat() is from intl package, you can format the time on any pattern you need.

                          setState(() {
                            timeinput.text =
                                formattedTime; //set the value of text field.
                          });
                        } else {
                          print("Time is not selected");
                        }
                      },
                      validator: (value) => value!.isEmpty
                          ? 'Please enter time'
                          : null, //if empty return error text
                    ),
                    SizedBox(
                      height: AppLayout.getHeight(20),
                    ),
                    TextFormField(
                      style: Mystyles.onpageheadingsyle
                          .copyWith(color: Mystyles.bigTitleStyle.color),
                      keyboardType: TextInputType.number,
                      controller: durationController,
                      decoration: const InputDecoration(
                        suffixIcon: Icon(Icons.punch_clock),
                        border: UnderlineInputBorder(),
                        hintText: 'Duration in minutes',
                      ),
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'please enter duration';
                        } else if (!RegExp(r"^[0-9]+$").hasMatch(val)) {
                          return 'enter valid duration';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: AppLayout.getHeight(20),
                    ),
                    TextFormField(
                      style: Mystyles.onpageheadingsyle
                          .copyWith(color: Mystyles.bigTitleStyle.color),
                      keyboardType: TextInputType.number,
                      controller: priceController,
                      decoration: const InputDecoration(
                        suffixIcon: Icon(
                          Icons.monetization_on,
                          color: Colors.grey,
                        ),
                        border: UnderlineInputBorder(),
                        hintText: 'Add price',
                      ),
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'please enter price';
                        } else if (!RegExp(r"^[0-9]+$").hasMatch(val)) {
                          return 'enter valid price in numbers';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: AppLayout.getHeight(20),
                    ),
                    GestureDetector(
                      onTap: () {
                        print("object");
                        if (_imagefile == null) {
                        } else if (formKey1.currentState!.validate()) {
                          //some method to save data,
                          //move to next screen
                          addwebinar['title'] = titleController.text;
                          addwebinar['date'] = dateController.text;
                          addwebinar['time'] = timeinput.text;
                          addwebinar['duration'] = durationController.text;
                          addwebinar['price'] = priceController.text;
                          addwebinar['cover'] = _imagefile;
                          print(addwebinar);
                          Get.to(() => AddWebinarScreen2(
                                webinarData: addwebinar,
                              ));
                          // Get.toNamed(RoutesHelper.addWebinarScreen2route);
                          print(titleController.text);
                          print(timeinput.text);
                          print(dateController.text);
                          // print("validated");
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
                            borderRadius:
                                BorderRadius.circular(AppLayout.getHeight(5))),
                        child: Center(
                          child: Text(
                            "Next",
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
            ),
          ),
        ),
      ),
    );
  }
}
