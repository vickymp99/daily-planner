import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_planner/core/utils/common_utils.dart';
import 'package:daily_planner/core/utils/hive_service.dart';
import 'package:daily_planner/features/pages/newday_planner.dart';
import 'package:daily_planner/features/widgets/home_widget.dart';
import 'package:daily_planner/features/widgets/statistics_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<BottomNavigationBarItem> _screeens = [
    BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
    BottomNavigationBarItem(icon: Icon(Icons.query_stats), label: "Statistics"),
  ];

  int _currentIndex = 0;
  // String name = HiveService.userDetails.get("userName", defaultValue: "")!;
  @override
  void initState() {
    super.initState();
    appDebugPrint("Current user id: ${FirebaseAuth.instance.currentUser!.uid}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      
      body: SafeArea(
        child: _currentIndex == 0
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonAppbar(
                    // title: "Welcome ${name.toUpperCase()}",
                    title: "Welcome",
                    isLogOut: true,
                    showThemeIcon: true,
                  ),
                  Expanded(child: HomeTabWidget()),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonAppbar(title: "Statistics"),
                  Expanded(child: StatisticsWidget()),
                ],
              ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: _screeens,
        elevation: 0.0,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      floatingActionButtonAnimator: FloatingActionButtonAnimator.noAnimation,
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NewDayPlanner()),
              ),
              elevation: 8.0,
              child: Icon(Icons.add),
            )
          : null,
    );
  }
}
