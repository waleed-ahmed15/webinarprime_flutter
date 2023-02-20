import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: TabBar(controller: _tabController, tabs: const [
          Tab(text: 'notifications'),
          Tab(text: 'requests'),
          Tab(text: '3rd tab'),
        ]),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          Center(child: Text('notifications')),
          Center(child: Text('requests')),
          Center(child: Text('3rd tab')),
        ],
      ),
    );
  }
}
