import 'package:daily_planner/core/constant/app_enum.dart';

class NewDayPlanUseCase {
  final String title;
  final String desc;
  final String date;
  final String time;
  final PlanStatus status;
  NewDayPlanUseCase({
    required this.title,
    required this.desc,
    required this.date,
    required this.time,
     this.status = PlanStatus.notStart,
  });
}
