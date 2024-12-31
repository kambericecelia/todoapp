import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';



class TaskTile extends StatelessWidget {
  final bool isChecked;
  final String taskTitle;
  final Function(bool?)? onChanged;
  final Function(BuildContext) deleteFunction;
  TaskTile({required this.isChecked, required this.taskTitle, required this.onChanged, required this.deleteFunction});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20),
        child: Slidable(
          endActionPane: ActionPane(
              motion: StretchMotion(),
              children: [
                SlidableAction(
                    onPressed: deleteFunction,
                    icon: Icons.delete,
                  backgroundColor: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(12),
                )
              ]),
          child: Container(
            child: ListTile(
              title: Text(
                this.taskTitle,
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: '',
                  fontSize: 25.0,
                  fontWeight: FontWeight.w400,
                  decoration: isChecked ? TextDecoration.lineThrough : TextDecoration.none,
                ),
              ),
              trailing: Checkbox(
                activeColor: Colors.green[150],
                value: isChecked,
                onChanged: onChanged,
              ),
            ),
            decoration: BoxDecoration(
                color: Colors.green, borderRadius: BorderRadius.circular(12)),
          ),
        )
    );
  }
}
