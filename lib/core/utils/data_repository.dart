import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_planner/core/utils/common_utils.dart';
import 'package:daily_planner/core/utils/firebase_service.dart';
import 'package:daily_planner/core/utils/hive_service.dart';
import 'package:daily_planner/features/data/model/plan_model.dart';

class DataRepository {
  final FirebaseService _firebaseService;
  DataRepository(this._firebaseService);

  listenChanges() {
    _firebaseService.fireBaseUserChange().listen((data) async {
      appDebugPrint("firebase change call");
      List<PlanModel> tempList = convertList(data);
      await HiveService.saveUserPlan(tempList);
    });
  }

  initLoad() async {
    final initData = await _firebaseService.fetchInit();
    await HiveService.saveUserPlan(convertList(initData));
  }

  List<PlanModel> convertList(QuerySnapshot<Map<String, dynamic>> list) {
    List<Map<String, dynamic>> ll = list.docs.map((map) => map.data()).toList();
    List<String> ll2 = list.docs.map((map) => map.id as String).toList();
    appDebugPrint("ll2222..$ll2 ${ll2.length}");
    appDebugPrint("ll..  ${ll.length} $ll ");
    int i = 0;
    for (var m in ll) {
      m["id"] = ll2[i];
      i++;
    }

    appDebugPrint("after  ll..${ll.length} ${ll.toString()}");
    return ll.map((x) => PlanModel.fromMap(x)).toList();
  }
}
