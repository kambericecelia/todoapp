import 'package:flutter/material.dart';

class AddTaskDialog extends StatelessWidget {
  TextEditingController textController = TextEditingController();
  final VoidCallback addTaskFunction;

  AddTaskDialog({required this.textController, required this.addTaskFunction});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15)),
      backgroundColor: Colors.green[150],
      content: Container(
          height: 180,
          child: Column(children: [
            TextField(
              style: TextStyle(
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                hintText: 'Enter task',
                border: OutlineInputBorder(),
              ),
              textAlign: TextAlign.center,
              controller: textController,
            ),
            SizedBox(height: 20),
            MaterialButton(
                color: Colors.green,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                //height: 60,
                padding: EdgeInsets.symmetric(
                    vertical: 15, horizontal: 50),
                onPressed: addTaskFunction,
                child: Text(
                  "Add",
                  style: TextStyle(fontSize: 20),
                )),
          ])));
}
}