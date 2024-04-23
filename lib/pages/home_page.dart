import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo/data/database.dart';
import 'package:todo/utils/dialog_box.dart';
import 'package:todo/utils/todo_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _mybox=Hive.box("mybox");
  final _controller=TextEditingController();
  //using database
  ToDoDatabase db= ToDoDatabase();
  @override
  void initState() {
    //check if this is the first time opening the app
    if(_mybox.get("TODOLIST")==null){
      db.createInitialData();
    }
    else{
      db.loadData();
    }
    super.initState();
  }

  void checkBoxChanged(bool? value,int index){
    setState(() {
      db.todo[index][1]=!db.todo[index][1];
    });
    db.updateDatabase();
  }

  void saveNewTask(){
    setState(() {
      db.todo.add([_controller.text,false]);
      _controller.clear();
    });
    db.updateDatabase();
    Navigator.of(context).pop();
  }

  void deleteTask(int index){
    setState(() {
      db.todo.removeAt(index);
    });
    db.updateDatabase();
  }

  void createNewTask(){
    showDialog(
        context: context,
        builder: (context){
          return DialogBox(
            controller: _controller,
            onCancel: ()=> Navigator.of(context).pop() ,
            onSave: saveNewTask,
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[200],
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        title: Center(child: Text("TO DO")),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: createNewTask,
        child: Icon(Icons.add),
        backgroundColor: Colors.yellow,
      ),

      body: ListView.builder(
        itemCount: db.todo.length,
        itemBuilder: (context,index){
          return TodoList(
            taskname: db.todo[index][0],
            taskvalue: db.todo[index][1],
            onChanged: (value)=> checkBoxChanged(value,index),
            deleteFunction: (context)=> deleteTask(index),
          );
        },
      ),
    );
  }
}
