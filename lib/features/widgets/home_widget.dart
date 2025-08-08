import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_planner/core/constant/daily_palnner_style.dart';
import 'package:daily_planner/core/utils/common_utils.dart';
import 'package:flutter/material.dart';

class HomeTabWidget extends StatelessWidget {
  const HomeTabWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 12.0,),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: List.generate(growable: true, 20, (index) {
                return Card(
                    elevation: 4.0,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                      side: BorderSide(color: Colors.grey.shade300),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: 35,
                        child: Text("MON \n\n9",textAlign: TextAlign.center,),),
                    ));
              }),
            ),
          ),
        ),

        SizedBox(height: 8.0,),

        StreamBuilder(
          key: GlobalKey(debugLabel: "home-dayplan"),
          stream: FirebaseFirestore.instance
              .collection('day-plan')
              .snapshots(),
          builder: (context, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            return Expanded(
              child: SizedBox(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: snap.data!.docs[0]["plan"].length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 0.0),
                      child: _DateCardWidget(
                        data: snap.data!.docs[0]["plan"][index],
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ),
        SizedBox(height: 12.0),
      ],
    );
  }
}

class _DateCardWidget extends StatelessWidget {
  final Map<String, dynamic> data;

  const _DateCardWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      shadowColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Text(data["time"], style: DailyPlannerStyle.fieldLabelText()),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Container(
                width: 2.0,
                color: Colors.grey.shade400,
                height: 80.0,
              ),
            ),
            // VerticalDivider(color: Colors.red,thickness: 5.0,width: 30.0,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(data["title"], style: DailyPlannerStyle.cardTitle()),
                  SizedBox(height: 8.0),
                  Text(
                    data["description"],
                    style: DailyPlannerStyle.cardDesc(),
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
