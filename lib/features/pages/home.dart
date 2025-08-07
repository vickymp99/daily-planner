import 'package:daily_planner/features/widgets/home_widget.dart';
import'package:flutter/material.dart';

class Home extends StatelessWidget{
 const Home({super.key});
  @override
  Widget build(BuildContext context){
    return Scaffold(
        backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      body: SafeArea(child: HomeWidget())
    );
  }
}