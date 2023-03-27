import 'package:flutter/material.dart';

class ChartTitleWidget extends StatefulWidget {
  String title;
  ChartTitleWidget(this.title, {super.key});

  @override
  State<ChartTitleWidget> createState() => _ChartTitleWidgetState();
}

class _ChartTitleWidgetState extends State<ChartTitleWidget> {
  @override
  void initState() {
    // TODO: implement initState
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(widget.title),
    );
  }
}
