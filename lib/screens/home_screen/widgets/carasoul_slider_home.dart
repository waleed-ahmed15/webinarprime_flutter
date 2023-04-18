import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:webinarprime/screens/home_screen/widgets/carasoul_item.dart';
import 'package:webinarprime/utils/colors.dart';

class CaresoulSliderHome extends StatefulWidget {
  List webinarList;
  CaresoulSliderHome({super.key, required this.webinarList});

  @override
  State<CaresoulSliderHome> createState() => _CaresoulSliderHomeState();
}

class _CaresoulSliderHomeState extends State<CaresoulSliderHome> {
  int _currentpagevalue = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          items: List.generate(widget.webinarList.length, (index) => index)
              .map((e) {
            return Container(
                decoration: BoxDecoration(
                  color: Get.isDarkMode ? Colors.black : Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: CaresoulItem(
                  webinar: widget.webinarList[e],
                ));
          }).toList(),
          // [
          //   Container(
          //     decoration: BoxDecoration(
          //       borderRadius: BorderRadius.circular(10),
          //       color: Colors.red,
          //     ),
          //     // width: 1.sw,
          //     width: 1.sw,
          //   ),
          //   Container(color: Colors.blue, width: 1.sw),
          //   Container(color: Colors.green, width: 1.sw)
          // ],
          options: CarouselOptions(
            // height: 200,
            animateToClosest: true,
            padEnds: true,
            // viewportFraction: 0.5,
            initialPage: 0,
            enlargeCenterPage: true,
            enlargeFactor: 0.3,
            enableInfiniteScroll: true,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 3),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            autoPlayCurve: Curves.fastOutSlowIn,
            // enlargeFactor,
            onPageChanged: (index, reason) {
              _currentpagevalue = index;
              setState(() {});
            },
            scrollDirection: Axis.horizontal,
          ),
        ),
        DotsIndicator(
          dotsCount: widget.webinarList.length,
          // dotsCount: widget.webinarList.isEmpty ? 1 : widget.webinarList.length,
          // dotsCount: popularproduct.popularProductList.isEmpty
          //     ? 1
          //     : popularproduct.popularProductList.length,
          position: _currentpagevalue.toDouble(),
          // position: 1,
          decorator: DotsDecorator(
            size: Size(9.w, 9.h),
            activeColor: Get.isDarkMode
                ? AppColors.LTsecondaryColor.withOpacity(0.8)
                : AppColors.LTprimaryColor,
            activeSize: Size(9.w, 9.h),
            activeShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }
}
