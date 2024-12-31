import 'package:hive/hive.dart';

part 'daily_task.g.dart';


@HiveType(typeId: 2)
class DailyTask{
  DailyTask({required this.name, this.time= '', required this.status});

  @HiveField(0)
  String name;

  @HiveField(1)
  String time;

  @HiveField(2)
  bool status;


}