import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:webinarprime/controllers/webinar_management_controller.dart';
import 'package:webinarprime/widgets/snackbar.dart';

class ReportScreen extends StatefulWidget {
  String reportType;
  String webianrId;
  String reportedUserId;
  ReportScreen({
    super.key,
    required this.reportType,
    this.reportedUserId = "",
    this.webianrId = "",
  });

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final _formKey = GlobalKey<FormState>();
  var reasonController = TextEditingController();
  var descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    print(widget.reportType);
    print(widget.reportedUserId);
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            'Report',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          centerTitle: true,
          elevation: 0,
        ),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(children: [
              TextFormField(
                controller: reasonController,
                decoration: const InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  labelText: 'Reason for reporting',
                  hintText: 'Reason',
                ),
                validator: (value) {
                  if (value!.trim().isEmpty) {
                    return 'Please enter Reason';
                  }
                  return null;
                },
              ),
              const Gap(10),
              TextFormField(
                maxLines: 5,
                maxLength: 500,
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  hintText: 'enter description...',
                ),
                validator: (value) {
                  if (value!.trim().isEmpty) {
                    return 'Please enter description';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.red,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      print('validated');
                      if (widget.reportType == 'webinar') {
                        print('webinar');
                      } else if (widget.reportType == 'user') {
                        print('user');
                      } else if (widget.reportType == 'chat') {
                        print('chat');
                      }
                      await Get.find<WebinarManagementController>()
                          .reportSomething(
                              description: descriptionController.text,
                              reason: reasonController.text,
                              type: widget.reportType,
                              reportedId: widget.reportedUserId,
                              webinarId: widget.webianrId);
                      ShowCustomSnackBar('Reported Successfully',
                          isError: false, title: 'Reported');
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Report',
                      style: TextStyle(
                        color: Colors.white,
                      )))
            ]),
          ),
        ));
  }
}
