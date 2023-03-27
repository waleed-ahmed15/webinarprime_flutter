import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:webinarprime/controllers/webinar_management_controller.dart';
import 'package:webinarprime/utils/colors.dart';
import 'package:webinarprime/utils/styles.dart';
import 'package:gap/gap.dart';

class WebinarStats extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  WebinarStats({Key? key}) : super(key: key);

  @override
  WebinarStatsState createState() => WebinarStatsState();
}

class WebinarStatsState extends State<WebinarStats> {
  late List<_ChartData> data;
  late TooltipBehavior _tooltip;
  RxString title = ''.obs;

  @override
  void initState() {
    data = List.generate(
        WebinarManagementController.webinaranalytics.length,
        (index) => _ChartData(
            WebinarManagementController.webinaranalytics[index]['_id'][0]
                ['name'],
            WebinarManagementController.webinaranalytics[index]['total'],
            WebinarManagementController.webinaranalytics[index]['count']));

    // data = [
    //   _ChartData('Tickets Sold', 12, Colors.red),
    //   _ChartData(
    //       'Revenue Generate asdslkd jsak jsa kjdsalk djslkskd;sakd salk dsal kasl; kdasl; dksa ;ldkasl ;jda skdjl aks 44444',
    //       15,
    //       Colors.green),
    //   _ChartData('RUS', 100000, Colors.blue),
    //   _ChartData('BRZ', 6.4, Colors.yellow),
    //   _ChartData('IND', 14, Colors.pink),
    // ];
    _tooltip = TooltipBehavior(
        enable: true,
        // header: '',
        activationMode: ActivationMode.singleTap,
        tooltipPosition: TooltipPosition.pointer,
        textAlignment: ChartAlignment.center,
        color: Colors.black,
        textStyle: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontFamily: 'josefinsans Bold',
          fontWeight: FontWeight.w500,
        ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: WebinarManagementController.webinaranalytics.isEmpty
            ? Center(
                child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.stacked_bar_chart,
                    size: 100.h,
                  ),
                  Gap(20.h),
                  Text(
                    'no analytics yet',
                    style: bigTitleStyle.copyWith(
                        color: Get.isDarkMode ? Colors.white : Colors.black),
                  ),
                ],
              ))
            : ListView(
                // shrinkWrap: true,
                // shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                children: [
                  SizedBox(
                    width: 20.w,
                  ),
                  Obx(
                    () => Container(
                      margin: const EdgeInsets.only(
                          top: 20, bottom: 20, left: 20, right: 20),
                      child: Text(
                        title.value,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Get.isDarkMode ? Colors.white : Colors.black,
                            fontSize: 16,
                            fontFamily: 'josefinsans Regular',
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 0.8.sh,
                    width: 1.sw,
                    child: SfCartesianChart(
                        onActualRangeChanged: (onActualRangeChangedArgs) {},
                        enableAxisAnimation: true,
                        isTransposed: true,
                        onDataLabelTapped: (onTapArgs) {
                          print(onTapArgs.pointIndex);
                          title.value = data[onTapArgs.pointIndex].name;
                        },
                        // backgroundColor: Colors.black,

                        // primaryXAxis: CategoryAxis(),
                        primaryXAxis: CategoryAxis(
                          visibleMinimum: 1,
                          // autoScrollingMode: Au
                          visibleMaximum: 2,

                          interactiveTooltip:
                              const InteractiveTooltip(enable: true),
                          labelPosition: ChartDataLabelPosition.inside,
                          // labelIntersectAction: AxisLabelIntersectAction.multipleRows,

                          title: AxisTitle(text: 'Webinars'),
                          labelAlignment: LabelAlignment.start,
                          labelsExtent: 200,
                          labelStyle: TextStyle(
                              color:
                                  Get.isDarkMode ? Colors.white : Colors.black,
                              fontSize: 14,
                              fontFamily: 'josefinsans Bold',
                              fontWeight: FontWeight.w500),
                          majorGridLines: const MajorGridLines(width: 0),
                          labelRotation: -90,
                        ),
                        zoomPanBehavior: ZoomPanBehavior(
                          enablePanning: true,
                          zoomMode: ZoomMode.x,
                        ),
                        primaryYAxis: NumericAxis(
                          minimum: 1,
                          autoScrollingMode: AutoScrollingMode.start,
                          majorGridLines: const MajorGridLines(width: 0),
                        ),
                        tooltipBehavior: _tooltip,
                        selectionType: SelectionType.series,

                        // selectionType: SelectionType.point,

                        series: <ChartSeries<_ChartData, String>>[
                          BarSeries<_ChartData, String>(
                            onPointTap: (ChartPointDetails details) {
                              title.value = data[details.pointIndex!].name;
                            },
                            dataSource: data,
                            xValueMapper: (_ChartData data, _) =>
                                data.name.length > 60
                                    ? '${data.name.substring(0, 30)}...'
                                    : data.name,
                            xAxisName: 'Webinars',
                            yValueMapper: (_ChartData data, _) =>
                                data.ticketsSold,
                            dataLabelSettings: DataLabelSettings(
                              isVisible: true,
                              angle: 40,
                              labelPosition: ChartDataLabelPosition.outside,
                              labelAlignment: ChartDataLabelAlignment.outer,
                              textStyle: TextStyle(
                                  color: Get.isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                                  fontSize: 12,
                                  fontFamily: 'josefinsans Bold',
                                  fontWeight: FontWeight.w500),
                            ),
                            name: "Tickets Sold",
                            color: AppColors.LTprimaryColor,
                          ),
                          BarSeries<_ChartData, String>(
                            // width: 0.3,
                            onPointTap: (ChartPointDetails details) {
                              // print(details.pointIndex);
                              // print(details.seriesIndex);
                              // print(title.value);
                              title.value = data[details.pointIndex!].name;
                              // title.refresh();

                              // print(ti data[0].x);

                              // print(data[0].x);
                              // setState(() {})
                            },
                            dataSource: data,
                            xValueMapper: (_ChartData data, _) =>
                                data.name.length > 60
                                    ? '${data.name.substring(0, 30)}...'
                                    : data.name,
                            yValueMapper: (_ChartData data, _) => data.revenue,

                            dataLabelSettings: DataLabelSettings(
                              isVisible: true,
                              angle: 40,
                              labelPosition: ChartDataLabelPosition.outside,
                              labelAlignment: ChartDataLabelAlignment.outer,
                              textStyle: TextStyle(
                                  color: Get.isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                                  fontSize: 12,
                                  fontFamily: 'josefinsans Bold',
                                  fontWeight: FontWeight.w500),
                            ),
                            name: 'revenue',
                            color: AppColors.LTsecondaryColor,
                          ),
                        ]),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: AppColors.LTprimaryColor,
                        ),
                        height: 20,
                        width: 20,
                        // color: const Color.fromARGB(255, 0, 106, 193),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Tickets Sold',
                        style: TextStyle(
                            color: Get.isDarkMode ? Colors.white : Colors.black,
                            fontSize: 12,
                            fontFamily: 'josefinsans Bold',
                            fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Container(
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: AppColors.LTsecondaryColor,
                        ),

                        // color: const Color.fromARGB(255, 37, 56, 72),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Revenue (USD)',
                        style: TextStyle(
                            color: Get.isDarkMode ? Colors.white : Colors.black,
                            fontSize: 12,
                            fontFamily: 'josefinsans Bold',
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  )
                ],
              ),
      ),
    );
  }
}

class _ChartData {
  _ChartData(this.name, this.revenue, this.ticketsSold);

  final String name;
  final int revenue;
  final int ticketsSold;
}
