import 'package:daily_planner/core/constant/daily_palnner_style.dart';
import 'package:daily_planner/core/utils/common_utils.dart';
import 'package:daily_planner/core/utils/hive_service.dart';
import 'package:daily_planner/features/cubit/home_cubit.dart';
import 'package:daily_planner/features/data/model/plan_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomeTabWidget extends StatefulWidget {
  const HomeTabWidget({super.key});

  @override
  State<HomeTabWidget> createState() => _HomeTabWidgetState();
}

class _HomeTabWidgetState extends State<HomeTabWidget> {
  List<PlanModel> plans = [];
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
      builder: (context, state) {
        if (state is HomeSuccessState) {
          return ValueListenableBuilder<Box<PlanModel>>(
            valueListenable: HiveService.userPlan.listenable(),
            builder: (context, box, Widget? child) {
              // set initial value from hive
              final rawList =box.values.toList();
               plans = rawList;
               appDebugPrint("final plans $plans");
              homeCubit.initPlan(state: state, list: plans);
              if (plans.isNotEmpty) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // date show widget
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Row(
                            children: List.generate(
                              growable: true,
                              state.dates.length,
                              (dateIndex) {
                                return GestureDetector(
                                  onTap: () {
                                    homeCubit.updateIndex(
                                      state: state,
                                      indexValue: dateIndex,
                                      plans: plans,
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
                                        color: state.index == dateIndex
                                            ? Colors.blueAccent.shade100
                                            : Colors.grey.shade300,
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: SizedBox(
                                        width: 40,
                                        child: Text(
                                          state.dates[dateIndex],
                                          style: DailyPlannerStyle.normalText(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
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
                      Expanded(
                        child: SizedBox(
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: state.plans.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  16.0,
                                  4.0,
                                  16.0,
                                  0.0,
                                ),
                                child: _DateCardWidget(
                                  data: state.plans[index],
                                  docId: homeCubit.getId(
                                    plans,
                                    state.dates[state.index],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 12.0),
                    ],
                  ),
                );
              } else {
                return Center(
                  child: SizedBox(
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
          return SizedBox();
        }
      },
    );
  }
}

class _DateCardWidget extends StatelessWidget {
  final PlanListModel data;
  final String docId;
  const _DateCardWidget({required this.data, required this.docId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {},
      onTap: () {
        BlocProvider.of<HomeCubit>(
          context,
        ).statusUpdate(planModel: data, docId: docId);
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
              Text(data.time, style: DailyPlannerStyle.fieldLabelText()),
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
                      data.title.toString().toUpperCase(),
                      style: DailyPlannerStyle.cardTitle(),
                    ),
                    SizedBox(height: 8.0),
                    Text(data.desc, style: DailyPlannerStyle.cardDesc()),
                  ],
                ),
              ),
              SizedBox(width: 8.0),
              BlocProvider.of<HomeCubit>(context).getImageString(data.status) !=
                      null
                  ? SizedBox(
                      height: 30,
                      width: 30,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24.0),
                        child: Image.asset(
                          (BlocProvider.of<HomeCubit>(
                            context,
                          ).getImageString(data.status))!,
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
