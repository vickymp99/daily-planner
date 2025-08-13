import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_planner/core/constant/app_enum.dart';
import 'package:daily_planner/core/utils/common_utils.dart';
import 'package:daily_planner/features/cubit/newday_plan_cubit.dart';
import 'package:daily_planner/features/usecase/day_usecase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NewDayPlannerWidget extends StatelessWidget {
  NewDayPlannerWidget({super.key});
  String _title = "";
  String _desc = "";
  String _date = "";
  String _time = "";
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NewDayPlanCubit, NewDayPlanState>(
      listener: (context, state) {
        if (state is NewDayPlanSuccessState) {
          if (state.msg != null) {
            CommonUtils.snackBar(context, msg: state.msg);
          } else if (state is NewDayPlanErrorState) {
            CommonUtils.snackBar(context, msg: state.msg);
          }
        }
      },
      buildWhen: (pre, cur) => cur is NewDayPlanInitialState,
      builder: (context, state) {
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
                    _title = value.trim();
                  },
                ),
                CommonTextField(
                  hintText: "Description(optional)",
                  onChanged: (value) {
                    _desc = value.trim();
                  },
                ),
                CommonTextField(
                  hintText: "Date",
                  type: TextFieldActionType.date,
                  enable: false,
                  onTap: (value) {
                    _date = value.trim();
                  },
                ),
                CommonTextField(
                  hintText: "time",
                  enable: false,
                  type: TextFieldActionType.time,
                  onTap: (value) {
                    _time = value.trim();
                  },
                ),
                SizedBox(height: 32),
                CommonElevatedButton(
                  onPressed: () async {
                    // allow only if all value is filled
                    if (_title.isNotEmpty &&
                        _date.isNotEmpty &&
                        _time.isNotEmpty) {
                      BlocProvider.of<NewDayPlanCubit>(context).addPlan(
                        NewDayPlanUseCase(
                          title: _title,
                          desc: _desc,
                          date: _date,
                          time: _time,
                        ),
                      );
                    } else {
                      CommonUtils.snackBar(
                        context,
                        msg: "Enter value correctly",
                      );
                    }
                  },
                  text: "Add",
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void insertThePlan() async {
    // Get current user doc
    List<QueryDocumentSnapshot<Map<String, dynamic>>> cDocs =
        await FirebaseFirestore.instance.collection("day-plan").get().then((
          val,
        ) {
          return val.docs.where((element) {
            return element["uID"] == FirebaseAuth.instance.currentUser!.uid;
          }).toList();
        });
    // check the date is already exist or not
    bool isDateExist = cDocs.any(
      (map) => map.data().containsValue("12 Aug 2025"),
    );
    appDebugPrint(isDateExist);
    // add or update the plan
    if (isDateExist) {
      QueryDocumentSnapshot<Map<String, dynamic>> docId = cDocs
          .where((map) => map.data()["date"] == "12 Aug 2025")
          .first;
      appDebugPrint(docId);
      appDebugPrint(docId.id);
      await FirebaseFirestore.instance
          .collection('day-plan')
          .doc(docId.id)
          .update({
            'plan': FieldValue.arrayUnion([
              {
                "time": "12 AM",
                "title": "dvsdds",
                "description": "sddds",
                "status": "",
              },
            ]),
          });
    } else {
      await FirebaseFirestore.instance.collection("day-plan").add({
        "date": "17 Aug 2025",
        "uID": FirebaseAuth.instance.currentUser!.uid,
        "plan": [
          {
            "time": "5 AM",
            "title": "Wake up",
            "description": "wake up before 5 Am and start routine",
            "status": "",
          },
        ],
      });
    }
  }
}
