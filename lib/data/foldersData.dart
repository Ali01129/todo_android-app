import 'package:hive_flutter/hive_flutter.dart';
final _mybox = Hive.box("notes-app");

List<String> folders = [];


void createFolder(String name) {
  if (!folders.contains(name)) {
    String newName=name[0].toUpperCase() + name.substring(1);
    folders.add(newName);
    _mybox.put('folders', folders);
  } else {
    print("Folder with the name '$name' already exists.");
  }
}

// Function to delete a folder if it exists
void deleteFolder(String name) {
  if (folders.contains(name)) {
    folders.remove(name);
    _mybox.put('folders', folders);
  } else {
    print("Folder with the name '$name' does not exist.");
  }
}

// Function to retrieve the list of folders
List<String> getFolders() {
  return folders;
}
