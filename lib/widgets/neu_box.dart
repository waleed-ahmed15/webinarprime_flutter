import 'package:flutter/material.dart';

class NueBox extends StatelessWidget {
  final child;
  const NueBox({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      child: child,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey.shade300,
          boxShadow: [
            BoxShadow(
                color: Colors.white, offset: Offset(-5, -5), blurRadius: 15),
            BoxShadow(
                color: Colors.grey.shade400,
                offset: Offset(5, 5),
                blurRadius: 15)
          ]),
    );
  }
}
