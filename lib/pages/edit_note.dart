import 'package:flutter/material.dart';
import 'package:todo/data/newDatabase.dart';

class EditNote extends StatelessWidget {
  final String taskname;
  final String note;

  EditNote({required this.taskname, required this.note});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> arguments = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    final String taskname = arguments['taskname'];
    final String note = arguments['note'];

    final TextEditingController _heading=TextEditingController(text: taskname);
    final TextEditingController _note=TextEditingController(text: note);

    void EditNote(){
      editNotes(taskname, note, _heading.text, _note.text);
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
          TextButton(onPressed: EditNote,
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