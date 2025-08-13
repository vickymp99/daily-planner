import 'package:hive/hive.dart';

part 'plan_model.g.dart'; // generated file

@HiveType(typeId: 0)
class PlanModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String date;

  @HiveField(2)
  final List<PlanListModel> planList;

  PlanModel({required this.id, required this.date, required this.planList});

  factory PlanModel.fromMap(Map<String, dynamic> json) => PlanModel(
    id: json['id'] ?? "",
    date: json['date'] ?? "",
    planList: List<PlanListModel>.from(
      json['plan'].map((x) => PlanListModel.fromMap(x)),
    ),
  );
}

@HiveType(typeId: 1)
class PlanListModel {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final String desc;

  @HiveField(2)
  final String status;

  @HiveField(3)
  final String time;

  factory PlanListModel.fromMap(Map<String, dynamic> map) => PlanListModel(
    title: map["title"] ?? "",
    status: map['status'] ?? "",
    desc: map['description'] ?? "",
    time: map['time'] ?? "",
  );

  PlanListModel({
    required this.title,
    required this.status,
    required this.desc,
    required this.time,
  });
}
