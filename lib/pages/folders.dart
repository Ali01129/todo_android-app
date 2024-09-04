import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo/data/foldersData.dart';
import '../constants/colors.dart';

class Folders extends StatefulWidget {
  const Folders({super.key});

  @override
  _FoldersState createState() => _FoldersState();
}

class _FoldersState extends State<Folders> {
  late List<String> folders;

  @override
  void initState() {
    super.initState();
    _refreshFolders(); // Initial loading of folders
  }

  void _refreshFolders() {
    setState(() {
      folders = getFolders(); // Retrieve folders from Hive or any other source
    });
  }

  void _createFolder(String folderName) {
    createFolder(folderName); // Logic to create a folder
    _refreshFolders(); // Refresh the folder list after adding a new folder
  }

  void _deleteFolder(String folderName) {
    deleteFolder(folderName); // Logic to delete a folder
    _refreshFolders(); // Refresh the folder list after deleting a folder
  }

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).brightness == Brightness.light
        ? Colors.grey.shade600
        : Colors.white;

    return Scaffold(
      backgroundColor: AppColors.getBackgroundColor(context),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 0,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Spacer(),
            IconButton(
              icon: Icon(Icons.create_new_folder, size: 35, color: Color(0xFFFE9402)),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    String folderName = "";
                    return AlertDialog(
                      backgroundColor: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      title: Text(
                        'Create New Folder',
                        style: TextStyle(color: textColor),
                      ),
                      content: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: TextField(
                          onChanged: (value) {
                            folderName = value;
                          },
                          style: TextStyle(color: textColor),
                          decoration: InputDecoration(
                            hintText: 'Folder Name',
                            hintStyle: TextStyle(color: textColor),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: textColor),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: textColor),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: Text(
                            'Cancel',
                            style: TextStyle(color: textColor),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Save',
                              style: TextStyle(color: textColor),
                            ),
                          ),
                          onPressed: () {
                            _createFolder(folderName);
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
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
            Text(
              "Folders",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            GestureDetector(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.folder, color: textColor),
                    SizedBox(width: 10),
                    Text(
                      "All Notes",
                      style: TextStyle(color: textColor),
                    ),
                  ],
                ),
              ),
              onTap: () {
                Navigator.pushNamed(context, '/HomePage');
              },
            ),
            SizedBox(height: 30),
            // Display folders with spacing
            ...folders.map((folder) => Column(
              children: [
                GestureDetector(
                  child: Slidable(
                    endActionPane: ActionPane(
                      motion: StretchMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (index) {
                            _deleteFolder(folder);
                          },
                          icon: Icons.delete,
                          backgroundColor: Colors.red.shade500,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ],
                    ),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.folder, color: textColor),
                          SizedBox(width: 10),
                          Text(
                            folder,
                            style: TextStyle(color: textColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, '/FolderNotes',arguments: {"folder":folder});
                  },
                ),
                SizedBox(height: 10),
              ],
            )).toList(),
          ],
        ),
      ),
    );
  }
}