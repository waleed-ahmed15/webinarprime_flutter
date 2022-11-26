import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webinarprime/controllers/auth_controller.dart';
import 'package:webinarprime/controllers/categoryController.dart';
import 'package:webinarprime/models/category_model.dart';
import 'package:webinarprime/utils/dimension.dart';

class SelectInterstScreen extends StatefulWidget {
  const SelectInterstScreen({super.key});

  @override
  State<SelectInterstScreen> createState() => _SelectInterstScreenState();
}

class _SelectInterstScreenState extends State<SelectInterstScreen> {
  List<String> pickedIntersts = [];
  List<CategoryModel> interestList1 =
      Get.find<CategoryContorller>().categoriesList;

  @override
  Widget build(BuildContext context) {
    interestList1.sort((a, b) => a.name!.length.compareTo(b.name!.length));
    print(interestList1[0].image);
    return Builder(builder: (context) {
      return SafeArea(
        child: Scaffold(
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.green,
            onPressed: () async {
              await Get.find<AuthController>().addInterests(pickedIntersts);
              // Get.offAllNamed(RoutesHelper.homeScreenRoute);
            },
            child: const Icon(Icons.done),
          ),
          body: SingleChildScrollView(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              SizedBox(
                height: AppLayout.getHeight(40),
              ),
              Text("Select Your Interests",
                  style: TextStyle(
                      letterSpacing: 2,
                      color: Theme.of(context).primaryColor,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat-Regular')),
              GridView.builder(
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
                            pickedIntersts
                                .add(interestList1[index].id.toString());
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
        ),
      );
    });
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
              padding: EdgeInsets.symmetric(
                  vertical: AppLayout.getHeight(60),
                  horizontal: AppLayout.getWidth(60)),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(widget.category.image!, scale: 0.7),
                  fit: BoxFit.cover,
                ),
                shape: BoxShape.circle,
                border: isSelected
                    ? Border.all(
                        width: 3,
                        color: Colors.green,
                      )
                    : Border.all(width: 3, color: Colors.orange.shade300),
              ),
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: AppLayout.getHeight(4),
                  horizontal: AppLayout.getWidth(4),
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: FittedBox(
                  child: Text(
                    widget.category.name!,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      fontFamily: 'Montserrat-Regular',
                    ),
                  ),
                ),
              ),
              // child: Column(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     Container(
              //       width: AppLayout.getWidth(200),
              //       margin: const EdgeInsets.all(10),
              //       padding: EdgeInsets.symmetric(
              //           vertical: AppLayout.getHeight(36),
              //           horizontal: AppLayout.getWidth(36)),
              //       child: Text(
              //         widget.category.name!,
              //         style: const TextStyle(
              //             color: Colors.white,
              //             fontSize: 20,
              //             // fontWeight: FontWeight.bold,
              //             fontFamily: 'Montserrat-Regular'),
              //         textAlign: TextAlign.center,
              //       ),
              //     ),
              //   ],
              // ),
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
