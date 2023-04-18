import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/categoryController.dart';
import '../../controllers/webinar_management_controller.dart';

// class TextBox extends StatefulWidget {
//   final String text;
//   final int index;
//   final int selectedIndex;
//   final Function(int) onSelected;

//   const TextBox(
//       {super.key,
//       required this.text,
//       required this.index,
//       required this.selectedIndex,
//       required this.onSelected});

//   @override
//   _TextBoxState createState() => _TextBoxState();
// }

// class _TextBoxState extends State<TextBox> {
//   @override
//   Widget build(BuildContext context) {
//     bool isSelected = widget.index == widget.selectedIndex;

//     return GestureDetector(
//       onTap: () {
//         if (!isSelected) {
//           print("Selected: ${widget.index}");
//           widget.onSelected(widget.index);
//           Get.find<WebinarManagementController>().searchbyCategory(
//               Get.find<CategoryContorller>().categoriesList[widget.index].id!);
//         }
//       },
//       child: Container(
//         margin: const EdgeInsets.symmetric(horizontal: 10),
//         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(10),
//           border: Border.all(
//             color: isSelected ? Colors.blue : Colors.grey,
//             width: 2,
//           ),
//         ),
//         child: Text(widget.text),
//       ),
//     );
//   }
// }

// class TextBoxList extends StatefulWidget {
//   const TextBoxList({super.key});

//   @override
//   _TextBoxListState createState() => _TextBoxListState();
// }

// class _TextBoxListState extends State<TextBoxList> {
//   final List<String> _texts = [
//     "Text Box 1",
//     "Text Box 2",
//     "Text Box 3",
//     "Text Box 4",
//     "Text Box 5",
//     "Text Box 6",
//     "Text Box 7",
//     "Text Box 8",
//     "Text Box 9",
//     "Text Box 10",
//   ];

//   int _selectedIndex = -1;
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     CategoryContorller()
//         .getCategoriesList()
//         .then((value) => print('categories fetched'));
//     print(Get.find<CategoryContorller>().categoriesList);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 100,
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         itemCount: Get.find<CategoryContorller>().categoriesList.length,
//         itemBuilder: (BuildContext context, int index) {
//           return TextBox(
//             text: Get.find<CategoryContorller>().categoriesList[index].name!,
//             index: index,
//             selectedIndex: _selectedIndex,
//             onSelected: (int selectedIndex) {
//               setState(() {
//                 _selectedIndex = selectedIndex;
//               });
//             },
//           );
//         },
//       ),
//     );
//   }
// }

class TextBox extends StatefulWidget {
  final String text;
  final int index;
  final bool isSelected;
  final Function(int, bool) onSelected;

  const TextBox(
      {super.key,
      required this.text,
      required this.index,
      required this.isSelected,
      required this.onSelected});

  @override
  _TextBoxState createState() => _TextBoxState();
}

class _TextBoxState extends State<TextBox> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // onTap: () {
        // if (!widget.isSelected) {
        // print("Selected: ${widget.index}");
        // widget.onSelected(widget.index, true);
        // Get.find<WebinarManagementController>().searchbyCategory(
        // Get.find<CategoryContorller>().categoriesList[widget.index].id!);
        // WebinarManagementController.searchedWebinars.refresh();
        // Get.find<WebinarManagementController>().update();

        // }
        // }

        setState(() {
          widget.onSelected(widget.index, !widget.isSelected);
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: widget.isSelected ? Colors.blue : Colors.grey,
            width: 2,
          ),
        ),
        child: Text(widget.text),
      ),
    );
  }
}

class TextBoxList extends StatefulWidget {
  const TextBoxList({super.key});

  @override
  _TextBoxListState createState() => _TextBoxListState();
}

class _TextBoxListState extends State<TextBoxList> {
  final List<String> _texts = [
    "Text Box 1",
    "Text Box 2",
    "Text Box 3",
    "Text Box 4",
    "Text Box 5",
    "Text Box 6",
    "Text Box 7",
    "Text Box 8",
    "Text Box 9",
    "Text Box 10",
  ];

  int _selectedIndex = -1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    CategoryContorller()
        .getCategoriesList()
        .then((value) => print('categories fetched'));
    print(Get.find<CategoryContorller>().categoriesList);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: Get.find<CategoryContorller>().categoriesList.length,
        itemBuilder: (BuildContext context, int index) {
          bool isSelected = index == _selectedIndex;

          return TextBox(
            text: Get.find<CategoryContorller>().categoriesList[index].name!,
            index: index,
            isSelected: isSelected,
            onSelected: (int selectedIndex, bool isSelected) async {
              setState(() {
                _selectedIndex = isSelected ? selectedIndex : -1;
                if (isSelected) {
                  print("Selected: $selectedIndex");
                  Get.find<WebinarManagementController>()
                      .searchbyCategory(Get.find<CategoryContorller>()
                          .categoriesList[selectedIndex]
                          .id!)
                      .then((value) {
                    Get.find<WebinarManagementController>().update();
                    print('updated');
                    setState(() {});
                  });
                } else {
                  print("Deselected: $selectedIndex");
                  Get.find<WebinarManagementController>()
                      .searchbyCategory('')
                      .then((value) {
                    Get.find<WebinarManagementController>().update();
                    print('updated2');
                    setState(() {});
                  });
                }
              });
            },
          );
        },
      ),
    );
  }
}
