class Note {
  final DateTime timestamp;
  final String heading;
  final String note;
  final String folder;

  Note({required this.timestamp, required this.heading, required this.note,required this.folder});
}

List<Note> notes = [
  Note(
    timestamp: DateTime.now(),
    heading: 'Meeting Notes',
    note: 'Discussed project timeline and next steps.',
    folder:'Meeting',
  ),
  Note(
    timestamp: DateTime.now().subtract(Duration(days: 1)),
    heading: 'Grocery List',
    note: 'Milk, eggs, bread, apples',
    folder: "Food",
  ),
  Note(
    timestamp: DateTime.now().subtract(Duration(days: 5)),
    heading: 'Grocery List',
    note: 'Milk, eggs, bread, apples',
    folder: "Food",
  ),
  Note(
    timestamp: DateTime.now().subtract(Duration(days: 1)),
    heading: 'Grocery List',
    note: 'Milk, eggs, bread, apples',
    folder: "Food",
  ),
];

List<Note> getNotesForToday() {
  final today = DateTime.now();
  return notes.where((note) => note.timestamp.year == today.year &&
      note.timestamp.month == today.month &&
      note.timestamp.day == today.day).toList();
}

List<Note> getNotesForYesterday() {
  final yesterday = DateTime.now().subtract(Duration(days: 1));
  return notes.where((note) => note.timestamp.year == yesterday.year &&
      note.timestamp.month == yesterday.month &&
      note.timestamp.day == yesterday.day).toList();
}

List<Note> getOtherNotes() {
  final today = DateTime.now();
  final yesterday = today.subtract(Duration(days: 1));
  return notes.where((note) {
    final noteDate = note.timestamp;
    return !(noteDate.year == today.year &&
        noteDate.month == today.month &&
        noteDate.day == today.day) && // Exclude today
        !(noteDate.year == yesterday.year &&
            noteDate.month == yesterday.month &&
            noteDate.day == yesterday.day); // Exclude yesterday
  }).toList();
}

//adding notes function
void addNote(String heading, String note, String folder) {
  Note newNote = Note(heading: heading, note: note, folder: folder, timestamp: DateTime.now());
  notes.add(newNote);
}

//delete notes
void deleteNote(String heading,String folder){
  notes.removeWhere((note)=> note.heading==heading && note.folder==folder);
}
