import 'package:daily_planner/core/constant/daily_palnner_style.dart';
import 'package:daily_planner/core/utils/circular_indicator.dart';
import 'package:daily_planner/core/utils/hive_service.dart';
import 'package:daily_planner/features/cubit/statistics_cubit.dart';
import 'package:daily_planner/features/data/model/plan_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

class StatisticsWidget extends StatefulWidget {
  StatisticsWidget({super.key});

  @override
  State<StatisticsWidget> createState() => _StatisticsWidgetState();
}

class _StatisticsWidgetState extends State<StatisticsWidget> {
  List<PlanModel> plans = [];

  @override
  void initState() {
    super.initState();
    BlocProvider.of<StatisticsCubit>(
      context,
    ).emitState(StatisticsSuccessState());
  }

  @override
  Widget build(BuildContext context) {
    final statisticsCubit = BlocProvider.of<StatisticsCubit>(context);
    return BlocBuilder<StatisticsCubit, StatisticsState>(
      builder: (context, state) {
        if (state is StatisticsSuccessState) {
          return ValueListenableBuilder<Box<PlanModel>>(
            valueListenable: HiveService.userPlan.listenable(),
            builder: (BuildContext context, box, Widget? child) {
              final rawList = box.values.toList();
              plans = rawList;
              statisticsCubit.initPlan(state: state, list: plans);
              if (plans.isNotEmpty) {
                return Column(
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
                            state.dates.length,
                            (dateIndex) {
                              return GestureDetector(
                                onTap: () {
                                  statisticsCubit.updateIndex(
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
                    SizedBox(height: 48.0),
                    Align(
                      alignment: AlignmentDirectional.center,
                      child: CustomCircularIndicator(
                        totalValue: state.count['total']!.toDouble(),
                        currentValue: state.count['completed']!.toDouble(),
                        size: MediaQuery.of(context).size.width * .7,
                        strokeWidth: 32,
                      ),
                    ),
                    SizedBox(height: 32),
                    Align(
                      alignment: AlignmentDirectional.center,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Total Task : ${state.count['total']} ",
                            style: DailyPlannerStyle.fieldLabelText(),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Completed : ${state.count['completed']} ",
                            style: DailyPlannerStyle.fieldLabelText(),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Not completed : ${state.count['notCompleted']}",
                            style: DailyPlannerStyle.fieldLabelText(),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Not start : ${state.count['notStart']}",
                            style: DailyPlannerStyle.fieldLabelText(),
                          ),
                        ],
                      ),
                    ),
                  ],
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
