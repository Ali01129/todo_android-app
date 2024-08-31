import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo/data/newDatabase.dart';

class TodoList extends StatelessWidget {
  final String taskname;
  final String note;
  final String folder;
  Function() refresh;
  TodoList({
    super.key,
    required this.note,
    required this.taskname,
    required this.folder,
    required this.refresh,
  });

  @override
  Widget build(BuildContext context) {

    String getShortenedNote(String note) {
      String firstLine = note.split('\n').first;
      return firstLine.length > 40 ? firstLine.substring(0, 40) + '...' : firstLine+ '...';
    }



    return Slidable(
      endActionPane: ActionPane(
        motion: StretchMotion(),
        children: [
          SlidableAction(
            onPressed: (index){
              deleteNote(taskname, folder);
              refresh();
            },
            icon: Icons.delete,
            backgroundColor: Colors.red.shade500,
            borderRadius: BorderRadius.circular(10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //task name
          Text(taskname,
            style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),
          ),
          Text(
            getShortenedNote(note),
            style: TextStyle(color: Colors.grey.shade400),
          ),
          Row(
            children: [
              Icon(Icons.folder_open,color: Colors.grey.shade400,),
              SizedBox(width: 5,),
              Text(folder,
                style: TextStyle(color: Colors.grey.shade400),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
