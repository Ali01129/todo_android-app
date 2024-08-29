import 'package:flutter/material.dart';
import 'package:todo/data/newDatabase.dart';

class NotePage extends StatelessWidget {
  final TextEditingController _heading=TextEditingController();
  final TextEditingController _note=TextEditingController();
  @override
  Widget build(BuildContext context) {

    void createNote(){
      List<Note> todayNotes=getNotesForToday();
      print(todayNotes.length);
      addNote(_heading.text, _note.text, 'All');
      todayNotes=getNotesForToday();
      print("after adding note");
      print(todayNotes.length);
      Navigator.pop(context);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'All Chats',
          style: TextStyle(color: Color(0xFFFE9402), fontSize: 18),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back,size: 25,),
          color: Color(0xFFFE9402),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        leadingWidth: 25,
        actions: [
          TextButton(onPressed: createNote,
              child: Text('Done',style:TextStyle(color: Color(0xFFFE9402), fontSize: 18,),)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              keyboardType: TextInputType.text,
              maxLines: 1,
              minLines: 1,
              controller: _heading,
              decoration: InputDecoration(
                hintText: 'Heading',
                border: InputBorder.none,
              ),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            const Divider(),
            Expanded(
              child: TextField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                minLines: 5,
                controller: _note,
                decoration: InputDecoration(
                  hintText: 'Write your note here...',
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}