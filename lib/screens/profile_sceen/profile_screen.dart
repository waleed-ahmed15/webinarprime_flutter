import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:webinarprime/controllers/auth_controller.dart';
import 'package:webinarprime/utils/app_constants.dart';
import 'package:webinarprime/utils/app_fonts.dart';
import 'package:webinarprime/utils/colors.dart';
import 'package:webinarprime/utils/dimension.dart';
import 'package:webinarprime/widgets/profile_screen_textfields.dart';
import 'package:webinarprime/widgets/snackbar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var currentUser = Get.find<AuthController>().currentUser;
  Map<String, String> profileData = {
    "Name": "JohnDoe",
    "Email": "waleedahmed@gamil.com",
    "birthdate": "1990-01-05",
    "registration_number": "FA19-BCS-66",
  };
  // String? name=profileData["Name"];
  final TextEditingController namecontroller = TextEditingController();
  bool isvalidateUsername(String value) {
    if (value.isEmpty ||
        !RegExp(r"^[A-Za-z][A-Za-z0-9_]{4,29}$").hasMatch(value)) {
      return false;
    }
    return true;
  }

  Future simpleDialog(
      {required BuildContext context,
      required String initailvalue,
      required String label}) async {
    String error = '';
    return await showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          namecontroller.text = initailvalue;

          return SimpleDialog(
            title: Text(label),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: TextFormField(
                  controller: namecontroller,
                  decoration:
                      const InputDecoration(border: UnderlineInputBorder()),
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Row(
                  children: [
                    TextButton(
                      child: const Text('CANCEL'),
                      onPressed: () {
                        setState(() {
                          Navigator.pop(context);
                        });
                      },
                    ),
                    TextButton(
                      child: const Text('Update'),
                      onPressed: () {
                        if (isvalidateUsername(namecontroller.text)) {
                          ShowCustomSnackBar(
                              title: 'Updated',
                              'username updated',
                              isError: false);
                          setState(() {
                            Navigator.pop(context);

                            profileData[label] = namecontroller.text;
                          });
                        } else {
                          ShowCustomSnackBar('username is not valid',
                              isError: true);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        });
  }

  Future<void> InputDialogForName(
      BuildContext context, String initalvalue) async {
    namecontroller.text = initalvalue;
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Name'),
            content: TextFormField(
              onChanged: (value) {
                setState(() {
                  initalvalue = value;
                });
              },
              // initialValue: 'sdsd',
              controller: namecontroller,
              decoration: const InputDecoration(border: UnderlineInputBorder()),
            ),
            actions: <Widget>[
              SimpleDialogOption(
                child: const Text('CANCEL'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
              TextButton(
                // color: Colors.red,
                // textColor: Colors.white,
                child: const Text('CANCEL'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
              TextButton(
                // color: Colors.green,
                // textColor: Colors.white,
                child: const Text('Update'),
                onPressed: () {
                  // if(_te)
                  // namecontroller.text = 'updated';
                  print('upadate name');

                  setState(() {
                    // codeDialog = valueText;
                    Navigator.pop(context);
                  });
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    Get.find<AuthController>().authenticateUser(true);
    print('profile screen');
    print(currentUser);
    Get.find<AuthController>().currentUser;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,
              color: Theme.of(context).colorScheme.secondary),
          onPressed: () {
            Get.back();
          },
        ),
        actions: const [
          // TextButton(
          //     onPressed: () {},
          //     child: Text('Save', style: AppConstants.secondaryHeadingStyle)),
        ],
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        centerTitle: true,
        title: Text(
          'Details',
          style: AppConstants.paragraphStyle.copyWith(
              color: Theme.of(context).colorScheme.secondary,
              fontSize: AppLayout.getHeight(20)),
        ),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(
            vertical: AppLayout.getHeight(20),
            horizontal: AppLayout.getWidth(6)),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 5),
              blurRadius: 7,
              color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
            ),
            BoxShadow(
              offset: const Offset(0, -5),
              blurRadius: 7,
              color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
            )
          ],
        ),
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: AppLayout.getHeight(20)),
          children: [
            SizedBox(height: AppLayout.getHeight(20)),
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fitHeight,
                  image: NetworkImage(Get.find<AuthController>()
                              .currentUser['profile_image'][0] ==
                          'h'
                      ? Get.find<AuthController>().currentUser['profile_image']
                      : AppConstants.baseURL +
                          Get.find<AuthController>()
                              .currentUser['profile_image']),
                ),
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              height: AppLayout.getHeight(150),
              child: Column(
                children: [
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(AppLayout.getHeight(4)),
                        color: Theme.of(context).scaffoldBackgroundColor),
                    child: GestureDetector(
                      onTap: () {
                        print('edit icon for image was pressed');
                      },
                      child: const Icon(
                        Icons.edit,
                        size: 20,
                      ),
                    ),
                  ),
                  const Gap(3),
                ],
              ),
            ),
            Gap(AppLayout.getHeight(20)),
            ProfileScreenTextFieldWidget(
              onEditIconPressed: () async {
                // InputDialogForName(context, profileData["Name"]!);
                simpleDialog(
                    context: context,
                    initailvalue: currentUser['name'],
                    label: 'Name');
              },
              initialValue: currentUser['name'],
              label: "Name",
              editIcon: Icons.edit,
              prefixIcon: Icons.person,
            ),
            Gap(AppLayout.getHeight(20)),
            ProfileScreenTextFieldWidget(
              onEditIconPressed: () async {
                // simpleDialog(context: );
                // _displayTextInputDialog(context, 'name');
              },
              initialValue: currentUser['email'],
              label: "Email",
              prefixIcon: Icons.email,
              editIcon: Icons.edit,
            ),
            Gap(AppLayout.getHeight(20)),
            ProfileScreenTextFieldWidget(
            
              onEditIconPressed: () async {
                // _displayTextInputDialog(context, 'name');
              },
              initialValue: currentUser["birthdate"],
              label: "Birthdate",
              prefixIcon: Icons.calendar_month,
              editIcon: Icons.edit,
            ),
            Gap(AppLayout.getHeight(20)),
            Container(
              padding: EdgeInsets.only(bottom: AppLayout.getHeight(5)),
              child: Text("Change Password",
                  textAlign: TextAlign.right,
                  style: AppConstants.secondaryHeadingStyle.copyWith(
                    fontSize: AppLayout.getHeight(20),
                    decoration: TextDecoration.underline,
                    letterSpacing: 2,
                    color: AppColors.LTprimaryColor,
                  )

                  // TextStyle(
                  //     letterSpacing: 2,
                  //     decoration: TextDecoration.underline,
                  //     fontFamily: AppFont.jsLight,
                  //     color: AppColors.LTprimaryColor,
                  //     // fontWeight: FontWeight.w400,
                  //     fontSize: AppLayout.getWidth(20)),
                  ),
            ),
            Gap(AppLayout.getHeight(20)),
            TextButton(
              onPressed: () {
                Get.find<AuthController>().deleteAccout();
                Get.snackbar('Account Deleted', 'Account Deleted',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.red,
                    colorText: Colors.white);
                print('delete account pressed');
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              child: Text(
                "Delete Account",
                style: TextStyle(
                    fontFamily: AppFont.jsThin,
                    letterSpacing: 2,
                    // fontWeight: FontWeight.w600,
                    fontSize: AppLayout.getWidth(20)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
