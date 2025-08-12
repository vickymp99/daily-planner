import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_planner/core/constant/app_enum.dart';
import 'package:daily_planner/core/utils/common_utils.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitialState());

  emitState(HomeState state) {
    emit(_HomeChangeState());
    emit(state);
  }

  updateIndex({required HomeSuccessState state, required int indexValue}) {
    state.updateIndex(indexValue);
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
    required String status,
    required QueryDocumentSnapshot<Map<String, dynamic>> docID,
    required String key,
  }) async {
    String updatedStaus = status;
    if (status == PlanStatus.notStart.name) {
      updatedStaus = PlanStatus.completed.name;
    } else if (status == PlanStatus.completed.name) {
      updatedStaus = PlanStatus.notComplete.name;
    } else if (status == PlanStatus.notComplete.name) {
      updatedStaus = PlanStatus.notStart.name;
    }
    appDebugPrint("Docid : ${docID.data()}");
    appDebugPrint("time : $key");
    // await FirebaseFirestore.instance
    //     .collection("day-plan")
    //     .doc(docId)
    //     .update({}); // filter current user docs

    Map<String, dynamic> updateMap = {};
    Map<String, dynamic> currentMap = (docID.data()["plan"] as List<dynamic>)
        .firstWhere((test) => test["time"] == key);

    updateMap = {...currentMap};
    updateMap["status"] = updatedStaus;

    appDebugPrint("cMap..$currentMap");
    appDebugPrint("UMap..$updateMap");

    await FirebaseFirestore.instance
        .collection("day-plan")
        .doc(docID.id)
        .update({
          "plan": FieldValue.arrayRemove([currentMap]),
        });
    await FirebaseFirestore.instance
        .collection("day-plan")
        .doc(docID.id)
        .update({
          "plan": FieldValue.arrayUnion([updateMap]),
        });
    appDebugPrint(updateMap);
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
  String currentDocId = "";
  HomeSuccessState();

  updateIndex(int indexValue) {
    appDebugPrint(indexValue);
    index = indexValue;
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
