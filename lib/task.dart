import 'package:hive/hive.dart';

part 'task.g.dart';

@HiveType(typeId: 1)
class Task {
  Task({required this.name, required this.status});

  @HiveField(0)
  String name;

  @HiveField(1)
  bool status;

  @override
  String toString() {
    return '$name: $status';
  }

  void toggleTaskStatus(){
    status = !status;
  }
}