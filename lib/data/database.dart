import 'package:hive_flutter/hive_flutter.dart';

class ToDoDatabase {
  List todo=[];
  final _mybox=Hive.box("mybox");

  //run when user open this app for the first time
  void createInitialData(){
    todo=[
      ["Wellcome to Todo",false],
      ["Add Task",false],
      ["Made by Ali Nawaz",false],
    ];
  }
  //load data form the database
  void loadData(){
    todo=_mybox.get("TODOLIST");
  }
  //update the database
  void updateDatabase(){
    _mybox.put("TODOLIST", todo);
  }
}