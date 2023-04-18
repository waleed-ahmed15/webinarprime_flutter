import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:webinarprime/utils/colors.dart';

class FilterDrawer extends StatefulWidget {
  final Function onSortOptionSelected;

  const FilterDrawer({super.key, required this.onSortOptionSelected});

  @override
  _FilterDrawerState createState() => _FilterDrawerState();
}

class _FilterDrawerState extends State<FilterDrawer> {
  String _sortOption = 'A-Z';
  bool _isAscending = true;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 0.7.sw,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 100.h,
            child: const DrawerHeader(
              decoration: BoxDecoration(
                color: AppColors.LTprimaryColor,
              ),
              child: Text(
                'Filters',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          ListTile(
            title: const Text('A-Z'),
            leading: Radio(
              value: 'A-Z',
              groupValue: _sortOption,
              activeColor: Get.isDarkMode
                  ? AppColors.LTsecondaryColor
                  : AppColors.LTprimaryColor,
              onChanged: (value) {
                setState(() {
                  _sortOption = value.toString();
                });
                widget.onSortOptionSelected(value.toString());
              },
            ),
          ),
          ListTile(
            title: const Text('Date'),
            leading: Radio(
              value: 'Date',
              groupValue: _sortOption,
              activeColor: Get.isDarkMode
                  ? AppColors.LTsecondaryColor
                  : AppColors.LTprimaryColor,
              onChanged: (value) {
                setState(() {
                  _sortOption = value.toString();
                });
                widget.onSortOptionSelected(value.toString(), _isAscending);
              },
            ),
          ),
          ListTile(
            title: const Text('Price'),
            leading: Radio(
              value: 'Price',
              activeColor: Get.isDarkMode
                  ? AppColors.LTsecondaryColor
                  : AppColors.LTprimaryColor,
              groupValue: _sortOption,
              onChanged: (value) {
                setState(() {
                  _sortOption = value.toString();
                });
                widget.onSortOptionSelected(value.toString());
              },
            ),
          ),
          ListTile(
            title: const Text('Duration'),
            leading: Radio(
              value: 'Duration',
              groupValue: _sortOption,
              activeColor: Get.isDarkMode
                  ? AppColors.LTsecondaryColor
                  : AppColors.LTprimaryColor,
              onChanged: (value) {
                setState(() {
                  _sortOption = value.toString();
                });
                widget.onSortOptionSelected(value.toString());
              },
            ),
          ),
          const Divider(),
          Gap(40.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Gap(10.w),
              const Text("Acsending Order"),
              const Spacer(),
              Switch(
                splashRadius: 0,
                dragStartBehavior: DragStartBehavior.start,
                activeColor: Get.isDarkMode
                    ? AppColors.LTsecondaryColor.withOpacity(0.7)
                    : AppColors.LTprimaryColor.withOpacity(0.7),
                value: _isAscending,
                onChanged: (value) async {
                  setState(() {
                    _isAscending = value;
                    widget.onSortOptionSelected(_sortOption, _isAscending);
                  });
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
