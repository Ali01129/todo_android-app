import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo/pages/create_note.dart';
import 'package:todo/pages/edit_note.dart';
import 'package:todo/pages/folderNotes.dart';
import 'package:todo/pages/folders.dart';
import 'package:todo/pages/home_page.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter is fully initialized
  // Initialize Hive
  await Hive.initFlutter();

  // Open a box
  await Hive.openBox("notes-app");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.white,
          bottomAppBarTheme: BottomAppBarTheme(
            color: Colors.grey.shade200,
          )
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Color(0xFF29292B),
        bottomAppBarTheme: BottomAppBarTheme(
          color: Colors.black,
        )
      ),

      // Automatically switch between light and dark themes based on system settings
      themeMode: ThemeMode.system,
      routes: {
        "/CreateNote": (context) {
          final arguments = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
          final folder = arguments?['folder'] ?? 'All';
          return NotePage(folder: folder);
        },
        "/EditNote":(context)=>EditNote(taskname: 'Heading', note: 'Note...'),
        "/Folders":(context)=>Folders(),
        '/HomePage':(context)=>HomePage(),
        '/FolderNotes': (context) {
          final arguments = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          final folder = arguments['folder'] ?? 'All';
          return FolderNotes(folder: folder);
        },
      },
      home: const HomePage(),
    );
  }
}
