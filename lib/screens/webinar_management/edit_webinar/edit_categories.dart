import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:webinarprime/controllers/auth_controller.dart';
import 'package:webinarprime/controllers/categoryController.dart';
import 'package:webinarprime/controllers/webinar_management_controller.dart';
import 'package:webinarprime/models/category_model.dart';
import 'package:webinarprime/utils/colors.dart';
import 'package:webinarprime/utils/styles.dart';

class EditCategories extends StatefulWidget {
  // this is same class which is being used to edit interst of the user.
  List<dynamic> webinarCategories;
  String webinarId;
  bool userinterest = false;
  EditCategories(
      {this.userinterest = false,
      super.key,
      required this.webinarCategories,
      required this.webinarId});
  List<String>? webinarCategoriesid;

  @override
  State<EditCategories> createState() => _EditCategoriesState();
}

class _EditCategoriesState extends State<EditCategories> {
  List<CategoryModel> allCategories =
      Get.find<CategoryContorller>().categoriesList;

  @override
  void initState() {
    super.initState();
    if (widget.userinterest) {
      print('---------------------------------userinterest');
      print(Get.find<AuthController>().currentUser['interests']);
      widget.webinarCategoriesid =
          widget.webinarCategories.map((e) => e as String).toList();

      return;
    }
    print('---------------------------------webinarCategories');

    widget.webinarCategoriesid =
        widget.webinarCategories.map((e) => e['_id'] as String).toList();
    // super.initState();
    print('---------------------------------webinarCategoriesid');
    print(widget.webinarCategoriesid);
    print('---------------------------------webinarCategoriesid');

    print(allCategories[0].id);
    print(widget.webinarCategoriesid![0]);
    print(widget.webinarCategoriesid!.contains(allCategories[0].id));
  }

  @override
  Widget build(BuildContext context) {
    print(widget.webinarCategoriesid);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: myappbarcolor,
          title: Text(
            'Edit Categories',
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(fontSize: 15.sp),
          ),
          centerTitle: true,
          elevation: 0,
        ),
        body: ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: allCategories.length,
          itemBuilder: (context, index) {
            return CheckboxListTile(
              title: Text(allCategories[index].name!),
              value:
                  widget.webinarCategoriesid!.contains(allCategories[index].id),
              onChanged: (value) {
                if (value == true) {
                  widget.webinarCategoriesid!
                      .add(allCategories[index].id.toString());
                } else {
                  widget.webinarCategoriesid!
                      .remove(allCategories[index].id.toString());
                }
                setState(() {
                  print(widget.webinarCategoriesid);
                });
              },
            );
          },
        ),
        bottomNavigationBar: Container(
          margin: const EdgeInsets.all(10),
          height: 40,
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Get.isDarkMode
                  ? AppColors.LTsecondaryColor
                  : AppColors.LTprimaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () async {
              // Get.back(result: widget.webinarCategoriesid);
              if (widget.userinterest) {
                await Get.find<AuthController>()
                    .addInterests(widget.webinarCategoriesid!);
                // Get.back();
                Get.find<AuthController>().currentUser['interests'].clear();
                Get.find<AuthController>()
                    .currentUser['interests']
                    .addAll(widget.webinarCategoriesid!);
                return;
              }

              bool updated = await Get.find<WebinarManagementController>()
                  .editWebinarCategories(
                      widget.webinarId, widget.webinarCategoriesid!);
              print('updated$updated');
              if (updated) {
                Get.back();
              }
            },
            child: Text(
              'Update',
              style: Theme.of(context)
                  .textTheme
                  .displayMedium!
                  .copyWith(color: Colors.white),
            ),
          ),
        ));
  }
}
