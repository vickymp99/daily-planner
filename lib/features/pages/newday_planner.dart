import 'package:daily_planner/core/utils/common_widgets.dart';
import 'package:daily_planner/features/widgets/newday_planner_widget.dart';
import 'package:flutter/material.dart';

class NewDayPlanner extends StatelessWidget {
  const NewDayPlanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Column(
        children: [
          CommonAppbar(title: "New Day Plan"),
          NewDayPlannerWidget(),
        ],
      )),
    );
  }
}
