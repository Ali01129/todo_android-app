import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo/data/database.dart';
import 'package:todo/utils/dialog_box.dart';
import 'package:todo/utils/todo_list.dart';
import 'package:todo/data/newDatabase.dart';
import 'package:todo/constants/colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _mybox = Hive.box("mybox");
  final TextEditingController _controller = TextEditingController();
  final ToDoDatabase db = ToDoDatabase();

  @override
  void initState() {
    super.initState();
    if (_mybox.get("TODOLIST") == null) {
      db.createInitialData();
    } else {
      db.loadData();
    }
  }

  void checkBoxChanged(bool? value, int index) {
    setState(() {
      db.todo[index][1] = !db.todo[index][1];
    });
    db.updateDatabase();
  }

  void saveNewTask() {
    setState(() {
      db.todo.add([_controller.text, false]);
      _controller.clear();
    });
    db.updateDatabase();
    Navigator.of(context).pop();
  }

  void deleteTask(int index) {
    setState(() {
      db.todo.removeAt(index);
    });
    db.updateDatabase();
  }

  void createNewTask() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          controller: _controller,
          onCancel: () => Navigator.of(context).pop(),
          onSave: saveNewTask,
        );
      },
    );
  }

  Widget buildNotesSection(String title, List<Note> notes) {
    if (notes.isEmpty) return SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
            itemCount: notes.length,
            itemBuilder: (context, index) {
              Note note = notes[index];
              return TodoList(
                taskname: note.heading,
                note: note.note.toString(),
                folder: note.folder,
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {

    List<Note> todayNotes = getNotesForToday();
    List<Note> yesterdayNotes = getNotesForYesterday();
    List<Note> otherNotes = getOtherNotes();

    return Scaffold(
      backgroundColor: AppColors.getBackgroundColor(context),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: createNewTask,
      //   child: Icon(Icons.add),
      //   backgroundColor: Color(0xFFFE9402),
      // ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 0,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              child: Center(
                child: Text(
                  "${todayNotes.length + yesterdayNotes.length + otherNotes.length} Notes",
                  style: TextStyle(fontSize: 16), // Adjust the font size as needed
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.post_add, size: 35, color: Color(0xFFFE9402)),
              onPressed: () {
                Navigator.pushNamed(context, '/CreateNote');
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(right: 10,left: 10,top: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.chevron_left, size: 30, color: Color(0xFFFE9402)),
                    Text(
                      "Folders",
                      style: TextStyle(color: Color(0xFFFE9402), fontSize: 18),
                    ),
                  ],
                ),
                Icon(Icons.more_horiz, size: 30, color: Color(0xFFFE9402)),
              ],
            ),
            SizedBox(height: 5),
            Text(
              "Notes",
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 5),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.search, color: Colors.grey.shade600),
                  SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: "Search",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildNotesSection("Today", todayNotes),
                    buildNotesSection("Yesterday", yesterdayNotes),
                    buildNotesSection("Other", otherNotes),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}