import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todoapp/daily_task.dart';
import 'package:todoapp/screens/everyday_tasks.dart';
import 'task.dart';

import '../screens/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensures Flutter is initialized properly
  await Hive.initFlutter();

  // Register Adapters
  Hive.registerAdapter(TaskAdapter());
  Hive.registerAdapter(DailyTaskAdapter());

  // Open Hive boxes
  await Hive.openBox<Task>('taskBox');
  await Hive.openBox<DailyTask>('dailyTasks');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      theme: ThemeData(primarySwatch: Colors.green),
      initialRoute: HomePage.id,
      routes: {
        HomePage.id: (context) =>  HomePage(),
        EverydayTasks.id: (context) => EverydayTasks(),
      },
    );
  }
}


