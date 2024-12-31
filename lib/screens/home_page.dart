import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:todoapp/screens/everyday_tasks.dart';
import 'package:todoapp/task_tile.dart';
import 'package:todoapp/add_task_dialog.dart';
import 'package:todoapp/task.dart';

class HomePage extends StatefulWidget {
  static const String id = 'home_page';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Box<Task> taskBox;
  String taskTitle = "";
  bool isChecked = false;
  bool isLoading = false;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    initializeHiveAndTasks();
  }

  Future<void> initializeHiveAndTasks() async {
    setState(() {
      isLoading = true;
    });

    await openBox();
    setState(() {
      isLoading = false;
    });
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
      Task? task = taskBox.getAt(index);
      if (task != null) {
        task.status = isChecked;
        taskBox.putAt(index, task);
      }
    });
  }

  void deleteTask(int index) {
    setState(() {
      taskBox.deleteAt(index);
    });
  }

  void addTask(String taskTitle) {
    if (taskTitle.isNotEmpty) {
      setState(() {
        taskBox.put('key_$taskTitle', Task(name: taskTitle, status: false));
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
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                        itemCount: taskBox.length,
                        itemBuilder: (context, index) {
                          Task? task = taskBox.getAt(index);
                          if (task != null) {
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
                          }
                          return SizedBox();
                        }),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                        child: FloatingActionButton(
                          heroTag: 'list_button',
                          onPressed: () {
                            Navigator.pushNamed(context, EverydayTasks.id);
                          },
                          child: Icon(Icons.list),
                          backgroundColor: Colors.green,
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
                                  textController: _controller,
                                  addTaskFunction: () {
                                    if (_controller != null) {
                                      addTask(_controller.text);
                                    }
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
              ));
  }
}
