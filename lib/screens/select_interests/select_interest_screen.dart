import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:webinarprime/controllers/auth_controller.dart';
import 'package:webinarprime/controllers/categoryController.dart';
import 'package:webinarprime/models/category_model.dart';
import 'package:webinarprime/routes/routes.dart';
import 'package:webinarprime/utils/dimension.dart';

class SelectInterstScreen extends StatefulWidget {
  const SelectInterstScreen({super.key});

  @override
  State<SelectInterstScreen> createState() => _SelectInterstScreenState();
}

class _SelectInterstScreenState extends State<SelectInterstScreen> {
  List<String> pickedIntersts = [];
  CategoryContorller controller = Get.find();

  List<CategoryModel> interestList1 =
      Get.find<CategoryContorller>().categoriesList;

  @override
  Widget build(BuildContext context) {
    interestList1.sort((a, b) => a.name!.length.compareTo(b.name!.length));
    print(interestList1);
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.green,
          onPressed: () async {
            await Get.find<AuthController>().addInterests(pickedIntersts);
            await Get.find<AuthController>().getUserById(Get.find<AuthController>().currentUser['_id']);
            Get.offAllNamed(RoutesHelper.homeScreenRoute);
          },
          child: const Icon(Icons.done),
        ),
        body: ListView(physics: const BouncingScrollPhysics(), children: [
          SizedBox(
            height: AppLayout.getHeight(40),
          ),
          Text("Select Your Interests",
              textAlign: TextAlign.center,
              style: TextStyle(
                  letterSpacing: 2,
                  color: Theme.of(context).primaryColor,
                  fontSize: 23.sp,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'josefinsans')),
          GridView.builder(
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            itemCount: interestList1.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                child: Item(
                  category: interestList1[index],
                  onselected: (bool value) {
                    if (value) {
                      setState(() {
                        print('1value');
                        pickedIntersts.add(interestList1[index].id.toString());
                        print(pickedIntersts);
                      });
                    } else {
                      setState(() {
                        print('value');
                        pickedIntersts.remove(interestList1[index].id);
                      });
                    }
                  },
                ),
              );
            },
          ),
        ]),
      ),
    );
  }
}

class Item extends StatefulWidget {
  final CategoryModel category;
  final ValueChanged<bool> onselected;
  const Item({
    Key? key,
    required this.category,
    required this.onselected,
  }) : super(key: key);

  @override
  State<Item> createState() => _ItemState();
}

class _ItemState extends State<Item> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: AppLayout.getHeight(20)),
      // width: double.maxFinite,
      child: GestureDetector(
        onTap: () {
          setState(() {
            isSelected = !isSelected;

            widget.onselected(isSelected);
          });
        },
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                  // vertical: AppLayout.getHeight(10),
                  // horizontal: AppLayout.getWidth(60)
                  ),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(widget.category.image!, scale: 0.7),
                  fit: BoxFit.cover,
                ),
                shape: BoxShape.circle,
                border: isSelected
                    ? Border.all(
                        width: 1,
                        color: Colors.green,
                      )
                    : Border.all(width: 1, color: Colors.orange.shade300),
              ),
              child: Center(
                child: Container(
                  // width: double.maxFinite,
                  width: 150.w,
                  padding: EdgeInsets.symmetric(
                    vertical: AppLayout.getHeight(4),
                    horizontal: AppLayout.getWidth(4),
                  ),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        transform: GradientRotation(0.5),
                        colors: [
                          Colors.black38,
                          Colors.black26,
                          // Color(0xff2A5470),
                          // Color.fromARGB(255, 86, 92, 207),
                          // Color(0xff4C4177),
                        ]),
                    // color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: AutoSizeText(
                    widget.category.name!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      fontFamily: 'josefinsans',
                    ),
                  ),
                ),
              ),
            ),
            isSelected
                ? Positioned(
                    top: 0,
                    right: 120,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          vertical: AppLayout.getHeight(3),
                          horizontal: AppLayout.getWidth(3)),
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
