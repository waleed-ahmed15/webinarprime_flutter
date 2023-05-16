import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:webinarprime/controllers/webinar_management_controller.dart';
import 'package:webinarprime/utils/dimension.dart';
import 'package:webinarprime/utils/styles.dart';

class ScheduleEventsScreen extends StatefulWidget {
  String webinarid;
  ScheduleEventsScreen({super.key, required this.webinarid});
  final formKey2 = GlobalKey<FormState>(); //key for form

  @override
  State<ScheduleEventsScreen> createState() => _ScheduleEventsScreenState();
}

class _ScheduleEventsScreenState extends State<ScheduleEventsScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController durationController = TextEditingController();

  void addScheduleEvent(
      {bool update = false,
      String title = "",
      String duration = "",
      String scheduleId = ''}) {
    titleController.text = title;
    durationController.text = duration;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppLayout.getWidth(10)),
          ),
          // title: const Text('add schedule event'),
          child: Container(
            padding: EdgeInsets.symmetric(
                horizontal: AppLayout.getWidth(20),
                vertical: AppLayout.getHeight(20)),
            height: AppLayout.getHeight(280),
            width: AppLayout.getWidth(1.sw),
            child: Form(
              key: widget.formKey2,
              child: Column(
                // mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      labelText: 'Title',
                      border: UnderlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter title';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    keyboardAppearance: Brightness.dark,
                    keyboardType: TextInputType.number,

                    controller: durationController,
                    // initialValue: duration,
                    decoration: const InputDecoration(
                      labelText: 'Duration',
                      border: UnderlineInputBorder(),
                    ),
                    validator: (value) {
                      //digits only
                      if (value == null ||
                          value.isEmpty ||
                          !value.isNumericOnly) {
                        return 'Please enter duration digits only';
                      }
                      return null;
                    },
                  ),
                  const Gap(20),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Get.isDarkMode
                              ? const Color.fromRGBO(0, 227, 223, 1)
                              : const Color(0xfff84f39)),
                      padding: MaterialStateProperty.all<EdgeInsets>(
                          EdgeInsets.symmetric(
                              horizontal: AppLayout.getWidth(20),
                              vertical: AppLayout.getHeight(10))),
                    ),
                    child: Text(
                      update ? 'Update Event' : ' Add Event',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(letterSpacing: 2, color: Colors.white),
                    ),
                    onPressed: () async {
                      String title = titleController.text;
                      String duration = durationController.text;
                      print(widget.webinarid);
                      if (widget.formKey2.currentState!.validate()) {
                        // WebinarManagementController.addScheduleEvent(
                        //     title, duration);
                        if (update) {
                          await Get.find<WebinarManagementController>()
                              .updatewebinarSchedule(
                                  scheduleId,
                                  titleController.text,
                                  durationController.text,
                                  widget.webinarid);
                          Navigator.of(context).pop(); // Close the dialog

                          return;
                        }
                        await Get.find<WebinarManagementController>()
                            .addwebinarSchedule(
                          widget.webinarid,
                          title,
                          duration,
                        );
                        Navigator.of(context).pop(); // Close the dialog
                      }

                      // Perform any desired actions with the title and duration values here.
                    },
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text(
            'Schedule Events',
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(letterSpacing: 2),
          ),
        ),
        body: GetBuilder<WebinarManagementController>(builder: (context) {
          return ListView.builder(
            padding: const EdgeInsets.only(left: 10, right: 10),
            physics: const BouncingScrollPhysics(),
            itemCount: WebinarManagementController.webinarSchedule.length,
            // itemCount: 4,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                margin: const EdgeInsets.only(bottom: 10, top: 10),
                decoration: listtileDecoration.copyWith(boxShadow: [
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
                ]),
                child: ListTile(
                  onTap: () {
                    //edit the schedule
                    addScheduleEvent(
                      update: true,
                      title: WebinarManagementController.webinarSchedule[index]
                          ['title'],
                      duration: WebinarManagementController
                          .webinarSchedule[index]['duration'],
                      scheduleId: WebinarManagementController
                          .webinarSchedule[index]['_id'],
                    );
                  },
                  title: Text(
                    WebinarManagementController.webinarSchedule[index]['title'],
                    style: TextStyle(
                        height: 1.5,
                        fontFamily: 'JosefinSans Regular',
                        fontWeight: FontWeight.w500,
                        color: Get.isDarkMode
                            ? const Color(0xffa1a1aa)
                            : const Color(0xff475569),
                        fontSize: AppLayout.getHeight(17)),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                        WebinarManagementController.webinarSchedule[index]
                                ['duration'] +
                            ' mins',
                        style: const TextStyle(
                            fontSize: 14,
                            color: Colors.blue,
                            fontFamily: 'JosefinSans Regular')),
                  ),
                  //delete icon
                  //edit icon button for editing the schedule

                  trailing: IconButton(
                    onPressed: () {
                      Get.find<WebinarManagementController>()
                          .removeWebinarSchedlue(WebinarManagementController
                              .webinarSchedule[index]['_id']);
                    },
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                  ),
                ),
              );
            },
          );
        }),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            addScheduleEvent();
          },
          child: const Icon(Icons.add),
        ));
  }
}
