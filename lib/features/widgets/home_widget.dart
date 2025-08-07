import 'package:daily_planner/core/utils/common_widgets.dart';
import 'package:flutter/material.dart';

class HomeTabWidget extends StatelessWidget {
  const HomeTabWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonAppbar(title: "Home",isLogOut: true,),
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: 20,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
                child: _DateCardWidget(),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _DateCardWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      shadowColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Text("5 AM"),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Container(
                width: 2.0,
                color: Colors.grey.shade400,
                height: 100.0,
              ),
            ),
            // VerticalDivider(color: Colors.red,thickness: 5.0,width: 30.0,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("title"),
                  SizedBox(height: 8.0),
                  Text(
                    "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna",
                  ),
                ],
              ),
            ),
            SizedBox(width: 8.0),
            Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
