import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:textfield_tags/textfield_tags.dart';
import 'package:webinarprime/screens/webinar_management/add_webinar_screens/add_webinar_screen3.dart';
import 'package:webinarprime/utils/colors.dart';
import 'package:webinarprime/widgets/snackbar.dart';

import '../../../controllers/categoryController.dart';
import '../../../models/category_model.dart';
import '../../../utils/dimension.dart';
import '../../select_interests/select_interest_screen.dart';

class AddWebinarScreen2 extends StatefulWidget {
  Map<String, dynamic>? webinarData;
  AddWebinarScreen2({this.webinarData, Key? key}) : super(key: key);
  // const AddWebinarScreen1({super.key});

  @override
  State<AddWebinarScreen2> createState() => _HomeState();
}

class _HomeState extends State<AddWebinarScreen2> {
  late double _distanceToField;
  late TextfieldTagsController _controller;
  List<String> tagsList = [];
  List<String> pickedIntersts = [];
  List<CategoryModel> interestList1 =
      Get.find<CategoryContorller>().categoriesList;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _distanceToField = MediaQuery.of(context).size.width;
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller = TextfieldTagsController();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.webinarData);
    return SafeArea(
      child: Scaffold(
        body: ListView(
          children: [
            Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                const Text("Tags and Categories",
                    style: TextStyle(
                        letterSpacing: 2,
                        fontFamily: 'Montserrat-Regular',
                        color: AppColors.LTprimaryColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w400)),
                TextFieldTags(
                  textfieldTagsController: _controller,
                  initialTags: const [],
                  textSeparators: const [' ', ','],
                  letterCase: LetterCase.normal,
                  validator: (String tag) {
                    if (tag == 'php') {
                      return 'No, please just no';
                    } else if (_controller.getTags!.contains(tag)) {
                      return 'you already entered that';
                    }
                    tagsList.add(tag);
                    print(tagsList);

                    return null;
                  },
                  inputfieldBuilder:
                      (context, tec, fn, error, onChanged, onSubmitted) {
                    return ((context, sc, tags, onTagDelete) {
                      return Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextField(
                          controller: tec,
                          focusNode: fn,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: AppColors.LTprimaryColor,
                                width: 1.0,
                              ),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: AppColors.LTprimaryColor,
                                width: 1.0,
                              ),
                            ),
                            helperText: 'tags ',
                            helperStyle: const TextStyle(),
                            hintText: _controller.hasTags ? '' : "Enter tag...",
                            errorText: error,
                            prefixIconConstraints: BoxConstraints(
                                maxWidth: _distanceToField * 0.74),
                            prefixIcon: tags.isNotEmpty
                                ? SingleChildScrollView(
                                    controller: sc,
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                        children: tags.map((String tag) {
                                      return Container(
                                        decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(20.0),
                                          ),
                                          color: AppColors.LTprimaryColor,
                                        ),
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 5.0),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10.0, vertical: 5.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            InkWell(
                                              child: Text(
                                                '#$tag',
                                                style: const TextStyle(
                                                    color: Colors.white),
                                              ),
                                              onTap: () {
                                                //print("$tag selected");
                                              },
                                            ),
                                            const SizedBox(width: 4.0),
                                            InkWell(
                                              child: const Icon(
                                                Icons.cancel,
                                                size: 14.0,
                                                color: Color.fromARGB(
                                                    255, 233, 233, 233),
                                              ),
                                              onTap: () {
                                                onTagDelete(tag);
                                              },
                                            )
                                          ],
                                        ),
                                      );
                                    }).toList()),
                                  )
                                : null,
                          ),
                          onChanged: onChanged,
                          onSubmitted: onSubmitted,
                        ),
                      );
                    });
                  },
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      AppColors.LTprimaryColor,
                    ),
                  ),
                  onPressed: () {
                    _controller.clearTags();
                    tagsList.clear();
                  },
                  child: const Text('CLEAR TAGS'),
                ),
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  SizedBox(
                    height: AppLayout.getHeight(10),
                  ),
                  const Text("Select Your Interests",
                      style: TextStyle(
                        letterSpacing: 2,
                        color: AppColors.LTprimaryColor,
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Montserrat-Regular',
                      )),
                  SizedBox(
                    height: AppLayout.getHeight(470),
                    child: GridView.builder(
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
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
                                  pickedIntersts
                                      .remove(interestList1[index].id);
                                });
                              }
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: AppLayout.getWidth(20)),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                          AppColors.LTprimaryColor,
                        ),
                      ),
                      onPressed: () {
                        if (tagsList.isEmpty || pickedIntersts.isEmpty) {
                          ShowCustomSnackBar(
                            'Please select at least 1 interest interests and tags',
                            title: 'interst and tags',
                            isError: true,
                          );
                        } else {
                          widget.webinarData!['tags'] = tagsList;
                          widget.webinarData!['categories'] = pickedIntersts;
                          print(widget.webinarData);
                          print(tagsList);
                          print(pickedIntersts);
                          // Get.toNamed(RoutesHelper.addWebinarScreen3route);
                          Get.to(() => AddWebinarScreen3(
                                webinarData: widget.webinarData,
                              ));
                        }
                        //move to next screen
                      },
                      child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: AppLayout.getHeight(10),
                              horizontal: AppLayout.getWidth(20)),
                          width: double.maxFinite,
                          child: const Center(child: Text('Next'))),
                    ),
                  )
                ]),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
