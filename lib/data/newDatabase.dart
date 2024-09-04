import 'package:hive_flutter/hive_flutter.dart';

class Note {
  DateTime timestamp;
  String heading;
  String note;
  final String folder;

  Note({
    required this.timestamp,
    required this.heading,
    required this.note,
    required this.folder,
  });

  // Convert Note object to Map
  Map<String, dynamic> toMap() {
    return {
      'timestamp': timestamp.toIso8601String(),
      'heading': heading,
      'note': note,
      'folder': folder,
    };
  }

  // Convert Map to Note object
  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      timestamp: DateTime.parse(map['timestamp']),
      heading: map['heading'],
      note: map['note'],
      folder: map['folder'],
    );
  }
}

List<Note> notes = [];

void createInitialData() {
  Note newNote = Note(
    heading: 'No Note Available',
    note: 'Add note from bottom',
    folder: 'All',
    timestamp: DateTime.now(),
  );
  notes.add(newNote);
  updateDatabase();
}

List<Note> getNotesForToday({String? folder}) {
  print(notes);
  loadData();
  print(folder);
  final today = DateTime.now();
  return notes.where((note) {
    final matchesDate = note.timestamp.year == today.year &&
        note.timestamp.month == today.month &&
        note.timestamp.day == today.day;
    final matchesFolder = folder == null || note.folder == folder;
    return matchesDate && matchesFolder;
  }).toList();
}

List<Note> getNotesForYesterday({String? folder}) {
  loadData();
  final yesterday = DateTime.now().subtract(Duration(days: 1));
  return notes.where((note) {
    final matchesDate = note.timestamp.year == yesterday.year &&
        note.timestamp.month == yesterday.month &&
        note.timestamp.day == yesterday.day;
    final matchesFolder = folder == null || note.folder == folder;
    return matchesDate && matchesFolder;
  }).toList();
}

List<Note> getOtherNotes({String? folder}) {
  loadData();
  final today = DateTime.now();
  final yesterday = today.subtract(Duration(days: 1));
  return notes.where((note) {
    final noteDate = note.timestamp;
    final isToday = noteDate.year == today.year &&
        noteDate.month == today.month &&
        noteDate.day == today.day;
    final isYesterday = noteDate.year == yesterday.year &&
        noteDate.month == yesterday.month &&
        noteDate.day == yesterday.day;
    final matchesFolder = folder == null || note.folder == folder;
    return !isToday && !isYesterday && matchesFolder;
  }).toList();
}


// Adding notes function
void addNote(String? heading, String? note, String folder) {
  if (heading == null || heading.isEmpty || note == null || note.isEmpty) {
    return;
  }
  String newHeading=heading[0].toUpperCase()+heading.substring(1);
  Note newNote = Note(
    heading: newHeading,
    note: note,
    folder: folder,
    timestamp: DateTime.now(),
  );
  notes.add(newNote);
  updateDatabase();
}

// Edit notes
void editNotes(String? oldHeading, String? oldNote, String? heading, String? note) {
  if (oldHeading == null || oldNote == null || heading == null || note == null) {
    return;
  }
  int index = notes.indexWhere((n) => n.heading == oldHeading && n.note == oldNote);
  if (index == -1) {
    return;
  }
  notes[index].heading = heading;
  notes[index].note = note;
  notes[index].timestamp = DateTime.now();
  updateDatabase();
}

// Delete notes
void deleteNote(String heading, String folder) {
  notes.removeWhere((note) => note.heading == heading && note.folder == folder);
  updateDatabase();
}

final _mybox = Hive.box("notes-app");

// Load data from the database
void loadData() {
  final data = _mybox.get("notes");
  if (data != null) {
    notes = List<Map<dynamic, dynamic>>.from(data)
        .map((noteMap) => Note.fromMap(Map<String, dynamic>.from(noteMap)))
        .toList();
  } else {
    notes = []; // Initialize with an empty list if no data is found
  }
}

// Update the database
void updateDatabase() {
  final noteMaps = notes.map((note) => note.toMap()).toList();
  _mybox.put("notes", noteMaps);
}
