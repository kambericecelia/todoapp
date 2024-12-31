import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive/hive.dart';
import 'package:todoapp/daily_task.dart';
import 'package:todoapp/task.dart';
import 'package:todoapp/task_tile.dart';

import '../add_task_dialog.dart';

class EverydayTasks extends StatefulWidget {
  static const String id = 'everyday_tasks';

  @override
  State<EverydayTasks> createState() => _EverydayTasks();
}

class _EverydayTasks extends State<EverydayTasks> {
  final TextEditingController _taskTitle = TextEditingController();
  late Box<DailyTask> dailyTaskBox;
  bool isLoading = true;
  bool isChecked = false;

  @override
  void initState() {
    super.initState();
    initializeHiveAndTasks();
  }

  Future<void> initializeHiveAndTasks() async {
    setState(() {
      isLoading =true;
    });
    await openBox();
    setState(() {
      isLoading=false;
    });
  }



  Future<void> openBox() async {
    dailyTaskBox = await Hive.openBox<DailyTask>('dailyTasks');
  }

  @override
  void dispose() {
    dailyTaskBox.close();
    super.dispose();
  }

  void addTask(String taskTitle){
    if(taskTitle.isNotEmpty){
      setState(() {
        dailyTaskBox.put('key_$taskTitle', DailyTask(name: taskTitle, status: false));
      });
    }
  }

  void checkboxChanged(int index, bool isChecked) {
    setState(() {
      DailyTask? task = dailyTaskBox.getAt(index);
      if (task != null) {
        task.status = isChecked;
        dailyTaskBox.putAt(index, task);
      }
    });
  }
  void checkBoxState(int index, bool isChecked) {
    setState(() {
      DailyTask? task = dailyTaskBox.getAt(index);
      if (task != null) {
        task.status = isChecked;
        dailyTaskBox.putAt(index, task);
      }
    });
  }

  void deleteTask(int index) {
    setState(() {
      dailyTaskBox.deleteAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.green[300],
        appBar: AppBar(
          title: Text('Everyday Tasks'),
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: (){Navigator.pop(context);}
          ),
        ),
        body: isLoading
            ? Center(
          child: CircularProgressIndicator(),
        )
            : Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: dailyTaskBox.length,
                itemBuilder: (context, index) {
                  DailyTask? dailyTask = dailyTaskBox.getAt(index);
                  if (dailyTask != null) {
                    return TaskTile(
                      isChecked: dailyTask.status,
                      taskTitle: dailyTask.name,
                      onChanged: (bool? isChecked) {
                        checkboxChanged(index, isChecked!);
                      },
                      deleteFunction: (context) {
                        deleteTask(index);
                      },
                    );
                  }
                  return SizedBox(); // Return an empty widget for null tasks.
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
              child: FloatingActionButton(
                heroTag: 'add_button',
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AddTaskDialog(
                        textController: _taskTitle,
                        addTaskFunction: () {
                          if (_taskTitle.text.isNotEmpty) {
                            addTask(_taskTitle.text);
                          }
                          Navigator.pop(context);
                          _taskTitle.clear();
                        },
                      );
                    },
                  );
                },
                child: Icon(Icons.add),
                backgroundColor: Colors.green,
              ),
            ),
          ],
        ),
      );

  }

}
