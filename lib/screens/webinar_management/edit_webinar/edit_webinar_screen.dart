import 'dart:io';
import 'dart:typed_data';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:textfield_tags/textfield_tags.dart';
import 'package:webinarprime/controllers/webinar_management_controller.dart';
import 'package:webinarprime/screens/webinar_management/edit_webinar/edit_categories.dart';
import 'package:webinarprime/utils/app_constants.dart';
import 'package:webinarprime/utils/colors.dart';
import 'package:webinarprime/utils/dimension.dart';

class EditWebinarScreen extends StatefulWidget {
  final Map<String, dynamic> webinarDetails;

  EditWebinarScreen({super.key, required this.webinarDetails});
  final formKey2 = GlobalKey<FormState>(); //key for form

  var editingController = TextEditingController();
  final TextfieldTagsController _controller = TextfieldTagsController();
  WebinarManagementController webinarcontroller =
      Get.find<WebinarManagementController>();

  @override
  State<EditWebinarScreen> createState() => _EditWebinarScreenState();
}

class _EditWebinarScreenState extends State<EditWebinarScreen>
    with SingleTickerProviderStateMixin {
  // this is the function that will be called when the user pressses edit for cover image
  final ImagePicker imagePicker = ImagePicker();
  File? _imagefile;
  Uint8List? imagebyte;
  String? base64img;
  String? coverImagePath;
  void _pickBase64Image(String imagetoEdit) async {
    final XFile? image =
        await imagePicker.pickImage(source: ImageSource.gallery);
    // uploadImage(File(image!.path));
    if (image != null) {
      print('image picked');

      if (imagetoEdit == 'coverImage') {
        String coverpath = await widget.webinarcontroller.editWebinarCoverImage(
            widget.webinarDetails['_id'], File(image.path));
        widget.webinarDetails['coverImage'] = coverpath;
      } else {
        String thumbnailpath = await widget.webinarcontroller
            .editWebinarBannerImage(
                widget.webinarDetails['_id'], File(image.path));
        widget.webinarDetails['bannerImage'] = thumbnailpath;
      }

      setState(() {});
    } else {
      print('No image selected.');
    }
    setState(() {});
    return;
  }

  //==================================================================================================
  late TabController tabController;
  late ScrollController scrollController;
  bool showTitle = false;
  late double distanceToField;
  late List<String> tagsList = [];

  List<String> selectedInterests = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    distanceToField = MediaQuery.of(context).size.width;
  }
  //  this is the function that will be called when the user presses the edit icon

  void _onEditIconPressed(String title) {
    Map<String, Widget> dialogboxWidgets = {
      'name': TextFormField(
        controller: widget.editingController,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Webinar Title',
        ),
        validator: (val) {
          if (val!.isEmpty) {
            return 'please enter webinar title';
          } else if (!RegExp(r"^[A-Za-z]").hasMatch(val)) {
            return 'enter valid title';
          } else if (val.length > 200) {
            return 'title cannot be greater than 200 characters';
          } else if (val.length < 5) {
            return 'please enter at least 5 characters';
          }
          return null;
        },
      ),
      'date': DateTimePicker(
        // initialValue: DateTime.now().toString(),
        decoration: const InputDecoration(
            border: UnderlineInputBorder(),
            suffixIcon: Icon(Icons.calendar_month_outlined),
            hintText: "Select date"),
        firstDate: DateTime.now(),
        initialDate: DateTime.now(),
        lastDate: DateTime(2030),
        dateLabelText: 'Select date',
        controller: widget.editingController,
        // initialValue: "qqq",
        // onChanged: (val) => print(dateController.text = val),
        validator: (val) {
          // print("val$val");
          if (val == '') {
            return 'Please select date';
          }
          return null;
        },
        onSaved: (val) => print(val),
      ),
      'time': TextFormField(
        controller: widget.editingController,
        //editing controller of this TextField
        decoration: const InputDecoration(
            border: OutlineInputBorder(),
            suffixIcon: Icon(Icons.access_time),
            // icon: Icon(Icons.timer), //icon of text field
            labelText: "Select Time" //label text of field
            ),
        readOnly: true, //set it true, so that user will not able to edit text
        onTap: () async {
          TimeOfDay? pickedTime = await showTimePicker(
            initialTime: TimeOfDay.now(),
            context: context,
          );
          if (pickedTime != null) {
            print(pickedTime.format(context)); //output 10:51 PM
            DateTime parsedTime =
                DateFormat.jm().parse(pickedTime.format(context).toString());
            //converting to DateTime so that we can further format on different pattern.
            print(parsedTime); //output 1970-01-01 22:53:00.000
            String formattedTime = DateFormat('HH:mm:ss').format(parsedTime);
            print(formattedTime); //output 14:59:00
            //DateFormat() is from intl package, you can format the time on any pattern you need.

            setState(() {
              widget.editingController.text = formattedTime;
              // timeinput.text =
              //     formattedTime; //set the value of text field.
            });
          } else {
            print("Time is not selected");
          }
        },
        validator: (value) => value!.isEmpty
            ? 'Please enter time'
            : null, //if empty return error text
      ),
      'tagline': TextFormField(
        controller: widget.editingController,
        decoration: const InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          hintText: 'enter tagline.....',
        ),
        validator: (val) {
          // print("val$val");
          if (val == '') {
            return 'please enter tag line';
          } else if (val!.length < 10) {
            return 'add tagline of atleast 10 characters';
          }
          return null;
        },
      ),
      'price': TextFormField(
        keyboardType: TextInputType.number,
        controller: widget.editingController,
        decoration: const InputDecoration(
          suffixIcon: Icon(
            Icons.monetization_on,
            color: Colors.grey,
          ),
          border: UnderlineInputBorder(),
          hintText: 'Add price',
        ),
        validator: (val) {
          if (val!.isEmpty) {
            return 'please enter price';
          } else if (!RegExp(r"^[0-9]+$").hasMatch(val)) {
            return 'enter valid price in numbers';
          }
          return null;
        },
      ),
      'duration': TextFormField(
        keyboardType: TextInputType.number,
        controller: widget.editingController,
        decoration: const InputDecoration(
          suffixIcon: Icon(
            Icons.timer,
            color: Colors.grey,
          ),
          border: UnderlineInputBorder(),
          hintText: 'Add duration',
        ),
        validator: (val) {
          if (val!.isEmpty) {
            return 'please enter duration';
          } else if (!RegExp(r"^[0-9]+$").hasMatch(val)) {
            return 'enter valid duration in numbers';
          }
          return null;
        },
      ),
      'description': TextFormField(
        maxLines: 10,
        controller: widget.editingController,
        decoration: const InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          hintText: 'Webinar desceiption.....',
        ),
        validator: (val) {
          // print("val$val");
          if (val == '') {
            return 'please enter description';
          } else if (val!.length < 50) {
            return 'add description of atleast 50 characters';
          }
          return null;
        },
      ),
      'tags': Column(
        children: [
          TextFieldTags(
            textfieldTagsController: widget._controller,
            initialTags: tagsList,
            textSeparators: const [' ', ','],
            letterCase: LetterCase.normal,
            validator: (String tag) {
              if (tag == 'php') {
                return 'No, please just no';
              } else if (widget._controller.getTags!.contains(tag)) {
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
                      hintText:
                          widget._controller.hasTags ? '' : "Enter tag...",
                      errorText: error,
                      prefixIconConstraints:
                          BoxConstraints(maxWidth: distanceToField * 0.5),
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
                                          tagsList.remove(tag);
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
              widget._controller.clearTags();
              tagsList.clear();
            },
            child: const Text('CLEAR TAGS'),
          ),
        ],
      ),
    };

    // title = 'price';
    if (title == 'date') {
      // widget.editingController.text = DateFormat('yyyy-MM-dd')
      // .format(DateTime.parse(widget.webinarDetails['datetime']));
    } else if (title == 'time') {
      widget.editingController.text = DateFormat('HH:mm:ss')
          .format(DateTime.parse(widget.webinarDetails['datetime']));
    } else {
      widget.editingController.text = widget.webinarDetails[title].toString();
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: SizedBox(
            height: title == 'tagline' ||
                    title == 'name' ||
                    title == 'price' ||
                    title == 'duration' ||
                    title == 'date' ||
                    title == 'time'
                ? AppLayout.getHeight(250)
                : AppLayout.getHeight(450),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: widget.formKey2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0),

                    dialogboxWidgets[title]!,
                    
                    const SizedBox(height: 20.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          child: const Text(
                            "Cancel",
                            style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.red,
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        // this is where update  is handled
                        const SizedBox(width: 20.0),
                        TextButton(
                          child: const Text(
                            "Update",
                            style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.blue,
                            ),
                          ),
                          onPressed: () {
                            // Do something with the edited text
                            if (widget.formKey2.currentState!.validate()) {
                              if (title == 'name') {
                                widget.webinarDetails['name'] =
                                    widget.editingController.text;

                                widget.webinarcontroller.editWebinarName(
                                    widget.webinarDetails['_id'],
                                    widget.editingController.text);
                              } else if (title == 'tagline') {
                                widget.webinarcontroller.editWebinarTagline(
                                    widget.webinarDetails['_id'],
                                    widget.editingController.text);
                                widget.webinarDetails['tagline'] =
                                    widget.editingController.text;
                              } else if (title == 'description') {
                                widget.webinarDetails['description'] =
                                    widget.editingController.text;
                                widget.webinarcontroller.editWebinarDescription(
                                    widget.webinarDetails['_id'],
                                    widget.editingController.text);
                              } else if (title == 'tags') {
                                widget._controller.clearTags();
                                widget.webinarDetails['tags'] = tagsList;
                                print(tagsList);

                                widget.webinarcontroller.editWebinarTags(
                                    widget.webinarDetails['_id'], tagsList);
                              } else if (title == 'duration') {
                                widget.webinarDetails['duration'] =
                                    widget.editingController.text;
                                widget.webinarcontroller.editWebinarDuration(
                                    widget.webinarDetails['_id'],
                                    widget.editingController.text);
                              } else if (title == 'date') {
                                String newdatetime =
                                    "${widget.editingController.text} ${widget.webinarDetails['datetime'].toString().split('T')[1]}";
                                widget.webinarDetails['datetime'] = newdatetime;
                                widget.webinarcontroller.editWebinarDateTime(
                                    widget.webinarDetails['_id'], newdatetime);
                                setState(() {});
                              } else if (title == 'time') {
                                String newdatetime =
                                    "${widget.webinarDetails['datetime'].toString().split(' ')[0]} ${widget.editingController.text}";
                                widget.webinarDetails['datetime'] = newdatetime;
                                widget.webinarcontroller.editWebinarDateTime(
                                    widget.webinarDetails['_id'], newdatetime);
                                setState(() {});
                              }

                              Navigator.of(context).pop();
                              print(widget.editingController.text);
                              print('--- Valid ---');
                              widget.editingController.clear();
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    scrollController = ScrollController();
    scrollController.addListener(_scrollListener);
    tabController = TabController(length: 4, vsync: this);

    super.initState();
  }

  void _scrollListener() {
    if (scrollController.offset >= 200 && !showTitle) {
      setState(() {
        showTitle = true;
      });
    } else if (scrollController.offset < 200 && showTitle) {
      setState(() {
        showTitle = false;
      });
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    widget._controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('webinarDetails: ${widget.webinarDetails}');
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print('hrreer');
          print(widget.webinarDetails['datetime']);
          Get.isDarkMode
              ? Get.changeThemeMode(ThemeMode.light)
              : Get.changeThemeMode(ThemeMode.dark);
        },
        child: const Icon(Icons.play_arrow),
      ),
      body: NestedScrollView(
        controller: scrollController,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              leading: IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
              ),
              iconTheme: IconThemeData(
                size: AppLayout.getHeight(30),
                color: Get.isDarkMode
                    ? Colors.white.withOpacity(0.98)
                    : const Color(0xff181b1f),
              ),
              collapsedHeight: AppLayout.getHeight(80),
              backgroundColor: Get.isDarkMode
                  ? const Color(0xff191919)
                  : const Color(0xffF7F8F8),
              expandedHeight: AppLayout.getHeight(360),
              flexibleSpace: FlexibleSpaceBar(
                title: showTitle
                    ? Padding(
                        padding:
                            EdgeInsets.only(bottom: AppLayout.getHeight(40)),
                        child: Text(
                          '${widget.webinarDetails['name']}',
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: AppLayout.getHeight(20),
                            fontFamily: 'JosefinSans Regular',
                            fontWeight: FontWeight.w500,
                            color: Get.isDarkMode
                                ? Colors.white.withOpacity(0.98)
                                : const Color(0xff181b1f),
                          ),
                        ),
                      )
                    : null,
                background: Stack(
                  children: [
                    // The back ground image goes here
                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        height: AppLayout.getHeight(200),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(
                              AppConstants.baseURL +
                                  widget.webinarDetails['bannerImage'],
                            ),
                            fit: BoxFit.cover,
                          ),
                          color: Theme.of(context).scaffoldBackgroundColor,
                          boxShadow: [
                            BoxShadow(
                              offset: const Offset(0, 5),
                              blurRadius: 7,
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondary
                                  .withOpacity(0.1),
                            ),
                            BoxShadow(
                              offset: const Offset(0, -5),
                              blurRadius: 7,
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondary
                                  .withOpacity(0.1),
                            )
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                                padding: const EdgeInsets.only(bottom: 6),
                                onPressed: () {
                                  _pickBase64Image('bannerImage');
                                  widget.webinarDetails['bannerImage'];
                                  print(_imagefile);

                                  // setState(() {});
                                  // _onEditIconPressed('name');
                                  print('button was pressed');
                                },
                                icon: Icon(
                                    color: Get.isDarkMode
                                        ? const Color.fromRGBO(122, 121, 121, 1)
                                        : const Color.fromRGBO(
                                            176, 179, 190, 1),
                                    size: AppLayout.getHeight(80),
                                    Icons.camera_alt)),
                            const Gap(30),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: AppLayout.getHeight(50.0),
                      left: AppLayout.getWidth(115.0),
                      child: Container(
                        width: AppLayout.getWidth(180),
                        height: AppLayout.getHeight(220),
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(AppLayout.getHeight(10)),
                          boxShadow: [
                            BoxShadow(
                              offset: const Offset(3, 3),
                              blurRadius: 4,
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondary
                                  .withOpacity(0.1),
                            ),
                            BoxShadow(
                              offset: const Offset(-3, -3),
                              blurRadius: 4,
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondary
                                  .withOpacity(0.1),
                            )
                          ],
                          image: DecorationImage(
                            image: NetworkImage(
                              AppConstants.baseURL +
                                  widget.webinarDetails['coverImage'],
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: IconButton(
                            padding: const EdgeInsets.only(bottom: 6),
                            onPressed: () {
                              _pickBase64Image('coverImage');
                              widget.webinarDetails['coverImage'];
                              print(_imagefile);

                              // setState(() {});
                              // _onEditIconPressed('name');
                              print('button was pressed');
                            },
                            icon: Icon(
                                color: Get.isDarkMode
                                    ? const Color.fromRGBO(122, 121, 121, 1)
                                    : const Color.fromRGBO(176, 179, 190, 1),
                                size: AppLayout.getHeight(80),
                                Icons.camera_alt)),
                      ),
                    ),
                    Positioned(
                      bottom: AppLayout.getHeight(50),
                      child: SizedBox(
                        width: AppLayout.getScreenWidth(),
                        // color: Colors.yellow,
                        child: Center(
                          child: Text(
                            '${widget.webinarDetails['attendees'].length} people attending',
                            style: TextStyle(
                              fontSize: AppLayout.getHeight(16),
                              fontFamily: 'JosefinSans Bold',
                              fontWeight: FontWeight.w500,
                              color: Get.isDarkMode
                                  ? const Color.fromRGBO(74, 229, 239, 1)
                                  : const Color.fromRGBO(248, 79, 57, 1),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              pinned: true,
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(10.0),
                child: TabBar(
                  controller: tabController,
                  indicatorWeight: 2.0,
                  indicatorColor: AppColors.LTprimaryColor,
                  unselectedLabelStyle: TextStyle(
                    fontSize: AppLayout.getHeight(10),
                    fontFamily: 'JosefinSans Bold',
                    fontWeight: FontWeight.w300,
                    color: Get.isDarkMode
                        ? Colors.white.withOpacity(0.8)
                        : Colors.black.withOpacity(0.9),
                  ),
                  tabs: [
                    Tab(
                      child: Text(
                        "About",
                        style: TextStyle(
                          letterSpacing: 1,
                          height: 1.5,
                          fontSize: AppLayout.getHeight(12),
                          fontFamily: 'JosefinSans Bold',
                          fontWeight: FontWeight.w600,
                          color: Get.isDarkMode
                              ? Colors.white.withOpacity(0.8)
                              : Colors.black.withOpacity(0.9),
                        ),
                      ),
                    ),
                    Tab(
                      child: FittedBox(
                        child: Text(
                          "Organizers",
                          style: TextStyle(
                            height: 1.5,
                            letterSpacing: 1,
                            fontSize: AppLayout.getHeight(12),
                            fontFamily: 'JosefinSans Bold',
                            fontWeight: FontWeight.w600,
                            color: Get.isDarkMode
                                ? Colors.white.withOpacity(0.8)
                                : Colors.black.withOpacity(0.9),
                          ),
                        ),
                      ),
                    ),
                    Tab(
                      child: Text(
                        "Guests",
                        style: TextStyle(
                          height: 1.5,
                          letterSpacing: 1,
                          fontSize: AppLayout.getHeight(12),
                          fontFamily: 'JosefinSans Bold',
                          fontWeight: FontWeight.w600,
                          color: Get.isDarkMode
                              ? Colors.white.withOpacity(0.8)
                              : Colors.black.withOpacity(0.9),
                        ),
                      ),
                    ),
                    Tab(
                      child: Text(
                        "Reviews",
                        style: TextStyle(
                          height: 1.5,
                          letterSpacing: 1,
                          fontSize: AppLayout.getHeight(12),
                          fontFamily: 'JosefinSans Bold',
                          fontWeight: FontWeight.w600,
                          color: Get.isDarkMode
                              ? Colors.white.withOpacity(0.8)
                              : Colors.black.withOpacity(0.9),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: tabController,
          children: [
            // The content for the first tab goes here
            ListView(
              padding: EdgeInsets.symmetric(horizontal: AppLayout.getWidth(20)),
              physics: const NeverScrollableScrollPhysics(),
              children: [
                Gap(
                  AppLayout.getHeight(20),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Name',
                      style: TextStyle(
                        letterSpacing: 1,
                        fontSize: AppLayout.getHeight(20),
                        color: Get.isDarkMode
                            ? const Color.fromARGB(255, 202, 198, 198)
                            : const Color.fromRGBO(176, 179, 190, 1),
                        fontWeight: FontWeight.w700,
                        fontFamily: 'JosefinSans Bold',
                      ),
                    ),
                    Gap(
                      AppLayout.getWidth(10),
                    ),
                    IconButton(
                        padding: const EdgeInsets.only(bottom: 6),
                        onPressed: () {
                          _onEditIconPressed('name');
                        },
                        icon: Icon(
                            color: Get.isDarkMode
                                ? const Color.fromRGBO(122, 121, 121, 1)
                                : const Color.fromRGBO(176, 179, 190, 1),
                            Icons.edit)),
                  ],
                ),
                Gap(
                  AppLayout.getHeight(20),
                ),

                AutoSizeText(
                  '${widget.webinarDetails['name']}',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: AppLayout.getHeight(40),
                    fontFamily: 'JosefinSans Bold',
                    fontWeight: FontWeight.w700,
                    color: Get.isDarkMode
                        ? Colors.white.withOpacity(0.98)
                        : const Color(0xff181b1f),
                    overflow: TextOverflow.visible,
                  ),
                ),
                Gap(
                  AppLayout.getHeight(20),
                ),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Tagline',
                      style: TextStyle(
                        letterSpacing: 1,
                        fontSize: AppLayout.getHeight(20),
                        color: Get.isDarkMode
                            ? const Color.fromARGB(255, 202, 198, 198)
                            : const Color.fromRGBO(176, 179, 190, 1),
                        fontWeight: FontWeight.w700,
                        fontFamily: 'JosefinSans Bold',
                      ),
                    ),
                    Gap(
                      AppLayout.getWidth(10),
                    ),
                    IconButton(
                        padding: const EdgeInsets.only(bottom: 6),
                        onPressed: () {
                          _onEditIconPressed('tagline');
                        },
                        icon: Icon(
                            color: Get.isDarkMode
                                ? const Color.fromRGBO(122, 121, 121, 1)
                                : const Color.fromRGBO(176, 179, 190, 1),
                            Icons.edit)),
                  ],
                ),
                Text(
                  widget.webinarDetails['tagline'],
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      height: 1.5,
                      color: Get.isDarkMode
                          ? const Color(0xffA1a1aa)
                          : const Color(0xff475569),
                      fontSize: AppLayout.getHeight(20),
                      fontFamily: 'JosefinSans Regular'),
                ),
                Gap(
                  AppLayout.getHeight(20),
                ),

                // =============================this is the date and time section==========================
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Date',
                              style: TextStyle(
                                letterSpacing: 1,
                                fontSize: AppLayout.getHeight(20),
                                color: Get.isDarkMode
                                    ? const Color.fromARGB(255, 202, 198, 198)
                                    : const Color.fromRGBO(176, 179, 190, 1),
                                fontWeight: FontWeight.w700,
                                fontFamily: 'JosefinSans Bold',
                              ),
                            ),
                            Gap(
                              AppLayout.getWidth(10),
                            ),
                            IconButton(
                                padding: const EdgeInsets.only(bottom: 6),
                                onPressed: () {
                                  _onEditIconPressed('date');
                                },
                                icon: Icon(
                                    color: Get.isDarkMode
                                        ? const Color.fromRGBO(122, 121, 121, 1)
                                        : const Color.fromRGBO(
                                            176, 179, 190, 1),
                                    Icons.edit)),
                          ],
                        ),
                        Text(
                          widget.webinarDetails['datetime']
                              .toString()
                              .split('T')[0],
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              height: 1.5,
                              color: Get.isDarkMode
                                  ? const Color(0xffA1a1aa)
                                  : const Color(0xff475569),
                              fontSize: AppLayout.getHeight(20),
                              fontFamily: 'JosefinSans Bold'),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Time',
                              style: TextStyle(
                                letterSpacing: 1,
                                fontSize: AppLayout.getHeight(20),
                                color: Get.isDarkMode
                                    ? const Color.fromARGB(255, 202, 198, 198)
                                    : const Color.fromRGBO(176, 179, 190, 1),
                                fontWeight: FontWeight.w700,
                                fontFamily: 'JosefinSans Bold',
                              ),
                            ),
                            Gap(
                              AppLayout.getWidth(10),
                            ),
                            IconButton(
                                padding: const EdgeInsets.only(bottom: 6),
                                onPressed: () {
                                  _onEditIconPressed('time');
                                },
                                icon: Icon(
                                    color: Get.isDarkMode
                                        ? const Color.fromRGBO(122, 121, 121, 1)
                                        : const Color.fromRGBO(
                                            176, 179, 190, 1),
                                    Icons.edit)),
                          ],
                        ),
                        Text(
                          widget.webinarDetails['datetime']
                              .toString()
                              .split('T')[1],
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              height: 1.5,
                              color: Get.isDarkMode
                                  ? const Color(0xffA1a1aa)
                                  : const Color(0xff475569),
                              fontSize: AppLayout.getHeight(20),
                              fontFamily: 'JosefinSans Bold'),
                        ),
                      ],
                    ),
                  ],
                ),
                Gap(
                  AppLayout.getHeight(20),
                ),
                const Divider(color: Colors.grey),
                Gap(
                  AppLayout.getHeight(20),
                ),
                //======================= this is the duration and price section==========================

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Duration',
                              style: TextStyle(
                                letterSpacing: 1,
                                fontSize: AppLayout.getHeight(20),
                                color: Get.isDarkMode
                                    ? const Color.fromARGB(255, 202, 198, 198)
                                    : const Color.fromRGBO(176, 179, 190, 1),
                                fontWeight: FontWeight.w700,
                                fontFamily: 'JosefinSans Bold',
                              ),
                            ),
                            Gap(
                              AppLayout.getWidth(10),
                            ),
                            IconButton(
                                padding: const EdgeInsets.only(bottom: 6),
                                onPressed: () {
                                  _onEditIconPressed('duration');
                                },
                                icon: Icon(
                                    color: Get.isDarkMode
                                        ? const Color.fromRGBO(122, 121, 121, 1)
                                        : const Color.fromRGBO(
                                            176, 179, 190, 1),
                                    Icons.edit)),
                          ],
                        ),
                        SizedBox(
                          width: AppLayout.getWidth(100),
                          child: AutoSizeText(
                            widget.webinarDetails['duration'] + " Mins",
                            textAlign: TextAlign.start,
                            maxLines: 1,
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                height: 1.5,
                                color: Get.isDarkMode
                                    ? const Color(0xffA1a1aa)
                                    : const Color(0xff475569),
                                fontSize: AppLayout.getHeight(20),
                                fontFamily: 'JosefinSans Bold'),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Price',
                              style: TextStyle(
                                letterSpacing: 1,
                                fontSize: AppLayout.getHeight(20),
                                color: Get.isDarkMode
                                    ? const Color.fromARGB(255, 202, 198, 198)
                                    : const Color.fromRGBO(176, 179, 190, 1),
                                fontWeight: FontWeight.w700,
                                fontFamily: 'JosefinSans Bold',
                              ),
                            ),
                            Gap(
                              AppLayout.getWidth(10),
                            ),
                            IconButton(
                                padding: const EdgeInsets.only(bottom: 6),
                                onPressed: () {
                                  _onEditIconPressed('price');
                                },
                                icon: Icon(
                                    color: Get.isDarkMode
                                        ? const Color.fromRGBO(122, 121, 121, 1)
                                        : const Color.fromRGBO(
                                            176, 179, 190, 1),
                                    Icons.edit)),
                          ],
                        ),
                        SizedBox(
                          width: AppLayout.getWidth(100),
                          child: AutoSizeText(
                            "\$ ${widget.webinarDetails['price']}",
                            maxLines: 1,
                            textAlign: TextAlign.end,
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                height: 1.5,
                                color: Get.isDarkMode
                                    ? const Color(0xffA1a1aa)
                                    : const Color(0xff475569),
                                fontSize: AppLayout.getHeight(20),
                                fontFamily: 'JosefinSans Bold'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Gap(
                  AppLayout.getHeight(30),
                ),
                // Gap(AppLayout.getHeight(20)),
                // Text(
                //   'Created By',
                //   style: TextStyle(
                //     letterSpacing: 1,
                //     fontSize: AppLayout.getHeight(14),
                //     color: Get.isDarkMode
                //         ? const Color.fromRGBO(122, 121, 121, 1)
                //         : const Color.fromRGBO(176, 179, 190, 1),
                //     fontWeight: FontWeight.w700,
                //     fontFamily: 'JosefinSans Bold',
                //   ),
                // ),
                // Gap(AppLayout.getHeight(10)),
                // Container(
                //   decoration: BoxDecoration(
                //     borderRadius:
                //         BorderRadius.circular(AppLayout.getHeight(10)),
                //     border: Border.all(
                //       color: Get.isDarkMode
                //           ? Colors.white.withOpacity(0.1)
                //           : Colors.black.withOpacity(0.1),
                //     ),
                //     color: Get.isDarkMode ? Colors.black54 : Colors.white,
                //     boxShadow: [
                //       BoxShadow(
                //         color: Colors.grey.withOpacity(0.1),
                //         offset: const Offset(2, 2),
                //         blurRadius: 6,
                //         spreadRadius: 0,
                //       ),
                //       BoxShadow(
                //         color: Colors.grey.withOpacity(0.01),
                //         offset: const Offset(-2, -2),
                //         blurRadius: 7,
                //       ),
                //     ],
                //   ),
                //   child: ListTile(
                //     leading: CircleAvatar(
                //       radius: AppLayout.getHeight(30),
                //       backgroundImage: NetworkImage(AppConstants.baseURL +
                //           widget.webinarDetails['createdBy']['profile_image']),
                //     ),
                //     title: Text(
                //       widget.webinarDetails['createdBy']['name'],
                //       style: TextStyle(
                //         fontSize: AppLayout.getHeight(16),
                //         color: Get.isDarkMode
                //             ? Colors.white.withOpacity(0.9)
                //             : Colors.black.withOpacity(0.9),
                //         fontWeight: FontWeight.w500,
                //         letterSpacing: 1,
                //         fontFamily: 'JosefinSans',
                //       ),
                //     ),
                //     subtitle: Text(
                //       widget.webinarDetails['createdBy']['email'],
                //       style: TextStyle(
                //         letterSpacing: 1,
                //         fontSize: AppLayout.getHeight(14),
                //         fontWeight: FontWeight.w500,
                //         fontFamily: 'JosefinSans',
                //       ),
                //     ),
                //   ),
                // ),
                // Gap(AppLayout.getHeight(28)),

                Row(
                  children: [
                    Text(
                      'Catergories',
                      style: TextStyle(
                        letterSpacing: 1,
                        fontSize: AppLayout.getHeight(20),
                        color: Get.isDarkMode
                            ? const Color.fromARGB(255, 202, 198, 198)
                            : const Color.fromRGBO(176, 179, 190, 1),
                        fontWeight: FontWeight.w700,
                        fontFamily: 'JosefinSans Bold',
                      ),
                    ),
                    Gap(
                      AppLayout.getWidth(10),
                    ),
                    IconButton(
                        padding:
                            EdgeInsets.only(bottom: AppLayout.getHeight(6)),
                        onPressed: () {
                          print('object');
                          Get.to(() => EditCategories(
                                webinarId: widget.webinarDetails['_id'],
                                webinarCategories:
                                    widget.webinarDetails['categories'],
                              ));
                        },
                        icon: Icon(
                            color: Get.isDarkMode
                                ? const Color.fromRGBO(122, 121, 121, 1)
                                : const Color.fromRGBO(176, 179, 190, 1),
                            Icons.edit)),
                  ],
                ),
                Gap(AppLayout.getHeight(10)),
                // this is where the categories are handled and displayed
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: GetBuilder<WebinarManagementController>(
                      builder: (controller) {
                        return Wrap(
                            children: List.generate(
                                WebinarManagementController
                                    .currentWebinar['categories']
                                    .length, (index) {
                          return Container(
                            width: AppLayout.getWidth(120),
                            height: AppLayout.getHeight(60),
                            margin:
                                const EdgeInsets.only(right: 30, bottom: 30),
                            padding: EdgeInsets.symmetric(
                                horizontal: AppLayout.getWidth(10),
                                vertical: AppLayout.getHeight(5)),
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  offset: const Offset(0, 2),
                                  blurRadius: 4,
                                  spreadRadius: 0,
                                ),
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  offset: const Offset(0, -2),
                                  blurRadius: 4,
                                ),
                              ],
                              color: Get.isDarkMode
                                  ? const Color.fromRGBO(38, 38, 38, 1)
                                  : const Color.fromRGBO(243, 243, 244, 1),
                              border: Border.all(
                                color: Get.isDarkMode
                                    ? Colors.white.withOpacity(0.1)
                                    : Colors.black.withOpacity(0.1),
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: AutoSizeText(
                                WebinarManagementController
                                        .currentWebinar['categories'][index]
                                    ['name'],
                                style: TextStyle(
                                    fontFamily: 'JosefinSans Bold',
                                    fontWeight: FontWeight.w500,
                                    color: Get.isDarkMode
                                        ? const Color.fromRGBO(212, 212, 216, 1)
                                        : const Color(0xff475569),
                                    fontSize: AppLayout.getHeight(17)),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          );
                        }));
                      },
                    ),
                  ),
                ),
                Gap(AppLayout.getHeight(28)),
                Row(
                  children: [
                    Text(
                      'Description',
                      style: TextStyle(
                        letterSpacing: 1,
                        fontSize: AppLayout.getHeight(20),
                        color: Get.isDarkMode
                            ? const Color.fromARGB(255, 202, 198, 198)
                            : const Color.fromRGBO(176, 179, 190, 1),
                        fontWeight: FontWeight.w700,
                        fontFamily: 'JosefinSans Bold',
                      ),
                    ),
                    Gap(
                      AppLayout.getWidth(10),
                    ),
                    IconButton(
                        padding:
                            EdgeInsets.only(bottom: AppLayout.getHeight(6)),
                        onPressed: () {
                          _onEditIconPressed('description');
                        },
                        icon: Icon(
                            color: Get.isDarkMode
                                ? const Color.fromRGBO(122, 121, 121, 1)
                                : const Color.fromRGBO(176, 179, 190, 1),
                            Icons.edit)),
                  ],
                ),

                Gap(AppLayout.getHeight(16)),

                // Text(widget.webinarDetails['description']),
                // ExpandableText(text: widget.webinarDetails['description']),
                ExpandableText(
                  widget.webinarDetails['description'],
                  expandText: 'Show more',
                  collapseText: 'Show less',
                  maxLines: 5,
                  linkColor: Colors.blue,
                  style: TextStyle(
                      height: 1.5,
                      fontFamily: 'JosefinSans Regular',
                      fontWeight: FontWeight.w500,
                      color: Get.isDarkMode
                          ? const Color(0xffa1a1aa)
                          : const Color(0xff475569),
                      fontSize: AppLayout.getHeight(17)),
                ),
                Gap(AppLayout.getHeight(28)),
                Row(
                  children: [
                    Text(
                      'Tags',
                      style: TextStyle(
                        letterSpacing: 1,
                        fontSize: AppLayout.getHeight(20),
                        color: Get.isDarkMode
                            ? const Color.fromARGB(255, 202, 198, 198)
                            : const Color.fromRGBO(176, 179, 190, 1),
                        fontWeight: FontWeight.w700,
                        fontFamily: 'JosefinSans Bold',
                      ),
                    ),
                    Gap(
                      AppLayout.getWidth(10),
                    ),
                    IconButton(
                        padding:
                            EdgeInsets.only(bottom: AppLayout.getHeight(6)),
                        onPressed: () {
                          print('object');
                          _onEditIconPressed('tags');
                          widget.webinarDetails['tags'] = tagsList;
                          // te(() {});setSta

                          // Get.to(() => const MyHomePage11());
                        },
                        icon: Icon(
                            color: Get.isDarkMode
                                ? const Color.fromRGBO(122, 121, 121, 1)
                                : const Color.fromRGBO(176, 179, 190, 1),
                            Icons.edit)),
                  ],
                ),

                Gap(AppLayout.getHeight(28)),
                GetBuilder<WebinarManagementController>(builder: (c) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Wrap(
                          spacing: 10,
                          runSpacing: 15,
                          children: List.generate(
                              widget.webinarDetails['tags'].length, (index) {
                            return Container(
                              width: 90,
                              height: 50,
                              padding: EdgeInsets.symmetric(
                                  horizontal: AppLayout.getWidth(10),
                                  vertical: AppLayout.getHeight(5)),
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    offset: const Offset(0, 2),
                                    blurRadius: 4,
                                    spreadRadius: 0,
                                  ),
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    offset: const Offset(0, -2),
                                    blurRadius: 4,
                                  ),
                                ],
                                color: Get.isDarkMode
                                    ? const Color.fromRGBO(38, 38, 38, 1)
                                    : const Color.fromRGBO(243, 243, 244, 1),
                                border: Border.all(
                                  color: Get.isDarkMode
                                      ? Colors.white.withOpacity(0.1)
                                      : Colors.black.withOpacity(0.1),
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: AutoSizeText(
                                  widget.webinarDetails['tags'][index],
                                  maxLines: 1,
                                  style: TextStyle(
                                      fontFamily: 'JosefinSans Bold',
                                      fontWeight: FontWeight.w500,
                                      color: Get.isDarkMode
                                          ? const Color.fromRGBO(
                                              212, 212, 216, 1)
                                          : const Color(0xff475569),
                                      fontSize: AppLayout.getHeight(17)),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            );
                          })),
                    ),
                  );
                }),
              ],
            ),
            // The content for the second tab goes here==========================================
            ListView(
              padding: EdgeInsets.symmetric(horizontal: AppLayout.getWidth(20)),
              physics: const NeverScrollableScrollPhysics(),
              children: List.generate(
                widget.webinarDetails['organizers'].length,
                (index) => Container(
                  margin:
                      EdgeInsets.symmetric(vertical: AppLayout.getHeight(20)),
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(AppLayout.getHeight(10)),
                    border: Border.all(
                      color: Get.isDarkMode
                          ? Colors.white.withOpacity(0.1)
                          : Colors.black.withOpacity(0.1),
                    ),
                    color: Get.isDarkMode ? Colors.black54 : Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        offset: const Offset(2, 2),
                        blurRadius: 6,
                        spreadRadius: 0,
                      ),
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.01),
                        offset: const Offset(-2, -2),
                        blurRadius: 7,
                      ),
                    ],
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: AppLayout.getHeight(30),
                      backgroundImage: NetworkImage(AppConstants.baseURL +
                          widget.webinarDetails['organizers'][index]
                              ['profile_image']),
                    ),
                    title: Text(
                      widget.webinarDetails['organizers'][index]['name'],
                      style: TextStyle(
                        fontSize: AppLayout.getHeight(16),
                        color: Get.isDarkMode
                            ? Colors.white.withOpacity(0.9)
                            : Colors.black.withOpacity(0.9),
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1,
                        fontFamily: 'JosefinSans Regular',
                      ),
                    ),
                    subtitle: Text(
                      widget.webinarDetails['organizers'][index]['email'],
                      style: TextStyle(
                        letterSpacing: 1,
                        fontSize: AppLayout.getHeight(14),
                        fontWeight: FontWeight.w500,
                        fontFamily: 'JosefinSans Regular',
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // The content for the third tab goes here================================
            ListView(
              padding: EdgeInsets.symmetric(horizontal: AppLayout.getWidth(20)),
              physics: const NeverScrollableScrollPhysics(),
              children: List.generate(
                widget.webinarDetails['guests'].length,
                (index) => Container(
                  margin:
                      EdgeInsets.symmetric(vertical: AppLayout.getHeight(20)),
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(AppLayout.getHeight(10)),
                    border: Border.all(
                      color: Get.isDarkMode
                          ? Colors.white.withOpacity(0.1)
                          : Colors.black.withOpacity(0.1),
                    ),
                    color: Get.isDarkMode ? Colors.black54 : Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        offset: const Offset(2, 2),
                        blurRadius: 6,
                        spreadRadius: 0,
                      ),
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.01),
                        offset: const Offset(-2, -2),
                        blurRadius: 7,
                      ),
                    ],
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: AppLayout.getHeight(30),
                      backgroundImage: NetworkImage(AppConstants.baseURL +
                          widget.webinarDetails['guests'][index]
                              ['profile_image']),
                    ),
                    title: Text(
                      widget.webinarDetails['guests'][index]['name'],
                      style: TextStyle(
                        fontSize: AppLayout.getHeight(16),
                        color: Get.isDarkMode
                            ? Colors.white.withOpacity(0.9)
                            : Colors.black.withOpacity(0.9),
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1,
                        fontFamily: 'JosefinSans Regular',
                      ),
                    ),
                    subtitle: Text(
                      widget.webinarDetails['guests'][index]['email'],
                      style: TextStyle(
                        letterSpacing: 1,
                        fontSize: AppLayout.getHeight(14),
                        fontWeight: FontWeight.w500,
                        fontFamily: 'JosefinSans Regular',
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // The content for the fourth tab goes here
            const Center(
              child: Text("Content for Tab 4"),
            ),
          ],
        ),
      ),
    );
  }
}
