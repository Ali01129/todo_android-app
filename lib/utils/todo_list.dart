import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class TodoList extends StatelessWidget {
  final String taskname;
  final bool taskvalue;
  Function(bool?)? onChanged;
  Function(BuildContext)? deleteFunction;
  TodoList({
    super.key,
    required this.taskname,
    required this.taskvalue,
    required this.onChanged,
    required this.deleteFunction
  });

  @override
  Widget build(BuildContext context) {
    return Padding(

      padding: const EdgeInsets.only(left: 25.0,right: 25.0,top: 25.0),

      child: Slidable(
        endActionPane: ActionPane(
          motion: StretchMotion(),
          children: [
            SlidableAction(
              onPressed: deleteFunction,
              icon: Icons.delete,
              backgroundColor: Colors.red.shade500,
              borderRadius: BorderRadius.circular(10),
            ),
          ],
        ),
        child: Container(
          padding: EdgeInsets.all(25.0),
          decoration: BoxDecoration(
            color: Colors.yellow,
            borderRadius: BorderRadius.circular(12)
          ),
          child: Row(
            children: [
              //checkbox
              Checkbox(value: taskvalue, onChanged: onChanged,activeColor: Colors.black,),
              //task name
              Text(
                taskname,
                style: TextStyle(decoration: taskvalue? TextDecoration.lineThrough:TextDecoration.none),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
