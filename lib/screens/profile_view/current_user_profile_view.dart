import 'package:flutter/material.dart';

class CurrentUserProfile extends StatefulWidget {
  const CurrentUserProfile({super.key});

  @override
  State<CurrentUserProfile> createState() => _CurrentUserProfileState();
}

class _CurrentUserProfileState extends State<CurrentUserProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.red,
        child: const Text('Logged in user profile'),
      ),
    );
  }
}
