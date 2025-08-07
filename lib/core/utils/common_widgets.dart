import 'package:daily_planner/core/constant/daily_palnner_style.dart';
import 'package:flutter/material.dart';

class CommonAppbar extends StatelessWidget {
  final String title;
  final bool isLogOut;

  const CommonAppbar({super.key, required this.title, this.isLogOut = false});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0.0,

      actionsPadding: EdgeInsetsGeometry.fromLTRB(0.0,8.0,16.0,8.0),
      scrolledUnderElevation: 0,
      // shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(
      //     bottomLeft: Radius.circular(16.0),bottomRight: Radius.circular(16.0))),
      // backgroundColor: Colors.grey.shade200,
      backgroundColor: Colors.transparent,
      actions: isLogOut ? [Icon(Icons.person, color: Colors.black,size: 40,)] : null,
      title: Text(title, style: DailyPlannerStyle.appbarTitle()),
    );
  }
}
