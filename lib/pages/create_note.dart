import 'package:flutter/material.dart';

class NotePage extends StatelessWidget {
  final TextEditingController _heading=TextEditingController();
  final TextEditingController _note=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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