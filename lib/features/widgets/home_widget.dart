import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_planner/core/constant/daily_palnner_style.dart';
import 'package:daily_planner/core/utils/common_utils.dart';
import 'package:daily_planner/features/cubit/home_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class HomeTabWidget extends StatefulWidget {
  const HomeTabWidget({super.key});

  @override
  State<HomeTabWidget> createState() => _HomeTabWidgetState();
}

class _HomeTabWidgetState extends State<HomeTabWidget> {
  @override
  void initState() {
    BlocProvider.of<HomeCubit>(context).emitState(HomeSuccessState());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // initialize cubit
    final homeCubit = BlocProvider.of<HomeCubit>(context);
    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen: (pre, cur) => cur is HomeSuccessState,
      builder: (context, state) {
        if (state is HomeSuccessState) {
          final dateFormat = DateFormat("dd MMM yyyy");
          return StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('day-plan')
                .where(
                  'uID',
                  isEqualTo: FirebaseAuth.instance.currentUser!.uid,
                ) // filter current user docs
                .snapshots()
                .map((snapshot) {
                  return snapshot.docs
                      .map((doc) => doc['date'] as String) // only `date` field
                      .toList();
                }),
            builder: (context, parentSnap) {
              if (parentSnap.connectionState == ConnectionState.waiting) {
                return SizedBox();
              } else if (parentSnap.hasData && parentSnap.data!.isNotEmpty) {
                parentSnap.data!.sort(
                  (a, b) => dateFormat.parse(a).compareTo(dateFormat.parse(b)),
                );
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // date show widget
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            children: List.generate(
                              growable: true,
                              parentSnap.data!.length,
                              (dateIndex) {
                                return GestureDetector(
                                  onTap: () {
                                    homeCubit.updateIndex(
                                      state: state,
                                      indexValue: dateIndex,
                                    );
                                  },
                                  child: Card(
                                    elevation: 4.0,
                                    color: state.index == dateIndex
                                        ? Colors.blueAccent.shade100
                                        : null,
                                    shadowColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16.0),
                                      side: BorderSide(
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: SizedBox(
                                        width: 35,
                                        child: Text(
                                          parentSnap.data![dateIndex],
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 8.0),
                      // plan list widget
                      StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('day-plan')
                            .where(
                              'uID',
                              isEqualTo: FirebaseAuth.instance.currentUser!.uid,
                            )
                            .where(
                              ("date"),
                              isEqualTo: parentSnap.data![state.index],
                            )
                            .snapshots(),
                        builder: (context, childSnap) {
                          if (childSnap.connectionState ==
                              ConnectionState.waiting) {
                            return SizedBox();
                          } else if (childSnap.hasData &&
                              (childSnap.data!.docs[0]["plan"]
                                      as List) // index value always "0" here, because there is always unique and one date
                                  .isNotEmpty) {
                            return Expanded(
                              child: SizedBox(
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount:
                                      childSnap.data!.docs[0]["plan"].length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                        16.0,
                                        4.0,
                                        16.0,
                                        0.0,
                                      ),
                                      child: _DateCardWidget(
                                        data: childSnap
                                            .data!
                                            .docs[0]["plan"][index],
                                        docID: childSnap.data!.docs[0],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            );
                          }
                          return SizedBox(child: Text("No data"));
                        },
                      ),
                      SizedBox(height: 12.0),
                    ],
                  ),
                );
              } else {
                return SizedBox(
                  child: Center(
                    child: Text(
                      "No data",
                      style: DailyPlannerStyle.labelText(),
                    ),
                  ),
                );
              }
            },
          );
        } else {
          return Center(
            child: SizedBox(
              width: 50,
              height: 50,
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}

class _DateCardWidget extends StatelessWidget {
  final Map<String, dynamic> data;
  final QueryDocumentSnapshot<Map<String, dynamic>> docID;

  const _DateCardWidget({required this.data, required this.docID});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {},
      onTap: () {
        appDebugPrint(data["status"]);
        BlocProvider.of<HomeCubit>(
          context,
        ).statusUpdate(status: data["status"], docID: docID, key: data["time"]);
      },
      child: Card(
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
                    Text(
                      data["title"].toString().toUpperCase(),
                      style: DailyPlannerStyle.cardTitle(),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      data["description"],
                      style: DailyPlannerStyle.cardDesc(),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.0),
              BlocProvider.of<HomeCubit>(
                        context,
                      ).getImageString(data["status"]) !=
                      null
                  ? SizedBox(
                      height: 30,
                      width: 30,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24.0),
                        child: Image.asset(
                          (BlocProvider.of<HomeCubit>(
                            context,
                          ).getImageString(data["status"]))!,
                        ),
                      ),
                    )
                  : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
