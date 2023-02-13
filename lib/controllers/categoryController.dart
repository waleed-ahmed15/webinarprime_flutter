import 'dart:convert';

import 'package:get/get.dart';
import 'package:webinarprime/models/category_model.dart';

import '../utils/app_constants.dart';
import 'package:http/http.dart' as http;

class CategoryContorller extends GetxController {
  List<CategoryModel> categoriesList = [];
  bool isLoading = true;

  @override
  void onInit() async {
    await getCategoriesList();
    super.onInit();
  }

  Future<void> getCategoriesList() async {
    try {
      categoriesList.clear();
      Uri url = Uri.parse("${AppConstants.baseURL}/category/all");
      final response = await http.get(url);
      var data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        for (var category in data) {
          categoriesList.add(CategoryModel.fromJson(category));
        }
      }
      print(categoriesList);

      // print('object');
      print(categoriesList[0].name);
      isLoading = false;
    } catch (e) {
      print(e);
    }
  }
}
