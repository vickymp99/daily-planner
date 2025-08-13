import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_planner/core/utils/common_utils.dart';
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
  String name = "";
  @override
  void initState() {
    super.initState();
    appDebugPrint("Current user id: ${FirebaseAuth.instance.currentUser!.uid}");

    getName();
  }

  Future<void> getName() async {
    var data = await FirebaseFirestore.instance
        .collection('user-details')
        .get();
    if (data.docs.where((val) {
      return val["id"] == FirebaseAuth.instance.currentUser!.uid;
    }).isNotEmpty) {
      QueryDocumentSnapshot<Map<String, dynamic>> userQuery = data.docs.where((
        val,
      ) {
        return val["id"] == FirebaseAuth.instance.currentUser!.uid;
      }).first;
      // setState(() {
      name = userQuery['name'];
      // });
    }
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
                    title: "Welcome ${name.toUpperCase()}",
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
