import 'package:daily_planner/core/constant/app_enum.dart';
import 'package:daily_planner/core/utils/common_utils.dart';
import 'package:flutter/material.dart';

class NewDayPlannerWidget extends StatelessWidget {
  const NewDayPlannerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            CommonTextField(
              hintText: "Title",
              onChanged: (value) {
                print(value);
              },
            ),
            CommonTextField(
              hintText: "Description",
              onChanged: (value) {
                print(value);
              },
            ),
            CommonTextField(
              hintText: "Date",
              type: TextFieldActionType.date,
              onChanged: (value) {
                print(value);
              },
              enable: false,
              onTap: (value) {
                print(value);
              },
            ),
            CommonTextField(
              hintText: "time",
              enable: false,
              type: TextFieldActionType.time,
              onChanged: (value) {},
            ),
          ],
        ),
      ),
    );
  }
}
