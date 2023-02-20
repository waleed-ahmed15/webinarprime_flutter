import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webinarprime/controllers/categoryController.dart';
import 'package:webinarprime/models/category_model.dart';

class EditCategories extends StatefulWidget {
  const EditCategories({super.key});

  @override
  State<EditCategories> createState() => _EditCategoriesState();
}

class _EditCategoriesState extends State<EditCategories> {
  List<String> pickedIntersts = [];
  List<CategoryModel> interestList1 =
      Get.find<CategoryContorller>().categoriesList;
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
