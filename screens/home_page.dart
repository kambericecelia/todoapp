import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:todoapp/boxes.dart';
import 'package:todoapp/screens/everyday_tasks.dart';
import 'package:todoapp/task_tile.dart';
import '../lib/task.dart';
import '../lib/add_task_dialog.dart';

class HomePage extends StatefulWidget {
  static const String id = 'home_page';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Box<Task> taskBox;
  String taskTitle = "";
  bool isChecked = false;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    openBox();
  }

  Future<void> openBox() async {
    taskBox = await Hive.openBox<Task>('tasks');
  }

  @override
  void dispose() {
    taskBox.close();
    super.dispose();
  }

  void checkboxChanged(int index, bool isChecked) {
    setState(() {
      Task task = boxes.getAt(index);
      task.status = isChecked;
      boxes.putAt(index, task);
    });
  }

  void deleteTask(int index) {
    setState(() {
      boxes.deleteAt(index);
    });
  }

  void addTask(String taskTitle) {
    if (taskTitle != "") {
      setState(() {
        boxes.put('key_$taskTitle', Task(name: taskTitle, status: false));
        _controller.clear();
      });
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[300],
      appBar: AppBar(
        title: Text('TO DO'),
        elevation: 0,
      ),
      body:
      Column(
        children: [
      Expanded(
        child: ListView.builder(
            itemCount: boxes.length,
            itemBuilder: (context, index) {
              Task task = boxes.getAt(index);
              return TaskTile(
                isChecked: task.status,
                taskTitle: task.name,
                onChanged: (bool? isChecked) {
                  checkboxChanged(index, isChecked!);
                },
                deleteFunction: (context) {
                  deleteTask(index);
                },
              );
            }),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FloatingActionButton(
              onPressed: () {
                Navigator.pushNamed(context, EverydayTasks.id);
              },
              child: Icon(Icons.list),
              backgroundColor: Colors.green,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FloatingActionButton(

              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AddTaskDialog(
                      textController: _controller,
                      addTaskFunction: () {
                        addTask(_controller.text);
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
      )

        ],
      )
    );
  }
}
