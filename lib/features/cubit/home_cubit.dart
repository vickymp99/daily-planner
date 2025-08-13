import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_planner/core/constant/app_enum.dart';
import 'package:daily_planner/core/utils/common_utils.dart';
import 'package:daily_planner/features/data/model/plan_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitialState());

  emitState(HomeState state) {
    emit(_HomeChangeState());
    emit(state);
  }

  updateIndex({
    required HomeSuccessState state,
    required int indexValue,
    required List<PlanModel> plans,
  }) {
    state.updateIndex(indexValue, plans);
    emitState(state);
  }

  String? getImageString(String status) {
    if (status == PlanStatus.notComplete.name) {
      return "assets/images/cross.png";
    } else if (status == PlanStatus.completed.name) {
      return "assets/images/tick.png";
    }
    return null;
  }

  statusUpdate({
    required PlanListModel planModel,
    required String docId,
  }) async {
    String updatedStaus = planModel.status;
    if (planModel.status == PlanStatus.notStart.name) {
      updatedStaus = PlanStatus.completed.name;
    } else if (planModel.status == PlanStatus.completed.name) {
      updatedStaus = PlanStatus.notComplete.name;
    } else if (planModel.status == PlanStatus.notComplete.name) {
      updatedStaus = PlanStatus.notStart.name;
    }
    appDebugPrint("Docid : ${docId}");
    appDebugPrint("time : ${planModel.time}");
    // await FirebaseFirestore.instance
    //     .collection("day-plan")
    //     .doc(docId)
    //     .update({}); // filter current user docs

    Map<String, dynamic> currentMap = {
      "time": planModel.time,
      "title": planModel.title,
      "description": planModel.desc,
      "status": planModel.status,
    };
    Map<String, dynamic> updateMap = {
      "time": planModel.time,
      "title": planModel.title,
      "description": planModel.desc,
      "status": updatedStaus,
    };

    appDebugPrint("cMap..$currentMap");
    appDebugPrint("UMap..$updateMap");
    // remove existing data
    await FirebaseFirestore.instance.collection("day-plan").doc(docId).update({
      "plan": FieldValue.arrayRemove([currentMap]),
    });
    //  update the status and add new data
    await FirebaseFirestore.instance.collection("day-plan").doc(docId).update({
      "plan": FieldValue.arrayUnion([updateMap]),
    });
    appDebugPrint(updateMap);
  }

  initPlan({required HomeSuccessState state, required List<PlanModel> list}) {
    state.setInitValue(list);
    // emitState(state);
  }

  String getId(List<PlanModel> list, String date) {
    appDebugPrint(date);
    return list.where((x) => x.date == date).toList().first.id;
  }
}

abstract class HomeState extends Equatable {}

class HomeInitialState extends HomeState {
  @override
  List<Object?> get props => [];
}

class _HomeChangeState extends HomeState {
  @override
  List<Object?> get props => [];
}

class HomeSuccessState extends HomeState {
  int index = 0;
  List<String> dates = [];
  List<PlanListModel> plans = [];
  String currentDocId = "";
  HomeSuccessState();

  updateIndex(int indexValue, List<PlanModel> list) {
    appDebugPrint(indexValue);
    index = indexValue;
    plans = list
        .where((element) => element.date == dates[index])
        .first
        .planList;
  }

  setInitValue(List<PlanModel> userList) {
    dates = userList.map((element) => element.date).toList();
    dates.sort((a, b) => a.compareTo(b));
    if (userList.where((element) => element.date == dates[index]).isNotEmpty) {
      plans = userList
          .where((element) => element.date == dates[index])
          .first
          .planList;
    }

    // appDebugPrint("dates..$dates");
    // appDebugPrint("plans..$plans");
  }

  @override
  List<Object?> get props => [];
}

class HomeErrorState extends HomeState {
  final String msg;
  HomeErrorState({required this.msg});
  @override
  List<Object?> get props => [msg];
}
