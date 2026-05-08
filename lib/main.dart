import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:serpentaire_perso_app/pages/home_page.dart';
import 'package:serpentaire_perso_app/pages/new_save_page.dart';
import 'package:serpentaire_perso_app/data/database.dart';
import 'package:serpentaire_perso_app/pages/save_page.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('mybox');
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final _myBox = Hive.box('mybox');
  SavesDatabase db = SavesDatabase();
  bool isAnySave = false;

  @override
  void initState() {
    super.initState();
    if (_myBox.get('MY_DATA') == null) {
      db.createInitialData();
    } else {
      db.loadData();
    }
    isAnySave = db.mySaves.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: isAnySave ? HomePage(db: db) : NewSavePage(db: db),
      theme: ThemeData(primarySwatch: Colors.blue),
      routes: {
        '/home': (context) => HomePage(db: db),
        '/new_save': (context) => NewSavePage(db: db),
        '/save': (context) => SavePage(id: ModalRoute.of(context)!.settings.arguments as int, db: db),
      },
    );
  }
}