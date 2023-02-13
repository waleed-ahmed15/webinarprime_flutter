import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:webinarprime/controllers/webinar_management_controller.dart';
import 'package:webinarprime/routes/routes.dart';
import 'package:webinarprime/widgets/snackbar.dart';

import '../../../utils/colors.dart';
import '../../../utils/dimension.dart';

class AddWebinarScreen3 extends StatefulWidget {
  Map<String, dynamic>? webinarData;
  AddWebinarScreen3({this.webinarData, super.key});

  @override
  State<AddWebinarScreen3> createState() => _AddWebinarScreen3State();
}

class _AddWebinarScreen3State extends State<AddWebinarScreen3> {
  // var titleController = TextEditingController();
  var descriptionController = TextEditingController();
  var talglineController = TextEditingController();
  var priceController = TextEditingController();
  var durationController = TextEditingController();
  var dateController = TextEditingController();
  TextEditingController timeinput = TextEditingController();

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
    print(widget.webinarData);
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
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
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: AppLayout.getWidth(20),
                  vertical: AppLayout.getHeight(20)),
              child: Form(
                key: formKey1,
                child: Column(
                  children: [
                    Text("description and banner image",
                        style: TextStyle(
                            letterSpacing: 2,
                            fontFamily: 'Montserrat-Regular',
                            color: AppColors.LTprimaryColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w400)),
                    SizedBox(
                      height: AppLayout.getHeight(50),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50)),
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
                            color: AppColors.LTprimaryColor,
                            borderRadius:
                                BorderRadius.circular(AppLayout.getHeight(5))),
                        child: Center(
                          child: Text(
                            "Add banner photo",
                            style: TextStyle(
                                letterSpacing: 2,
                                fontFamily: 'montserrat-bold',
                                fontWeight: FontWeight.w400,
                                color: Theme.of(context).colorScheme.secondary,
                                fontSize: AppLayout.getHeight(17)),
                          ),
                        ),
                      ),
                    ),
                    Text(
                      _imagefile == null ? 'please add image.' : "",
                      style: const TextStyle(color: Colors.red),
                    ),
                    SizedBox(
                      height: AppLayout.getHeight(20),
                    ),
                    TextFormField(
                      maxLines: 5,
                      controller: descriptionController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        hintText: 'Webinar desceiption.....',
                      ),
                      validator: (val) {
                        // print("val$val");
                        if (val == '') {
                          return 'please enter description';
                        } else if (val!.length < 50) {
                          return 'add description of atleast 50 characters';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: AppLayout.getHeight(20),
                    ),
                    TextFormField(
                      controller: talglineController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        hintText: 'enter tagline.....',
                      ),
                      validator: (val) {
                        // print("val$val");
                        if (val == '') {
                          return 'please enter tag line';
                        } else if (val!.length < 10) {
                          return 'add description of atleast 10 characters';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: AppLayout.getHeight(20),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (_imagefile == null) {
                        } else if (formKey1.currentState!.validate()) {
                          //some method to save data,
                          //move to next screen
                          // Get.toNamed(RoutesHelper.addWebinarScreen2route);
                          widget.webinarData!['description'] =
                              descriptionController.text.toString();
                          widget.webinarData!['tagline'] =
                              talglineController.text.toString();
                          widget.webinarData!['banner'] = _imagefile;
                          // print(widget.webinarData);
                          WebinarManagementController
                              webinarManagementController = Get.find();
                          webinarManagementController.AddWebinardata(
                              widget.webinarData!);

                          // print(titleController.text);
                          // print(timeinput.text);
                          // print(dateController.text);
                          print("validated");
                          ShowCustomSnackBar(
                              'webinar creation requested successfully',
                              title: "successfull",
                              isError: false);
                          Get.toNamed(RoutesHelper.homeScreenRoute);
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
                            "create webinar",
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
