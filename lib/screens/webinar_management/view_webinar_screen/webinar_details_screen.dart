import 'package:flutter/material.dart';

class WebinarDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> webinarDetails;
  const WebinarDetailsScreen({super.key, required this.webinarDetails});

  @override
  Widget build(BuildContext context) {
    print('webinarDetails: $webinarDetails');
    return Scaffold(
      body: Stack(children: const [
        Positioned(child: Text('Webinar Details Screen')),
      ]),
    );
  }
}
