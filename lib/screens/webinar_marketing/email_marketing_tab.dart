import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:webinarprime/controllers/marketing_controller.dart';
import 'package:webinarprime/controllers/webinar_management_controller.dart';
import 'package:webinarprime/utils/colors.dart';
import 'package:webinarprime/widgets/snackbar.dart';

class EmailMarketingTab extends StatefulWidget {
  const EmailMarketingTab({super.key});

  @override
  State<EmailMarketingTab> createState() => _EmailMarketingTabState();
}

class _EmailMarketingTabState extends State<EmailMarketingTab> {
  bool isloading = false;
  String audienceAge = 'Specific Age';
  String bannerImageSelection = 'Default Banner Image';
  var specficAgeController = TextEditingController();
  var startAgeController = TextEditingController();
  var endAgeController = TextEditingController();
  var messageController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final ImagePicker imagePicker = ImagePicker();
  File? _imagefile;
  Uint8List? imagebyte;
  String? base64img;
  String? coverImagePath;
  void _pickBase64Image() async {
    final XFile? image =
        await imagePicker.pickImage(source: ImageSource.gallery);
    // uploadImage(File(image!.path));
    if (image != null) {
      print('image picked');
      _imagefile = File(image.path);
      // print('No image selected.');
      imagebyte = await image.readAsBytes();

      setState(() {});
      return;
    } else {
      print('No image selected.');
    }
    setState(() {});
    return;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(8),
      children: [
        Container(
          child: DropdownButton<String>(
            underline: const SizedBox(),
            value: audienceAge,
            items: <String>[
              'Specific Age',
              'Age Range',
            ].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                ),
              );
            }).toList(),
            onChanged: (String? value) {
              setState(() {
                audienceAge = value!;
                print(audienceAge);
              });
            },
          ),
        ),
        Form(
          key: _formKey,
          child: Column(
            children: [
              audienceAge == 'Specific Age'
                  ? TextFormField(
                      controller: specficAgeController,
                      decoration: InputDecoration(
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.blue.withOpacity(0.5)),
                        ),
                        hintText: 'Enter Age',
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty ||
                            !RegExp(r'^[0-9]+$').hasMatch(value)) {
                          return 'Please enter age';
                        } else if (int.parse(value) > 70 ||
                            int.parse(value) < 18) {
                          return 'Please enter valid age(18-70)';
                        }
                        return null;
                      },
                    )
                  : Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: startAgeController,
                            decoration: InputDecoration(
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              border: const OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.blue.withOpacity(0.5)),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.red.withOpacity(0.5)),
                              ),
                              hintText: 'start age',
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value!.isEmpty ||
                                  !RegExp(r'^[0-9]+$').hasMatch(value)) {
                                return 'Please enter age';
                              } else if (int.parse(value) > 70 ||
                                  int.parse(value) < 18) {
                                return 'Please enter valid age(18-70)';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(
                          child: Text(
                            ' - ',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: endAgeController,
                            decoration: InputDecoration(
                              // errorMaxLines: 1,
                              border: const OutlineInputBorder(),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.blue.withOpacity(0.5)),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.red.withOpacity(0.5)),
                              ),
                              hintText: 'end age',
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              print(int.parse(value!));
                              print(int.parse(startAgeController.text.trim()));

                              print(startAgeController.text.trim());
                              if (value.isEmpty) {
                                return 'Please enter age';
                              } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                                return 'Please enter age';
                              } else if (int.parse(value) <
                                  int.parse(startAgeController.text.trim())) {
                                print('object');
                                return 'Please enter valid age';
                              } else if (int.parse(value) > 70 ||
                                  int.parse(value) < 18) {
                                return 'Please enter valid age(18-70)';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
              Gap(30.h),
              TextFormField(
                maxLines: 5,
                maxLength: 500,
                controller: messageController,
                decoration: InputDecoration(
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  border: const OutlineInputBorder(),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red.withOpacity(0.5)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue.withOpacity(0.5)),
                  ),
                  hintText: 'Type Message...',
                ),
                validator: (value) {
                  if (value!.trim().isEmpty) {
                    return 'Please enter message';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        const Gap(20),
        Container(
          child: DropdownButton<String>(
            underline: const SizedBox(),
            value: bannerImageSelection,
            items: <String>[
              'Default Banner Image',
              'Upload Banner Image',
            ].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                ),
              );
            }).toList(),
            onChanged: (String? value) {
              setState(() {
                bannerImageSelection = value!;
                print(audienceAge);
              });
            },
          ),
        ),
        Gap(20.h),
        bannerImageSelection == 'Upload Banner Image'
            ? Container(
                decoration: BoxDecoration(
                  image: imagebyte != null
                      ? DecorationImage(
                          image: MemoryImage(imagebyte!), fit: BoxFit.cover)
                      : null,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey),
                ),
                height: 200,
                width: 200,
                child: IconButton(
                  onPressed: () {
                    _pickBase64Image();
                  },
                  icon: Icon(
                    Icons.camera_alt,
                    size: 40.h,
                  ),
                ),
              )
            : const SizedBox(),
        const Gap(20),
        isloading
            ? Container(
                child: const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.LTprimaryColor,
                  ),
                ),
              )
            : ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    if (bannerImageSelection == 'Upload Banner Image') {
                      if (imagebyte == null) {
                        return ShowCustomSnackBar('Please upload banner image',
                            isError: true);
                      } else {
                        print(_imagefile);

                        print('upload with image');
                        String age = audienceAge == 'Specific Age'
                            ? specficAgeController.text.trim()
                            : '${startAgeController.text.trim()}-${endAgeController.text.trim()}';
                        setState(() {
                          isloading = true;
                        });
                        int statuscode = await Get.find<MarketingController>()
                            .emailMarketing_with_image(
                          WebinarManagementController.currentWebinar['_id'],
                          age,
                          messageController.text.trim(),
                          _imagefile!,
                        );
                        setState(() {
                          isloading = false;
                        });
                        if (statuscode == 200) {
                          ShowCustomSnackBar(
                              title: "Success",
                              'Email marketing done successfully',
                              isError: false);
                          Navigator.pop(context);
                        } else {
                          ShowCustomSnackBar(
                              title: "Error",
                              'Something went wrong',
                              isError: true);
                        }
                      }
                    } else {
                      String age = audienceAge == 'Specific Age'
                          ? specficAgeController.text.trim()
                          : '${startAgeController.text.trim()}-${endAgeController.text.trim()}';

                      setState(() {
                        isloading = true;
                      });
                      int statuscode = await Get.find<MarketingController>()
                          .emailMarketing_without_image(
                        WebinarManagementController.currentWebinar['_id'],
                        age,
                        messageController.text.trim(),
                      );
                      print(statuscode);
                      if (statuscode == 200) {
                        ShowCustomSnackBar(
                            title: "Success",
                            'Email marketing done successfully',
                            isError: false);
                        Navigator.pop(context);
                      }
                      setState(() {
                        isloading = false;
                      });
                      print('upload without image');
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.LTprimaryColor,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 15,
                  ),
                ),
                child: Text(
                  'Market',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontSize: 20, color: Colors.white),
                ),
              ),
      ],
    );
  }
}
