import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:webinarprime/utils/colors.dart';
import 'package:webinarprime/utils/dimension.dart';
import 'package:webinarprime/utils/styles.dart';

class BannerTemplate1 extends StatefulWidget {
  const BannerTemplate1({super.key});

  @override
  State<BannerTemplate1> createState() => _BannerTemplate1State();
}

class _BannerTemplate1State extends State<BannerTemplate1> {
  final formKey = GlobalKey<FormState>(); //key for form

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Container(
          height: AppLayout.getHeight(220),
          decoration: BoxDecoration(
            color: Colors.grey[600],
            borderRadius: BorderRadius.circular(AppLayout.getHeight(10)),
            boxShadow: [
              BoxShadow(
                offset: const Offset(3, 3),
                blurRadius: 4,
                color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
              ),
              BoxShadow(
                offset: const Offset(-3, -3),
                blurRadius: 4,
                color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
              )
            ],
            // image: DecorationImage(
            //   image: NetworkImage(
            //     AppConstants.baseURL +
            //         WebinarManagementController.currentWebinar['bannerImage'],
            //   ),
            // fit: BoxFit.cover,
          ),
          //icon: const Icon(Icons.add),
          child: Center(
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.camera_alt),
              color: Colors.white,
              iconSize: AppLayout.getHeight(50),
            ),
          ),
          // ),
        ),
        Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Enter your title here',
                  hintStyle: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontSize: 30, color: Colors.grey),
                ),
                maxLength: 100,
              ),
              // const Gap(10),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Your Tagline Here',
                  hintStyle: myhintTextstyle,
                ),
                maxLength: 150,
              ),
              const Gap(10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: AppLayout.getWidth(200),
                    child: TextFormField(
                      maxLines: 10,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(0),
                        // focusedBorder: const OutlineInputBorder(),
                        hintText: 'Description here',
                        hintStyle: myhintTextstyle,
                      ),
                      maxLength: 250,
                    ),
                  ),
                  Container(
                    width: AppLayout.getWidth(180),
                    height: AppLayout.getHeight(220),
                    decoration: BoxDecoration(
                      color: Colors.grey[600],
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
                      // image: DecorationImage(
                      //   image: NetworkImage(
                      //     AppConstants.baseURL +
                      //         WebinarManagementController
                      //             .currentWebinar['bannerImage'],
                      //   ),
                      //   fit: BoxFit.cover,
                      // ),
                    ),
                    child: Center(
                      child: IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.camera_alt),
                        color: Colors.white,
                        iconSize: AppLayout.getHeight(50),
                      ),
                    ),
                  )
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    // width: 100,
                    child: DateTimePicker(
                      // initialValue: DateTime.now().toString(),
                      style: onpageheadingsyle.copyWith(
                          color:
                              Theme.of(context).textTheme.displayLarge!.color),
                      decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          focusedBorder: UnderlineInputBorder(),
                          suffixIcon: Icon(Icons.calendar_month_outlined),
                          hintText: "Select date"),
                      firstDate: DateTime.now(),
                      initialDate: DateTime.now(),
                      lastDate: DateTime(2030),

                      // controller: dateController,
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
                  ),
                  const Gap(10),
                  Expanded(
                    child: TextFormField(
                      style: onpageheadingsyle.copyWith(
                          color:
                              Theme.of(context).textTheme.displayLarge!.color),
                      // controller:
                      // timeinput, //editing controller of this TextField
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        focusedBorder: UnderlineInputBorder(),
                        suffixIcon: Icon(Icons.access_time),
                        // icon: Icon(Icons.timer), //icon of text field
                      ),
                      readOnly:
                          true, //set it true, so that user will not able to edit text
                      onTap: () async {
                        TimeOfDay? pickedTime = await showTimePicker(
                          initialTime: TimeOfDay.now(),
                          context: context,
                        );
                        if (pickedTime != null) {
                          print(pickedTime.format(context)); //output 10:51 PM
                          DateTime parsedTime = DateFormat.jm()
                              .parse(pickedTime.format(context).toString());
                          //converting to DateTime so that we can further format on different pattern.
                          print(parsedTime); //output 1970-01-01 22:53:00.000
                          String formattedTime =
                              DateFormat('HH:mm:ss').format(parsedTime);
                          print(formattedTime); //output 14:59:00
                          //DateFormat() is from intl package, you can format the time on any pattern you need.

                          setState(() {
                            // timeinput.text =
                            // formattedTime; //set the value of text field.
                          });
                        } else {
                          print("Time is not selected");
                        }
                      },
                      validator: (value) => value!.isEmpty
                          ? 'Please enter time'
                          : null, //if empty return error text
                    ),
                  )
                ],
              ),
              const Gap(10),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.LTprimaryColor,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7),
                  ),
                ),
                child: const Text("Generate Banner",
                    style: TextStyle(fontSize: 20, color: Colors.white)),
              )
            ],
          ),
        ),
      ],
    );
  }
}
