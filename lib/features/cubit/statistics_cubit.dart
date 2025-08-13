import 'package:daily_planner/core/constant/app_enum.dart';
import 'package:daily_planner/core/utils/common_utils.dart';
import 'package:daily_planner/features/data/model/plan_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StatisticsCubit extends Cubit<StatisticsState> {
  StatisticsCubit() : super(StatisticsInitialState());

  emitState(StatisticsState state) {
    emit(_StatisticsChangeState());
    emit(state);
  }

  updateIndex({
    required StatisticsSuccessState state,
    required int indexValue
  }) {
    state.updateIndex(indexValue);
    emitState(state);
  }
  initPlan({
    required StatisticsSuccessState state,
    required List<PlanModel> list,
  }) {
    state.setInitValue(list);
  }

  String getId(List<PlanModel> list, String date) {
    appDebugPrint(date);
    return list.where((x) => x.date == date).toList().first.id;
  }
}

abstract class StatisticsState extends Equatable {}

class StatisticsInitialState extends StatisticsState {
  @override
  List<Object?> get props => [];
}

class _StatisticsChangeState extends StatisticsState {
  @override
  List<Object?> get props => [];
}

class StatisticsSuccessState extends StatisticsState {
  int index = 0;
  List<String> dates = [];
  Map<String, int> count = {};
  StatisticsSuccessState();

  updateIndex(int indexValue) {
    appDebugPrint(indexValue);
    index = indexValue;
  }

  setInitValue(List<PlanModel> userList) {
    dates = userList.map((element) => element.date).toList();
    dates.sort((a, b) => a.compareTo(b));
    PlanModel model = userList
        .where((map) => map.date == dates[index])
        .toList()
        .first;
    count.addEntries([
      MapEntry("total", model.planList.length),
      MapEntry(
        "completed",
        model.planList
            .where((map) => map.status == PlanStatus.completed.name)
            .toList()
            .length,
      ),
      MapEntry(
        "notCompleted",
        model.planList
            .where((map) => map.status == PlanStatus.notComplete.name)
            .toList()
            .length,
      ),
      MapEntry(
        "notStart",
        model.planList
            .where((map) => map.status == PlanStatus.notStart.name)
            .toList()
            .length,
      ),
    ]);
  }

  @override
  List<Object?> get props => [];
}

class StatisticsErrorState extends StatisticsState {
  final String msg;
  StatisticsErrorState({required this.msg});
  @override
  List<Object?> get props => [msg];
}
