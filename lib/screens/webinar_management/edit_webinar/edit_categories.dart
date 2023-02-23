import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webinarprime/controllers/categoryController.dart';
import 'package:webinarprime/controllers/webinar_management_controller.dart';
import 'package:webinarprime/models/category_model.dart';
import 'package:webinarprime/utils/styles.dart';

class EditCategories extends StatefulWidget {
  List<dynamic> webinarCategories;
  String webinarId;
  EditCategories(
      {super.key, required this.webinarCategories, required this.webinarId});
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
          backgroundColor: Mycolors.myappbarcolor,
          title: const Text('Edit Categories'),
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
          height: 50,
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () async {
              // Get.back(result: widget.webinarCategoriesid);
              bool updated = await Get.find<WebinarManagementController>()
                  .editWebinarCategories(
                      widget.webinarId, widget.webinarCategoriesid!);
              print('updated$updated');
              if (updated) {
                Get.back();
              }
            },
            child: const Text('Update'),
          ),
        ));
  }
}
