import 'package:daily_planner/core/constant/app_local_storage_constant.dart';
import 'package:daily_planner/features/data/model/plan_model.dart';
import 'package:hive/hive.dart';

class HiveService {
  static Box<PlanModel> get userPlan =>
      Hive.box<PlanModel>(AppLocalStorageConstant.userPlan);
  static Box<String> get userDetails =>
      Hive.box<String>(AppLocalStorageConstant.userDetails);

  static init() async {
    await Hive.openBox<PlanModel>(AppLocalStorageConstant.userPlan);
    await Hive.openBox<String>(AppLocalStorageConstant.userDetails);
  }

  static saveUserPlan(List<PlanModel> list) async {
    var box = userPlan;
    await box.clear();
    int i = 0;
    for (var data in list) {
      await box.put(i, data);
      i++;
    }
  }
}
