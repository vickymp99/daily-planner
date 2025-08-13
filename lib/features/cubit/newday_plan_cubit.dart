import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_planner/core/utils/common_utils.dart';
import 'package:daily_planner/features/usecase/day_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NewDayPlanCubit extends Cubit<NewDayPlanState> {
  NewDayPlanCubit() : super(NewDayPlanInitialState());

  // NewDayPlan User
  addPlan(NewDayPlanUseCase planDetail) async {
    if (_checkCredential(planDetail)) {
      try {
        insertThePlan(planDetail);
      } catch (e) {
        emitState(NewDayPlanErrorState(msg: e.toString()));
      }
    } else {
      emitState(NewDayPlanErrorState(msg: "Enter correct userName / Password"));
    }
  }

  bool _checkCredential(NewDayPlanUseCase planDetail) {
    return planDetail.title.isNotEmpty &&
            planDetail.desc.isNotEmpty &&
            planDetail.date.isNotEmpty &&
            planDetail.time.isNotEmpty
        ? true
        : false;
  }

  emitState(NewDayPlanState state) {
    emit(state);
    emit(_NewDayPlanChangeState());
  }

  void insertThePlan(NewDayPlanUseCase planDetail) async {
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
      (map) => map.data().containsValue(planDetail.date),
    );
    appDebugPrint("isDateExist $isDateExist");
    // if date exist update value or else add the value
    if (isDateExist) {
      QueryDocumentSnapshot<Map<String, dynamic>> docId = cDocs
          .where((map) => map.data()["date"] == planDetail.date)
          .first;
      appDebugPrint(docId.id);
      await FirebaseFirestore.instance
          .collection('day-plan')
          .doc(docId.id)
          .update({
            'plan': FieldValue.arrayUnion([
              {
                "time": planDetail.time,
                "title": planDetail.title,
                "description": planDetail.desc,
                "status": planDetail.status.name,
              },
            ]),
          });
      emitState(NewDayPlanSuccessState(msg: "Data Added Successfully!!!"));
    } else {
      await FirebaseFirestore.instance.collection("day-plan").add({
        "date": planDetail.date,
        "uID": FirebaseAuth.instance.currentUser!.uid,
        "plan": [
          {
            "time": planDetail.time,
            "title": planDetail.title,
            "description": planDetail.desc,
            "status": planDetail.status.name,
          },
        ],
      });
      emitState(NewDayPlanSuccessState(msg: "Data Added Successfully!!!"));
    }
  }
}

abstract class NewDayPlanState extends Equatable {}

class NewDayPlanInitialState extends NewDayPlanState {
  @override
  List<Object?> get props => [];
}

class _NewDayPlanChangeState extends NewDayPlanState {
  @override
  List<Object?> get props => [];
}

// Log in state
class NewDayPlanLoadingState extends NewDayPlanState {
  @override
  List<Object?> get props => [];
}

class NewDayPlanSuccessState extends NewDayPlanState {
  final String? msg;
  NewDayPlanSuccessState({this.msg});
  @override
  List<Object?> get props => [];
}

class NewDayPlanBuildState extends NewDayPlanState {
  @override
  List<Object?> get props => [];
}

class NewDayPlanErrorState extends NewDayPlanState {
  final String msg;
  NewDayPlanErrorState({required this.msg});
  @override
  List<Object?> get props => [msg];
}
