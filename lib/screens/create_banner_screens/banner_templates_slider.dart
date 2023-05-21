import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:webinarprime/screens/create_banner_screens/create_banner_screen.dart';
import 'package:webinarprime/utils/colors.dart';

class BannerTemplates extends StatefulWidget {
  bool customBanner;
  BannerTemplates({required this.customBanner, super.key});

  @override
  State<BannerTemplates> createState() => _BannerTemplatesState();
}

class _BannerTemplatesState extends State<BannerTemplates> {
  int _currentpagevalue = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ListView(
          children: [
            CarouselSlider(
              items: [
                GestureDetector(
                  onTap: () async {
                    // Get.to(() => const CreateBannerScreen());
                    Get.to(() => CreateBannerScreen(
                        customBanner: widget.customBanner,
                        backgroundImage:
                            'https://img.freepik.com/free-vector/abstract-orange-background-with-lines-halftone-effect_1017-32107.jpg?w=1380&t=st=1680850954~exp=1680851554~hmac=b6170f3a08d1d7569152223ddc3f86478cdc2bb291eee450787fbe74906d31f5'));
                  },
                  child: Container(
                    // width: 50.w,
                    width: 1.sw,
                    // height: 50.h,
                    decoration: const BoxDecoration(
                        // borderRadius: BorderRadius.circular(30),
                        // color: Get.isDarkMode
                        // ? myappbarcolor
                        // : AppColors.LTprimaryColor,
                        // image: DecorationImage(
                        // image: AssetImage('assets/chatbot4.png'),
                        // fit: BoxFit.cover,
                        // ),
                        ),
                    // margin: EdgeInsets.only(left: 40.w),
                    child: Image.network(
                      loadingBuilder: (context, child, loadingProgress) =>
                          loadingProgress == null
                              ? child
                              : const Center(
                                  child: CircularProgressIndicator(),
                                ),
                      errorBuilder: (context, error, stackTrace) =>
                          const Center(
                        child: Text('Error'),
                      ),
                      // 'assets/imagebanner_temp1.jpg',
                      'https://img.freepik.com/free-vector/abstract-orange-background-with-lines-halftone-effect_1017-32107.jpg?w=1380&t=st=1680850954~exp=1680851554~hmac=b6170f3a08d1d7569152223ddc3f86478cdc2bb291eee450787fbe74906d31f5',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    // Get.to(() => const CreateBannerScreen());
                    Get.to(() => CreateBannerScreen(
                        customBanner: widget.customBanner,
                        backgroundImage:
                            'https://img.freepik.com/premium-photo/simple-white-background-with-smooth-lines-light-colors_476363-5759.jpg'));
                  },
                  child: Container(
                    // width: 50.w,
                    width: 1.sw,
                    // height: 50.h,
                    decoration: const BoxDecoration(
                        // borderRadius: BorderRadius.circular(30),
                        // color: Get.isDarkMode
                        // ? myappbarcolor
                        // : AppColors.LTprimaryColor,
                        // image: DecorationImage(
                        // image: AssetImage('assets/chatbot4.png'),
                        // fit: BoxFit.cover,
                        // ),
                        ),
                    // margin: EdgeInsets.only(left: 40.w),
                    child: Image.network(
                      loadingBuilder: (context, child, loadingProgress) =>
                          loadingProgress == null
                              ? child
                              : const Center(
                                  child: CircularProgressIndicator(),
                                ),
                      errorBuilder: (context, error, stackTrace) =>
                          const Center(
                        child: Text('Error'),
                      ),
                      // 'assets/imagebanner_temp1.jpg',
                      'https://img.freepik.com/premium-photo/simple-white-background-with-smooth-lines-light-colors_476363-5759.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    // Get.to(() => const CreateBannerScreen());
                    Get.to(() => CreateBannerScreen(
                        customBanner: widget.customBanner,
                        backgroundImage:
                            'https://img.freepik.com/free-vector/blue-copy-space-digital-background_23-2148821698.jpg?w=1060&t=st=1681214608~exp=1681215208~hmac=c92e2648f904a00d5cee2a08170e7dd143ede7fc6375f0e864b0ebf7baa6a640'));
                  },
                  child: Container(
                    // width: 50.w,
                    width: 1.sw,
                    // height: 50.h,
                    decoration: const BoxDecoration(
                        // borderRadius: BorderRadius.circular(30),
                        // color: Get.isDarkMode
                        // ? myappbarcolor
                        // : AppColors.LTprimaryColor,
                        // image: DecorationImage(
                        // image: AssetImage('assets/chatbot4.png'),
                        // fit: BoxFit.cover,
                        // ),
                        ),
                    // margin: EdgeInsets.only(left: 40.w),
                    child: Image.network(
                      loadingBuilder: (context, child, loadingProgress) =>
                          loadingProgress == null
                              ? child
                              : const Center(
                                  child: CircularProgressIndicator(),
                                ),
                      errorBuilder: (context, error, stackTrace) =>
                          const Center(
                        child: Text('Error'),
                      ),
                      // 'assets/imagebanner_temp1.jpg',
                      'https://img.freepik.com/free-vector/blue-copy-space-digital-background_23-2148821698.jpg?w=1060&t=st=1681214608~exp=1681215208~hmac=c92e2648f904a00d5cee2a08170e7dd143ede7fc6375f0e864b0ebf7baa6a640',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // const BannerTemplate1(),
                // Container(color: Colors.blue, width: 1.sw),
                // Container(color: Colors.green, width: 1.sw)
              ],
              options: CarouselOptions(
                // height: 200,
                animateToClosest: true,
                padEnds: true,

                // viewportFraction: 0.5,
                height: 0.94.sh,
                initialPage: 0,
                viewportFraction: 1,
                enlargeCenterPage: true,
                // enlargeFactor: 0.3,
                enableInfiniteScroll: true,
                // autoPlay: true,
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
              dotsCount: 3,
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
        ),
      ),
    );
  }
}
