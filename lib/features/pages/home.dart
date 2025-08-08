import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_planner/core/utils/common_utils.dart';
import 'package:daily_planner/features/pages/newday_planner.dart';
import 'package:daily_planner/features/widgets/home_widget.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: SafeArea(child: Column(
        children: [
          CommonAppbar(title: "Home", isLogOut: true, showThemeIcon: true),
          Expanded(child: HomeTabWidget()),
        ],
      )),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NewDayPlanner()),
        ),
        elevation: 8.0,
        child: Icon(Icons.add),
      ),
    );
  }
}
