import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:webinarprime/utils/styles.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  TextEditingController searchController = TextEditingController();
  bool hideSearch = true;

  List<String> users = [
    'ali',
    'ahmed',
    'mohamed',
    'umar',
    'hazim',
    'kk',
    'sdk',
    'xami',
  ];

  @override
  Widget build(BuildContext context) {
    print('object');
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: TextFormField(
          controller: searchController,
          style: Mystyles.bigTitleStyle
              .copyWith(fontSize: 15.sp, fontWeight: FontWeight.w500),
          decoration: InputDecoration(
            hintText: 'Search. . .',
            hintStyle: TextStyle(
              color: Colors.grey,
              fontSize: 16.sp,
            ),
            border: InputBorder.none,
          ),
          onChanged: (value) {
            setState(() {});
          },
        ),
        elevation: 0,
      ),
      body: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: users.length,
        itemBuilder: (BuildContext context, int index) {
          String user = users[index].toLowerCase().toString();
          if (searchController.text.isEmpty) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                leading: const CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(
                      'https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&w=600'),
                ),
                title: Text(
                  users[index],
                  overflow: TextOverflow.ellipsis,
                  style: Mystyles.listtileTitleStyle
                      .copyWith(fontWeight: FontWeight.w500),
                ),
                subtitle: Text(
                  'kdr ha?',
                  style: Mystyles.listtileTitleStyle.copyWith(fontSize: 14.sp),
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Text(
                    "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}"),
              ),
            );
          } else if (user
              .contains(searchController.text.toLowerCase().toString())) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                leading: const CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(
                      'https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&w=600'),
                ),
                title: Text(
                  users[index],
                  overflow: TextOverflow.ellipsis,
                  style: Mystyles.listtileTitleStyle
                      .copyWith(fontWeight: FontWeight.w500),
                ),
                subtitle: Text(
                  'kdr ha?',
                  style: Mystyles.listtileTitleStyle.copyWith(fontSize: 14.sp),
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Text(
                    "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}"),
              ),
            );
          }
          return Container();
        },
      ),
    );
  }
}
