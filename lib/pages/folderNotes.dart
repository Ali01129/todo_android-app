import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo/utils/todo_list.dart';
import 'package:todo/data/newDatabase.dart';
import 'package:todo/constants/colors.dart';

class FolderNotes extends StatefulWidget {
  final String folder;

  const FolderNotes({Key? key, required this.folder}) : super(key: key);

  @override
  State<FolderNotes> createState() => _FolderNotesState();
}

class _FolderNotesState extends State<FolderNotes> {
  final _mybox = Hive.box("notes-app");
  final TextEditingController _controller = TextEditingController();

  List<Note> todayNotes = [];
  List<Note> yesterdayNotes = [];
  List<Note> otherNotes = [];

  @override
  void initState() {
    super.initState();

    // Use the widget's folder property to filter notes
    String folder = widget.folder;

    if (_mybox.get("notes") == null) {
      createInitialData();
    }

    todayNotes = getNotesForToday(folder: folder);
    yesterdayNotes = getNotesForYesterday(folder: folder);
    otherNotes = getOtherNotes(folder: folder);
  }

  void _refreshNotes() {
    setState(() {
      todayNotes = getNotesForToday(folder: widget.folder);
      yesterdayNotes = getNotesForYesterday(folder: widget.folder);
      otherNotes = getOtherNotes(folder: widget.folder);
    });
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
                refresh: _refreshNotes,
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    String folder = widget.folder;
    return Scaffold(
      backgroundColor: AppColors.getBackgroundColor(context),
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
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.post_add, size: 35, color: Color(0xFFFE9402)),
              onPressed: () {
                Navigator.pushNamed(context, '/CreateNote',arguments: {'folder':folder}).then((value) {
                  _refreshNotes();
                });
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(right: 10, left: 10, top: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/Folders');
                  },
                  child: Row(
                    children: [
                      Icon(Icons.chevron_left, size: 30, color: Color(0xFFFE9402)),
                      Text(
                        "Folders",
                        style: TextStyle(color: Color(0xFFFE9402), fontSize: 18),
                      ),
                    ],
                  ),
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
