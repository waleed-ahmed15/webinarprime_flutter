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

class SocialMediaMarketingTab extends StatefulWidget {
  const SocialMediaMarketingTab({super.key});

  @override
  State<SocialMediaMarketingTab> createState() =>
      _SocialMediaMarketingTabState();
}

class _SocialMediaMarketingTabState extends State<SocialMediaMarketingTab> {
  String bannerImageSelection = 'Default Banner Image';
  bool isloading = false;
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
        Gap(10.h),
        Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                maxLines: 5,
                maxLength: 500,
                decoration: InputDecoration(
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue.withOpacity(0.5)),
                  ),
                  errorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  ),
                  hintText: 'Type Message...',
                ),
                validator: (value) {
                  if (value!.trim().isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              const Gap(10),
            ],
          ),
        ),
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
                print(bannerImageSelection);
              });
            },
          ),
        ),
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
                        if (imagebyte == null) {
                          return ShowCustomSnackBar(
                              'Please upload banner image',
                              isError: true);
                        }
                      } else {
                        print('upload with image');
                        setState(() {
                          isloading = true;
                        });
                        int statusCode = await Get.find<MarketingController>()
                            .facebookMarketing_with_image(
                                WebinarManagementController
                                    .currentWebinar["_id"],
                                messageController.text.trim(),
                                _imagefile!);
                        if (statusCode == 200) {
                          ShowCustomSnackBar('Posted Successfully',
                              isError: false, title: "Success");
                          setState(() {
                            isloading = false;
                            navigator!.pop(context);
                          });
                        } else {
                          ShowCustomSnackBar('Something went wrong',
                              isError: true);
                          setState(() {
                            isloading = false;
                          });
                        }
                      }
                    } else {
                      print('upload without image');
                      setState(() {
                        isloading = true;
                      });
                      int statusCode = await Get.find<MarketingController>()
                          .facebookMarketing_without_image(
                              WebinarManagementController.currentWebinar["_id"],
                              messageController.text.trim());
                      if (statusCode == 200) {
                        ShowCustomSnackBar('Posted Successfully',
                            isError: false, title: "Success");
                        setState(() {
                          isloading = false;
                          navigator!.pop(context);
                        });
                      } else {
                        ShowCustomSnackBar('Something went wrong',
                            isError: true);
                        setState(() {
                          isloading = false;
                        });
                      }
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.LTprimaryColor,
                  fixedSize: Size(1.sw, 50.h),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                child: Text(
                  'Post',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontSize: 20),
                ),
              ),
      ],
    );
  }
}
